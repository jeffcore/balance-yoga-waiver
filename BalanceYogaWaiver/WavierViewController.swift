//
//  WavierViewController.swift
//  BalanceYogaWaiver
//
//  Created by rixcore on 11/7/18.
//  Copyright © 2018 rixcore. All rights reserved.
//

import UIKit

class WavierViewController: UIViewController, SignatureViewDelegate, XMLParserDelegate {
    var customer: Customer?
    var signatureFinal: UIImage?
    var signatureCount = 0
    var googleStorageAPIKey: String = ""
    var currentElement: String = ""
    var clientID: String = ""
    var siteID: String = ""
    var apiKey: String = ""    
    
    @IBOutlet weak var signatureView: SignatureView!
    @IBOutlet weak var signatureDate: UILabel!
    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var clearSignatureButton: UIButton!
    @IBOutlet weak var indicatorView: UIView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var indicatorLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        signatureView.delegate = self
        let currentDateTime = Date()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, YYYY"
        let somedateString = dateFormatter.string(from: currentDateTime)
        signatureDate.text = somedateString
        // signatureView.layer.borderColor = UIColor.black.cgColor
        // signatureView.layer.borderWidth = 1
        finishButton.layer.cornerRadius = 5
        clearSignatureButton.layer.cornerRadius = 5
        backButton.layer.cornerRadius = 5
        indicatorView.isHidden = true
        indicator.transform = CGAffineTransform(scaleX: 4, y: 4)
        customer!.printCustomer()
        getPlist()
    }
    func getPlist() {
        var resourceFileDictionary: NSDictionary?
        
        //Load content of Info.plist into resourceFileDictionary dictionary
        if let path = Bundle.main.path(forResource: "Info", ofType: "plist") {
            resourceFileDictionary = NSDictionary(contentsOfFile: path)
        }
        
        if let resourceFileDictionaryContent = resourceFileDictionary {
            // Get something from our Info.plist like MinimumOSVersion
            self.googleStorageAPIKey = resourceFileDictionaryContent.object(forKey: "GOOGLE_STORAGE_API_KEY")! as! String
            self.siteID = resourceFileDictionaryContent.object(forKey: "STUDIO_ID")! as! String
            self.apiKey = resourceFileDictionaryContent.object(forKey: "API_KEY")! as! String
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func clickFinishButton(_ sender: UIButton) {
        sendCustomerData()
    }
    
    func sendCustomerData() {
        finishButton.isEnabled = false
        indicatorView.isHidden = false
        indicatorLabel.text = "Creating Customer Account"
        indicator.startAnimating()
        if signatureCount > 10 {
            customer!.sendCustomerAPI {
                (statusCode, data) in
                if statusCode == 200 {
                    let parser = XMLParser(data: data ?? Data())
                    parser.delegate = self
                    parser.parse()
                    print("AppDelegate.swift: status of run quantumDB.syncToServer  call - \(statusCode)")
                    self.customer!.sendCustomerPasswordResetAPI {
                        (statusCode) in
                        if statusCode == 200 {
                            DispatchQueue.main.async {
                                self.indicatorLabel.text = "Storing PDF Version Of Waiver"
                                self.uploadPDF {
                                    (statusCode) in
                                    if statusCode == 200 {
                                        DispatchQueue.main.async {
                                            self.performSegue(withIdentifier: "EndViewSegue", sender: self)
                                        }
                                    } else {
                                        DispatchQueue.main.async {
                                            self.alert(title: "Waiver Not Uploaded")
                                            print("MindBody - upload waiver. Status code: \(statusCode)")
                                        }
                                    }
                                }
                            }
                        } else {
                            DispatchQueue.main.async {
                                self.alert(title: "Connection Error")
                                print("MindBody - unable to send password reset. Status code: \(statusCode)")
                            }
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        self.alert(title: "Connection Error")
                        print("MindBody - unable to create new customer. Status code: \(statusCode)")
                    }
                }
            }
        } else {
            print("you did not sign your name")
        }
    }
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName

        if currentElement == "Client" {
            self.clientID = ""
        }
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        switch currentElement {
        case "UniqueID": self.clientID += string
        default: break
        }
        print("client id \(self.clientID)")
    }
    
    func alert(title: String) {
        let alert = UIAlertController(title: title, message: "Please give iPad to Teacher", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { action in
            self.indicatorView.isHidden = true
            self.sendCustomerData()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            self.indicatorView.isHidden = true
            self.finishButton.isEnabled = true
        }))
        
        self.present(alert, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is ViewController {
            let vc = segue.destination as? ViewController
            
            vc?.customer = customer!
        } else if segue.destination is EndViewController {
            let vc = segue.destination as? EndViewController
            
            vc?.customer = customer!
        }
    }
    
    @IBAction func clearSignature(_ sender: UIButton) {
        signatureView.clearCanvas()
        signatureCount = 0
    }
    
    func SignatureViewDidCaptureSignature(view: SignatureView, signature: Signature?) {
        print("signature view  did capture signature")
        if signature != nil {
            print(signature!.image)
            
            signatureFinal = signature!.image
            
            // signatureView.clearCanvas()
        } else {
            if signatureView.signaturePresent == false {
                print("Signature is blank")
            } else {
                print("Failed to Capture Signature")
            }
        }
    }
    
    func uploadPDF(withCallBack callback: @escaping (Int) -> ()) {
        signatureView.captureSignature()
                
        let waiverText = """
              In consideration of and as inducement to my enrollment as a student of Balance Yoga, I represent and agree as follows:
                1.    I have been examined by a licensed physician within the past 6 months and have been found by such physician to be in good physical health and fully able to perform all yoga exercises which I am to learn and perform during my enrollment with Balance Yoga.
                2.   I will faithfully follow all instructions given to me by Balance Yoga instructors as to when, where and how to perform and not to perform yoga exercises - it being understood that any deviation from such instruction by me shall be at my own risk.
                3.   I will not hold Balance Yoga, it’s owners, instructors, employees, or other practitioners responsible for any injuries suffered by me caused in whole or in part by instructions provided by Balance Yoga instructors, or by any physical impairment of mine not fully disclosed to Balance Yoga in writing, and release Balance Yoga from any and all claims for such injuries.
                4.  I understand and acknowledge that I am to receive instruction in yoga theory and exercise only, and I will not hold Balance Yoga, it’s owners, instructors or employees to any higher standard of care than that applicable to school of yoga theory and exercise.
                5.   In the event that I am pregnant, I will not attend a yoga class until I have discussed the risks with my obstetrician, I will follow my doctor’s recommendations and will not hold Balance Yoga responsible for any injuries to myself or my fetus caused in part or in whole by my failure to follow my doctor’s recommendation.
                6.  If I am under 18 years of age, I have disclosed that information to Balance Yoga, in addition to my signature, my parent and/or guardian has signed and dated this waiver of liability at the bottom of this page.
                7.  The tuition paid herewith and such registration fees paid hereafter are non-refundable.
                8.  I agree to have my email address added to Balance Yoga's mailing list, which can be removed at anytime.
        """
        
        let A4paperSize = CGSize(width: 595, height: 842)
        let pdf = SimplePDF(pageSize: A4paperSize)
        
        pdf.addImage(UIImage(named: "logosm.png")!)
        pdf.addLineSpace(20.0)
        pdf.addText(self.customer!.customerToString(), font: UIFont.systemFont(ofSize: 16))
        pdf.addLineSpace(20.0)
        pdf.addText(waiverText, font: UIFont.systemFont(ofSize: 10))
        pdf.addLineSpace(20.0)
        pdf.addImage(self.signatureFinal!)
        pdf.addText(signatureDate.text!)
        
        let pdfData = pdf.generatePDFdata()
   
        let fileName = customer?.fileName()
        
        let is_SoapMessage: String = """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns="http://clients.mindbodyonline.com/api/0_5_1">
                <soapenv:Header/>
                <soapenv:Body>
                    <UploadClientDocument>
                        <Request>
                            <ClientID>\(self.clientID)</ClientID>
                            <FileName>\(fileName!)</FileName>
                            <Bytes>\(pdfData.base64EncodedString())</Bytes>
                        </Request>
                    </UploadClientDocument>
                </soapenv:Body>
            </soapenv:Envelope>
        """
        // print(is_SoapMessage)

        let is_URL: String = "https://api.mindbodyonline.com/0_5_1/ClientService.asmx"

        let lobj_Request = NSMutableURLRequest(url: NSURL(string: is_URL)! as URL)
        let session = URLSession.shared
        print("api key \(self.apiKey)")
        print("site id \(self.siteID)")
        lobj_Request.httpMethod = "POST"
        lobj_Request.httpBody = is_SoapMessage.data(using: String.Encoding.utf8)
        lobj_Request.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        lobj_Request.addValue(String(is_SoapMessage.count), forHTTPHeaderField: "Content-Length")
        lobj_Request.addValue("http://clients.mindbodyonline.com/api/0_5_1/UploadClientDocument", forHTTPHeaderField: "SOAPAction")
        lobj_Request.addValue("\(self.apiKey)", forHTTPHeaderField: "API-key")
        lobj_Request.addValue("\(self.siteID)", forHTTPHeaderField: "SiteId")

        let task = session.dataTask(with: lobj_Request as URLRequest, completionHandler: {data, response, error -> Void in
            print("Response: \(String(describing: response))")
            let strData = NSString(data: data ?? Data() , encoding: String.Encoding.utf8.rawValue)
            print("Body: \(strData! as String)")

            if error != nil
            {
                callback(400)
                print("Error: " + error.debugDescription)
            } else {
                if let httpResponse = response as? HTTPURLResponse {
                    print("status code \(httpResponse.statusCode)")
                    callback(httpResponse.statusCode)
                } else {
                    callback(400)
                }
            }
        })
        task.resume()
        
//        let is_URL: String = "https://www.googleapis.com/upload/storage/v1/b/balance-waivers/o?uploadType=media&key=\(googleStorageAPIKey)&name=\(String(describing: fileName!))"
//        print(is_URL)
//        let lobj_Request = NSMutableURLRequest(url: NSURL(string: is_URL)! as URL)
//        let session = URLSession.shared
//        lobj_Request.httpMethod = "POST"
//        lobj_Request.httpBody = pdfData
//        lobj_Request.addValue("application/pdf", forHTTPHeaderField: "Content-Type")
//        lobj_Request.addValue(String(pdfData.count), forHTTPHeaderField: "Content-Length")
//
//        let task = session.dataTask(with: lobj_Request as URLRequest, completionHandler: {data, response, error -> Void in
//            print("Response: \(String(describing: response))")
//            let strData = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
//            print("Body: \(strData! as String))")
//
//            if error == nil {
//                if let httpResponse = response as? HTTPURLResponse {
//                    print("status code \(httpResponse.statusCode)")
//                    callback(httpResponse.statusCode)
//                } else {
//                    callback(400)
//                }
//            } else {
//                callback(400)
//                print("Error: " + error.debugDescription)
//            }
//        })
//        task.resume()
        
//        if let documentDirectories = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first {
//            // make uniquename
//            let fileName = "example.pdf"
//            let documentsFileName = documentDirectories + "/" + fileName
//
//            do {
//                try pdfData.write(to:URL(fileURLWithPath: documentsFileName), options: .atomic)
//                print("\nThe generated pdf can be found at:")
//                print("\n\t\(documentsFileName)\n")
//            }catch{
//                print(error)
//            }
//        }
    }
    
    func SignatureViewDidBeginDrawing(view: SignatureView) {
        print("Began drawing Signature")
    }
    
    func SignatureViewIsDrawing(view: SignatureView) {
        self.signatureCount = self.signatureCount + 1
        print("Is drawing Signature \(self.signatureCount)")
    }
    
    func SignatureViewDidFinishDrawing(view: SignatureView) {
        print("Did finish drawing Signature")
    }
    
    func SignatureViewDidCancelDrawing(view: SignatureView) {
        print("Did cancel drawing signature")
    }
}
