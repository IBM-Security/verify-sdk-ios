import UIKit
import AVFoundation
import LocalAuthentication
import IBMVerifyKit

class ViewController: UIViewController
{
    // MARK: Control variables
    @IBOutlet weak var textboxUsername: UITextField!
    @IBOutlet weak var textboxPassword: UITextField!
    @IBOutlet weak var textboxClientId: UITextField!
    @IBOutlet weak var textboxHostname: UITextField!
    @IBOutlet weak var buttonOK: UIButton!
    @IBOutlet weak var buttonRefresh: UIButton!
    
    // MARK: Variables
    var token: OAuthToken!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Pad the left and right margins of the textboxes.
        textboxUsername.leftView = UIView(frame: CGRect(x: 0, y:0, width: 10, height:10))
        textboxUsername.leftViewMode = .always
        textboxPassword.leftView = UIView(frame: CGRect(x: 0, y:0, width: 10, height:10))
        textboxPassword.leftViewMode = .always;
        textboxClientId.leftView = UIView(frame: CGRect(x: 0, y:0, width: 10, height:10))
        textboxClientId.leftViewMode = .always;
        textboxHostname.leftView = UIView(frame: CGRect(x: 0, y:0, width: 10, height:10))
        textboxHostname.leftViewMode = .always;
    }
    
    // Dismiss the keyboard.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        guard let touch = touches.first else
        {
            return
        }
        
        if(!touch.isMember(of: UITextField.self))
        {
            touch.view?.endEditing(true)
        }
    }
    
    // MARK: Control events
    @IBAction func onOkClick(_ sender: UIButton)
    {
        var alert: UIAlertController!
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        // Make sure we have the values.
        guard let username = textboxUsername.text,
            let password = textboxPassword.text,
            let clientId = textboxClientId.text,
            let endpointUrl = URL(string:  textboxHostname.text!) else
        {
            alert = UIAlertController(title: "OAuth Sample", message: "Enter values into all required fields.", preferredStyle: .alert)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        NSLog("Username: \(username)")
        NSLog("Password: \(password)")
        NSLog("Endpoint URL: \(endpointUrl)")
        NSLog("ClientId: \(clientId)")
        
        // For ROPC flow, you should be providing a Client Secret
        OAuthContext.shared.clientSecret = "myclientsecret"
        OAuthContext.shared.authorize(endpointUrl, clientId, username: username, password: password, serverTrustDelegate: SelfSignedCertificateDelegate())
        {
            token, error in
            
            // Process callback on main UI thread to display alert.
            DispatchQueue.main.async
            {
                if let error = error
                {
                    alert = UIAlertController(title: "OAuth Sample", message: error.localizedDescription, preferredStyle: .alert)
                }
                else
                {
                    // We got the token, encode to a string and save in UserDefaults.
                    if let data = try? JSONEncoder().encode(token!)
                    {
                        let value = String(data: data, encoding: .utf8)
                        UserDefaults.standard.set(value, forKey: "token")
                    
                        self.token = token!
                        alert = UIAlertController(title: "OAuth Sample", message: value, preferredStyle: .alert)
                    }
                }
                
                // Show the message.
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }

    @IBAction func onRefreshClick(_ sender: UIButton)
    {
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        var alert: UIAlertController!
        
        // Attempt to load the token from UserDefaults.
        if let value = UserDefaults.standard.string(forKey: "token"), let data = Data(base64Encoded: value)
        {
            self.token = try? JSONDecoder().decode(OAuthToken.self, from: data)
            alert = UIAlertController(title: "OAuth Sample", message: value, preferredStyle: .alert)
        }
        
        
        // Check for the token.
        guard token != nil else
        {
            // Show the error message.
            alert = UIAlertController(title: "OAuth Sample", message: "No token to refresh.", preferredStyle: .alert)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        
        guard let clientId = textboxClientId.text,
            let endpointUrl = URL(string:  textboxHostname.text!) else
        {
            alert = UIAlertController(title: "OAuth Sample", message: "Missing client id or token endpoint fields.", preferredStyle: .alert)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        NSLog("Endpoint URL: \(endpointUrl)")
        NSLog("ClientId: \(clientId)")
        
        NSLog("== Old Token ==")
        NSLog("Access token: \(self.token.accessToken)")
        NSLog("Refresh token: \(self.token.refreshToken)")
        NSLog("Should refresh: \(self.token.shouldRefresh)")
        
        // If the /token endpoint is using a self-signed certificate, then pass SelfSignedCertificateDelegate()
        // NOTE: You shouldn't do this in production!
        OAuthContext.shared.refresh(endpointUrl, clientId, refreshToken:token.refreshToken, serverTrustDelegate: SelfSignedCertificateDelegate())
        {
            token, error in
            
            // Process callback on main UI thread and display alert.
            DispatchQueue.main.async
            {
                if let error = error
                {
                    alert = UIAlertController(title: "OAuth Sample", message: error.localizedDescription, preferredStyle: .alert)
                }
                else
                {
                    // We got the token, encode to a string and save in UserDefaults.
                    if let data = try? JSONEncoder().encode(token!)
                    {
                        let value = String(data: data, encoding: .utf8)
                        UserDefaults.standard.set(value, forKey: "token")
                        
                        self.token = token!
                        alert = UIAlertController(title: "OAuth Sample", message: value, preferredStyle: .alert)
                    
                
                        NSLog("== New Token ==");
                        NSLog("Access token: \(self.token.accessToken)")
                        NSLog("Refresh token: \(self.token.refreshToken)")
                        NSLog("Should refresh: \(self.token.shouldRefresh)")
                        
                        alert = UIAlertController(title: "OAuth Sample", message: value, preferredStyle: .alert)
                    }
                }
                
                // Show the message.
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}
