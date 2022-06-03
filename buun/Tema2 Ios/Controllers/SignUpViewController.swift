import UIKit

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var firstNameTextBox: UITextField!
    @IBOutlet weak var lastNameTextBox: UITextField!
    @IBOutlet weak var emailTextBox: UITextField!
    @IBOutlet weak var passwordTextBox: UITextField!
    @IBOutlet weak var confirmPasswordTextBox: UITextField!
    
    @IBAction func registrationButton(_ sender: Any) {
        
        var items = [User]()
        var appContext = CoreDataManager.sharedManager.persistentContainer.viewContext
        do
        {
            items = try appContext.fetch(User.fetchRequest())
            
        }
        catch {
            showToast(message: String(describing: self) + ": Error while trying to get entities from DB!", font: .systemFont(ofSize: 12.0))
        }
        
        for actor in items{
            if(actor.mail == emailTextBox.text){
                showToast(message: String(describing: self) + ": Mail already used!", font: .systemFont(ofSize: 12.0))
                return

            }
        }
        
        var user = User(context: appContext)
        
        if(firstNameTextBox.text != "" && lastNameTextBox.text != ""
            && emailTextBox.text != "" && passwordTextBox.text != ""
            && confirmPasswordTextBox.text != "" && isValidEmail(emailTextBox.text!)){
            
                user.firstName = firstNameTextBox.text
                user.lastName = lastNameTextBox.text
                user.mail = emailTextBox.text
                user.password = passwordTextBox.text
                
                
                do
                {
                   try appContext.save()
                    self.showToast(message: "Successfully created new user!", font: .systemFont(ofSize: 12.0))
                }
                catch {
                    self.showToast(message: "Error while trying to save the new user!", font: .systemFont(ofSize: 12.0))
                }        }
            }
           
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
}
