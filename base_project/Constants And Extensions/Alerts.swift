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
    
    private let titleAttributes = [NSAttributedString.Key.font: UIFont.bitterHeadline,
                                   NSAttributedString.Key.foregroundColor: UIColor.blackColor]
    private let messageAttributes = [NSAttributedString.Key.font: UIFont.bitterFootnote,
                                     NSAttributedString.Key.foregroundColor: UIColor.blackColor]
    
    func showToast(withMessage message: String, seconds: Double = 2.0) {
        let alert = getAlertController(ofStyle: .alert, withTitle: message, andMessage: nil)
        //alert.view.backgroundColor = UIColor.lightPrimaryColor
        //alert.view.alpha = 0.6
        //alert.view.layer.cornerRadius = 15
        
        let vc = UIApplication.shared.getTopViewController()
        vc?.present(alert, animated: true, completion: nil)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
            alert.dismiss(animated: true)
        }
    }
    
    func getAlertController(ofStyle style: UIAlertController.Style, withTitle title: String?, andMessage message: String?) -> UIAlertController {
        let alert = UIAlertController(title: "", message: "", preferredStyle: style)
        
        if let title {
            let titleString = NSAttributedString(string: title, attributes: titleAttributes)
            alert.setValue(titleString, forKey: attributedTitleKey)
        }
        
        if let message {
            let messageString = NSAttributedString(string: message, attributes: messageAttributes)
            alert.setValue(messageString, forKey: attributedMessageKey)
        }
        
        return alert
    }
    
    func errorAlertWith(message: String){
        alertWith(title: AppTexts.AlertMessages.errorWithExclamation, message: message)
    }

    func alertWith(title: String, message: String?,
                   defaultButtonTitle: String = AppTexts.AlertMessages.ok,
                   defaultButtonAction: ((UIAlertAction) -> Void)? = nil) {
        let alert = getAlertController(ofStyle: .alert, withTitle: title, andMessage: message)

        alert.addAction(UIAlertAction(title: defaultButtonTitle, style: UIAlertAction.Style.default, handler: defaultButtonAction))

        let vc = UIApplication.shared.getTopViewController()
        vc?.present(alert, animated: true, completion: nil)
    }
    
    func alertWith(title: String, message: String?,
                   defaultButtonTitle: String = AppTexts.AlertMessages.ok,
                   defaultButtonAction: ((UIAlertAction) -> Void)? = nil,
                   cancelButtonTitle: String = AppTexts.AlertMessages.cancel,
                   cancelButtonAction: ((UIAlertAction) -> Void)? = nil) {
        let alert = getAlertController(ofStyle: .alert, withTitle: title, andMessage: message)

        alert.addAction(UIAlertAction(title: defaultButtonTitle, style: UIAlertAction.Style.default, handler: defaultButtonAction))
        alert.addAction(UIAlertAction(title: cancelButtonTitle, style: UIAlertAction.Style.cancel, handler: cancelButtonAction))

        let vc = UIApplication.shared.getTopViewController()
        vc?.present(alert, animated: true, completion: nil)
    }
    
    func alertWith(title: String, message: String?,
                   defaultButtonOneTitle: String,
                   defaultButtonOneAction: ((UIAlertAction) -> Void)? = nil,
                   defaultButtonTwoTitle: String,
                   defaultButtonTwoAction: ((UIAlertAction) -> Void)? = nil) {
        let alert = getAlertController(ofStyle: .alert, withTitle: title, andMessage: message)

        alert.addAction(UIAlertAction(title: defaultButtonOneTitle, style: UIAlertAction.Style.default, handler: defaultButtonOneAction))
        alert.addAction(UIAlertAction(title: defaultButtonTwoTitle, style: UIAlertAction.Style.default, handler: defaultButtonTwoAction))

        let vc = UIApplication.shared.getTopViewController()
        vc?.present(alert, animated: true, completion: nil)
    }
    
    func actionSheetWith(title: String, message: String?,
                         firstDefaultButtonTitle: String,
                         firstDefaultButtonAction: @escaping ((UIAlertAction) -> Void),
                         secondDefaultButtonTitle: String,
                         secondDefaultButtonAction: @escaping ((UIAlertAction) -> Void),
                         cancelButtonTitle: String = AppTexts.AlertMessages.cancel,
                         cancelButtonAction: ((UIAlertAction) -> Void)? = nil) {
        let alert = getAlertController(ofStyle: .actionSheet, withTitle: title, andMessage: message)

        alert.addAction(UIAlertAction(title: firstDefaultButtonTitle, style: UIAlertAction.Style.default, handler: firstDefaultButtonAction))
        alert.addAction(UIAlertAction(title: secondDefaultButtonTitle, style: UIAlertAction.Style.default, handler: secondDefaultButtonAction))
        alert.addAction(UIAlertAction(title: cancelButtonTitle, style: UIAlertAction.Style.cancel, handler: cancelButtonAction))

        let vc = UIApplication.shared.getTopViewController()
        vc?.present(alert, animated: true, completion: nil)
    }
    

    func internetNotConnectedAlert(outputBlock : @escaping () -> Void){
        let alert = getAlertController(ofStyle: .alert,
                                       withTitle: AppTexts.AlertMessages.networkUnreachableWithExclamation,
                                       andMessage: AppTexts.AlertMessages.youAreNotConnectedToInternet)

        alert.addAction(UIAlertAction(title: AppTexts.AlertMessages.tapToRetry, style: UIAlertAction.Style.default) { _ in
            outputBlock()
        })

        let vc = UIApplication.shared.getTopViewController()
        vc?.present(alert, animated: true, completion: nil)
    }

    func handle401StatueCode(){
        let alert = getAlertController(ofStyle: .alert,
                                       withTitle: AppTexts.AlertMessages.sessionExpiredWithExclamation,
                                       andMessage: AppTexts.AlertMessages.yourSessionHasExpiredPleaseLoginAgain)

        alert.addAction(UIAlertAction(title: AppTexts.AlertMessages.ok.uppercased(), style: UIAlertAction.Style.default, handler: { _ in
            Singleton.sharedInstance.generalFunctions.deinitilseAllVariables()
        }))


        let vc = UIApplication.shared.getTopViewController()
        vc?.present(alert, animated: true, completion: nil)
    }
}
