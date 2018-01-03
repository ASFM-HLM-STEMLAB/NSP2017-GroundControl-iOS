//
//  SocketManager.swift
//  GroundControl
//
//  Created by Francisco Lobo on 11/27/17.
//  Copyright © 2017 Movic Technologies. All rights reserved.
//

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
        
        socket.on(clientEvent: .connect) {data, ack in
            print("[SocketCenter] Connected...")
            self.notificationCenter.post(name:SocketCenter.socketConnectedNotification,
                                         object: nil,
                                         userInfo: nil)
        }
        
        self.socket.on(clientEvent: .reconnectAttempt) {data, ack in
            print("[SocketCenter] Interruption Detected - Retrying")
            self.notificationCenter.post(name:SocketCenter.socketDisconnectedNotification,
                                         object: nil,
                                         userInfo: nil)
        }
        
         socket.on(clientEvent: .disconnect) {data, ack in
            print("[SocketCenter] Disconnection Detected - Will not attempt reconnected")
            self.notificationCenter.post(name:SocketCenter.socketDisconnectedNotification,
                                         object: nil,
                                         userInfo: nil)
        }
        
        
        socket.on("c") {data, ack in
            guard let rawData = data[0] as? String else { return }
            print("[SocketCenter] New Message Arrived: \(rawData)")
            
            let report = Report(rawString: rawData)
            self.notificationCenter.post(name:SocketCenter.newMessageNotification,
                                    object: nil,
                                    userInfo: ["payload":rawData, "report":report])
            
        }
        
        socket.on("response") {data, ack in
            guard let rawData = data[0] as? String else { return }            
            self.notificationCenter.post(name:SocketCenter.socketResponseNotification,
                                         object: nil,
                                         userInfo: ["response":rawData])
        }
        
        
        print("[SocketCenter] Connecting...")
        socket.connect()
    }
    
    
    static func getAllReports(onCompletion:@escaping CompletionHandler) {
        sharedInstance.socket.emitWithAck("GETLOGFILE", with: ["test"]) .timingOut(after: 10) { (data) in
            
            guard let rawData = data[0] as? String else { return }
            print("[SocketCenter] LogFile Arrived")
            
            let logFileByLine = rawData.split(separator: "\n")
            
            var reports = [Report]()
            for (idx, line) in logFileByLine.enumerated() {
                print("[SocketCenter] Processing line \(idx)")
                var report = Report(rawString: String(line))
                report.index = idx
                reports.append(report)
            }
            
            onCompletion(reports)
        }
        
    }
    
    
    static func sendMessage(event:String, data:[Any]) {
        sharedInstance.socket.emit(event, with: data)
    }
    
    
}
