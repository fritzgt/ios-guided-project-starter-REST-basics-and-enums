//
//  PersonSearchTableViewController.swift
//  FindACrew
//
//  Created by Ben Gohlke on 5/4/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit

class PersonSearchTableViewController: UITableViewController {
    
    
    //MARK: - Outlets
    @IBOutlet weak var searchBar: UISearchBar!
    
    //MARK: - Properties
    private let personController = PersonController()

    //MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return personController.people.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PersonTableViewCell.reuseIdentifier, for: indexPath) as! PersonTableViewCell

        let person = personController.people[indexPath.row]
        cell.person = person
        
        return cell
    }
}

//MARK: - UISearchBarDelegate
extension PersonSearchTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchTerm = searchBar.text else { return }
        searchBar.resignFirstResponder()//Dismiss keyboard after press return and there is a search term
        
        //Pass search term to the API call and when the completion finish reload tableview
        personController.searchForPeople(searchTerm: searchTerm) {
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}
