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

extension Client: Hashable {
    static func ==(lhs: Client, rhs: Client) -> Bool {
        return lhs.name == rhs.name && lhs.balance == rhs.balance
    }
}


typealias Transaction = (amount: Double, debt: Double, owe: Double)

extension Client {
    
    /// Pay to a client
    /// - Parameters:
    ///   - client: client to be paid
    ///   - amount: amount to be paid
    /// - Returns: Resultant Transaction
    mutating func pay(to client: Client, amount: Double) -> Transaction {
        var owedValue = 0.0
        
        for owedClient in owed {
            if owedClient.key.name == client.name {
                owedValue = owedClient.value
            }
        }
        
        if owedValue > 0 {
            if amount < owedValue {
                let value = owedValue - amount
                owed.updateValue(value, forKey: client)
                return (0, 0, value)
            } else {
                let value = amount - owedValue
                owed.updateValue(0, forKey: client)
                return (value, 0, 0)
            }
        } else if owedValue == 0 {
            if balance >=  amount {
                // Normal Payment
                balance -= amount
                return (amount, 0, 0)
            } else {
                // Debt Payment
                if balance > 0 {
                    let debt = amount - balance // make it postive
                    let paid = balance
                    balance = 0
                    debted.updateValue(debt, forKey: client)
                    return (paid, debt, 0)
                } else {
                    // topup
                    return (0, 0, 0)
                }
            }
        } else {
            return (0, 0, 0)
        }
    }
    
    /// Paid by
    /// - Parameters:
    ///   - client: Client who is paying
    ///   - transaction: Amount paid by client
    mutating func paid(by client: Client, transaction: Transaction) {
        let amount = transaction.amount
        let owe = transaction.owe
        let debt = transaction.debt
        
        if owe >= 0 {
            // owed by client. Debt to self
            debted.updateValue(owe, forKey: client)
        }
        
        if debt >= 0 {
            // debted by client. Owned by self
            owed.updateValue(debt, forKey: client)
        }
        
        if amount >= 0 {
            balance += amount
        }
    }
    
    mutating func topup(_ amount: Double) {
        balance += amount
    }
    
    /// Pay Debt
    /// - Parameter client: Client who is expecting to be paid of debts
    /// - Returns: Resultant Transaction
    mutating func payDebt(for client: Client) -> Transaction {
        var debtValue = 0.0
        
        for debtedClient in debted {
            if debtedClient.key.name == client.name {
                debtValue = debtedClient.value
            }
        }
        
        if balance > debtValue {
            balance -= debtValue
            let transaction = pay(to: client, amount: debtValue)
            debted.updateValue(0, forKey: client)
            return transaction
        } else {
            let pending = debtValue - balance
            let transaction = pay(to: client, amount: balance)
            debted.updateValue(pending, forKey: client)
            balance = 0
            return transaction
        }
    }
}

