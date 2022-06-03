import Foundation
import UIKit

class MenuViewController: UIViewController{
    
    var actorsData: Actors!
    
    @IBOutlet weak var createActorButton: UIButton!
    @IBOutlet weak var seeActorsButton: UIButton!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == "tableViewSegue") {
            let destController = segue.destination as! TableViewController
            
                do
                {
                    
                    var items = try CoreDataManager.sharedManager.persistentContainer.viewContext.fetch(ActorModel.fetchRequest()) as! [ActorModel]
                    
                        var actors = Actors()
                        
                        actors.data = CoreDataManager.sharedManager.transformEntitiesToModels(data: items)
                        destController.actorsData = actors
                    destController.typeOfTableView = false
                }
                catch {
                    self.showToast(message: "Error while trying to get actors from DB!", font: .systemFont(ofSize: 12.0))
                }
                
            destController.actorsData = actorsData
            }
        
        if(segue.identifier == "favoriteActorsSegue") {
            let destController = segue.destination as! TableViewController
            
                do
                {
                    
                    var items = try CoreDataManager.sharedManager.persistentContainer.viewContext.fetch(ActorFavoriteModel.fetchRequest()) as! [ActorFavoriteModel]
                    
                        var actors = Actors()
                        
                        actors.data = CoreDataManager.sharedManager.transformEntitiesToModels(data: items)
                        destController.actorsData = actors
                    destController.typeOfTableView = true
                }
                catch {
                    self.showToast(message: "Error while trying to get actors from DB", font: .systemFont(ofSize: 12.0))
                }
                
            destController.actorsData = actorsData
            }
        }
}

    

