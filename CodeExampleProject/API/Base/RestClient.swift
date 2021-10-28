//
//  RestClient.swift
//  CodeExampleProject
//
//  Created by Oleg Pogosian on 21.10.2021.
//

import Foundation

typealias IdResponse = Result<Data?, CustomError>
typealias IdResponseBlock = (IdResponse) -> Void
typealias IdParsingBlock<T: Decodable> = (Result<T, CustomError>) -> Void

class RestClient: NSObject {
    
    let http = NetworkService()
    let baseUrl = BaseRequests.baseURL
    
    let dataIsNil = CustomError.init(localizedDescription: "Error parsing", code: 0)
    
    func response<T: Decodable>(_ result: (IdResponse), modelType: T.Type, resp: @escaping IdParsingBlock<T>, url: String) {
        
        switch result {
        case .success(let data):
            guard let data = data else {
                return resp(.failure(self.dataIsNil))
            }
            
            do {
                let model = try JSONDecoder().decode(modelType.self, from: data)
                return resp(.success(model))
            } catch let DecodingError.dataCorrupted(context) {
                print(context)
                return resp(.failure(self.dataIsNil))
            } catch let DecodingError.keyNotFound(key, context) {
                let context = "Key '\(key)' not found: \(context.debugDescription)" + "codingPath: \(context.codingPath)"
                print(context)
                return resp(.failure(self.dataIsNil))
            } catch let DecodingError.valueNotFound(value, context) {
                let context = "Value '\(value)' not found: \(context.debugDescription)" + "codingPath: \(context.codingPath)"
                print(context)
                return resp(.failure(self.dataIsNil))
            } catch let DecodingError.typeMismatch(type, context)  {
                let context = "Type '\(type)' mismatch: \(context.debugDescription)" + "codingPath: \(context.codingPath)"
                print(context)
                return resp(.failure(self.dataIsNil))
            } catch {
                print("error: ", error)
                
                return resp(.failure(self.dataIsNil))
            }
        case .failure(let error):
            return resp(.failure(error))
        }
    }
    
    func cancellRequests() {
        http.cancellAllRequests()
    }
}
