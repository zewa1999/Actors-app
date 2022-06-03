import UIKit
import SafariServices

class DetailsViewController: UIViewController {

    var personData: Actor!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    
    
    @IBAction func webViewAction(_ sender: UIButton) {
        guard let url = URL(string: personData.wikiLink) else {
            return
        }
        
        let vc = WebViewController(url:url, title:"Wikipedia")
        
        let navVC = UINavigationController(rootViewController: vc)
        present(navVC, animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.modalTransitionStyle = .flipHorizontal        // get the data to populate outlets
        nameLabel.text    = personData.name
        addressLabel.text = personData.description
        emailLabel.text   = personData.birthDate
        phoneLabel.text   = personData.bestMovie
        
    }
    
}
