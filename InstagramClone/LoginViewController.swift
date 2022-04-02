//
//  LoginViewController.swift
//  InstagramClone
//
//  Created by Jibril Mohamed on 3/16/22.
//

import UIKit
import Parse

class LoginViewController: UIViewController {

   
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        if PFUser.current() != nil {
//            self.performSegue(withIdentifier: "loginSegue", sender: self)
//        }
    }
    
    @IBAction func onSignup(_ sender: Any) {
        let user = PFUser()
        user.username = usernameField.text!
        user.password = passwordField.text!
        
        user.signUpInBackground {(success, error) in
            if success {
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            }
            else {
                print("Error in signing up a user: \(String(describing: error?.localizedDescription))")
            }
        }
        
        
    }
    

 
    @IBAction func onSignIn(_ sender: Any) {
        PFUser.logInWithUsername(inBackground:usernameField.text!, password:passwordField.text!) {
          (user: PFUser?, error: Error?) -> Void in
          if user != nil {
            // Do stuff after successful login.
              self.performSegue(withIdentifier: "loginSegue", sender: nil)
          } else {
            // The login failed. Check error to see why.
              print("Login Failed: \(String(describing: error?.localizedDescription))")
          }
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
