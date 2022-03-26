//
//  CameraViewController.swift
//  InstagramClone
//
//  Created by Jibril Mohamed on 3/25/22.
//

import UIKit
import AlamofireImage
import Parse

class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var cameraVIew: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func submitButton(_ sender: Any) {
        let Post = PFObject(className: "Posts")
        
        Post["caption"] = commentTextField.text!
        Post["author"] = PFUser.current()
        
        let imageData = cameraVIew.image!.pngData()
        let file = PFFileObject(name: "image.png", data: imageData!)
        
        Post["image"] = file
        
        Post.saveInBackground{(success, error) in
            
            if success {
                print("Saved")
                self.dismiss(animated: true, completion: nil)
            }
            else {
                print("Failed")
            }
            
        }
        
    }
   
    @IBAction func onCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onCameraButton(_ sender: Any) {
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
        let scaledImage = image.af.imageScaled(to: size)
        cameraVIew.image = scaledImage
        
        dismiss(animated: true, completion: nil)
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
