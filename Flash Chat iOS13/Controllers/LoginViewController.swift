//
//  LoginViewController.swift
//  Flash Chat iOS13
//


import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    @IBAction func loginPressed(_ sender: UIButton) {
        if let email=emailTextfield.text ,let password=passwordTextfield.text{
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let error = error{
                    self.emailTextfield.placeholder="Try again with relevant details"
                }
                else{
                    self.performSegue(withIdentifier: K.loginSegue, sender: self)
                }
            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == K.loginSegue){
            let chatVC=segue.destination as! ChatViewController
        }
    }
    
}
