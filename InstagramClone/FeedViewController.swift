//
//  FeedViewController.swift
//  InstagramClone
//
//  Created by Jibril Mohamed on 3/16/22.
//

import UIKit
import Parse
import AlamofireImage

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var posts = [PFObject]()
    
    let pullToRefresh = UIRefreshControl()
    
    
    @IBOutlet weak var postTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        var currentUser = PFUser.current()
        print("This use is logged IN: \(currentUser?.username)")
        
        
        postTableView.dataSource = self
        postTableView.delegate = self
        
        self.loadPosts()
        
        pullToRefresh.addTarget(self, action: #selector(loadPosts), for: .valueChanged)
        
        postTableView.refreshControl = pullToRefresh
    }
    
    override func viewDidAppear(_ animated: Bool) {
      
        self.loadPosts()
    }
    
    
    @objc func loadPosts() {
        let query = PFQuery(className: "Posts")
        query.includeKey("author")
        query.limit = 20
        self.posts.removeAll()
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
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = postTableView.dequeueReusableCell(withIdentifier: "PostTableViewCell", for: indexPath) as! PostTableViewCell
       
        let post = self.posts[indexPath.row]
        let user = post["author"] as! PFUser
        let imageFile = post["image"] as! PFFileObject
        let urlString = imageFile.url!
        let url = URL(string: urlString)!
        
        cell.postAuthorLabel?.text = user.username
        cell.postCommentLabel?.text = post["caption"] as? String
        cell.postImagView.af.setImage(withURL: url)

        
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        if indexPath.row + 1 == self.posts.count {
//            self.loadPosts()
//        }
//    }
  
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
