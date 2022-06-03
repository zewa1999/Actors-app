import Foundation

class Actor {
    
    // attributes
    var name, description, birthDate, bestMovie, image, wikiLink: String;
    
    init(){
        name = ""
        description = ""
        birthDate = ""
        bestMovie = ""
        image = ""
        wikiLink = ""
    }
    
    init(name: String, description: String, birthDate: String, bestMovie: String, image:String, wikiLink:String) {
        self.name    = name;
        self.description   = description;
        self.birthDate = birthDate;
        self.bestMovie   = bestMovie;
        self.image   = image;
        self.wikiLink = wikiLink
    }
}
