//
//  ClientTest.swift
//  MockBankAppTests
//
//  Created by Siva Dayalan on 11/5/21.
//

import XCTest
@testable import MockBankApp

class ClientTest: XCTestCase {

    var clientAlice = Client(name: "Alice", balance: 100)
    var clientBob = Client(name: "Bob", balance: 80)
    
    func testBalance() {
        XCTAssertEqual(clientAlice.balance, 100.0)
        XCTAssertEqual(clientBob.balance, 80)
    }

}
