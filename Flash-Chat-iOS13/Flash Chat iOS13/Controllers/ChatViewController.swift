//
//  ChatViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    
    var authManager = AuthManager()
    var messages: [Message] = [
        Message(sender: "shameem@gmail.com", message: "Hi"),
        Message(sender: "ahammed@gmail.com", message: "Hello"),
        Message(sender: "shameem@gmail.com", message: "how are you?")
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        self.authManager.delegate = self
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(UINib(nibName: Constants.cellNibName,
                                      bundle: nil),
                                forCellReuseIdentifier: Constants.cellIdentifier)
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
    }
    
    @IBAction func logoutPressed(_ sender: UIBarButtonItem) {
        self.authManager.logout()
    }
    
}
// MARK: - AuthDelegate
extension ChatViewController: AuthDelegate{
    func authError(error: any Error) {
        print("error in logout")
    }
    
    func logoutSuccess() {
        print("logout success")
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    
}

// MARK: - Table Delegate
extension ChatViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier,
                                                      for: indexPath) as? MessageCell else{
           return UITableViewCell()
       }
        cell.messageLabel.text = self.messages[indexPath.row].message
        return cell
    }
}
