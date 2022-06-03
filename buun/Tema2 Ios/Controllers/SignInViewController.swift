import UIKit
import CoreData

class SignInViewController: UIViewController {
    @IBOutlet weak var emailTextBox: UITextField!
    @IBOutlet weak var passwordTextBox: UITextField!
    @IBAction func signUpButton(_ sender: Any) {
    }
    
    @IBAction func loginButton(_ sender: Any) {
        var context = CoreDataManager.sharedManager.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<User>
        fetchRequest = User.fetchRequest()

        fetchRequest.predicate = NSPredicate(
            format: "mail LIKE %@", emailTextBox.text!
        )
        
        let objects = try! context.fetch(fetchRequest)
        
        if(objects.isEmpty){
            showToast(message: "Email or password incorrect!", font: .systemFont(ofSize: 12.0))
        }
        else{
            var user = objects[0]
            if(user.password == passwordTextBox.text){
                let story = UIStoryboard(name: "Main", bundle: nil)
                let controller = story.instantiateViewController(identifier: "MenuViewController") as! MenuViewController
                self.present(controller, animated: true, completion: nil)
            }
        }
    }
}
