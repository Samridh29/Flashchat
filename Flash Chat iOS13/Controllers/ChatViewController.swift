//  ChatViewController.swift
//  Flash Chat iOS13
//


import UIKit
import Firebase

class ChatViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    
    let db = Firestore.firestore()
    var ref:DocumentReference? = nil
    
    var messages:[Message]=[]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource=self
        navigationItem.hidesBackButton=true
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        loadMessages()
        
    }
    
    func loadMessages(){
        
        db.collection(K.FStore.collectionName).order(by: K.FStore.dateField).addSnapshotListener{(querySnapshot, error) in
            self.messages = []
            if let error =  error{
                print("Error occured \(error)")
            }
            else{
                for document in querySnapshot!.documents {
                    if let sender = document.data()[K.FStore.senderField] as? String, let message = document.data()[K.FStore.bodyField] as? String{
                        self.messages.append(Message(sender: sender, body: message))
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                            self.tableView.scrollToRow(at: IndexPath(row: self.messages.count-1, section: 0), at: .top, animated: false)
                        }
                        
                    }
                }
            }
        }
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        
        if let messageBody = messageTextfield.text,  let sender = Auth.auth().currentUser?.email{
            ref = db.collection(K.FStore.collectionName).addDocument(data: [K.FStore.senderField:sender,
                                                                            K.FStore.bodyField :messageBody,K.FStore.dateField:Date().timeIntervalSince1970]){ (error) in
                if let error = error{
                    print("\(error)")
                }
                else{
                    print("Successfully saved with ref \(self.ref!)")
                    DispatchQueue.main.async {
                        self.messageTextfield.text =  ""
                    }
                    
                }
            }
            
        }
        
    }
    
    @IBAction func logoutButtonPressed(_ sender: UIBarButtonItem) {
        
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        }
        catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
    }
    
}
//MARK:- TableViewDataSource
extension ChatViewController:UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let user = messages[indexPath.row].sender
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier , for: indexPath) as! MessageCell
        cell.label .text = messages[indexPath.row].body
        
        if(user == Auth.auth().currentUser?.email){
            cell.leftImageView.isHidden = true
            cell.rightImageView.isHidden = false
            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.lightPurple)
            cell.label.textColor = UIColor(named: K.BrandColors.purple)
        }
        else{
            cell.rightImageView.isHidden = true
            cell.leftImageView.isHidden = false
            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.lighBlue)
            cell.label.textColor = UIColor(named: K.BrandColors.blue)
        }
        return cell
    }
}
