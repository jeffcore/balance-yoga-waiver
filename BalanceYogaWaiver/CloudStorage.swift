//
// Copyright 2015 Google Inc. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import Foundation
import UIKit

//
// Class used to upload photos to Google Cloud Storage.
//
class CloudStorage {

  //
  // Uploads an image to a resumable upload URL from GCS.
  //
  internal func uploadImageToGoogleCloud(image: UIImage, uploadUrl: String,
                                         completion:(_ error: Bool, _ details: String) -> Void) {
    // let imageData = UIImageJPEGRepresentation(image, 100)

    // The request to send
//    let request = NSMutableURLRequest(url:NSURL(string:uploadUrl)! as URL);
//    request.httpMethod = "PUT"
//    request.addValue("image/jpeg", forHTTPHeaderField: "Content-Type")
//    let uploadSession = URLSession.shared
//    var body = NSMutableData.init()
//    body.append(imageData ?? <#default value#>)
//    request.httpBody = body as Data

//    // The upload task using NSURLSession
//    var uploadTask = uploadSession.uploadTaskWithRequest(request as URLRequest, fromData:body,
//      completionHandler: { data, response, error -> Void in
//      if error == nil {
//        var httpResponse = response as? NSHTTPURLResponse
//        var statusCode = httpResponse!.statusCode;
//        if statusCode == 200 || statusCode == 201 {
//          completion(error: false, details: "");
//        } else {
//          var responseString = NSString(data: data, encoding: NSUTF8StringEncoding)
//          completion (error: true, details: String(format: "Code: %@, Headers: %@", statusCode,
//            httpResponse!.allHeaderFields ))
//        }
//      } else {
//        println(error)
//        completion (error: true, details: String(format:"code: %@, domain: %@, userInfo: %@ ",
//          error.code, error.domain, error.userInfo!))
//      }
//  })
//  uploadTask.resume()
   }

}
