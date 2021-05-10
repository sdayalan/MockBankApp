//
//  Client.swift
//  MockBankApp
//
//  Created by Siva Dayalan on 11/5/21.
//

import Foundation

struct Client {
    
    /// Client's name
    let name: String
    
    /// Client's account Balance
    var balance: Double
    
    /// client's debts
    var debted = [Client: Double]()
    
    /// Owed to Client
    var owed = [Client: Double]()
}

extension Client: Hashable {}

extension Client: Equatable {
    static func ==(lhs: Client, rhs: Client) -> Bool {
        return lhs.name == rhs.name
    }
}

typealias Transaction = (amount: Double, debt: Double, owe: Double)


