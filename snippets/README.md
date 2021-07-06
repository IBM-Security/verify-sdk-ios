# Code Snippets

<table>
    <tr>
        <th width="300px">Name</th>
        <th>Type</th>
        <th>Description</th>
    </tr>
    <tr>
        <td>Get OAuth token</td>
        <td><a href="#oauthtoken">Snippet</a></td>
        <td> The SDK supports the ROPC grant flow.</td>
    </tr>
    <tr>
        <td>Certificate pinning</td>
        <td><a href="#certpin">Snippet</a></td>
        <td>Compares a certificate stored in the mobile app as being the same certificate presented by the web server that provides the HTTPS connection.</td>
    </tr>
    <tr>
        <td>Key pair generation</td>
        <td><a href="#keypairgen">Snippet</a></td>
        <td>Key pairs are used in the SDK to sign challenges, coming from IBM Security Access Manager. The private key remains on the device, whereas the public key gets uploaded to the server as part of the mechanisms enrollment.</td>
    </tr>
     <tr>
        <td>Signing data</td>
        <td><a href="#signdata">Snippet</a></td>
        <td>The public key would be stored on a server and provide the challenge text to the client. The client uses the private key to sign the data which is sent back to the server. The server validates the signed data against the public key to verify the keys have not been tampered with.</td>
    </tr>
</table>

<h2 id="oauthtoken">Get OAuth token</h2>
The SDK supports the ROPC grant flow.
<br/>


![Swift Version](https://img.shields.io/badge/swift-5.1-orange.svg)

```swift
let hostname =  URL(string: "https://yourserver/mga/sps/oauth/oauth20/token")!
let clientId = "yourClientId"
let username = "yourUserName"
let password = "yourPassword"
    
OAuthContext.sharedInstance.authorize(hostname, clientId, username: username, password: password)
{
    token, error in
  
    guard let _ = error else
    {
        print("Error: \(error.errorDescription)")
        return
    }
 
    if let token = token
    {
        // We got the token.
        print("Token: \(token)")
    }
}
```

<h2 id="certpin">Certificate pinning</h2>
Compares a certificate stored in the mobile app as being the same certificate presented by the web server that provides the HTTPS connection.  Refer to <a href="https://developer.apple.com/documentation/foundation/urlsessiondelegate">URLSessionDelegate</a> for additional information on session level events.  

> Assign the class implmentating `URLSessionDelegate` to `serverTrustDelegate`argument in function of the `OAuthContext` class.

To obtain the certificate chain to include into your Xcode project, run the following command:

```bash
input=tmpinput && touch $input && openssl s_client -connect sdk.securitypoc.com:443 -showcerts 2>/dev/null <$input | openssl x509 -inform pem -outform der -out sdk_cert.der && rm $input
```

> Ensure the certifcate has been copied into the project folder and added to the project in Xcode.
> This example demonstrates a custom implementation of `URLSessionDelegate`.  The IBMVerifySDK supports the sample below in `PinnedCertificateDelegate`.

<br/>

![Swift Version](https://img.shields.io/badge/swift-5.1-orange.svg)

```swift
public class MyPinnedCertificateDelegate: NSObject, URLSessionDelegate
{
    let pinnedCertificateData: Data
    
    // Initialized with the name of the file and the file extension.
    init?(forResource: String, withExtension: String)
    {
        guard let url = Bundle.main.url(forResource: forResource, withExtension: withExtension) else
        {
            return nil
        }
        
        do
        {
            self.pinnedCertificateData = try Data(contentsOf: url)
        }
        catch
        {
            return nil
        }
    }
    
    public func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void)
    {
        guard let serverTrust = challenge.protectionSpace.serverTrust, let presentedCertificate = SecTrustGetCertificateAtIndex(serverTrust, 0) else
        {
            // Terminate further processing, no certificate at index 0
            completionHandler(.cancelAuthenticationChallenge, nil)
            return
        }
        
        // Compare the presented certificate to the pinned certificate.
        let presentedCertificateData: NSData = SecCertificateCopyData(presentedCertificate)
        if presentedCertificateData.isEqual(to: pinnedCertificateData)
        {
            completionHandler(.useCredential, URLCredential(trust: serverTrust))
            return
        }
        
        // Don't trust the presented certificate by default.
        completionHandler(.cancelAuthenticationChallenge, nil)
    }
}


private func execute()
{
    let hostname = "https://yourserver/mga/sps/oauth/oauth20/token"
    let clientId = "yourClientId"
    let username = "yourUserName"
    let password = "yourPassword"
    let publicKeyCertificate = "MIIGETCCBPmgAwIBAgISA3NETe9ib0wR69vFjz9Vfil ..."
    
    guard let myPinnedCertificate = MyPinnedCertificateDelegate(forResource: "MyCertficate", withExtension: "cer") else
    {
        print("invalid certificate.")
        return
    }
    
    OAuthContext.sharedInstance.authorize(hostname, clientId, username: username, password: password, serverTrustDelegate: myPinnedCertificate)
    {
        token, error in
  
        guard let _ = error else
        {
            print("Error: \(error.errorDescription)")
            return
        }
 
        if let token = token
        {
            // We got the token.
            print("Token: \(token)")
        }
    }
}
    
```


<h2 id="keypairgen">Key pair generation</h2>
Key pairs are used in the SDK to sign challenges, coming from IBM Security Access Manager. The private key remains on the device, whereas the public key gets uploaded to the server as part of the mechanisms enrollment.
<br/>

![Swift Version](https://img.shields.io/badge/swift-5.1-orange.svg)


```swift
// Create the private and public keys.
KeychainHelper.create("sample")
{
    success, publicKeyData  in

    if success && let data = publicKeyData
    {
        print("Public key: \(KeychainHelper.export(data)!)")
    }
}

// Delete the private key.
KeychainHelper.delete("sample")
{
    result in
    
    print("Private key deleted successful: \(result).")
}

```


<h2 id="signdata">Signing data</h2>
The public key would be stored on a server and provide the challenge text to the client.  The client uses the private key to sign the data which is sent back to the server. The server validates the signed data against the public key to verify the keys have not been tampered with.


![Swift Version](https://img.shields.io/badge/swift-5.1-orange.svg)

```swift
// Create the private and public keys.
KeychainHelper.create("sample")
{
    success, _  in

    print("Private and public keys created successfully: \(success).")
}

// Sign the data.
guard let value = KeychainHelper.sign("sample", value: "hello world") else
{
    print("Unable to sign data with private key.")
    return
}

print("Signed data: \(value)")

// Delete the private key.
KeychainHelper.delete("sample")
{
    result in
    
    print("Private key deleted successful: \(result).")
}
```
