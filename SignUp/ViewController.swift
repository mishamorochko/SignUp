import UIKit
import Combine

final class ViewController: UITableViewController {

    // MARK: - Outlets

    @IBOutlet weak private var emailAddressTextField: UITextField!
    @IBOutlet weak private var passwordTextField: UITextField!
    @IBOutlet weak private var passwordConfirmationTextField: UITextField!
    @IBOutlet weak private var agreeTermsSwitch: UISwitch!
    @IBOutlet weak private var signUpButton: BigButton!

    // MARK: - Subjects

    private var emailSubject = CurrentValueSubject<String, Never>("")
    private var passwordSubject = CurrentValueSubject<String, Never>("")
    private var passwordConformationSubject = CurrentValueSubject<String, Never>("")
    private var agreeAndTermsSubject = CurrentValueSubject<Bool, Never>(false)

    private var cancellables: Set<AnyCancellable> = []

    // MARK: - Properties

    private var isFormValid: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest3(
            isEmailValid,
            isPasswordValidConfirmed,
            agreeAndTermsSubject
        )
            .map { $0.0 && $0.1 && $0.2 }
            .eraseToAnyPublisher()
    }

    private var isPasswordValid: AnyPublisher<Bool, Never> {
        passwordSubject
            .map { $0 != "password" && $0.count >= 8 }
            .eraseToAnyPublisher()
    }

    private var isPasswordMatchesConfirmation: AnyPublisher<Bool, Never> {
        passwordSubject
            .combineLatest(passwordConformationSubject)
            .map { $0.0 == $0.1 }
            .eraseToAnyPublisher()
    }

    private var isPasswordValidConfirmed: AnyPublisher<Bool, Never> {
        isPasswordValid.combineLatest(isPasswordMatchesConfirmation)
            .map { $0.0 && $0.1 }
            .eraseToAnyPublisher()
    }

    private var isEmailValid: AnyPublisher<Bool, Never> {
        emailSubject
            .map { [weak self] in self?.isEmailValid($0) }
            .replaceNil(with: false)
            .eraseToAnyPublisher()
    }

    // MARK: - Actions

    @IBAction func emailDidChange(_ sender: Any) {
        emailSubject.send(emailAddressTextField.text ?? "")
    }

    @IBAction func passwordDidChange(_ sender: Any) {
        passwordSubject.send(passwordTextField.text ?? "")
    }

    @IBAction func passwordConfirmationDidChange(_ sender: Any) {
        passwordConformationSubject.send(passwordConfirmationTextField.text ?? "")
    }

    @IBAction private func agreeSwitchDidChange(_ sender: Any) {
        agreeAndTermsSubject.send(agreeTermsSwitch.isOn)
    }

    @IBAction private func signUpTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Welcome!", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        isFormValid
            .assign(to: \.isEnabled, on: signUpButton)
            .store(in: &cancellables)
    }

    // MARK: - Helpers

    private func isEmailValid(_ email: String) -> Bool {
        email.contains("@") && email.contains(".")
    }
}
