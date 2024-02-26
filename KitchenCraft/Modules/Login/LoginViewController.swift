//
//  ViewController.swift
//  KitchenCraft
//
//  Created by Tony Michael on 12/02/24.
//

import UIKit
import GoogleSignIn
import FirebaseAuth
import FirebaseCore

class LoginViewController: UIViewController {
    var eyeIsClicked : Bool = false
    
    @IBOutlet weak var loginContainerView: UIView!
    @IBOutlet weak var emailAdressErrorMessage: UILabel!
    @IBOutlet weak var signInButton: GIDSignInButton?
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailAdressTextField: UITextField!
    
    @IBAction func googleSigninButtonClicked(_ sender: UIButton) {
        googleSignin()
    }
    @IBAction func resetButtonTapped(_ sender: UIButton) {
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        if !emailAdressTextField.hasText && !passwordTextField.hasText {
            alertPopUp(controller: self, title: AppStrings.incompleteFormTitle, message: AppStrings.incompleteFormMessage , actionTitle: "Cancel", style: .cancel)
        } else if emailAdressTextField.hasText && !passwordTextField.hasText {
            alertPopUp(controller: self, title: AppStrings.incompleteFormTitle, message: AppStrings.incompleteFormMessage, actionTitle: "Cancel", style: .cancel)
        } else if !emailAdressTextField.hasText && passwordTextField.hasText {
            alertPopUp(controller: self, title: AppStrings.incompleteFormTitle, message: AppStrings.incompleteFormMessage , actionTitle: "Cancel", style: .cancel)
        }else {
            let vc = self.storyboard?.instantiateViewController(identifier: "HomePageViewController") as! HomePageViewController
            
            UserDefaults.standard.set(2, forKey: "isLogedIn")
            vc.modalPresentationStyle = .fullScreen
            
            
            self.present(vc, animated: true)
        }
        
        sender.layer.shadowRadius = 1
        sender.layer.shadowOpacity = 0.5
    }
    
    @IBAction func signUpButtonTapped(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(identifier: "CreateAccountViewController") as! CreateAccountViewController
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTextFieldButton()
        emailTextFieldImage()
        emailAdressErrorMessage.isHidden = true
        viewShadow()
        
    }
    
    func viewShadow(){
        loginContainerView.layer.masksToBounds = false
        loginContainerView.layer.shadowOffset = CGSize(width: 1, height: 1)
        loginContainerView.layer.shadowRadius = 0.5
        loginContainerView.layer.shadowOpacity = 0.5
    }
    
    
    func googleSignin(){
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: "820983785017-f7sdli9g0vqp887tc2imleni9o083fpn.apps.googleusercontent.com")
        GIDSignIn.sharedInstance.configuration = config
        
        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [unowned self] result, error in
            guard error == nil else {
                // ...
                return
            }
            
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString
            else {
                // ...
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: user.accessToken.tokenString)
            
            // ...
            Auth.auth().signIn(with: credential) { result, error in
                let vc = self.storyboard?.instantiateViewController(identifier: "HomePageViewController") as! HomePageViewController
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true)
            }
        }
        
    }
    
    func passwordTextFieldButton(){
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        button.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        button.tintColor = .lightGray
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 20))
        paddingView.addSubview(button)
        passwordTextField.rightView  = paddingView
        passwordTextField.rightViewMode = .always
        button.addTarget(self, action: #selector(self.eyeButtonClicked(_:)), for: .touchUpInside)
    }
    
    @objc func eyeButtonClicked(_ sender: UIButton){
        if eyeIsClicked == false {
            sender.setImage(UIImage(systemName: "eye"), for: .normal)
            passwordTextField.isSecureTextEntry = false
            eyeIsClicked = true
        } else {
            sender.setImage(UIImage(systemName: "eye.slash"), for: .normal)
            passwordTextField.isSecureTextEntry = true
            eyeIsClicked = false
        }
    }
    
    func emailTextFieldImage() {
        let imageView = UIImageView(image: UIImage(systemName: "envelope.badge"))
        imageView.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .lightGray
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 20))
        paddingView.addSubview(imageView)
        
        emailAdressTextField.rightView = paddingView
        emailAdressTextField.rightViewMode = .always
    }
    
}
extension LoginViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if emailAdressTextField == textField {
            passwordTextField.becomeFirstResponder()
        } else if passwordTextField == textField {
            passwordTextField.resignFirstResponder()
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if emailAdressTextField == textField {
            if emailAdressTextField.hasText && emailAdressTextField.text!.isValidEmail() {
                emailAdressErrorMessage.isHidden = true
            } else {
                emailAdressErrorMessage.isHidden = false
            }
        }
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

