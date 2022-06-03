import UIKit

class TableViewController: UITableViewController, UISearchBarDelegate {

    // model data
    var actorsData: Actors!
    var filteredData: Actors!
    var actorsDataCopy: Actors!
    var typeOfTableView: Bool! // false for all actors, true for favorites
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    func GetActorsData(){
        do
        {
            var actorModels = [ActorModel]()
            var actorFavoriteModels = [ActorFavoriteModel]()
            actorsData = Actors()
            
            if typeOfTableView == false{
                
                actorModels = try CoreDataManager.sharedManager.persistentContainer.viewContext.fetch(ActorModel.fetchRequest())
                actorsData.data = CoreDataManager.sharedManager.transformEntitiesToModels(data: actorModels)
            }
            else{
                actorFavoriteModels = try CoreDataManager.sharedManager.persistentContainer.viewContext.fetch(ActorFavoriteModel.fetchRequest())
                
                actorsData.data = CoreDataManager.sharedManager.transformEntitiesToModels(data: actorFavoriteModels)
            }
            
                var actors = Actors()
                
            self.actorsDataCopy = Actors()
            self.filteredData = Actors()
            self.actorsDataCopy.data = actorsData.data
            self.filteredData.data = actorsData.data

        }
        catch {
            showToast(message: String(describing: self) + ":Error while trying to get actors from DB!", font: .systemFont(ofSize: 12.0))
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.modalTransitionStyle = .flipHorizontal; searchBar.delegate = self
        GetActorsData()
    }
    override func viewWillAppear(_ animated: Bool) {
        GetActorsData()
        self.tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.getCount()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        let personData = filteredData.getPerson(index: indexPath.row)
        cell.textLabel?.text = personData.name
        cell.detailTextLabel?.text = personData.birthDate
        cell.imageView?.image = UIImage(named:personData.image)
        
        return cell
    }

    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let favoriteAction = UIContextualAction(style: .normal, title: "Favorite") { (action, view, completitionHandler) in
            
            do
            {
                var items = try CoreDataManager.sharedManager.persistentContainer.viewContext.fetch(ActorModel.fetchRequest()) as! [ActorModel]
                var favoriteActors = try CoreDataManager.sharedManager.persistentContainer.viewContext.fetch(ActorFavoriteModel.fetchRequest())
                
                let personToFavorite = self.filteredData.data[indexPath.row]
                var ok = false
                if !favoriteActors.isEmpty {
                for i in 0...favoriteActors.count - 1{
                    var castedActor = favoriteActors[i] as! ActorFavoriteModel
                    if castedActor.actorName == personToFavorite.name{
                        ok = true
                    }
                }
                }
                
                if ok == false{
                for i in 0...items.count  - 1 {
                    if items[i].actorName == personToFavorite.name{
                        var favoriteActor = ActorFavoriteModel(context: CoreDataManager.sharedManager.persistentContainer.viewContext)
                        favoriteActor.actorWikiPage = items[i].actorWikiPage
                        favoriteActor.actorName = items[i].actorName
                        favoriteActor.actorDescription = items[i].actorDescription
                        favoriteActor.actorImage = items[i].actorImage
                        favoriteActor.actorBirthdate = items[i].actorBirthdate
                        favoriteActor.actorBestMovie = items[i].actorBestMovie
                        break
                    }
                }
                }
                self.filteredData.data = CoreDataManager.sharedManager.transformEntitiesToModels(data: items)
                self.actorsData.data = CoreDataManager.sharedManager.transformEntitiesToModels(data: items)
                
                try CoreDataManager.sharedManager.persistentContainer.viewContext.save()
                self.showToast(message: "Successfully added item to favorite!", font: .systemFont(ofSize: 12.0))

            }
            catch {
                self.showToast(message: "Error while trying to delete from DB", font: .systemFont(ofSize: 12.0))
            }
        }
        
        favoriteAction.backgroundColor = UIColor(red: 28.0/255.0, green: 165.0/255.0, blue: 253.0/255.0, alpha: 1.0)
        if typeOfTableView == false{
            let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completitionHandler) in
                
                do
                {
                    var items = try CoreDataManager.sharedManager.persistentContainer.viewContext.fetch(ActorModel.fetchRequest()) as! [ActorModel]
                    
                    let personToRemove = self.filteredData.data[indexPath.row]
                    for i in 0...items.count{
                        if items[i].actorName == personToRemove.name{
                            CoreDataManager.sharedManager.persistentContainer.viewContext.delete(items[i])
                            items.remove(at: i)
                            break
                        }
                    }
                    
                    self.filteredData.data = CoreDataManager.sharedManager.transformEntitiesToModels(data: items)
                    self.actorsData.data = CoreDataManager.sharedManager.transformEntitiesToModels(data: items)
                    
                    tableView.deleteRows(at: [indexPath], with: .fade)
                    try CoreDataManager.sharedManager.persistentContainer.viewContext.save()
                    self.showToast(message: "Successfully deleted item!", font: .systemFont(ofSize: 12.0))
                }
                catch {
                    self.showToast(message: "Error while trying to delete from DB", font: .systemFont(ofSize: 12.0))
                }
            }
            
            return UISwipeActionsConfiguration(actions: [favoriteAction, deleteAction])
        }
                else{
                    let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completitionHandler) in
                        
                        do
                        {
                            var items = try CoreDataManager.sharedManager.persistentContainer.viewContext.fetch(ActorFavoriteModel.fetchRequest()) as! [ActorFavoriteModel]
                            
                            let personToRemove = self.filteredData.data[indexPath.row]
                            for i in 0...items.count{
                                if items[i].actorName == personToRemove.name{
                                    CoreDataManager.sharedManager.persistentContainer.viewContext.delete(items[i])
                                    items.remove(at: i)
                                    break
                                }
                            }
                            self.filteredData.data = CoreDataManager.sharedManager.transformEntitiesToModels(data: items)
                            self.actorsData.data = CoreDataManager.sharedManager.transformEntitiesToModels(data: items)
                            
                            tableView.deleteRows(at: [indexPath], with: .fade)
                            try CoreDataManager.sharedManager.persistentContainer.viewContext.save()
                            self.showToast(message: "Successfully deleted item!", font: .systemFont(ofSize: 12.0))

                        }
                        catch {
                            self.showToast(message: "Error while trying to delete from DB", font: .systemFont(ofSize: 12.0))
                        }
                    }
                    
            return UISwipeActionsConfiguration(actions: [deleteAction])
        }
            }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == "personSegue") {
            let destController = segue.destination as! PersonViewController;
            destController.actorsData = filteredData
            let indexPath = tableView.indexPath(for: sender as! UITableViewCell)
            
            var index = 0
            for person in actorsData.data {
                if person.name == filteredData.data[indexPath!.row].name{
                    destController.index = index
                }
                index = index + 1
            }
        }
        
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
       
        filteredData.data = []
        
        if searchText == ""{
            filteredData.data = actorsData.data
        }
        else {
            for actor in actorsData.data {                                                                                 if actor.name.lowercased().contains(searchText.lowercased()) {
                    filteredData.data.append(actor)
                }
            }
        }
        
        self.tableView.reloadData()
    }
}
