//
//  Publinks
//
//

import Foundation

// TODO:
//   Ideally this would be generic over ChannelType, rather than assuming String.
//   Unfortunately, this doesn't seem to be valid syntax:
//
//        class Publink<MessageType, ChannelType = String> {
//            ...
//        }
//
//   Attempting to provide a partial implementation of the type parameters:
//
//       <T> -> Publink<T, String>
//
//   yields a compiler error: "cannot explicitly specialize a generic function"

public class Publink<MessageType>{
    
    public typealias CallbackType = (MessageType) -> ()
    
    private var subscribers: [CallbackType] = []
    private var channelers: [String: [CallbackType]] = [:]
    
    ///
    
    public init() {
    }
    
    public func subscribe(_ callback: CallbackType) {
        subscribers.append(callback)
    }

    public func publish(_ message: MessageType) {
        for fn in subscribers {
            fn(message)
        }
    }
    
    public func subscribe(to channel: String, _ callback: CallbackType) {
        subscribe(callback)
        if channelers[channel] == nil {
            channelers[channel] = [callback]
        } else {
            channelers[channel]?.append(callback)
        }
    }
    
    public func publish(_ message: MessageType, on channel: String, only: Bool = false) {
        if !only {
            publish(message)
        }
        
        guard let subscribers = channelers[channel]
            else { return }
        
        for fn in subscribers {
            fn(message)
        }
    }
}
