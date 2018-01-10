# NSP2017-GroundControl-iOS
ASFM Near Space Program 2017 - Ground Station and Control for iOS (iPhone/iPad)

- Designed and created in XCode 9
- Uses Socket.io library for socket networking with the intermediary server. 
- Uses Carthage as a package and dependency manager to download and include Socket.io latest version and it's dependencies.

## How does it work?
### Comunications to Server: 
 We use a 3 party paradigm so that we can have a central repository that holds all the reports ever sent by the capsule.
 
 The capsule talks to the server thru either a Cellular Modem or a Satellite modem thru the vendor services (see the server code in the github repository for more info), and this app talks to the server. 
 
 The capsule sends messages to the servder either thru cellular modem or satellite modem at defined intervals. Each service uses it's own handler from it's own service provider to talk to the internet. In the case of the sat modem we have to use RockBlock relay service for this to work and in the case of the cellular data we use Particle.io service for the same porpouse. The latter is optional but makes coding easier and they have great data plans. 
 
 We then leverage each providers service to notify and relay the message to our own server that collects all the reports.
 Every message sent to the server (Movic.io) is stored/presisted in a file to log or keep and it is also relayed to all active GroundControl apps that are connected to the server at any given moment.

 The server is always listening for new messsages form the capsule. Once it receives a new message it saves it, and then broadcast it to every ground control station (app) that is connected to the server.

 The server is capable of receiving messages from the capsule and also managing multiple connections from ground control apps.

 We use Socket networking as a low level way to talk to the server instead of the classic REST (PUT/PUSH/GET) methods used in stateless applications.
 This method allows for a more robust realtime/push comunication protocol instead of polling every N seconds or so for new messages. This is similar like whatsapp and other chat services work. In this kind of applications this is far more efficient method for bi directional communications in real time. Socket coding is a bit more challenging because it is not stateless so we have to know where we are in the communication process at all times to react accordingly. For instance if a disconnect happens we need to try to reconnect to restablish communications and keep retrying until we connect. Also we need to know what we requested so that when the server responds we have some conext of what it is saying to us.

 To simplify this process we use a library/framework called Socket.io.
 Socket.io abstracts and simplifies the whole socket com process by adding methods and boiler plate code that help us concentrate on the business logic rather than on the tiny details of the protocol implementation. This class [SocketCenter] concentrates and encapsulates all networking and communication methods in one place and uses SIO (Socket.io) framework to talk to and from the server. We then leverage the iOS notification framework to notify any part of the app that wants to be made aware of any interesting events.

* [SatCom] <---> (RockBlock Server) <---> (GroundControl Server) <--> (GroundControl Apps)
* [CellCom] <---> (Particle.io Server) <---> (GroundControl Server) <--> (GroundControl Apps)



Designed and created at ASFM Monterrey Mexico, 2017 @ Humberto Lobo Morales STEM LAB
