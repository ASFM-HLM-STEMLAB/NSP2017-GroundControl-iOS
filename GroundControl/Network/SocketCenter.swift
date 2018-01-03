//
//  SocketManager.swift
//  GroundControl
//
//  Created by Francisco Lobo on 11/27/17.
//  Copyright © 2017 Movic Technologies. All rights reserved.
//

// This class is used as a central repository to control comunication to and from the server that holds the data from the capsule.

// How does it work:
// The capsule talks to the server by sending a message either thru cellular modem or satellite modem. Every message sent to the server (Movic.io) is stored in a database for later retrieval and also relayed to all active GroundControl apps connected to the server.
//
//
//
// We use Sockets to talk to the server instead of the classic REST method. So we use a more robust realtime/push comunication protocol instead of polling every N seconds or so new messages. So this is far more efficient way of bi directional communications. Socket coding is a bit more challenging because it is not stateless so we have to know where we are in the communication process at all times. So say we want to ask for the latest message, we ask the server for it but we have to remember what we asked for, so when the server responds we know that message corresponds to that request.
//
// Socket.io is a framework that helps us simplify that process by adding abstraction layers to it to simplify the process. This class uses that framework to talk to and from the server. We then leverage the iOS notification framework to notify any part of the app that wants to be notified of any interested events.


import Foundation
import SocketIO


class SocketCenter {
    let socket: SocketIOClient
    private let manager = SocketManager(socketURL: URL(string: "http://movic.io:4200")!, config: [.log(false), .compress])
    private let notificationCenter = NotificationCenter.default
    static let sharedInstance = SocketCenter()
    static let newMessageNotification = Notification.Name("com.GroundControl.Socket.NewMessage")
    static let socketConnectedNotification = Notification.Name("com.GroundControl.Socket.Connected")
    static let socketDisconnectedNotification = Notification.Name("com.GroundControl.Socket.Discconnected")
    static let socketResponseNotification = Notification.Name("com.GroundControl.Socket.NewResponse")
    
    typealias CompletionHandler = ([Any]) -> Void
    
    init() {
        print("[SocketCenter] Initializing...")
        socket = manager.defaultSocket
        
        //Every socket.on line bellow registers for a given type of message from the server and executes the code in the closure.
        //
        // So when we .connect we:
        socket.on(clientEvent: .connect) {data, ack in
            print("[SocketCenter] Connected...")
            //Send a notification in the iOS notification system to anyone that registered for it.
            self.notificationCenter.post(name:SocketCenter.socketConnectedNotification,
                                         object: nil,
                                         userInfo: nil)
        }
        //
        //Or when we reconnect, we:
        self.socket.on(clientEvent: .reconnectAttempt) {data, ack in
            print("[SocketCenter] Interruption Detected - Retrying")
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
        }
        
        //Or when we get a new fresh report from the capsule and the server let us know:
        // NOTE: Server reported a new message [New report] We use this one when we are already connected to the server and already got the full logFile (see bellow getAllReports) so once an event happens in realtime the server reports this message to us to append to the message history for plotting.
        socket.on("c") {data, ack in
            //We interpret the message and create the report
            guard let rawData = data[0] as? String else { return }
            print("[SocketCenter] New Message Arrived: \(rawData)")
            
            let report = Report(rawString: rawData)
            //And let all observers or subscribers know and send them that message (for instance the MapView or ReportInfoView
            self.notificationCenter.post(name:SocketCenter.newMessageNotification,
                                    object: nil,
                                    userInfo: ["payload":rawData, "report":report])
            
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
        socket.connect()
    }
    
    //Request all reports from the server and run a completion handler when we get them.
    static func getAllReports(onCompletion:@escaping CompletionHandler) {
        //When we use emitWithAck, we send a message to the server and wait for the response. When we get the response, we run the completion handler and pass the data we got from the server.
        sharedInstance.socket.emitWithAck("GETLOGFILE", with: ["test"]) .timingOut(after: 10) { (data) in
            
            guard let rawData = data[0] as? String else { return }
            print("[SocketCenter] LogFile Arrived")
            
            //We get all the contents in the logFile from the server and we separate each line of the file \n in an array logFileByLine
            let logFileByLine = rawData.split(separator: "\n")
            
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
    
    
}
