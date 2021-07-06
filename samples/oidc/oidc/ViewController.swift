//
//  ViewController.swift
//  oidc
//
//  Created by Craig Pearson on 18/10/19.
//  Copyright © 2019 Craig Pearson. All rights reserved.
//

import UIKit
import IBMVerifyKit

protocol AuthorizationDelegate {
    func onComplete(result: (token: OAuthToken?, error: Error?))
}

class ViewController: UIViewController, AuthorizationDelegate {

    // MARK: Control variables
    @IBOutlet weak var textboxHostname: UITextField!
    @IBOutlet weak var textboxClientId: UITextField!
    @IBOutlet weak var textboxClientSecret: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Pad the left and right margins of the textboxes.
        textboxClientSecret.leftView = UIView(frame: CGRect(x: 0, y:0, width: 10, height:10))
        textboxClientSecret.leftViewMode = .always;
        textboxClientId.leftView = UIView(frame: CGRect(x: 0, y:0, width: 10, height:10))
        textboxClientId.leftViewMode = .always;
        textboxHostname.leftView = UIView(frame: CGRect(x: 0, y:0, width: 10, height:10))
        textboxHostname.leftViewMode = .always;
    }

    // Dismiss the keyboard.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        
        if(!touch.isMember(of: UITextField.self)) {
            touch.view?.endEditing(true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let hostanme = textboxHostname.text, let clientId = textboxClientId.text, let clientSecret = textboxClientSecret.text else {
            return
        }
        
        if let viewController = segue.destination as? LoginViewController {
            viewController.hostname = hostanme
            viewController.clientId = clientId
            viewController.clientSecret = clientSecret
            viewController.authorizationDelegate = self
        }
    }
    
    // MARK: AuthorizationDelegate
    
    func onComplete(result: (token: OAuthToken?, error: Error?)) {
        var alert: UIAlertController!
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        if let error = result.error {
            alert = UIAlertController(title: "A2 Sample", message: error.localizedDescription, preferredStyle: .alert)
        }
        else {
            // We got the token, encode to a string and save in UserDefaults.
            if let data = try? JSONEncoder().encode(result.token!) {
                let value = String(data: data, encoding: .utf8)
                alert = UIAlertController(title: "A2 Sample", message: value, preferredStyle: .alert)
            }
        }
        
        // Show the message.
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}

