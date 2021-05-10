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
    
    func testTransactions() {
        let firstTransaction = clientBob.pay(to: clientAlice, amount: 50)
        clientAlice.paid(by: clientBob, transaction: firstTransaction)
        
        XCTAssertEqual(clientAlice.balance, 150.0)
        XCTAssertEqual(clientBob.balance, 30)
        
        let secondTransaction = clientBob.pay(to: clientAlice, amount: 100)
        clientAlice.paid(by: clientBob, transaction: secondTransaction)

        XCTAssertEqual(clientAlice.balance, 180.0)
        XCTAssertEqual(clientBob.balance, 0)
        XCTAssertEqual(secondTransaction.debt, 70)

        clientBob.topup(30)
        let thirdTransaction = clientBob.payDebt(for: clientAlice)
        clientAlice.paid(by: clientBob, transaction: thirdTransaction)

        XCTAssertEqual(clientAlice.balance, 210.0)
        XCTAssertEqual(clientBob.balance, 0)
        
        let fourthTransaction = clientAlice.pay(to: clientBob, amount: 30)
        clientBob.paid(by: clientAlice, transaction: fourthTransaction)

        XCTAssertEqual(clientAlice.balance, 210.0)
        XCTAssertEqual(clientBob.balance, 0)

        clientBob.topup(100)
        let fifthTransaction = clientBob.payDebt(for: clientAlice)
        clientAlice.paid(by: clientBob, transaction: fifthTransaction)

        XCTAssertEqual(clientAlice.balance, 220.0)
        XCTAssertEqual(clientBob.balance, 90.0)
    }
}
