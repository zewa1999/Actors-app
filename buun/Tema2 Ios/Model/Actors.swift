import Foundation
import UIKit

class Actors {
    var data:[Actor]
    
    init(){
        data = [Actor]()
    }
    
    init(xmlFileName:String) {
        // make a parsing object
        let xmlPeopleParser = XmlActorsParser(fileName: xmlFileName)
        xmlPeopleParser.parsing()
        
        // set data
        self.data = xmlPeopleParser.actorsData
    }
    
    func getCount()->Int{return data.count}
    func getPerson(index:Int)->Actor{return data[index]}
}
