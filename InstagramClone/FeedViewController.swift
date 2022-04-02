//
//  FeedViewController.swift
//  InstagramClone
//
//  Created by Jibril Mohamed on 3/16/22.
//

import UIKit
import Parse
import AlamofireImage
import MessageInputBar

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MessageInputBarDelegate {
    
    var posts = [PFObject]()
    var selectedPost: PFObject!
    
    let pullToRefresh = UIRefreshControl()
    
    let commentBar = MessageInputBar()
    var showsCommentBar = false
    
    
    @IBOutlet weak var postTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        postTableView.dataSource = self
        postTableView.delegate = self
        
        commentBar.inputTextView.placeholder = "Add a comment here..."
        commentBar.sendButton.title = "Post"
        commentBar.delegate = self
        
        postTableView.keyboardDismissMode = .interactive
        
        let center = NotificationCenter.default
        
        center.addObserver(self, selector: #selector(keyboardWillBeHidden(note: )), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        pullToRefresh.addTarget(self, action: #selector(loadPosts), for: .valueChanged)
        
        postTableView.refreshControl = pullToRefresh
    }
    
    override func viewDidAppear(_ animated: Bool) {
      
        self.loadPosts()
        postTableView.reloadData()
    }
    
    @objc func keyboardWillBeHidden(note: Notification) {
        commentBar.inputTextView.text = ""
        showsCommentBar = false
        becomeFirstResponder()
     }
    
    override var inputAccessoryView: UIView? {
        return commentBar
    }
    
    override var canBecomeFirstResponder: Bool {
        return showsCommentBar
    }
    
    
    
    @objc func loadPosts() {
        let query = PFQuery(className: "Posts")
        query.includeKeys(["author", "comments", "comments.author"])
        query.limit = 20
        self.posts.removeAll()
        query.order(byDescending: "createdAt")
        query.findObjectsInBackground { (posts, error) in
            if posts != nil {
                self.posts = posts!
                self.postTableView.reloadData()
                self.pullToRefresh.endRefreshing()
            }
            else {
                print("Failed Fetching the Posts Data.")
            }
            
        }
    }
    
    @IBAction func onLogout(_ sender: Any) {
        PFUser.logOut()
//        self.dismiss(animated: true, completion: nil)
        
        let main = UIStoryboard(name: "Main", bundle: nil)
        
        let loginViewController = main.instantiateViewController(identifier: "LoginViewController")
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let delegate = windowScene.delegate as? SceneDelegate else { return }
        
        delegate.window?.rootViewController = loginViewController
    }
    
    func messageInputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String) {
        // Create the comment
        let comment = PFObject(className: "Comments")
        comment["text"] = text
        comment["post"] = selectedPost
        comment["author"] = PFUser.current()
        
  
        selectedPost.add(comment, forKey: "comments")
        
        selectedPost.saveInBackground { (success, error) in
            if success {
                print("Comment add!")
            }
            else {
                print("Error Adding Comment!")
            }
            
        }
        postTableView.reloadData()
        
        // Clear and dismiss input bar.
        commentBar.inputTextView.text = nil
        showsCommentBar = false
        becomeFirstResponder()
        commentBar.inputTextView.resignFirstResponder()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let post = posts[section]
        let comments = (post["comments"] as? [PFObject]) ?? []
        
        return comments.count + 2
    }
    
     func numberOfSections(in tableView: UITableView) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let post = posts[indexPath.section]
        let comments = (post["comments"] as? [PFObject]) ?? []
        
        if indexPath.row == 0 {
            let cell = postTableView.dequeueReusableCell(withIdentifier: "PostTableViewCell", for: indexPath) as! PostTableViewCell
           
            let user = post["author"] as! PFUser
            let imageFile = post["image"] as! PFFileObject
            let urlString = imageFile.url!
            let url = URL(string: urlString)!
            
            cell.postAuthorLabel?.text = user.username
            cell.postCommentLabel?.text = post["caption"] as? String
            cell.postImagView.af.setImage(withURL: url)

            
            
            return cell
        }
        else if indexPath.row <= comments.count {
            let cell = postTableView.dequeueReusableCell(withIdentifier: "CommentTableViewCell", for: indexPath) as! CommentTableViewCell
            
            let comment = comments[indexPath.row - 1]
            
            cell.commentText?.text = comment["text"] as? String
            let user = comment["author"] as! PFUser
            cell.commentedUser?.text = user.username
            
            return cell
        }
        else {
            let cell = postTableView.dequeueReusableCell(withIdentifier: "AddCommentCell", for: indexPath)
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let post = self.posts[indexPath.section]
        let comments = (post["comments"] as? [PFObject] ) ?? []
        
        if indexPath.row == comments.count + 1 {
            showsCommentBar = true
            becomeFirstResponder()
            commentBar.inputTextView.becomeFirstResponder()
            selectedPost = post
        }
    }

}
