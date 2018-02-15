//
//  LoginVC.swift
//  IHXTracker
//
//  Created by Chuck Underwood on 2/14/18.
//  Copyright © 2018 Chuck Underwood. All rights reserved.
//

import UIKit
import Firebase

class LoginVC: UIViewController {
    
    @IBOutlet weak var emailField: InsetTextField!
    @IBOutlet weak var passwordField: InsetTextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        emailField.delegate = self
        passwordField.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Auth.auth().currentUser != nil {
            displayStartingVC()
        }
    }

    @IBAction func signInButtonWasPressed(_ sender: Any) {
        if emailField.text != nil && passwordField.text != nil {
            AuthService.instance.loginUser(withEmail: emailField.text!, andPassword: passwordField.text!, loginComplete: { (success, loginError) in
                if success {
                    print("Logged In!")
                    self.displayStartingVC()
                } else {
                    debugPrint(String(describing: loginError))
                }
                
                AuthService.instance.registerUser(withEmail: self.emailField.text!, andPassword: self.passwordField.text!, userCreationComplete: { (success, registrationError) in
                    if success {
                        AuthService.instance.loginUser(withEmail: self.emailField.text!, andPassword: self.passwordField.text!, loginComplete: { (success, nil) in
                            print("Successful registers user.")
                            self.displayStartingVC()
                        })
                    } else  {
                        debugPrint(String(describing: registrationError))
                    }
                })
            })
        }
    }
    
    func displayStartingVC() {
        let feedVC = storyboard?.instantiateViewController(withIdentifier: "TabBarVC")
        present(feedVC!, animated: true, completion: nil)
    }
    

}

extension LoginVC: UITextFieldDelegate {
    
}
