import Foundation
import SystemConfiguration
import Alamofire

public class APIManager {
    
    static let sharedInstance = APIManager()
    
    class func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
    
    //MARK: -  Base Service Request
    func serviceGet(_ url:String, headerParam : [String: String], successBlock:@escaping (_ response:Any) -> Void, failureBlock:@escaping (_ error : String)->Void)
    {
        if APIManager.isConnectedToNetwork()
        {
            print("request url : \(url)")
            Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headerParam).responseJSON {
                response in
                switch response.result {
                case .success:
                    print(response.result.value!)
                    if let dict = response.result.value
                    {
                        successBlock(dict)
                    }
                    else
                    {
                        failureBlock((response.result.error?.localizedDescription)!)
                    }
                    break
                case .failure(let error):
                    print(error)
                    failureBlock(error.localizedDescription)
                }
            }
        }
    }
    
    func servicePost(_ url:String, param : [String: Any], headerParam : [String: String], successBlock:@escaping (_ response:Any) -> Void, failureBlock:@escaping (_ error : String)->Void)
    {
        Alamofire.request(url, method: .post, parameters: param, encoding: JSONEncoding.default, headers: headerParam).responseJSON { (response) in
            switch response.result {
            case .success:
                print(response.result.value!)
                if let dict = response.result.value
                {
                    successBlock(dict)
                }
                else
                {
                    failureBlock((response.result.error?.localizedDescription)!)
                }
                break
            case .failure(let error):
                print(error)
                failureBlock(error.localizedDescription)
            }
        }
    }
}
