import UIKit

class SplashViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    var actorsData: Actors!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.modalTransitionStyle = .flipHorizontal;
        imageView.image = UIImage(named: "andrei_costache.jpeg")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3){
            self.performSegue(withIdentifier: "firstSegue", sender: nil)
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        var items = [ActorModel]()
        let actorsData = Actors(xmlFileName: "actors.xml")
        var appContext = CoreDataManager.sharedManager.persistentContainer.viewContext
        do
        {
            items = try appContext.fetch(ActorModel.fetchRequest())
            
        }
        catch {
            //print(String(describing: self) + ": Error while trying to get entities from DB!")
            showToast(message: String(describing: self) + ": Error while trying to get entities from DB!", font: .systemFont(ofSize: 12.0))
        }
        
        if items.isEmpty{
            for actor in actorsData.data{
                var actorModel = ActorModel(context: appContext)
                actorModel.actorName = actor.name
                actorModel.actorBestMovie = actor.bestMovie
                actorModel.actorBirthdate = actor.birthDate
                actorModel.actorDescription = actor.description
                actorModel.actorImage = actor.image
                actorModel.actorWikiPage = actor.wikiLink
                
                do
                {
                   try appContext.save()
                }
                catch {
                    showToast(message: String(describing: self) + ":Error while trying to insert actors to DB!", font: .systemFont(ofSize: 12.0))
                }
                
            }
            
            do
            {
                items = try appContext.fetch(ActorModel.fetchRequest())
                
                if(segue.identifier == "firstSegue") {
                    let destController = segue.destination as! SignInViewController
                    
                }
            }
            catch {
                showToast(message: String(describing: self) + ":Error while trying to get actors from DB!", font: .systemFont(ofSize: 12.0))
            }
            
        }
        
        if(segue.identifier == "firstSegue") {
            let destController = segue.destination as! SignInViewController
        
        }
    }

}
