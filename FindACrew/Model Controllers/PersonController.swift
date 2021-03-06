//
//  PersonController.swift
//  FindACrew
//
//  Created by Ben Gohlke on 5/4/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation

class PersonController {
    enum HTTPMethod: String {
        case get = "GET"
        case put = "PUT"
        case post = "POST"
        case delete = "DELETE"
    }
    
    private let baseURL = URL(string: "https://lambdaswapi.herokuapp.com")!
    private lazy var peopleURL = URL(string: "/api/people", relativeTo: baseURL)!
    var people: [Person] = []//Container for all the people
    
    //Completion will be run after the function completes its task
    func searchForPeople(searchTerm:String, completion: @escaping () -> Void) {
        //1.Building URL
        var urlComponents = URLComponents(url: peopleURL, resolvingAgainstBaseURL: true)
        let searchTermQueryItem = URLQueryItem(name: "search", value: searchTerm)
        urlComponents?.queryItems = [searchTermQueryItem]
        
        guard let requestURL = urlComponents?.url else {
            print("Request URL is nil")
            completion()
            return
        }
        
        // URL Request
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.get.rawValue
        
        
        //Data task, [weak self] to prevent memory leaks
        URLSession.shared.dataTask(with: request) {[weak self] (data, _, error) in
            
            if let error = error {
                print("Error Fetching data: \(error)")
                completion()
                return
            }
            
            guard let self = self else {
                completion()
                return
            }
            
            guard let data = data else {
                print("No data returned from data task")
                completion()
                return
            }
            
            let jsonDecoder = JSONDecoder()
            
            //Use to convert camel case to snake case for the Model to match the json format of the name of each property
            jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
            
            do{
                let personSearch = try jsonDecoder.decode(PersonSearch.self, from: data)
                self.people.append(contentsOf: personSearch.results)
                completion()
            }catch{
                print("Unable to decode data of type PersonSearch: \(error)")
                completion()
                return
            }
            
            
        }.resume()
    }
}
