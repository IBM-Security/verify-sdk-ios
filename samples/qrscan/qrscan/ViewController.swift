import UIKit
import IBMVerifyKit
import AVFoundation

class ViewController: UIViewController, QrScanReaderDelegate
{
    // MARK: Control variables
    @IBOutlet weak var viewQRCamera: UIView!
    
    private var videoLayer: CALayer!
    private var scanResult: QrScanProtocol?
    private var reader = QrScanReader()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }

    /// Notifies the view controller that its view is about to be added to a view hierarchy.
    /// - parameter animated: If `true`, the view is being added to the window using an animation.
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        verifyCameraPermission()
    }
    
    /// Called to notify the view controller that its view has just laid out its subviews.
    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
        
        guard videoLayer != nil else
        {
            return
        }
        
        videoLayer.frame = viewQRCamera.bounds
    }
    
    /// Notifies the view controller that its view is about to be removed from a view hierarchy.
    /// - parameter animated: If `true`, the disappearance of the view is being animated.
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        
        if reader.delegate == nil
        {
            return
        }
        
        reader.stop()
    }
    
    // MARK: Camera permissions
    
    /// Checks if the user has allowed access to the camera.
    /// - remark: If access is denied, the user can enable access via application settings.  The OS will only prompt once for permissions.
    func verifyCameraPermission()
    {
        let authorizationStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        
        if authorizationStatus == AVAuthorizationStatus.authorized
        {
            showCameraView()
        }
        else if authorizationStatus == AVAuthorizationStatus.notDetermined
        {
            promptForCameraPermission()
        }
    }
    
    /// Prompt for camera permissions.
    /// - remark: This occurs when the app is requesting permisssions for the first time.
    func promptForCameraPermission()
    {
        AVCaptureDevice.requestAccess(for: .video, completionHandler:
        {
            granted in
            
            DispatchQueue.main.async
            {
                if granted
                {
                    self.showCameraView()
                }
            }
        })
    }
    
    /// Show the Show the `UIView` representing camera view.
    func showCameraView()
    {
        reader.delegate = self
        videoLayer = reader.videoPreview
        
        viewQRCamera.layer.addSublayer(videoLayer)
        viewQRCamera.setNeedsDisplay()
        view.bringSubviewToFront(viewQRCamera)
        
        reader.start()
    }
    
    // MARK: QrScanReaderDelegate method
    
    /// The function that contains the result of an successful registrations scan.
    /// - parameter result: An instance of `QRScanResultProtocol`.
    func didScan(with result: QrScanProtocol)
    {
        DispatchQueue.main.async
        {
            let alert = UIAlertController(title: "QR Scan", message: "", preferredStyle: .alert)
            
            if let result = result as? CloudQrScan
            {
                alert.title = "Cloud QR Scan"
                alert.message = "\(result)"
            }
            
            if let result = result as? OnPremiseQrScan
            {
                alert.title = "On-Premise QR Scan"
                alert.message = "\(result)"
            }
            
            
            if let result = result as? OTPQrScan
            {
                alert.title = "OTP QR Scan"
                alert.message = "\(result)"
            }
            
            if let result = result as? OnPremiseLoginQrScan
            {
                alert.title = "Login QR Scan"
                alert.message = "\(result)"
            }
        
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler:
            {
                _ in
                
                self.reader.start()
            }))
            
            self.present(alert, animated: true)
        }
    }
}

