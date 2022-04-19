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
    
    init(amount a: Int, currency c: String) {
        amount = a
        currency = c
    }
    
    func convert(_ currName : String) -> Money {
        var newAmount : Int
        
        // switch from the currency to USD first
        switch(self.currency) {
            case "GBP":
                newAmount = self.amount * 2
            case "EUR":
                newAmount = (self.amount * 2) / 3
            case "CAN":
                newAmount = (self.amount * 4) / 5
            default:
                newAmount = self.amount
        }
        
        // next: switch from USD to the currency we want
        var finalAmount : Int
        switch(currName) {
            case "GBP":
                finalAmount = newAmount / 2
            case "EUR":
                finalAmount = (newAmount * 3) / 2
            case "CAN":
                finalAmount = (newAmount * 5) / 4
            default:
                finalAmount = newAmount
        }
        
        return Money(amount: finalAmount, currency: currName)
    }

    func add(_ m : Money) -> Money {
        // if both currencies are the same
        if self.currency == m.currency {
            return Money(amount: self.amount + m.amount, currency: self.currency)
        }
        
        // else: have to normalize the currency -- should be the currency of the param
        let newSelf = self.convert(m.currency)
        return Money(amount: newSelf.amount + m.amount, currency: m.currency)
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

// job initialization ex: let job = Job(title: "Guest Lecturer", type: Job.JobType.Salary(1000))
public class Job {
    public enum JobType {
        case Hourly(Double)
        case Salary(UInt)
    }
    var title : String
    var type : JobType
    
    init(title t: String, type jt: JobType) {
        title = t
        type = jt
    }
    
    // num of hours worked is provided
    func calculateIncome(_ hours : Int) -> Int {
        switch type {
        case Job.JobType.Hourly(let h):
            return Int(h) * hours
        case Job.JobType.Salary(let s):
            return Int(s)
        }
    }
    
    // num of hours worked is not provided
    func calculateIncome() -> Int {
        switch type {
        case .Hourly(let h): return Int(h * 2000)
        case .Salary(let s): return Int(s)
        }
    }
    
    func raise(byAmount amount : Double) {
        switch type {
            case Job.JobType.Hourly(let h):
                type = Job.JobType.Hourly(h + amount)
            case Job.JobType.Salary(let s):
                type = Job.JobType.Salary(s + UInt(amount))
        }
    }
    
    func raise(byPercent percent : Double) {
        switch type {
            case Job.JobType.Hourly(let h):
                type = Job.JobType.Hourly(h * (1 + percent))
            case Job.JobType.Salary(let s):
                let newSal = Double(s) * (1 + percent)
                type = Job.JobType.Salary(UInt(newSal))
        }
    }
}

////////////////////////////////////
// Person
//
public class Person {
    var firstName : String
    var lastName : String
    var age : Int
    
    init(firstName f : String, lastName l : String, age a : Int) {
        firstName = f
        lastName = l
        age = a
    }
    
    private var spousePriv : Person? = nil
    var spouse : Person? {
        get { return spousePriv }
        set { if age > 17 { spousePriv = newValue } }
    }
    
    
    private var jobPriv : Job? = nil
    var job : Job? {
        get { return jobPriv }
        set { if age > 17 { jobPriv = newValue } }
    }
    
    func toString() -> String {
        let str = "[Person: firstName:\(self.firstName) lastName:\(self.lastName) age:\(self.age) job:\(self.job?.type) spouse:\(self.spouse?.firstName)]"
        return str
        // return "Person: \(self.firstName) lastNmae: \(self.lastName) age: \(self.age) job: \(self.job?.type) spouse: \(self.spouse?.firstName)"
        // return "Person: \(firstName) lastNmae: \(lastName) age: \(age) job: \(job?.type) spouse: \(spouse?.firstName)"
    }
}

////////////////////////////////////
// Family
//
public class Family {
    var members : [Person] = []
    var spouse1 : Person
    var spouse2 : Person
    
    init(spouse1 s1 : Person, spouse2 s2 : Person) {
        spouse1 = s1
        spouse2 = s2
        
        members.append(spouse1)
        members.append(spouse2)
        
        // setting respective spouse fields to each other
        s1.spouse = s2
        s2.spouse = s1
    }
    
    func haveChild(_ person : Person) -> Bool {
        if spouse1.age > 21 || spouse2.age > 21 {
            self.members.append(person)
            return true
        }
        return false
    }
    
    func householdIncome() -> Int {
        var totalIncome = 0
        for member in members {
            totalIncome += member.job?.calculateIncome() ?? 0
        }
        return totalIncome
    }
}
