//
//  Publinks
//
//

import Foundation

public class Publink<MessageType, ChannelType>
    where ChannelType: Hashable
{
    
    public typealias CallbackType = (MessageType) -> ()
    
    private var subscribers: [CallbackType] = []
    private var channelers: [ChannelType: [CallbackType]] = [:]
    
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
    
    public func subscribe(to channel: ChannelType, _ callback: CallbackType) {
        subscribe(callback)
        if channelers[channel] == nil {
            channelers[channel] = [callback]
        } else {
            channelers[channel]?.append(callback)
        }
    }
    
    public func publish(_ message: MessageType, on channel: ChannelType, only: Bool = false) {
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
