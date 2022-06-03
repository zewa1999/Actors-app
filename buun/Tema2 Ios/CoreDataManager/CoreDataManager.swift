import Foundation
import CoreData
import UIKit

// Singleton class to have only one instance in the whole app
class CoreDataManager {
  
  static let sharedManager = CoreDataManager()
  
  var contextHasChanged : Bool

  private init() {
      contextHasChanged = false
  } // Prevent clients from creating another instance.
  
  lazy var persistentContainer: NSPersistentContainer = {
    
    let container = NSPersistentContainer(name: "ActorsModel")
    
    
    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
      
      if let error = error as NSError? {
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    })
    return container
  }()
  
  //4
  func saveContext () {
    let context = CoreDataManager.sharedManager.persistentContainer.viewContext
    if context.hasChanges {
      do {
        try context.save()
      } catch {
        // Replace this implementation with code to handle the error appropriately.
        // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        let nserror = error as NSError
        fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
      }
    }
  }
    
    func transformEntitiesToModels(data:[ActorModel]) -> [Actor]{
        
        var returnedActors = [Actor]()
        for actor in data{
            var appendedActor = Actor()
            appendedActor.wikiLink = actor.actorWikiPage!
            appendedActor.bestMovie = actor.actorBestMovie!
            appendedActor.birthDate = actor.actorBirthdate!
            appendedActor.name = actor.actorName!
            appendedActor.description = actor.actorDescription!
            appendedActor.image = actor.actorImage!
            
            returnedActors.append(appendedActor)
        }
        
        return returnedActors
    }
    
    func transformEntitiesToModels(data:[ActorFavoriteModel]) -> [Actor]{
        
        var returnedActors = [Actor]()
        for actor in data{
            var appendedActor = Actor()
            appendedActor.wikiLink = actor.actorWikiPage!
            appendedActor.bestMovie = actor.actorBestMovie!
            appendedActor.birthDate = actor.actorBirthdate!
            appendedActor.name = actor.actorName!
            appendedActor.description = actor.actorDescription!
            appendedActor.image = actor.actorImage!
            
            returnedActors.append(appendedActor)
        }
        
        return returnedActors
    }

}
