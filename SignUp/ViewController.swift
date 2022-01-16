import UIKit

final class ViewController: UITableViewController {

    // MARK: - Outlets

    @IBOutlet weak private var emailAddressTextField: UITextField!
    @IBOutlet weak private var passwordTextField: UITextField!
    @IBOutlet weak private var passwordConfirmationTextField: UITextField!
    @IBOutlet weak private var agreeTermsSwitch: UISwitch!
    @IBOutlet weak private var signUpButton: BigButton!

    // MARK: - Actions

    @IBAction private func emailDidChange(_ sender: Any) { }

    @IBAction private func passwordDidChange(_ sender: Any) { }

    @IBAction private func passwordConfirmationDidChange(_ sender: Any) { }

    @IBAction private func agreeSwitchDidChange(_ sender: Any) { }

    @IBAction private func signUpTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Welcome!", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
