//
//  Alerts.swift
//  base_project
//
//  Created by Pranav Singh on 01/08/22.
//

import Foundation
import SwiftUI

class Alerts {
    //MARK: - variables
    private let attributedTitleKey = "attributedTitle"
    private let attributedMessageKey = "attributedMessage"
    
    private let titleAttributes = [NSAttributedString.Key.font: UIFont.bitterMedium(size: 17), NSAttributedString.Key.foregroundColor: UIColor.blackColor]
    private let messageAttributes = [NSAttributedString.Key.font: UIFont.bitterRegular(size: 14), NSAttributedString.Key.foregroundColor: UIColor.blackColor]
    
    func errorAlert(title: String = "Error!", message: String){
        let alert = UIAlertController(title: "", message: "", preferredStyle: UIAlertController.Style.alert)
        
        let titleString = NSAttributedString(string: title, attributes: titleAttributes)
        alert.setValue(titleString, forKey: attributedTitleKey)
        
        let messageString = NSAttributedString(string: message, attributes: messageAttributes)
        alert.setValue(messageString, forKey: attributedMessageKey)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        
        let vc = Singleton.sharedInstance.generalFunctions.getTopViewController()
        vc?.present(alert, animated: true, completion: nil)
    }
    
    func alertWith(title: String, message: String, firstButtonTitle firstTitle: String, firstButtonStyle: UIAlertAction.Style, firstButtonAction: (() -> Void)? = nil, andSecondButtonTitle secondButtonTitle: String, secondButtonStyle: UIAlertAction.Style, secondButtonAction: (()-> Void)? = nil) {
        let alert = UIAlertController(title: "", message: "", preferredStyle: UIAlertController.Style.alert)
        
        let titleString = NSAttributedString(string: title, attributes: titleAttributes)
        alert.setValue(titleString, forKey: attributedTitleKey)
        
        let messageString = NSAttributedString(string: message, attributes: messageAttributes)
        alert.setValue(messageString, forKey: attributedMessageKey)
        
        alert.addAction(UIAlertAction(title: firstTitle, style: firstButtonStyle, handler: firstButtonAction == nil ? nil : { _ in
            firstButtonAction!()
        }))
        
        alert.addAction(UIAlertAction(title: secondButtonTitle, style: secondButtonStyle, handler: secondButtonAction == nil ? nil : { _ in
            secondButtonAction!()
        }))
        
        let vc = Singleton.sharedInstance.generalFunctions.getTopViewController()
        vc?.present(alert, animated: true, completion: nil)
    }
    
    func internetNotConnectedAlert(outputBlock : @escaping () -> Void){
        let alert = UIAlertController(title: "", message: "", preferredStyle: UIAlertController.Style.alert)
        
        let titleString = NSAttributedString(string: "Network Unreachable!", attributes: titleAttributes)
        alert.setValue(titleString, forKey: attributedTitleKey)
        
        let messageString = NSAttributedString(string: "You are not connected to Internet", attributes: messageAttributes)
        alert.setValue(messageString, forKey: attributedMessageKey)
        
        alert.addAction(UIAlertAction(title: "Tap to Retry", style: UIAlertAction.Style.default) { (UIAlertAction) in
            outputBlock()
        })
        
        let vc = Singleton.sharedInstance.generalFunctions.getTopViewController()
        vc?.present(alert, animated: true, completion: nil)
    }
    
    func handle401StatueCode(){
        let alert = UIAlertController(title: "", message: "", preferredStyle: UIAlertController.Style.alert)
        
        let titleString = NSAttributedString(string: "Session Expired", attributes: titleAttributes)
        alert.setValue(titleString, forKey: attributedTitleKey)
        
        let messageString = NSAttributedString(string: "Your Session has been Expired, PLease Login Again.", attributes: messageAttributes)
        alert.setValue(messageString, forKey: attributedMessageKey)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(_: UIAlertAction!) in
            Singleton.sharedInstance.generalFunctions.deinitilseAllVariables()
        }))
        
        
        let vc = Singleton.sharedInstance.generalFunctions.getTopViewController()
        vc?.present(alert, animated: true, completion: nil)
    }
}
