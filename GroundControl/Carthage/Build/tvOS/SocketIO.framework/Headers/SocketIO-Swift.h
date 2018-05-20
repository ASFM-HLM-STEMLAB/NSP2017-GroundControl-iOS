// Generated by Apple Swift version 4.1 (swiftlang-902.0.48 clang-902.0.37.1)
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgcc-compat"

#if !defined(__has_include)
# define __has_include(x) 0
#endif
#if !defined(__has_attribute)
# define __has_attribute(x) 0
#endif
#if !defined(__has_feature)
# define __has_feature(x) 0
#endif
#if !defined(__has_warning)
# define __has_warning(x) 0
#endif

#if __has_include(<swift/objc-prologue.h>)
# include <swift/objc-prologue.h>
#endif

#pragma clang diagnostic ignored "-Wauto-import"
#include <objc/NSObject.h>
#include <stdint.h>
#include <stddef.h>
#include <stdbool.h>

#if !defined(SWIFT_TYPEDEFS)
# define SWIFT_TYPEDEFS 1
# if __has_include(<uchar.h>)
#  include <uchar.h>
# elif !defined(__cplusplus)
typedef uint_least16_t char16_t;
typedef uint_least32_t char32_t;
# endif
typedef float swift_float2  __attribute__((__ext_vector_type__(2)));
typedef float swift_float3  __attribute__((__ext_vector_type__(3)));
typedef float swift_float4  __attribute__((__ext_vector_type__(4)));
typedef double swift_double2  __attribute__((__ext_vector_type__(2)));
typedef double swift_double3  __attribute__((__ext_vector_type__(3)));
typedef double swift_double4  __attribute__((__ext_vector_type__(4)));
typedef int swift_int2  __attribute__((__ext_vector_type__(2)));
typedef int swift_int3  __attribute__((__ext_vector_type__(3)));
typedef int swift_int4  __attribute__((__ext_vector_type__(4)));
typedef unsigned int swift_uint2  __attribute__((__ext_vector_type__(2)));
typedef unsigned int swift_uint3  __attribute__((__ext_vector_type__(3)));
typedef unsigned int swift_uint4  __attribute__((__ext_vector_type__(4)));
#endif

#if !defined(SWIFT_PASTE)
# define SWIFT_PASTE_HELPER(x, y) x##y
# define SWIFT_PASTE(x, y) SWIFT_PASTE_HELPER(x, y)
#endif
#if !defined(SWIFT_METATYPE)
# define SWIFT_METATYPE(X) Class
#endif
#if !defined(SWIFT_CLASS_PROPERTY)
# if __has_feature(objc_class_property)
#  define SWIFT_CLASS_PROPERTY(...) __VA_ARGS__
# else
#  define SWIFT_CLASS_PROPERTY(...)
# endif
#endif

#if __has_attribute(objc_runtime_name)
# define SWIFT_RUNTIME_NAME(X) __attribute__((objc_runtime_name(X)))
#else
# define SWIFT_RUNTIME_NAME(X)
#endif
#if __has_attribute(swift_name)
# define SWIFT_COMPILE_NAME(X) __attribute__((swift_name(X)))
#else
# define SWIFT_COMPILE_NAME(X)
#endif
#if __has_attribute(objc_method_family)
# define SWIFT_METHOD_FAMILY(X) __attribute__((objc_method_family(X)))
#else
# define SWIFT_METHOD_FAMILY(X)
#endif
#if __has_attribute(noescape)
# define SWIFT_NOESCAPE __attribute__((noescape))
#else
# define SWIFT_NOESCAPE
#endif
#if __has_attribute(warn_unused_result)
# define SWIFT_WARN_UNUSED_RESULT __attribute__((warn_unused_result))
#else
# define SWIFT_WARN_UNUSED_RESULT
#endif
#if __has_attribute(noreturn)
# define SWIFT_NORETURN __attribute__((noreturn))
#else
# define SWIFT_NORETURN
#endif
#if !defined(SWIFT_CLASS_EXTRA)
# define SWIFT_CLASS_EXTRA
#endif
#if !defined(SWIFT_PROTOCOL_EXTRA)
# define SWIFT_PROTOCOL_EXTRA
#endif
#if !defined(SWIFT_ENUM_EXTRA)
# define SWIFT_ENUM_EXTRA
#endif
#if !defined(SWIFT_CLASS)
# if __has_attribute(objc_subclassing_restricted)
#  define SWIFT_CLASS(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) __attribute__((objc_subclassing_restricted)) SWIFT_CLASS_EXTRA
#  define SWIFT_CLASS_NAMED(SWIFT_NAME) __attribute__((objc_subclassing_restricted)) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
# else
#  define SWIFT_CLASS(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
#  define SWIFT_CLASS_NAMED(SWIFT_NAME) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
# endif
#endif

#if !defined(SWIFT_PROTOCOL)
# define SWIFT_PROTOCOL(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) SWIFT_PROTOCOL_EXTRA
# define SWIFT_PROTOCOL_NAMED(SWIFT_NAME) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_PROTOCOL_EXTRA
#endif

#if !defined(SWIFT_EXTENSION)
# define SWIFT_EXTENSION(M) SWIFT_PASTE(M##_Swift_, __LINE__)
#endif

#if !defined(OBJC_DESIGNATED_INITIALIZER)
# if __has_attribute(objc_designated_initializer)
#  define OBJC_DESIGNATED_INITIALIZER __attribute__((objc_designated_initializer))
# else
#  define OBJC_DESIGNATED_INITIALIZER
# endif
#endif
#if !defined(SWIFT_ENUM_ATTR)
# if defined(__has_attribute) && __has_attribute(enum_extensibility)
#  define SWIFT_ENUM_ATTR __attribute__((enum_extensibility(open)))
# else
#  define SWIFT_ENUM_ATTR
# endif
#endif
#if !defined(SWIFT_ENUM)
# define SWIFT_ENUM(_type, _name) enum _name : _type _name; enum SWIFT_ENUM_ATTR SWIFT_ENUM_EXTRA _name : _type
# if __has_feature(generalized_swift_name)
#  define SWIFT_ENUM_NAMED(_type, _name, SWIFT_NAME) enum _name : _type _name SWIFT_COMPILE_NAME(SWIFT_NAME); enum SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_ENUM_ATTR SWIFT_ENUM_EXTRA _name : _type
# else
#  define SWIFT_ENUM_NAMED(_type, _name, SWIFT_NAME) SWIFT_ENUM(_type, _name)
# endif
#endif
#if !defined(SWIFT_UNAVAILABLE)
# define SWIFT_UNAVAILABLE __attribute__((unavailable))
#endif
#if !defined(SWIFT_UNAVAILABLE_MSG)
# define SWIFT_UNAVAILABLE_MSG(msg) __attribute__((unavailable(msg)))
#endif
#if !defined(SWIFT_AVAILABILITY)
# define SWIFT_AVAILABILITY(plat, ...) __attribute__((availability(plat, __VA_ARGS__)))
#endif
#if !defined(SWIFT_DEPRECATED)
# define SWIFT_DEPRECATED __attribute__((deprecated))
#endif
#if !defined(SWIFT_DEPRECATED_MSG)
# define SWIFT_DEPRECATED_MSG(...) __attribute__((deprecated(__VA_ARGS__)))
#endif
#if __has_feature(attribute_diagnose_if_objc)
# define SWIFT_DEPRECATED_OBJC(Msg) __attribute__((diagnose_if(1, Msg, "warning")))
#else
# define SWIFT_DEPRECATED_OBJC(Msg) SWIFT_DEPRECATED_MSG(Msg)
#endif
#if __has_feature(modules)
@import Foundation;
@import ObjectiveC;
@import Dispatch;
#endif

#pragma clang diagnostic ignored "-Wproperty-attribute-mismatch"
#pragma clang diagnostic ignored "-Wduplicate-method-arg"
#if __has_warning("-Wpragma-clang-attribute")
# pragma clang diagnostic ignored "-Wpragma-clang-attribute"
#endif
#pragma clang diagnostic ignored "-Wunknown-pragmas"
#pragma clang diagnostic ignored "-Wnullability"

#if __has_attribute(external_source_symbol)
# pragma push_macro("any")
# undef any
# pragma clang attribute push(__attribute__((external_source_symbol(language="Swift", defined_in="SocketIO",generated_declaration))), apply_to=any(function,enum,objc_interface,objc_category,objc_protocol))
# pragma pop_macro("any")
#endif












/// A class that represents an emit that will request an ack that has not yet been sent.
/// Call <code>timingOut(after:callback:)</code> to complete the emit
/// Example:
/// \code
/// socket.emitWithAck("myEvent").timingOut(after: 1) {data in
///     ...
/// }
///
/// \endcode
SWIFT_CLASS("_TtC8SocketIO13OnAckCallback")
@interface OnAckCallback : NSObject
/// Completes an emitWithAck. If this isn’t called, the emit never happens.
/// \param seconds The number of seconds before this emit times out if an ack hasn’t been received.
///
/// \param callback The callback called when an ack is received, or when a timeout happens.
/// To check for timeout, use <code>SocketAckStatus</code>’s <code>noAck</code> case.
///
- (void)timingOutAfter:(double)seconds callback:(void (^ _Nonnull)(NSArray * _Nonnull))callback;
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
+ (nonnull instancetype)new SWIFT_DEPRECATED_MSG("-init is unavailable");
@end


/// A wrapper around Starscream’s SSLSecurity that provides a minimal Objective-C interface.
SWIFT_CLASS("_TtC8SocketIO11SSLSecurity")
@interface SSLSecurity : NSObject
/// Creates a new SSLSecurity that specifies whether to use publicKeys or certificates should be used for SSL
/// pinning validation
/// \param usePublicKeys is to specific if the publicKeys or certificates should be used for SSL pinning
/// validation
///
- (nonnull instancetype)initWithUsePublicKeys:(BOOL)usePublicKeys;
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
+ (nonnull instancetype)new SWIFT_DEPRECATED_MSG("-init is unavailable");
@end


/// A class that represents a waiting ack call.
/// <em>NOTE</em>: You should not store this beyond the life of the event handler.
SWIFT_CLASS("_TtC8SocketIO16SocketAckEmitter")
@interface SocketAckEmitter : NSObject
/// Call to ack receiving this event.
/// \param items An array of items to send when acking. Use <code>[]</code> to send nothing.
///
- (void)with:(NSArray * _Nonnull)items;
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
+ (nonnull instancetype)new SWIFT_DEPRECATED_MSG("-init is unavailable");
@end


/// Represents some event that was received.
SWIFT_CLASS("_TtC8SocketIO14SocketAnyEvent")
@interface SocketAnyEvent : NSObject
/// The event name.
@property (nonatomic, readonly, copy) NSString * _Nonnull event;
/// The data items for this event.
@property (nonatomic, readonly, copy) NSArray * _Nullable items;
/// The description of this event.
@property (nonatomic, readonly, copy) NSString * _Nonnull description;
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
+ (nonnull instancetype)new SWIFT_DEPRECATED_MSG("-init is unavailable");
@end

@class NSHTTPCookie;
@class WebSocket;
@protocol SocketEngineClient;
enum SocketEnginePacketType : NSInteger;

/// The class that handles the engine.io protocol and transports.
/// See <code>SocketEnginePollable</code> and <code>SocketEngineWebsocket</code> for transport specific methods.
SWIFT_CLASS("_TtC8SocketIO12SocketEngine")
@interface SocketEngine : NSObject <NSURLSessionDelegate>
/// The queue that all engine actions take place on.
@property (nonatomic, readonly, strong) dispatch_queue_t _Nonnull engineQueue;
/// The connect parameters sent during a connect.
@property (nonatomic, copy) NSDictionary<NSString *, id> * _Nullable connectParams;
/// A dictionary of extra http headers that will be set during connection.
@property (nonatomic, copy) NSDictionary<NSString *, NSString *> * _Nullable extraHeaders;
/// <code>true</code> if this engine is closed.
@property (nonatomic, readonly) BOOL closed;
/// If <code>true</code> the engine will attempt to use WebSocket compression.
@property (nonatomic, readonly) BOOL compress;
/// <code>true</code> if this engine is connected. Connected means that the initial poll connect has succeeded.
@property (nonatomic, readonly) BOOL connected;
/// An array of HTTPCookies that are sent during the connection.
@property (nonatomic, readonly, copy) NSArray<NSHTTPCookie *> * _Nullable cookies;
/// When <code>true</code>, the engine is in the process of switching to WebSockets.
/// <em>Do not touch this directly</em>
@property (nonatomic, readonly) BOOL fastUpgrade;
/// When <code>true</code>, the engine will only use HTTP long-polling as a transport.
@property (nonatomic, readonly) BOOL forcePolling;
/// When <code>true</code>, the engine will only use WebSockets as a transport.
@property (nonatomic, readonly) BOOL forceWebsockets;
/// If <code>true</code>, the engine is currently in HTTP long-polling mode.
@property (nonatomic, readonly) BOOL polling;
/// If <code>true</code>, the engine is currently seeing whether it can upgrade to WebSockets.
@property (nonatomic, readonly) BOOL probing;
/// The session id for this engine.
@property (nonatomic, readonly, copy) NSString * _Nonnull sid;
/// The path to engine.io.
@property (nonatomic, readonly, copy) NSString * _Nonnull socketPath;
/// The url for polling.
@property (nonatomic, readonly, copy) NSURL * _Nonnull urlPolling;
/// The url for WebSockets.
@property (nonatomic, readonly, copy) NSURL * _Nonnull urlWebSocket;
/// If <code>true</code>, then the engine is currently in WebSockets mode.
@property (nonatomic, readonly) BOOL websocket;
/// The WebSocket for this engine.
@property (nonatomic, readonly, strong) WebSocket * _Nullable ws;
/// The client for this engine.
@property (nonatomic, weak) id <SocketEngineClient> _Nullable client;
/// Creates a new engine.
/// \param client The client for this engine.
///
/// \param url The url for this engine.
///
/// \param options The options for this engine.
///
- (nonnull instancetype)initWithClient:(id <SocketEngineClient> _Nonnull)client url:(NSURL * _Nonnull)url options:(NSDictionary<NSString *, id> * _Nullable)options;
/// Starts the connection to the server.
- (void)connect;
/// Called when an error happens during execution. Causes a disconnection.
- (void)didErrorWithReason:(NSString * _Nonnull)reason;
/// Disconnects from the server.
/// \param reason The reason for the disconnection. This is communicated up to the client.
///
- (void)disconnectWithReason:(NSString * _Nonnull)reason;
/// Called to switch from HTTP long-polling to WebSockets. After calling this method the engine will be in
/// WebSocket mode.
/// <em>You shouldn’t call this directly</em>
- (void)doFastUpgrade;
/// Causes any packets that were waiting for POSTing to be sent through the WebSocket. This happens because when
/// the engine is attempting to upgrade to WebSocket it does not do any POSTing.
/// <em>You shouldn’t call this directly</em>
- (void)flushWaitingForPostToWebSocket;
/// Parses raw binary received from engine.io.
/// \param data The data to parse.
///
- (void)parseEngineData:(NSData * _Nonnull)data;
/// Parses a raw engine.io packet.
/// \param message The message to parse.
///
- (void)parseEngineMessage:(NSString * _Nonnull)message;
/// Writes a message to engine.io, independent of transport.
/// \param msg The message to send.
///
/// \param type The type of this message.
///
/// \param data Any data that this message has.
///
- (void)write:(NSString * _Nonnull)msg withType:(enum SocketEnginePacketType)type withData:(NSArray<NSData *> * _Nonnull)data;
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
+ (nonnull instancetype)new SWIFT_DEPRECATED_MSG("-init is unavailable");
@end




/// Declares that a type will be a delegate to an engine.
SWIFT_PROTOCOL("_TtP8SocketIO18SocketEngineClient_")
@protocol SocketEngineClient
/// Called when the engine errors.
/// \param reason The reason the engine errored.
///
- (void)engineDidErrorWithReason:(NSString * _Nonnull)reason;
/// Called when the engine closes.
/// \param reason The reason that the engine closed.
///
- (void)engineDidCloseWithReason:(NSString * _Nonnull)reason;
/// Called when the engine opens.
/// \param reason The reason the engine opened.
///
- (void)engineDidOpenWithReason:(NSString * _Nonnull)reason;
/// Called when the engine receives a pong message.
- (void)engineDidReceivePong;
/// Called when the engine sends a ping to the server.
- (void)engineDidSendPing;
/// Called when the engine has a message that must be parsed.
/// \param msg The message that needs parsing.
///
- (void)parseEngineMessage:(NSString * _Nonnull)msg;
/// Called when the engine receives binary data.
/// \param data The data the engine received.
///
- (void)parseEngineBinaryData:(NSData * _Nonnull)data;
@end

/// Represents the type of engine.io packet types.
typedef SWIFT_ENUM(NSInteger, SocketEnginePacketType) {
/// Open message.
  SocketEnginePacketTypeOpen = 0,
/// Close message.
  SocketEnginePacketTypeClose = 1,
/// Ping message.
  SocketEnginePacketTypePing = 2,
/// Pong message.
  SocketEnginePacketTypePong = 3,
/// Regular message.
  SocketEnginePacketTypeMessage = 4,
/// Upgrade message.
  SocketEnginePacketTypeUpgrade = 5,
/// NOOP.
  SocketEnginePacketTypeNoop = 6,
};


/// Specifies a SocketEngine.
SWIFT_PROTOCOL("_TtP8SocketIO16SocketEngineSpec_")
@protocol SocketEngineSpec
/// The client for this engine.
@property (nonatomic, strong) id <SocketEngineClient> _Nullable client;
/// <code>true</code> if this engine is closed.
@property (nonatomic, readonly) BOOL closed;
/// If <code>true</code> the engine will attempt to use WebSocket compression.
@property (nonatomic, readonly) BOOL compress;
/// <code>true</code> if this engine is connected. Connected means that the initial poll connect has succeeded.
@property (nonatomic, readonly) BOOL connected;
/// The connect parameters sent during a connect.
@property (nonatomic, copy) NSDictionary<NSString *, id> * _Nullable connectParams;
/// An array of HTTPCookies that are sent during the connection.
@property (nonatomic, readonly, copy) NSArray<NSHTTPCookie *> * _Nullable cookies;
/// The queue that all engine actions take place on.
@property (nonatomic, readonly, strong) dispatch_queue_t _Nonnull engineQueue;
/// A dictionary of extra http headers that will be set during connection.
@property (nonatomic, copy) NSDictionary<NSString *, NSString *> * _Nullable extraHeaders;
/// When <code>true</code>, the engine is in the process of switching to WebSockets.
@property (nonatomic, readonly) BOOL fastUpgrade;
/// When <code>true</code>, the engine will only use HTTP long-polling as a transport.
@property (nonatomic, readonly) BOOL forcePolling;
/// When <code>true</code>, the engine will only use WebSockets as a transport.
@property (nonatomic, readonly) BOOL forceWebsockets;
/// If <code>true</code>, the engine is currently in HTTP long-polling mode.
@property (nonatomic, readonly) BOOL polling;
/// If <code>true</code>, the engine is currently seeing whether it can upgrade to WebSockets.
@property (nonatomic, readonly) BOOL probing;
/// The session id for this engine.
@property (nonatomic, readonly, copy) NSString * _Nonnull sid;
/// The path to engine.io.
@property (nonatomic, readonly, copy) NSString * _Nonnull socketPath;
/// The url for polling.
@property (nonatomic, readonly, copy) NSURL * _Nonnull urlPolling;
/// The url for WebSockets.
@property (nonatomic, readonly, copy) NSURL * _Nonnull urlWebSocket;
/// If <code>true</code>, then the engine is currently in WebSockets mode.
@property (nonatomic, readonly) BOOL websocket;
/// The WebSocket for this engine.
@property (nonatomic, readonly, strong) WebSocket * _Nullable ws;
/// Creates a new engine.
/// \param client The client for this engine.
///
/// \param url The url for this engine.
///
/// \param options The options for this engine.
///
- (nonnull instancetype)initWithClient:(id <SocketEngineClient> _Nonnull)client url:(NSURL * _Nonnull)url options:(NSDictionary<NSString *, id> * _Nullable)options;
/// Starts the connection to the server.
- (void)connect;
/// Called when an error happens during execution. Causes a disconnection.
- (void)didErrorWithReason:(NSString * _Nonnull)reason;
/// Disconnects from the server.
/// \param reason The reason for the disconnection. This is communicated up to the client.
///
- (void)disconnectWithReason:(NSString * _Nonnull)reason;
/// Called to switch from HTTP long-polling to WebSockets. After calling this method the engine will be in
/// WebSocket mode.
/// <em>You shouldn’t call this directly</em>
- (void)doFastUpgrade;
/// Causes any packets that were waiting for POSTing to be sent through the WebSocket. This happens because when
/// the engine is attempting to upgrade to WebSocket it does not do any POSTing.
/// <em>You shouldn’t call this directly</em>
- (void)flushWaitingForPostToWebSocket;
/// Parses raw binary received from engine.io.
/// \param data The data to parse.
///
- (void)parseEngineData:(NSData * _Nonnull)data;
/// Parses a raw engine.io packet.
/// \param message The message to parse.
///
- (void)parseEngineMessage:(NSString * _Nonnull)message;
/// Writes a message to engine.io, independent of transport.
/// \param msg The message to send.
///
/// \param type The type of this message.
///
/// \param data Any data that this message has.
///
- (void)write:(NSString * _Nonnull)msg withType:(enum SocketEnginePacketType)type withData:(NSArray<NSData *> * _Nonnull)data;
@end

@protocol SocketManagerSpec;
enum SocketIOStatus : NSInteger;

/// Represents a socket.io-client.
/// Clients are created through a <code>SocketManager</code>, which owns the <code>SocketEngineSpec</code> that controls the connection to the server.
/// For example:
/// \code
/// // Create a socket for the /swift namespace
/// let socket = manager.socket(forNamespace: "/swift")
///
/// // Add some handlers and connect
///
/// \endcode<em>NOTE</em>: The client is not thread/queue safe, all interaction with the socket should be done on the <code>manager.handleQueue</code>
SWIFT_CLASS("_TtC8SocketIO14SocketIOClient")
@interface SocketIOClient : NSObject
/// The namespace that this socket is currently connected to.
/// <em>Must</em> start with a <code>/</code>.
@property (nonatomic, readonly, copy) NSString * _Nonnull nsp;
/// The session id of this client.
@property (nonatomic, readonly, copy) NSString * _Nonnull sid;
/// The manager for this socket.
@property (nonatomic, readonly, weak) id <SocketManagerSpec> _Nullable manager;
/// The status of this client.
@property (nonatomic, readonly) enum SocketIOStatus status;
/// Type safe way to create a new SocketIOClient. <code>opts</code> can be omitted.
/// \param manager The manager for this socket.
///
/// \param nsp The namespace of the socket.
///
- (nonnull instancetype)initWithManager:(id <SocketManagerSpec> _Nonnull)manager nsp:(NSString * _Nonnull)nsp OBJC_DESIGNATED_INITIALIZER;
/// Connect to the server. The same as calling <code>connect(timeoutAfter:withHandler:)</code> with a timeout of 0.
/// Only call after adding your event listeners, unless you know what you’re doing.
- (void)connect;
/// Connect to the server. If we aren’t connected after <code>timeoutAfter</code> seconds, then <code>withHandler</code> is called.
/// Only call after adding your event listeners, unless you know what you’re doing.
/// \param timeoutAfter The number of seconds after which if we are not connected we assume the connection
/// has failed. Pass 0 to never timeout.
///
/// \param handler The handler to call when the client fails to connect.
///
- (void)connectWithTimeoutAfter:(double)timeoutAfter withHandler:(void (^ _Nullable)(void))handler;
/// Disconnects the socket.
/// This will cause the socket to leave the namespace it is associated to, as well as remove itself from the
/// <code>manager</code>.
- (void)disconnect;
/// Same as emit, but meant for Objective-C
/// \param event The event to send.
///
/// \param items The items to send with this event. Send an empty array to send no data.
///
- (void)emit:(NSString * _Nonnull)event with:(NSArray * _Nonnull)items;
/// Same as emitWithAck, but for Objective-C
/// <em>NOTE</em>: It is up to the server send an ack back, just calling this method does not mean the server will ack.
/// Check that your server’s api will ack the event being sent.
/// Example:
/// \code
/// socket.emitWithAck("myEvent", with: [1]).timingOut(after: 1) {data in
///     ...
/// }
///
/// \endcode\param event The event to send.
///
/// \param items The items to send with this event. Use <code>[]</code> to send nothing.
///
///
/// returns:
/// An <code>OnAckCallback</code>. You must call the <code>timingOut(after:)</code> method before the event will be sent.
- (OnAckCallback * _Nonnull)emitWithAck:(NSString * _Nonnull)event with:(NSArray * _Nonnull)items SWIFT_WARN_UNUSED_RESULT;
/// Called when socket.io has acked one of our emits. Causes the corresponding ack callback to be called.
/// \param ack The number for this ack.
///
/// \param data The data sent back with this ack.
///
- (void)handleAck:(NSInteger)ack data:(NSArray * _Nonnull)data;
/// Called when we get an event from socket.io.
/// \param event The name of the event.
///
/// \param data The data that was sent with this event.
///
/// \param isInternalMessage Whether this event was sent internally. If <code>true</code> it is always sent to handlers.
///
/// \param ack If > 0 then this event expects to get an ack back from the client.
///
- (void)handleEvent:(NSString * _Nonnull)event data:(NSArray * _Nonnull)data isInternalMessage:(BOOL)isInternalMessage withAck:(NSInteger)ack;
/// Call when you wish to leave a namespace and disconnect this socket.
- (void)leaveNamespace;
/// Joins <code>nsp</code>.
- (void)joinNamespace;
/// Removes handler(s) based on an event name.
/// If you wish to remove a specific event, call the <code>off(id:)</code> with the UUID received from its <code>on</code> call.
/// \param event The event to remove handlers for.
///
- (void)off:(NSString * _Nonnull)event;
/// Removes a handler with the specified UUID gotten from an <code>on</code> or <code>once</code>
/// If you want to remove all events for an event, call the off <code>off(_:)</code> method with the event name.
/// \param id The UUID of the handler you wish to remove.
///
- (void)offWithId:(NSUUID * _Nonnull)id;
/// Adds a handler for an event.
/// \param event The event name for this handler.
///
/// \param callback The callback that will execute when this event is received.
///
///
/// returns:
/// A unique id for the handler that can be used to remove it.
- (NSUUID * _Nonnull)on:(NSString * _Nonnull)event callback:(void (^ _Nonnull)(NSArray * _Nonnull, SocketAckEmitter * _Nonnull))callback;
/// Adds a single-use handler for an event.
/// \param event The event name for this handler.
///
/// \param callback The callback that will execute when this event is received.
///
///
/// returns:
/// A unique id for the handler that can be used to remove it.
- (NSUUID * _Nonnull)once:(NSString * _Nonnull)event callback:(void (^ _Nonnull)(NSArray * _Nonnull, SocketAckEmitter * _Nonnull))callback;
/// Adds a handler that will be called on every event.
/// \param handler The callback that will execute whenever an event is received.
///
- (void)onAny:(void (^ _Nonnull)(SocketAnyEvent * _Nonnull))handler;
/// Tries to reconnect to the server.
- (void)reconnect SWIFT_UNAVAILABLE_MSG("Call the manager's reconnect method");
/// Removes all handlers.
/// Can be used after disconnecting to break any potential remaining retain cycles.
- (void)removeAllHandlers;
/// Puts the socket back into the connecting state.
/// Called when the manager detects a broken connection, or when a manual reconnect is triggered.
/// \param reason The reason this socket is reconnecting.
///
- (void)setReconnectingWithReason:(NSString * _Nonnull)reason;
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
+ (nonnull instancetype)new SWIFT_DEPRECATED_MSG("-init is unavailable");
@end

/// Represents state of a manager or client.
typedef SWIFT_ENUM(NSInteger, SocketIOStatus) {
/// The client/manager has never been connected. Or the client has been reset.
  SocketIOStatusNotConnected = 0,
/// The client/manager was once connected, but not anymore.
  SocketIOStatusDisconnected = 1,
/// The client/manager is in the process of connecting.
  SocketIOStatusConnecting = 2,
/// The client/manager is currently connected.
  SocketIOStatusConnected = 3,
};


/// A manager for a socket.io connection.
/// A <code>SocketManagerSpec</code> is responsible for multiplexing multiple namespaces through a single <code>SocketEngineSpec</code>.
/// Example with <code>SocketManager</code>:
/// \code
/// let manager = SocketManager(socketURL: URL(string:"http://localhost:8080/")!)
/// let defaultNamespaceSocket = manager.defaultSocket
/// let swiftSocket = manager.socket(forNamespace: "/swift")
///
/// // defaultNamespaceSocket and swiftSocket both share a single connection to the server
///
/// \endcodeSockets created through the manager are retained by the manager. So at the very least, a single strong reference
/// to the manager must be maintained to keep sockets alive.
/// To disconnect a socket and remove it from the manager, either call <code>SocketIOClient.disconnect()</code> on the socket,
/// or call one of the <code>disconnectSocket</code> methods on this class.
SWIFT_PROTOCOL("_TtP8SocketIO17SocketManagerSpec_")
@protocol SocketManagerSpec <SocketEngineClient>
/// Returns the socket associated with the default namespace (”/”).
@property (nonatomic, readonly, strong) SocketIOClient * _Nonnull defaultSocket;
/// The engine for this manager.
@property (nonatomic, strong) id <SocketEngineSpec> _Nullable engine;
/// If <code>true</code> then every time <code>connect</code> is called, a new engine will be created.
@property (nonatomic) BOOL forceNew;
/// The queue that all interaction with the client should occur on. This is the queue that event handlers are
/// called on.
@property (nonatomic, strong) dispatch_queue_t _Nonnull handleQueue;
/// The sockets in this manager indexed by namespace.
@property (nonatomic, copy) NSDictionary<NSString *, SocketIOClient *> * _Nonnull nsps;
/// If <code>true</code>, this manager will try and reconnect on any disconnects.
@property (nonatomic) BOOL reconnects;
/// The number of seconds to wait before attempting to reconnect.
@property (nonatomic) NSInteger reconnectWait;
/// The URL of the socket.io server.
@property (nonatomic, readonly, copy) NSURL * _Nonnull socketURL;
/// The status of this manager.
@property (nonatomic, readonly) enum SocketIOStatus status;
/// Connects the underlying transport.
- (void)connect;
/// Connects a socket through this manager’s engine.
/// \param socket The socket who we should connect through this manager.
///
- (void)connectSocket:(SocketIOClient * _Nonnull)socket;
/// Called when the manager has disconnected from socket.io.
/// \param reason The reason for the disconnection.
///
- (void)didDisconnectWithReason:(NSString * _Nonnull)reason;
/// Disconnects the manager and all associated sockets.
- (void)disconnect;
/// Disconnects the given socket.
/// \param socket The socket to disconnect.
///
- (void)disconnectSocket:(SocketIOClient * _Nonnull)socket;
/// Disconnects the socket associated with <code>forNamespace</code>.
/// \param nsp The namespace to disconnect from.
///
- (void)disconnectSocketForNamespace:(NSString * _Nonnull)nsp;
/// Sends an event to the server on all namespaces in this manager.
/// \param event The event to send.
///
/// \param items The data to send with this event.
///
- (void)emitAll:(NSString * _Nonnull)event withItems:(NSArray * _Nonnull)items;
/// Tries to reconnect to the server.
/// This will cause a <code>disconnect</code> event to be emitted, as well as an <code>reconnectAttempt</code> event.
- (void)reconnect;
/// Removes the socket from the manager’s control.
/// After calling this method the socket should no longer be considered usable.
/// \param socket The socket to remove.
///
///
/// returns:
/// The socket removed, if it was owned by the manager.
- (SocketIOClient * _Nullable)removeSocket:(SocketIOClient * _Nonnull)socket;
/// Returns a <code>SocketIOClient</code> for the given namespace. This socket shares a transport with the manager.
/// Calling multiple times returns the same socket.
/// Sockets created from this method are retained by the manager.
/// Call one of the <code>disconnectSocket</code> methods on the implementing class to remove the socket from manager control.
/// Or call <code>SocketIOClient.disconnect()</code> on the client.
/// \param nsp The namespace for the socket.
///
///
/// returns:
/// A <code>SocketIOClient</code> for the given namespace.
- (SocketIOClient * _Nonnull)socketForNamespace:(NSString * _Nonnull)nsp SWIFT_WARN_UNUSED_RESULT;
@end


/// A manager for a socket.io connection.
/// A <code>SocketManager</code> is responsible for multiplexing multiple namespaces through a single <code>SocketEngineSpec</code>.
/// Example:
/// \code
/// let manager = SocketManager(socketURL: URL(string:"http://localhost:8080/")!)
/// let defaultNamespaceSocket = manager.defaultSocket
/// let swiftSocket = manager.socket(forNamespace: "/swift")
///
/// // defaultNamespaceSocket and swiftSocket both share a single connection to the server
///
/// \endcodeSockets created through the manager are retained by the manager. So at the very least, a single strong reference
/// to the manager must be maintained to keep sockets alive.
/// To disconnect a socket and remove it from the manager, either call <code>SocketIOClient.disconnect()</code> on the socket,
/// or call one of the <code>disconnectSocket</code> methods on this class.
SWIFT_CLASS("_TtC8SocketIO13SocketManager")
@interface SocketManager : NSObject <SocketManagerSpec>
/// The socket associated with the default namespace (”/”).
@property (nonatomic, readonly, strong) SocketIOClient * _Nonnull defaultSocket;
/// The URL of the socket.io server.
/// If changed after calling <code>init</code>, <code>forceNew</code> must be set to <code>true</code>, or it will only connect to the url set in the
/// init.
@property (nonatomic, readonly, copy) NSURL * _Nonnull socketURL;
/// The engine for this manager.
@property (nonatomic, strong) id <SocketEngineSpec> _Nullable engine;
/// If <code>true</code> then every time <code>connect</code> is called, a new engine will be created.
@property (nonatomic) BOOL forceNew;
/// The queue that all interaction with the client should occur on. This is the queue that event handlers are
/// called on.
/// <em>This should be a serial queue! Concurrent queues are not supported and might cause crashes and races</em>.
@property (nonatomic, strong) dispatch_queue_t _Nonnull handleQueue;
/// The sockets in this manager indexed by namespace.
@property (nonatomic, copy) NSDictionary<NSString *, SocketIOClient *> * _Nonnull nsps;
/// If <code>true</code>, this client will try and reconnect on any disconnects.
@property (nonatomic) BOOL reconnects;
/// The number of seconds to wait before attempting to reconnect.
@property (nonatomic) NSInteger reconnectWait;
/// The status of this manager.
@property (nonatomic, readonly) enum SocketIOStatus status;
/// Not so type safe way to create a SocketIOClient, meant for Objective-C compatiblity.
/// If using Swift it’s recommended to use <code>init(socketURL: NSURL, options: Set<SocketIOClientOption>)</code>
/// \param socketURL The url of the socket.io server.
///
/// \param config The config for this socket.
///
- (nonnull instancetype)initWithSocketURL:(NSURL * _Nonnull)socketURL config:(NSDictionary<NSString *, id> * _Nullable)config;
/// Connects the underlying transport and the default namespace socket.
/// Override if you wish to attach a custom <code>SocketEngineSpec</code>.
- (void)connect;
/// Connects a socket through this manager’s engine.
/// \param socket The socket who we should connect through this manager.
///
- (void)connectSocket:(SocketIOClient * _Nonnull)socket;
/// Called when the manager has disconnected from socket.io.
/// \param reason The reason for the disconnection.
///
- (void)didDisconnectWithReason:(NSString * _Nonnull)reason;
/// Disconnects the manager and all associated sockets.
- (void)disconnect;
/// Disconnects the given socket.
/// This will remove the socket for the manager’s control, and make the socket instance useless and ready for
/// releasing.
/// \param socket The socket to disconnect.
///
- (void)disconnectSocket:(SocketIOClient * _Nonnull)socket;
/// Disconnects the socket associated with <code>forNamespace</code>.
/// This will remove the socket for the manager’s control, and make the socket instance useless and ready for
/// releasing.
/// \param nsp The namespace to disconnect from.
///
- (void)disconnectSocketForNamespace:(NSString * _Nonnull)nsp;
/// Sends an event to the server on all namespaces in this manager.
/// Same as <code>emitAll(_:_:)</code>, but meant for Objective-C.
/// \param event The event to send.
///
/// \param items The data to send with this event.
///
- (void)emitAll:(NSString * _Nonnull)event withItems:(NSArray * _Nonnull)items;
/// Called when the engine closes.
/// \param reason The reason that the engine closed.
///
- (void)engineDidCloseWithReason:(NSString * _Nonnull)reason;
/// Called when the engine errors.
/// \param reason The reason the engine errored.
///
- (void)engineDidErrorWithReason:(NSString * _Nonnull)reason;
/// Called when the engine opens.
/// \param reason The reason the engine opened.
///
- (void)engineDidOpenWithReason:(NSString * _Nonnull)reason;
/// Called when the engine receives a pong message.
- (void)engineDidReceivePong;
/// Called when the sends a ping to the server.
- (void)engineDidSendPing;
/// Called when the engine has a message that must be parsed.
/// \param msg The message that needs parsing.
///
- (void)parseEngineMessage:(NSString * _Nonnull)msg;
/// Called when the engine receives binary data.
/// \param data The data the engine received.
///
- (void)parseEngineBinaryData:(NSData * _Nonnull)data;
/// Tries to reconnect to the server.
/// This will cause a <code>SocketClientEvent.reconnect</code> event to be emitted, as well as
/// <code>SocketClientEvent.reconnectAttempt</code> events.
- (void)reconnect;
/// Removes the socket from the manager’s control. One of the disconnect methods should be called before calling this
/// method.
/// After calling this method the socket should no longer be considered usable.
/// \param socket The socket to remove.
///
///
/// returns:
/// The socket removed, if it was owned by the manager.
- (SocketIOClient * _Nullable)removeSocket:(SocketIOClient * _Nonnull)socket;
/// Returns a <code>SocketIOClient</code> for the given namespace. This socket shares a transport with the manager.
/// Calling multiple times returns the same socket.
/// Sockets created from this method are retained by the manager.
/// Call one of the <code>disconnectSocket</code> methods on this class to remove the socket from manager control.
/// Or call <code>SocketIOClient.disconnect()</code> on the client.
/// \param nsp The namespace for the socket.
///
///
/// returns:
/// A <code>SocketIOClient</code> for the given namespace.
- (SocketIOClient * _Nonnull)socketForNamespace:(NSString * _Nonnull)nsp SWIFT_WARN_UNUSED_RESULT;
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
+ (nonnull instancetype)new SWIFT_DEPRECATED_MSG("-init is unavailable");
@end


#if __has_attribute(external_source_symbol)
# pragma clang attribute pop
#endif
#pragma clang diagnostic pop
