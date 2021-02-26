//
//  Person.swift
//  FindACrew
//
//  Created by Ben Gohlke on 5/4/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation

//Custom object and using codable to convert from the external type in this case JSON into  our custom type 
struct Person: Codable {
    let name: String
    let birthYear: String
    let height: String
}


struct PersonSearch: Codable {
    let results: [Person]
}
