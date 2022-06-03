import Foundation

class XmlActorsParser: NSObject, XMLParserDelegate{
    
    var name: String!
    
    init(fileName:String){self.name = fileName}
    
    // vars and objects needed for parsing
    
    var aName, aDescription, aBirthDate, aBestMovie, aImage, aLink : String!
    
    var actorsData = [Actor]()
    var actor : Actor!
    
    var elemId = -1
    var passData = false
    
    var parser : XMLParser!
    
    let tags = ["name", "description", "birthDate", "bestMovie", "image", "wikiPage"]
    
    // delegate methods
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        if tags.contains(elementName){
            passData = false
            elemId = -1
        }
        
        if elementName == "actor" {
            actorsData.append(Actor(name: aName, description: aDescription, birthDate: aBirthDate, bestMovie: aBestMovie, image: aImage, wikiLink: aLink))
        }
        
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        // check if elementName is in tags
        if(tags.contains(elementName)){
            passData = true
            elemId = tags.firstIndex(of: elementName)!
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        
        if passData {
            switch elemId {
            case 0: aName = string
            case 1: aDescription = string
            case 2: aBirthDate = string
            case 3: aBestMovie = string
            case 4: aImage = string
            case 5: aLink = string
            default: break
            }
        }
        
    }
    
    // method to parse
    
    func parsing(){
        // get the xml path
        let bundleUrl = Bundle.main.bundleURL
        let fileURL = URL(fileURLWithPath: self.name, relativeTo: bundleUrl)
        
        // make the xmlparser
        parser = XMLParser(contentsOf: fileURL)
        
        // set the delegate and parse
        parser.delegate = self
        parser.parse()
    }
}
