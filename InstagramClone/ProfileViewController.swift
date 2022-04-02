//
//  ProfileViewController.swift
//  InstagramClone
//
//  Created by Jibril Mohamed on 4/1/22.
//

import UIKit
import Parse

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let user = PFUser.current()
        username?.text = user?.username
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        updateUserProfile()
    }
    
    func updateUserProfile() {
        let imageData = self.profileImage.image!.pngData()
        let file = PFFileObject(name: "image.png", data: imageData!)
        var user = PFUser.current()
        user?.add(file, forKey: "image")
        
        user?.saveInBackground { (success, error) in
            if success {
                print("Successfully added Image")
            } else {
                print("Failed adding image!")
            }
            
        }
        
        
        
//        let userObjectId = PFUser.current()?.objectId
//        print("userObject: \(userObjectId)")
//
//        let query = PFUser.query()
//        query?.getObjectInBackground(withId: userObjectId!) { (user: PFUser?, error: Error?) in
//            if let error = error {
//                print(error.localizedDescription)
//                print("Failed updating user!")
//            } else if let user = user {
//                let imageData = self.profileImage.image!.pngData()
//                let file = PFFileObject(name: "image.png", data: imageData!)
//                user["image"] = file
//                print("User saved with image!")
//            }
//        }
        
    }
    
    
    @IBAction func updateImageButton(_ sender: Any) {
        updateUserProfile()
    }
    
    @IBAction func onProfileImageButton(_ sender: Any) {
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
        }
        else {
            picker.sourceType = .photoLibrary
        }
        present(picker, animated: true, completion: nil)
    }
 
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.editedImage] as! UIImage
        
        let size = CGSize(width: 300, height: 300)
        let scaledImage = image.af.imageAspectScaled(toFill: size)
        profileImage.image = scaledImage
        
        dismiss(animated: true, completion: nil)
    }

}
