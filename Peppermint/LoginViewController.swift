/*
 * Copyright (c) 2015 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit
import RealmSwift

class LoginViewController: UIViewController {
  
  // MARK: Constants
  let loginToList = "LoginToList"
  
  // MARK: Outlets
  @IBOutlet weak var textFieldLoginEmail: UITextField!
  @IBOutlet weak var textFieldLoginPassword: UITextField!
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let _ = SyncUser.current {
            // We have already logged in here!
            performSegue(withIdentifier: loginToList, sender: self)
        }
    }
  // MARK: Actions
  @IBAction func loginDidTouch(_ sender: AnyObject) {
    
    let creds = SyncCredentials.nickname(textFieldLoginEmail.text!, isAdmin: true)
    
    SyncUser.logIn(with: creds, server: Constants.AUTH_URL, onCompletion: { [weak self](user, err) in
        if let _ = user {
            self?.performSegue(withIdentifier: "LoginToList", sender: self)
        } else if let error = err {
            fatalError(error.localizedDescription)
        }
    })
//    Auth.auth().signIn(withEmail: textFieldLoginEmail.text!,
//                           password: textFieldLoginPassword.text!)
    }
  
  @IBAction func signUpDidTouch(_ sender: AnyObject) {
    let alert = UIAlertController(title: "Register",
                                  message: "Register",
                                  preferredStyle: .alert)
    
    let saveAction = UIAlertAction(title: "Save",
                                   style: .default) { action in
                                    // 1
                                    let emailField = alert.textFields![0]
                                    let passwordField = alert.textFields![1]
                                    
                                    // 2
//                                    Auth.auth().createUser(withEmail: emailField.text!,
//                                                               password: passwordField.text!) { user, error in
//                                                                  if error == nil {
//                                                                    // 3
//                                                                    Auth.auth().signIn(withEmail: self.textFieldLoginEmail.text!,
//                                                                                           password: self.textFieldLoginPassword.text!)
//                                                                }
//                                    }
    }
    
    let cancelAction = UIAlertAction(title: "Cancel",
                                     style: .default)
    
    alert.addTextField { textEmail in
      textEmail.placeholder = "Enter your email"
    }
    
    alert.addTextField { textPassword in
      textPassword.isSecureTextEntry = true
      textPassword.placeholder = "Enter your password"
    }
    
    alert.addAction(saveAction)
    alert.addAction(cancelAction)
    
    present(alert, animated: true, completion: nil)
  }
    
    @IBAction func dismissKeyboard(sender: AnyObject) {
        textFieldLoginEmail.resignFirstResponder()
        textFieldLoginPassword.resignFirstResponder()
    }
}


extension LoginViewController: UITextFieldDelegate {
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if textField == textFieldLoginEmail {
      textFieldLoginPassword.becomeFirstResponder()
    }
    if textField == textFieldLoginPassword {
      textField.resignFirstResponder()
    }
    return true
  }
  
}
