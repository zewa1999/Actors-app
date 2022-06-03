import UIKit

class PersonViewController: UIViewController {

    // outlets
    
    @IBOutlet weak var personImageView: UIImageView!
    @IBOutlet weak var personNameLabel: UILabel!
    
    @IBAction func previousPerson(_ sender: Any) {
        index = index == 0 ? actorsData.getCount()-1 : index-1
        updateViews()
    }
    
    @IBAction func nextPerson(_ sender: Any) {
        index = index == actorsData.getCount()-1 ? 0 : index+1
        updateViews()
    }
    
    // model object
    var actorsData: Actors!
    var actorData: Actor!
    
    // other vars and methods
    var index = 0
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        
        var items = try! CoreDataManager.sharedManager.persistentContainer.viewContext.fetch(ActorModel.fetchRequest()) as! [ActorModel]
        
        actorsData = Actors()
        actorsData.data = CoreDataManager.sharedManager.transformEntitiesToModels(data: items)
        actorData = actorsData.getPerson(index: index)
        
        personNameLabel.text = actorData.name
        personImageView.image = UIImage(named: actorData.image)
    }
    
    func updateViews(){
        // get person
        var items = try! CoreDataManager.sharedManager.persistentContainer.viewContext.fetch(ActorModel.fetchRequest()) as! [ActorModel]

        actorsData = Actors()
        actorsData.data = CoreDataManager.sharedManager.transformEntitiesToModels(data: items)
        actorData = actorsData.getPerson(index: index)
        
        // update views
        personNameLabel.text = actorData.name
        personImageView.image = UIImage(named: actorData.image)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.modalTransitionStyle = .flipHorizontal;        // put data on outlets
        updateViews()
        
        if (CoreDataManager.sharedManager.contextHasChanged == true)
        {
            do
            {
                
                var items = try CoreDataManager.sharedManager.persistentContainer.viewContext.fetch(ActorModel.fetchRequest()) as! [ActorModel]
                
                    var actors = Actors()
                    
                actorsData.data = CoreDataManager.sharedManager.transformEntitiesToModels(data: items)
                    
            }
            catch {
                self.showToast(message: "Error while trying to get actors from DB!", font: .systemFont(ofSize: 12.0))
            }
            
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "personToDetailsSegue" {
            
            // Get the new view controller using segue.destination.
            let destController = segue.destination as! DetailsViewController
            
            // Pass the data object to the new view controller.
            destController.personData = actorData
        }
        
        if segue.identifier == "updateSegue"{
            let destController = segue.destination as! UpdateActorViewController
            
            destController.actorData = self.actorData
        }
        
    }

}
