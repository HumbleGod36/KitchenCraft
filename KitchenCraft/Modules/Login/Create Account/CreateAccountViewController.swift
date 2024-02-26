//
//  CreateAccountViewController.swift
//  KitchenCraft
//
//  Created by Tony Michael on 12/02/24.
//

import UIKit
import IQKeyboardManagerSwift

class CreateAccountViewController: UIViewController {

    var eyeIsClicked : Bool = false
    var confirmEyeIsClicked : Bool = false
    
    @IBOutlet weak var confrimPasswordError: UILabel!
    @IBOutlet weak var invalidEmailError: UILabel!
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailAdressTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPassowordTextField: UITextField!
    
    @IBAction func signUpButtonClicked(_ sender: UIButton) {
        if firstNameTextField.hasText && lastNameTextField.hasText && emailAdressTextField.hasText && passwordTextField.hasText && confirmPassowordTextField.hasText {
            alertPopUp(controller: self, title: "Success", message: "Account has be created login to Continue ", actionTitle: "Login", style: .default) { action in
                self.dismiss(animated: true)
            }
        }
        else     {
            alertPopUp(controller: self, title: "Error", message: "Please complete the form", actionTitle: "Cancel", style: .cancel)
        }
    }
    
    @IBAction func signInButtonClicked(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstNameTextField.becomeFirstResponder()
        
        confrimPasswordError.isHidden = true
        invalidEmailError.isHidden = true
     
        emailTextFieldImage()
        passwordTextFieldButton()
        confirmPasswordTextFieldButton()

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

    
    func passwordTextFieldButton(){
    
        passwordTextField.rightView  = eyeView(controller: self, action: #selector(self.eyeButtonClicked(_:)))
        passwordTextField.rightViewMode = .always
        
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
    
    func confirmPasswordTextFieldButton(){
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        button.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        button.tintColor = .lightGray
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 20))
        paddingView.addSubview(button)
        button.addTarget(self, action: #selector(self.eyeButtonClickedConfirm(_:)), for: .touchUpInside)
        confirmPassowordTextField.rightView = paddingView
        confirmPassowordTextField.rightViewMode = .always
       
    }
    
    @objc func eyeButtonClickedConfirm(_ sender : UIButton){
        if confirmEyeIsClicked == false {
            sender.setImage(UIImage(systemName: "eye"), for: .normal)
            confirmPassowordTextField.isSecureTextEntry = false
            confirmEyeIsClicked = true
        } else {
            sender.setImage(UIImage(systemName: "eye.slash"), for: .normal)
            confirmPassowordTextField.isSecureTextEntry = true
            confirmEyeIsClicked = false
        }
    }


}
extension CreateAccountViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if  textField == firstNameTextField {
            lastNameTextField.becomeFirstResponder()
        } else if textField == lastNameTextField {
            emailAdressTextField.becomeFirstResponder()
        } else if textField == emailAdressTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            confirmPassowordTextField.becomeFirstResponder()
            
        }else if textField == confirmPassowordTextField {
            confirmPassowordTextField.resignFirstResponder()
        }
        
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
