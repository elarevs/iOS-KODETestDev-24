//
//  NetworkManager.swift
//  iOS-KODETestDEV'24
//
//  Created by Artem Elchev on 22.03.2024.
//

import Foundation
import UIKit

// MARK: - Networking
final class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() {}
    
    enum NetworkError: String, Error {
        case fatalError = "Unsupported"
        case noData = "Can't recieve data"
        case badData = "Bad data"
        case serverError = "Problem with server"
        case decodingError = "Can't decode data"
    }
    
    func fetchContacts(completion: @escaping(Result<[Contact], NetworkError>) -> Void) {
    
        let baseUrl = "https://stoplight.io/mocks/kode-api/trainee-test/331141861/users"
        
        guard let apiURL = URL(string: baseUrl) else {
            print("\(NetworkError.fatalError.rawValue)")
            return
        }
    
        var request = URLRequest(url: apiURL)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("code=200, example=success", forHTTPHeaderField: "Prefer")
        //request.setValue("code=500, dynamic=true", forHTTPHeaderField: "Prefer")
        

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                print(error?.localizedDescription ?? "No error desription")
                completion(.failure(.fatalError))
                return
            }

            guard let response = response as? HTTPURLResponse else {
                print(error?.localizedDescription ?? "No error desription")
                completion(.failure(.fatalError))
                return
            }
            
            guard let data = data else {
                completion(.failure(.badData))
                return
            }

            if (200...299).contains(response.statusCode) {
                let decoder = JSONDecoder()
                do {
                    let contactsQuery = try decoder.decode(ContactsQuery.self, from: data)
                    DispatchQueue.main.async {
                        if contactsQuery.items.count == 0 {
                            completion(.failure(.noData))
                            return
                        }
                        print("Success decoding \n\(contactsQuery.items)")
                        completion(.success(contactsQuery.items))
                    }
                } catch {
                    completion(.failure(.decodingError))
                }
       
            } else if (500...599).contains(response.statusCode) {
                completion(.failure(.serverError))
            } else {
                completion(.failure(.fatalError))
            }
            
        }.resume()
    }

    func fetchAvatar(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        guard let imageURL = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: imageURL) { (data, response, error) in
            guard error == nil else {
                print("Ошибка при получении аватара \(error!)")
                completion(nil)
                return
            }
            guard let data = data, let image = UIImage(data: data) else {
                print("Ошибка при получении аватара \(error!)")
                completion(nil)
                return
            }
            DispatchQueue.main.async {
                completion(image)
            }
        }.resume()
    }
    
}
