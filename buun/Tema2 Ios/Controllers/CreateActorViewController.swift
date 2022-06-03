import Foundation
import UIKit

class CreateActorViewController: UIViewController{
    
    
    @IBOutlet weak var nameTextBox: UITextField!
    @IBOutlet weak var descriptionTextBox: UITextField!
    @IBOutlet weak var wikiLinkTextBox: UITextField!
    @IBOutlet weak var imageTextBox: UITextField!
    @IBOutlet weak var bestMovieTextBox: UITextField!
    @IBOutlet weak var birthdateTextBox: UITextField!
    
    @IBAction func saveButtonAction(_ sender: Any) {
        var appContext = CoreDataManager.sharedManager.persistentContainer.viewContext
        
        
        let dateRegex = "^([0]?[1-9]|[1|2][0-9]|[3][0|1])[./-]([0]?[1-9]|[1][0-2])[./-]([0-9]{4}|[0-9]{2})$"
        if let range = birthdateTextBox.text?.range(of: dateRegex, options: .regularExpression){
            
        }
        
        
        var actorModel = ActorModel(context: appContext)
        actorModel.actorName = nameTextBox.text
        actorModel.actorBestMovie = bestMovieTextBox.text
        actorModel.actorBirthdate = birthdateTextBox.text
        actorModel.actorDescription = descriptionTextBox.text
        actorModel.actorImage = imageTextBox.text
        actorModel.actorWikiPage = wikiLinkTextBox.text
        
        do
        {
           try appContext.save()
            self.showToast(message: "Successfully created new actor!", font: .systemFont(ofSize: 12.0))
        }
        catch {
            self.showToast(message: "Error while trying to save the new actor!", font: .systemFont(ofSize: 12.0))
        }
        CoreDataManager.sharedManager.contextHasChanged = true

    }
}
