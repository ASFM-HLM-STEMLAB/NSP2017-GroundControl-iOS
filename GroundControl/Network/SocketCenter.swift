//
//  SocketManager.swift
//  GroundControl
//
//  Created by Francisco Lobo on 11/27/17.
//  Copyright © 2017 Movic Technologies. All rights reserved.
//

// Comunications to Server:
// This class is used as a central class to manage comunications to/from the server that in turn talks to the capsule.
// We use this 3 part paradigm so that we have a central repository that holds all the information sent by the capsule at all times.
// We then connect using this app to the server to pull that information and to ask the server to relay messages to the capsule.
//

// How does it work (in detail):
// The capsule talks to the server by sending a message either thru cellular modem or satellite modem at defined intervals.
// Every message sent to the server (Movic.io) is stored/presisted in a file for log keeping and also relayed to all active GroundControl apps that are connected to the server at that moment.
// In this fashion we will pull the history upon connecting and then listen to new messages as the arrive.
//
// The server is always listening for new messsages form the capsule. Once it receives a new message it saves it, and broadcast it to every ground control station that is connected to the server.
//
// So the server is capable of receiving messages from the capsule and also managing multiple connections from ground control apps.
//
//
// We use Sockets as a low level way to talk to the server instead of the classic REST (PUT/PUSH/GET) methods used in stateless applications.
// This method allows for a more robust realtime/push comunication protocol instead of polling every N seconds or so for new messages. This is similar like whatsapp and other chat services work. In this kind of applications this is far more efficient method for bi directional communications in real time. Socket coding is a bit more challenging because it is not stateless so we have to know where we are in the communication process at all times to react accordingly. For instance if a disconnect happens we need to try to reconnect to restablish communications and keep retrying until we connect. Also we need to know what we requested so that when the server responds we have some conext of what it is saying to us.
//
// To simplify this process we use a library/framework called Socket.io.
// Socket.io abstracts and simplifies the whole socket com process by adding methods and boiler plate code that help us concentrate on the business logic rather than on the tiny details of the protocol implementation. This class [SocketCenter] concentrates and encapsulates all networking and communication methods in one place and uses SIO (Socket.io) framework to talk to and from the server. We then leverage the iOS notification framework to notify any part of the app that wants to be made aware of any interesting events.

// [SatCom] <---> (RockBlock Server) <---> (GroundControl Server) <--> (GroundControl Apps)
// [CellCom] <---> (Particle.io Server) <---> (GroundControl Server) <--> (GroundControl Apps)



import Foundation
import SocketIO


class SocketCenter {
    let socket: SocketIOClient //Instantiate the SocketIOClient class from the official framework.
    private let manager = SocketManager(socketURL: URL(string: "http://asfmstemlab.com:81")!, config: [.log(false), .compress])
//    private let manager = SocketManager(socketURL: URL(string: "http://127.0.0.1:4200")!, config: [.log(false), .compress])
    
    private let notificationCenter = NotificationCenter.default //Get the default iOS NotificationCenter
    
    static let sharedInstance = SocketCenter() //Singleton (Only one instantiation allowed)
    
    //Abstraction of the notification flags for easy referal.
    static let newMessageNotification = Notification.Name("com.GroundControl.Socket.NewMessage")
    static let timeSyncNotification = Notification.Name("com.GroundControl.Socket.TimeSync")
    static let socketGotAllMessageNotification = Notification.Name("com.GroundControl.Socket.gotAllMessageNotification")
    static let socketConnectedNotification = Notification.Name("com.GroundControl.Socket.Connected")
    static let socketDisconnectedNotification = Notification.Name("com.GroundControl.Socket.Discconnected")
    static let socketResponseNotification = Notification.Name("com.GroundControl.Socket.NewResponse")
    public var remoteTimerSeconds:TimeInterval = 0
    
    typealias CompletionHandler = ([Any]) -> Void
    typealias AckHandler = (_ success: Bool, _ data: [Any])
        -> Void
    
    init() {
        //When we instantiate this class, this method is executed to setup everything. (See AppDelegate.swift)
        // This method only executes once since it is a singleton so it can only be initialized once and only once in the whole application.
        print("[SocketCenter] Initializing...")
        
        
        
        // Once we get a reference to the manager singleton from Socket.io framework, we setup everything and attempt to connect:
        socket = manager.defaultSocket
        
        // Setup events:
        // --------[PROTOCOL SPECIFIC EVENTS]-------------
        // When we [.connect] we:
        socket.on(clientEvent: .connect) {data, ack in
            print("[SocketCenter] Connected...")
            //..Broadcast a notification to anyone that cares and subscribed to it.
            self.notificationCenter.post(name:SocketCenter.socketConnectedNotification,
                                         object: nil,
                                         userInfo: nil)
        }
        //
        //Or when we [.reconnect], we:
        self.socket.on(clientEvent: .reconnectAttempt) {data, ack in
            print("[SocketCenter] Interruption Detected - Retrying")
            //Also notify everyone as on [.connect]
            self.notificationCenter.post(name:SocketCenter.socketDisconnectedNotification,
                                         object: nil,
                                         userInfo: nil)
        }
        
        //Or when we disconnect, we:
         socket.on(clientEvent: .disconnect) {data, ack in
            print("[SocketCenter] Disconnection Detected - Will not attempt reconnected")
            self.notificationCenter.post(name:SocketCenter.socketDisconnectedNotification,
                                         object: nil,
                                         userInfo: nil)
            //[.disconnect] only happens gracefuly. Meaning that is user requests to disconnect, so we wont attempt reconnect.
        }
        
        
        // --------[SERVER OR CUSTOM EVENTS]-------------
        //
        //When we get a new fresh report from the capsule and the server relays it to us we:
        // NOTE: This is only used for new messages arriving in realtime to the server (see getAllReports for history).
        //       We defined "RAW" in the server, we can change it in the server and have to change it here to identify this type of messages.
        socket.on("RAW") {data, ack in
            //
            //We interpret the message and create the report
            guard let rawData = data[0] as? String else { return }
            print("[SocketCenter] New Message Arrived: \(rawData)")
            
            let report = Report(rawString: rawData)
            //And let all observers or subscribers know and send them that message (for instance the MapView or ReportInfoView
            if (report.reportValid) {
                self.notificationCenter.post(name:SocketCenter.newMessageNotification,
                                        object: nil,
                                        userInfo: ["payload":rawData, "report":report])
            }
            
        }
        
        socket.on("TSYNC") { data, ack in
            guard let rawData = data[0] as? String else { return }
            let decodedTime = TimeInterval(rawData)
            guard let time = decodedTime else { return }
            self.remoteTimerSeconds = time
            
            let timer = Time(epoch: time)    
            
            self.notificationCenter.post(name:SocketCenter.timeSyncNotification,
                                         object: nil,
                                         userInfo: ["time":timer])
        }
        
        //----HELPERS----
        //A response was received from a request to the server. we have to see what is the date we got in order to identify what did the server sent.
        //Not used very much. We use it mostly to post to the terminal window messages that the server sends when we ask it to execute something.
        socket.on("response") {data, ack in
            guard let rawData = data[0] as? String else { return }            
            self.notificationCenter.post(name:SocketCenter.socketResponseNotification,
                                         object: nil,
                                         userInfo: ["response":rawData])
        }
        
        print("[SocketCenter] Connecting...")
    }
    
    static func connect() {
        sharedInstance.socket.connect()
    }
    
    //Request all reports from the server and run a completion handler when we get them.
    static func getAllReports(onCompletion:@escaping CompletionHandler) {
        //When we use emitWithAck, we send a message to the server and wait for the response. When we get the response, we run the completion handler and pass the data we got from the server.
        sharedInstance.socket.emitWithAck("GETLOGFILE", with: ["test"]) .timingOut(after: 10) { (data) in
            
            guard let rawData = data[0] as? String else { return }
            
            if (rawData == "NO ACK") {
                print("[SocketCenter] Request TimedOut");
                return
            }
            
            print("[SocketCenter] LogFile Arrived")
            
            //We get all the contents in the logFile from the server and we separate each line of the file \n in an array logFileByLine
//            let logFileByLine = rawData.split(separator: "\r")
            let logFileByLine = rawData.components(separatedBy: .newlines)
            
            var reports = [Report]() //An Array of Report structs [models] see Report.swift
            for (idx, line) in logFileByLine.enumerated() { //We iterate on everyline and then use the Report initializer to create an array of Report structs. Each one corresponds to a line in the logFile, which in turn corresponds to an individual report event from the capsule.
                print("[SocketCenter] Processing line \(idx)")
                var report = Report(rawString: String(line))
                report.index = idx
                reports.append(report)
            }
            
            //We run the completion handler closure and pass the reports array containing all Report structs parsed and initialized.
            onCompletion(reports)
            
            
        }
        
    }
    
    //Send a message to the server
    static func sendMessage(event:String, data:[Any]) {
        sharedInstance.socket.emit(event, with: data)
    }
    
    static func send(event: String, data:[Any], onAck ack: AckHandler?) {
        sharedInstance.socket.emitWithAck(event, with:data) .timingOut(after: 30) {(data) in
            guard let rawData = data[0] as? String else { return }
            guard let ack = ack else { return }
            
            if (rawData == "NO ACK") {
                print("[SocketCenter] Request TimedOut");
                ack(false, [])
                return
            }
            
            ack(true, data)
        }
    }
    

    
}

