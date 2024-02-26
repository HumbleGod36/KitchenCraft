//
//  Helper.swift
//  KitchenCraft
//
//  Created by Tony Michael on 12/02/24.
//

import Foundation
import UIKit

func alertPopUp(controller : UIViewController , title : String , message : String , actionTitle: String , style : UIAlertAction.Style , handler : ((UIAlertAction) -> Void)? = nil ){
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: actionTitle , style: style , handler: handler ))
    controller.present(alert, animated: true)
}

func eyeView(controller : UIViewController , action : Selector ) -> UIView {
    let button = UIButton(type: .custom)
    button.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
    button.setImage(UIImage(systemName: "eye.slash"), for: .normal)
    button.tintColor = .lightGray
    button.addTarget(controller, action: action, for: .touchUpInside)
    
    let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 20))
    paddingView.addSubview(button)
    
    return paddingView
}
