import Foundation
import UIKit

class UpdateActorViewController: UIViewController{
    
    var actorData: Actor!
    
    @IBOutlet weak var nameTextBox: UITextField!
    @IBOutlet weak var descriptionTextBox: UITextField!
    @IBOutlet weak var birthdateTextBox: UITextField!
    @IBOutlet weak var bestMovieTextBox: UITextField!
    @IBOutlet weak var imageTextBox: UITextField!
    @IBOutlet weak var wikiLinkTextBox: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextBox.text = actorData.name
        descriptionTextBox.text = actorData.description
        birthdateTextBox.text = actorData.birthDate
        bestMovieTextBox.text = actorData.bestMovie
        wikiLinkTextBox.text = actorData.wikiLink
        imageTextBox.text = actorData.image
    }
    
    @IBAction func saveButtonAction(_ sender: Any) {
        
        var appContext = CoreDataManager.sharedManager.persistentContainer.viewContext
        var items = try! CoreDataManager.sharedManager.persistentContainer.viewContext.fetch(ActorModel.fetchRequest()) as! [ActorModel]
        
        
        for i in 0...items.count - 1{
            
            if items[i].actorName == actorData.name{
                items[i].actorName = nameTextBox.text
                items[i].actorImage = imageTextBox.text
                items[i].actorDescription = descriptionTextBox.text
                items[i].actorBirthdate = birthdateTextBox.text
                items[i].actorBestMovie = bestMovieTextBox.text
                items[i].actorWikiPage = wikiLinkTextBox.text
                break
            }
        }
        
        do
        {
           try appContext.save()
            self.showToast(message: "Successfully updated item!", font: .systemFont(ofSize: 12.0))
        }
        catch {
            self.showToast(message: "Error while trying to update entity", font: .systemFont(ofSize: 12.0))

        }
        
        CoreDataManager.sharedManager.contextHasChanged = true
        
        _ = navigationController?.popViewController(animated: true)

    }
 }
