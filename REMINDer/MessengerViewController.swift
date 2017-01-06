//
//  MessengerViewController.swift
//  REMINDer
//
//  Created by Michael Ho on 1/5/17.
//  Copyright © 2017 reminder.com. All rights reserved.
//

import UIKit
import NMessenger
import AsyncDisplayKit
import PubNub

class MessengerViewController: NMessengerViewController, PNObjectEventListener {
    
    let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    private(set) var lastMessageGroup:MessageGroup? = nil
    var myName: String = ""
    var chatChannelName: String = "REMINDerChat"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "REMINDer"
//        navigationItem.hidesBackButton = false
//        appDelegate.client.addListener(self)
//        appDelegate.client.subscribeToChannels([chatChannelName], withPresence: false)
        self.hideKeyboardWhenTappedAround()
        automaticallyAdjustsScrollViewInsets = false
        for view in self.messengerView.subviews {
            view.backgroundColor = UIColor.black
        }
//        self.inputBarView.textInputView.backgroundColor = UIColor.black
//        self.inputBarView.textInputAreaView.backgroundColor = UIColor.gray
    }
    
    override func sendText(_ text: String, isIncomingMessage: Bool) -> GeneralMessengerCell {
        let sendText = "\(myName)HYCUBEISAWESOME\(text)"
//        appDelegate.client.publish(sendText, toChannel: chatChannelName, compressed: false, withCompletion: { (status) in
//            if !status.isError {
//                
//            } else {
//                
//            }
//        })
        //create a new text message
        let textContent = TextContentNode(textMessageString: text, currentViewController: self, bubbleConfiguration: self.sharedBubbleConfiguration)
        let newMessage = MessageNode(content: textContent)
        newMessage.cellPadding = messagePadding
        newMessage.currentViewController = self
        self.postText(newMessage, userName: myName, isIncomingMessage: false)
        
        return newMessage
    }
    
    //MARK: Helper Functions
    /**
     Posts a text to the correct message group. Creates a new message group *isIncomingMessage* is different than the last message group.
     - parameter message: The message to add
     - parameter isIncomingMessage: If the message is incoming or outgoing.
     */
    private func postText(_ message: MessageNode, userName: String, isIncomingMessage: Bool) {
        message.backgroundColor = UIColor.black
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
    
    /**
     Creates a new message group for *lastMessageGroup*
     -returns: MessageGroup
     */
    private func createMessageGroup()->MessageGroup {
        let newMessageGroup = MessageGroup()
        newMessageGroup.currentViewController = self
        newMessageGroup.cellPadding = self.messagePadding
        return newMessageGroup
    }
    
    /**
     Creates mock avatar with an AsyncDisplaykit *ASImageNode*.
     - returns: ASImageNode
     */
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
        
        if(chatChannelName == "\(message.data.channel)"){
            let messageArr = "\(message.data.message as! String)".components(separatedBy: "HYCUBEISAWESOME")
            if(messageArr[0] != "\(self.myName)"){
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
}
