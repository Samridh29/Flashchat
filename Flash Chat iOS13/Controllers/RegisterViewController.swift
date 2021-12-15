//
//  RegisterViewController.swift
//  Flash Chat iOS13
//


import UIKit
import Firebase
class RegisterViewController: UIViewController {
    
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    @IBAction func registerPressed(_ sender: UIButton) {
        if let email=emailTextfield.text, let password=passwordTextfield.text{
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let error=error{
                    self.emailTextfield.placeholder="\(error.localizedDescription)"
                    
                }
                else{
                    self.performSegue(withIdentifier: "RegisterToChat", sender: self)
                }
            }
        }
        else{
            if(emailTextfield.text == ""){
                emailTextfield.placeholder="This field can't be empty"
            }
            else{
                passwordTextfield.placeholder="Enter a password to register"
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "RegisterToChat"){
            let chatVC = segue.destination as! ChatViewController
        }
    }
    
}


