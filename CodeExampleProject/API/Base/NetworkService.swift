//
//  NetworkService.swift
//  CodeExampleProject
//
//  Created by Oleg Pogosian on 21.10.2021.
//

import Foundation
import Alamofire

enum QueueQos {
    case background
    case defaultQos
}

protocol CustomErrorProtocol: Error {
    var localizedDescription: String { get }
    var code: Int { get }
}


struct CustomError: CustomErrorProtocol, Codable {
    
    var localizedDescription: String
    var code: Int
    
    init(localizedDescription: String, code: Int, dictionary: [String: Any]? = nil) {
        self.localizedDescription = localizedDescription
        self.code = code
    }
}

class NetworkService {
    
    func checkInternetConnect() -> Bool {
        return InternetService.shared.checkInternetConnect()
    }
    
    func internetConnectError() -> CustomError {
        return CustomError(localizedDescription: "Error", code: 404)
    }
    
    func serverError() -> CustomError {
        return CustomError(localizedDescription: "Could not access the server", code: 500)
    }
    
}

extension NetworkService {
    
    func cancellAllRequests() {
        
        Alamofire.Session.default.session.getTasksWithCompletionHandler { (sessionDataTask, uploadData, downloadData) in
            
            sessionDataTask.forEach { $0.cancel() }
            uploadData.forEach { $0.cancel() }
            downloadData.forEach { $0.cancel() }
        }
    }
    
    func queryBy(_ url: URLConvertible,
                 method: HTTPMethod = .get,
                 parameters: Parameters? = nil,
                 encoding: ParameterEncoding = URLEncoding.default,
                 queue: QueueQos = .defaultQos,
                 headers: HTTPHeaders? = nil,
                 resp: @escaping IdResponseBlock) {
        
        let headersDefault = self.configurateHeaders()
        
        return query(url,
                     method: method,
                     parameters: parameters,
                     encoding: encoding,
                     headers: headersDefault,
                     queue: queue,
                     resp: resp)
    }
    
    
    private func query(_ url: URLConvertible,
                       method: HTTPMethod = .get,
                       parameters: Parameters? = nil,
                       encoding: ParameterEncoding = URLEncoding.default,
                       headers: HTTPHeaders? = nil,
                       queue: QueueQos,
                       resp: @escaping IdResponseBlock) {
        
        let queueQos: DispatchQueue
        
        switch queue {
        case QueueQos.defaultQos:
            queueQos = DispatchQueue(label: "com.queueDefault", qos: .default, attributes: [.concurrent])
        case QueueQos.background:
            queueQos = DispatchQueue(label: "com.queueBackground", qos: .background, attributes: [.concurrent])
        }
        
        if !checkInternetConnect() {
            return resp(.failure(internetConnectError()))
        }
        
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
        
        let _ = AF.request(url,
                           method: method,
                           parameters: parameters,
                           encoding: encoding,
                           headers: headers
        ).validate()
        .responseData(queue: queueQos, emptyResponseCodes: Set(200...299)) { (response) in
            
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
            
            guard let statusCode = response.response?.statusCode else {
                print("ERROR: Not Found status code")
                return resp(.failure(CustomError(localizedDescription: "Not Found status code", code: 0)))
            }
            
            switch response.result {
            case .success(let value):
                return resp(.success(value))
            case .failure(let error):
                print(error)
                return resp(.failure(self.parseError(response.data, statusCode: statusCode)))
            }
        }
    }
    
    func queryMultipart(_ url: URLConvertible,
                        method: HTTPMethod = .post,
                        parameters: Parameters? = nil,
                        data: [String : Data]? = nil,
                        fileName: String? = nil,
                        image: [UIImage]? = nil,
                        keyForFile: String = "avatar",
                        headers: HTTPHeaders? = nil,
                        encoding: ParameterEncoding = URLEncoding.default,
                        resp: @escaping IdResponseBlock) {
        
        if !checkInternetConnect() {
            return resp(.failure(internetConnectError()))
        }
        
        let headersDefault = self.configurateHeaders()
        
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
        
        AF.upload(multipartFormData: { (multipartFormData) in
            
            if let params = parameters {
                for (key, value) in params {
                    multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
                }
            }
            
            if let data = data {
                for (key, value) in data {
                    print(value.description)
                    multipartFormData.append(value, withName: key, fileName: key + ".wav", mimeType: "wav")
                }
            }
            
            if let data = image {
                
                for item in data {
                    
                    guard let fName = fileName else { return }
                    
                    if let imageData = item.jpegData(compressionQuality: 0.5) {
                        multipartFormData.append(imageData, withName: keyForFile, fileName: fName, mimeType: "image/jpeg")
                    }
                }
            }
            
        }, to: url, method: method, headers: headersDefault).validate().responseData { (response) in
            
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
            
            guard let statusCode = response.response?.statusCode else {
                print("ERROR: Not Found status code")
                return resp(.failure(CustomError(localizedDescription: "Not Found status code", code: 0)))
            }
            
            switch response.result {
            case .success(let value):
                return resp(.success(value))
            case .failure(let error):
                print(error)
                return resp(.failure(self.parseError(response.data, statusCode: statusCode)))
            }
        }
        
    }
    
    private func parseError(_ data: Data?, statusCode: Int) -> CustomError {
        
        guard let data = data else { return serverError() }
        
        do {
            let model = try JSONDecoder().decode(CustomError.self, from: data)
            print(model.localizedDescription)
            switch model.localizedDescription {
            default:
                return CustomError(localizedDescription: model.localizedDescription, code: statusCode)
            }
        } catch let error {
            print(error)
            do {
                let jsonDictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                guard let text = jsonDictionary?.values.first as? Array<String> else {
                    let error = String(data: data, encoding: .utf8) ?? ""
                    
                    return CustomError(localizedDescription: error, code: statusCode)
                }
                
                return CustomError(localizedDescription: text.first ?? "", code: statusCode, dictionary: jsonDictionary)
            } catch let error {
                print(error)
                let error = String(data: data, encoding: .utf8) ?? ""
                return CustomError(localizedDescription: error, code: statusCode)
            }
        }
    }
    
    private func configurateHeaders() -> HTTPHeaders {
        //configurate parameters for request header here
        let headersForQuery: HTTPHeaders = HTTPHeaders.default
        
        return headersForQuery
    }
    
}
