//
//  Customer.swift
//  BalanceYogaWaiver
//
//  Created by rixcore on 11/7/18.
//  Copyright © 2018 rixcore. All rights reserved.
//

import Foundation

class Customer {
    var firstName: String
    var lastName: String
    var address: String
    var city: String
    var state: String
    var zip: String
    var phone: String?
    var emergencyPhone: String?
    var email: String
    var birthDate: String?
    var hearUs: String?
    var injuries: String?
    var liabilityRelease: Bool = true
    var emailOptIn: Bool = true
    var sourceName: String = ""
    var sourcePassword: String = ""
    var siteID: String = ""
    var apiKey: String = ""
    
    init(firstName: String, lastName: String, address: String, city: String, state: String, zip: String, phone: String?, emergencyPhone: String?, email: String, birthDate: String?, hearUs: String?, injuries: String?) {
        self.firstName = firstName
        self.lastName = lastName
        self.address = address
        self.city = city
        self.state = state
        self.zip = zip
        self.phone = phone
        self.emergencyPhone = emergencyPhone
        self.email = email
        self.birthDate = birthDate
        self.hearUs = hearUs
        self.injuries = injuries
        self.getPlist()
    }
    
    func getPlist() {
        var resourceFileDictionary: NSDictionary?
        
        //Load content of Info.plist into resourceFileDictionary dictionary
        if let path = Bundle.main.path(forResource: "Info", ofType: "plist") {
            resourceFileDictionary = NSDictionary(contentsOfFile: path)
        }
        
        if let resourceFileDictionaryContent = resourceFileDictionary {
            // Get something from our Info.plist like MinimumOSVersion
            self.siteID = resourceFileDictionaryContent.object(forKey: "STUDIO_ID")! as! String
            self.sourceName = resourceFileDictionaryContent.object(forKey: "API_LOGIN_NAME")! as! String
            self.sourcePassword = resourceFileDictionaryContent.object(forKey: "API_PASSWORD")! as! String
            self.apiKey = resourceFileDictionaryContent.object(forKey: "API_KEY")! as! String
            print(self.apiKey)
        }
    }
    
    func fileName() -> String {
        return "\(self.removeSpecialCharsFromString(text: self.firstName))-\(self.removeSpecialCharsFromString(text: self.lastName))-\(UUID().uuidString).pdf"
    }
    
    private func removeSpecialCharsFromString(text: String) -> String {
        let okayChars = Set("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890-")
        return text.filter {okayChars.contains($0) }
    }
    
    func printCustomer() {
        print(customerToString())
    }
    
    func customerToString () -> String {
        return """
            Customer\n
            \(self.firstName) \(self.lastName)
            \(self.address)
            \(self.city), \(self.state) \(self.zip)
            Phone: \(self.phone ?? "")
            Emergency Phone: \(self.emergencyPhone ?? "")
            Email: \(self.email)
            BirthDate: \(self.birthDate ?? "")
            How did you hear about us: \(self.hearUs ?? "")
            Any Injuries: \(self.injuries ?? "")
        """
    }
    
    func sendCustomerAPI(withCallBack callback: @escaping (Int) -> ()) {
        var birthDateSoap = ""
        if (self.birthDate! != "") {
            birthDateSoap = "<BirthDate>\(self.birthDate!)</BirthDate>"
        }
        
        let is_SoapMessage: String = """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns="http://clients.mindbodyonline.com/api/0_5_1">
                <soapenv:Header/>
                <soapenv:Body>
                  <AddOrUpdateClients xmlns="http://clients.mindbodyonline.com/api/0_5_1">
                     <Request>
                        <XMLDetail>Full</XMLDetail>
                        <PageSize>10</PageSize>
                        <CurrentPageIndex>0</CurrentPageIndex>
                        <UpdateAction>AddNew</UpdateAction>
                        <Test>false</Test>
                        <Clients>
                           <Client>
                              <FirstName>\(self.firstName)</FirstName>
                              <LastName>\(self.lastName)</LastName>
                              <AddressLine1>\(self.address)</AddressLine1>
                              <City>\(self.city)</City>
                              <State>\(self.state)</State>
                              <PostalCode>\(self.zip)</PostalCode>
                              <Country>US</Country>
                              <MobilePhone>\(self.phone!)</MobilePhone>
                              <EmergencyContactInfoPhone>\(self.emergencyPhone!)</EmergencyContactInfoPhone>
                              <Email>\(self.email)</Email>
                              \(birthDateSoap)
                              <YellowAlert>\(self.injuries!)</YellowAlert>
                              <EmailOptIn>\(self.emailOptIn)</EmailOptIn>
                              <PromotionalEmailOptIn>\(self.emailOptIn)</PromotionalEmailOptIn>
                              <LiabilityRelease>\(self.liabilityRelease)</LiabilityRelease>
                              <ReferredBy>\(self.hearUs!)</ReferredBy>
                           </Client>
                        </Clients>
                     </Request>
                  </AddOrUpdateClients>
                </soapenv:Body>
            </soapenv:Envelope>
            """

        print(is_SoapMessage)
        
        let is_URL: String = "https://api.mindbodyonline.com/0_5_1/ClientService.asmx"

        let lobj_Request = NSMutableURLRequest(url: NSURL(string: is_URL)! as URL)
        let session = URLSession.shared

        lobj_Request.httpMethod = "POST"
        lobj_Request.httpBody = is_SoapMessage.data(using: String.Encoding.utf8)
        lobj_Request.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        lobj_Request.addValue(String(is_SoapMessage.count), forHTTPHeaderField: "Content-Length")
        lobj_Request.addValue("http://clients.mindbodyonline.com/api/0_5_1/AddOrUpdateClients", forHTTPHeaderField: "SOAPAction")
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
    }
    
    
    func sendCustomerPasswordResetAPI(withCallBack callback: @escaping (Int) -> ()) {
        let is_SoapMessage: String = """
        <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns="http://clients.mindbodyonline.com/api/0_5_1">
            <soapenv:Header/>
            <soapenv:Body>
                <SendUserNewPassword xmlns="http://clients.mindbodyonline.com/api/0_5_1">
                    <Request>
                        <UserFirstName>\(self.firstName)</UserFirstName>
                        <UserLastName>\(self.lastName)</UserLastName>
                        <UserEmail>\(self.email)</UserEmail>
                    </Request>
                </SendUserNewPassword>
            </soapenv:Body>
        </soapenv:Envelope>
        """
        
        print(is_SoapMessage)
        
        let is_URL: String = "https://api.mindbodyonline.com/0_5_1/ClientService.asmx"
        
        let lobj_Request = NSMutableURLRequest(url: NSURL(string: is_URL)! as URL)
        let session = URLSession.shared
        
        lobj_Request.httpMethod = "POST"
        lobj_Request.httpBody = is_SoapMessage.data(using: String.Encoding.utf8)
        lobj_Request.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        lobj_Request.addValue(String(is_SoapMessage.count), forHTTPHeaderField: "Content-Length")
        lobj_Request.addValue("http://clients.mindbodyonline.com/api/0_5_1/SendUserNewPassword", forHTTPHeaderField: "SOAPAction")
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
    }
    
}
