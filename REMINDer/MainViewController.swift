//
//  ViewController.swift
//  REMINDer
//
//  Created by Michael Ho on 12/19/16.
//  Copyright © 2016 reminder.com. All rights reserved.
//

import UIKit
import NMessenger
import AsyncDisplayKit
import PubNub

struct MessageItem {
    var uuid: String
    var sender: String
    var messageContent: String
    var isIncoming: Bool
}

class MainViewController: NMessengerViewController, PNObjectEventListener {
    
    private(set) var lastMessageGroup:MessageGroup? = nil
    @IBOutlet weak var inputAreaBackground: UIView!
    @IBOutlet weak var edInput: UITextField!
    @IBOutlet weak var btnSend: UIButton!
    
    var mainChannelName: String = "REMINDerChat"
    var allMessageItems: [MessageItem] = []
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRect(x: 0,y: 0, width: 50, height: 50)) as UIActivityIndicatorView
    let serialQueue: DispatchQueue = DispatchQueue(label: "pageHistoryQueue", attributes: [])
    let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        
        showActivityIndicator()
        appDelegate.client.addListener(self)
        appDelegate.client.subscribeToChannels([mainChannelName], withPresence: false)
        
        self.hideKeyboardWhenTappedAround()
        automaticallyAdjustsScrollViewInsets = false
        self.inputBarView.isHidden = true
        for view in self.messengerView.subviews {
            view.backgroundColor = UIColor(red:0.20, green:0.20, blue:0.20, alpha:1.0)
        }
        inputAreaBackground.isHidden = false
        self.edInput.textColor = UIColor.lightGray
        self.edInput.attributedPlaceholder = NSAttributedString(string: " New Message", attributes: [NSForegroundColorAttributeName: UIColor.gray])
        self.edInput.layer.borderWidth = CGFloat(1.0)
        self.edInput.layer.borderColor = UIColor(red:0.90, green:0.90, blue:0.90, alpha:1.0).cgColor
        self.edInput.layer.cornerRadius = CGFloat(10.0)
        self.edInput.rightViewMode = UITextFieldViewMode.always
        self.edInput.rightView = btnSend
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateMessengerView()
    }
    
    func updateMessengerView(){
        showActivityIndicator()
        serialQueue.async { [unowned self] () -> Void in
            self.pageHistory(self.mainChannelName)
        }
    }
    
    @IBAction func btnSendPressed(_ sender: UIButton) {
        if ("\(edInput.text!)".characters.count > 0) {
            self.postText(sendText(edInput.text!, isIncomingMessage: false) as! MessageNode, userName: "Me", isIncomingMessage: false)
            edInput.text = ""
        }
    }
    
    override func sendText(_ text: String, isIncomingMessage: Bool) -> GeneralMessengerCell {
        let sendText = "REMINDerISAWESOME\(text)"
        appDelegate.client.publish(sendText, toChannel: mainChannelName, compressed: false, withCompletion: { (status) in
            if !status.isError {
                
            } else {
                
            }
        })
        
        return getMessageNode(text: text)
    }
    
    private func postText(_ message: MessageNode, userName: String, isIncomingMessage: Bool) {
        message.backgroundColor = UIColor(red:0.20, green:0.20, blue:0.20, alpha:1.0)
        if self.lastMessageGroup == nil || self.lastMessageGroup?.isIncomingMessage == !isIncomingMessage {
            self.lastMessageGroup = self.createMessageGroup()
            
            //add avatar if incoming message
            if isIncomingMessage {
                self.lastMessageGroup?.avatarNode = self.createAvatar(userName: userName)
            }
            
            self.lastMessageGroup!.isIncomingMessage = isIncomingMessage
            self.messengerView.addMessageToMessageGroup(message, messageGroup: self.lastMessageGroup!, scrollsToLastMessage: false)
            self.messengerView.addMessage(self.lastMessageGroup!, scrollsToMessage: true, withAnimation: isIncomingMessage ? .left : .right)
            
        } else {
            self.messengerView.addMessageToMessageGroup(message, messageGroup: self.lastMessageGroup!, scrollsToLastMessage: true)
        }
    }
    
    private func createMessageGroup()->MessageGroup {
        let newMessageGroup = MessageGroup()
        newMessageGroup.currentViewController = self
        newMessageGroup.cellPadding = self.messagePadding
        return newMessageGroup
    }
    
    private func createAvatar(userName: String)->ASImageNode {
        let avatar = ASImageNode()
//        if(nil != defaults.data(forKey: userName)){
//            avatar.image = UIImage(data: defaults.data(forKey: userName)! as Data)
//        }
        avatar.backgroundColor = UIColor.lightGray
        avatar.preferredFrameSize = CGSize(width: 45, height: 45)
        avatar.layer.cornerRadius = 22.5
        avatar.clipsToBounds = true
        return avatar
    }
    
    func client(_ client: PubNub, didReceiveMessage message: PNMessageResult) {
        if message.data.channel != message.data.subscription {
            // Message has been received on channel group stored in message.data.subscription.
        }
        else {
            // Message has been received on channel stored in message.data.channel.
        }
        
        if(mainChannelName == "\(message.data.channel)"){
            let messageArr = "\(message.data.message as! String)".components(separatedBy: "REMINDerISAWESOME")
            if(messageArr[0] != "Me"){
                let textContent = TextContentNode(textMessageString: messageArr[1], currentViewController: self, bubbleConfiguration: self.sharedBubbleConfiguration)
                let newMessage = MessageNode(content: textContent)
                newMessage.cellPadding = messagePadding
                newMessage.currentViewController = self
                let senderName = messageArr[0]
                self.postText(newMessage, userName: senderName, isIncomingMessage: true)
            }
        }
    }
    
    deinit {
        print("Deinitialized")
    }
    
    func pageHistory(_ channelName: String) {
        
        var shouldStop: Bool = false
        var isPaging: Bool = false
        var startTimeToken: NSNumber = 0
        let itemLimit: Int = 100
        let semaphore: DispatchSemaphore = DispatchSemaphore(value: 0)
        
        self.appDelegate.client.historyForChannel(channelName, start: nil, end: nil, limit: 100, reverse: true, includeTimeToken: true, withCompletion: { (result, status) in
            for message in (result?.data.messages)! {
                if let resultMessage = (message as! [String:AnyObject])["message"] {
                    self.postText(self.getMessageNode(text: resultMessage["messageContent"] as! String), userName: resultMessage["sender"] as! String, isIncomingMessage: resultMessage["isIncoming"] as! Bool)
                }
            }
            
            if let endTime = result?.data.end {
                startTimeToken = endTime
            }
            
            if result?.data.messages.count == itemLimit {
                isPaging = true
            }
            semaphore.signal()
        })
        
        semaphore.wait(timeout: DispatchTime.distantFuture)
        
        while isPaging && !shouldStop {
            self.appDelegate.client.historyForChannel(channelName, start: startTimeToken, end: nil, limit: 100, reverse: true, includeTimeToken: true, withCompletion: { (result, status) in
                for message in (result?.data.messages)! {
                    if let resultMessage = (message as! [String:AnyObject])["message"] {
                        self.postText(self.getMessageNode(text: resultMessage["messageContent"] as! String), userName: resultMessage["sender"] as! String, isIncomingMessage: resultMessage["isIncoming"] as! Bool)
                    }
                }
                
                if let endTime = result?.data.end {
                    startTimeToken = endTime
                }
                
                if (result?.data.messages.count)! < itemLimit {
                    shouldStop = true
                }
                semaphore.signal()
            })
            
            semaphore.wait(timeout: DispatchTime.distantFuture)
        }
    }
    
    func getMessageNode(text: String) -> MessageNode{
        let textContent = TextContentNode(textMessageString: text, currentViewController: self, bubbleConfiguration: self.sharedBubbleConfiguration)
        let newMessage = MessageNode(content: textContent)
        newMessage.cellPadding = messagePadding
        newMessage.currentViewController = self
        return newMessage
    }
    
    func showActivityIndicator() {
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.inputAreaBackground.frame.origin.y = self.inputAreaBackground.frame.origin.y - keyboardSize.height
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.inputAreaBackground.frame.origin.y = self.inputAreaBackground.frame.origin.y + keyboardSize.height
            }
        }
    }
}

