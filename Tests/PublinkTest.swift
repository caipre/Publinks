//
//  Publinks
//
//

import Publinks
import XCTest

class Publisher {
    let publink = Publink<Publisher>()
    var val = 0
}

class Subscriber {
    var subscription: Publisher!
    var val = 0
    
    func receive(publisher: Publisher) {
        val = publisher.val
    }
}

class PublinksTest: XCTestCase {
    var publisher: Publisher!
    var subscriber: Subscriber!
    var subscriber2: Subscriber!
    
    override func setUp() {
        publisher = Publisher()
        subscriber = Subscriber()
        subscriber2 = Subscriber()
    }

    func testPubsub() {
        publisher.publink.subscribe(subscriber.receive)
        publisher.val = 1
        publisher.publink.publish(publisher)
        XCTAssert(subscriber.val == 1)
    }
    
    func testChannels() {
        publisher.publink.subscribe(subscriber.receive)
        publisher.publink.subscribe(to: "channel", subscriber2.receive)
        
        publisher.val = 1
        publisher.publink.publish(publisher)
        XCTAssert(subscriber.val == 1)
        XCTAssert(subscriber2.val == 1)
        
        publisher.val = 2
        publisher.publink.publish(publisher, on: "channel")
        XCTAssert(subscriber.val == 2)
        XCTAssert(subscriber2.val == 2)
        
        publisher.val = 3
        publisher.publink.publish(publisher, on: "channel", only: true)
        XCTAssert(subscriber.val == 2)
        XCTAssert(subscriber2.val == 3)
    }

}
