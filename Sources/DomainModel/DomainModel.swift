struct DomainModel {
    var text = "Hello, World!"
        // Leave this here; this value is also tested in the tests,
        // and serves to make sure that everything is working correctly
        // in the testing harness and framework.
}

////////////////////////////////////
// Money
//
public struct Money {
    var amount : Int
    var currency : String
    
//    init(amount a: Int, currency c: String) {
//        amount = a
//        currency = c
//    }
    
    func convert(_ currName : String) -> Money {
        var newAmount : Int
        
        // switch from the currency to USD first
        switch(self.currency) {
            case "GBP":
                newAmount = self.amount / 2
            case "EUR":
                newAmount = (self.amount * 2) / 3
            case "CAN":
                newAmount = (self.amount * 4) / 5
            default:
                newAmount = self.amount
        }
        
        // next: switch from USD to the currency we want
        switch(currName) {
            case "GBP":
                newAmount = self.amount * 2
            case "EUR":
                newAmount = (self.amount * 3) / 2
            case "CAN":
                newAmount = (self.amount * 5) / 4
            default:
                newAmount = self.amount
        }
        
        return Money(amount: newAmount, currency: currName)
    }

    func add(_ m : Money) -> Money {
        // if both currencies are the same
        if self.currency == m.currency {
            return Money(amount: self.amount + m.amount, currency: self.currency)
        }
        
        // else: have to normalize to USD
        let newSelf = self.convert("USD")
        let newM = m.convert("USD")
        return Money(amount: newSelf.amount + newM.amount, currency: "USD")
    }
    
    func subtract(_ m : Money) -> Money {
        // if both currencies are the same
        if self.currency == m.currency {
            return Money(amount: self.amount - m.amount, currency: self.currency)
        }
        
        // else: have to normalize to USD
        let newSelf = self.convert("USD")
        let newM = m.convert("USD")
        return Money(amount: newSelf.amount - newM.amount, currency: "USD")
    }

}

////////////////////////////////////
// Job
//
public class Job {
    public enum JobType {
        case Hourly(Double)
        case Salary(UInt)
    }
}

////////////////////////////////////
// Person
//
public class Person {
    let firstName : String
    let lastName : String
    let age : Int
    
    init(firstName f : String, lastName l : String, age a : Int) {
        firstName = f
        lastName = l
        age = a
    }
}

////////////////////////////////////
// Family
//
public class Family {
}
