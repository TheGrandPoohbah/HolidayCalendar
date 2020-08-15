//
//HolidaysTableViewController.swift
//  HolidayCalendar
//
//  Created by Mimi Shahzad on 8/15/20.
//  Copyright © 2020 Mimi Shahzad. All rights reserved.
//

import UIKit

class HolidaysTableViewController: UITableViewController {
    
    @IBOutlet var searchBar: UISearchBar!
    
    
    /* coming back here after creating the request our next order of business is to create a new array
     it will be a list of holidayObjects or an array of holidayDetails
     
     now fill this array with info as soon as a search is performed (line 52)
     */
    
    var listOfHolidays = [HolidayDetail]() {
        /* listen for the didSet value  */
        didSet{
            /*whenever we get new info and pass it to this array we want ot reload the data in our tableView
             
             this needs to be done on the main thread so in the DispatchQueue:
             */
            DispatchQueue.main.async {
                self.tableView.reloadData()
                //also add the number of items found to our title bar:
//                self.navigationController?.title = "\(self.listOfHolidays.count) Holidays found "
            }
        }
    }
    
    
    
    // MARK: - viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        
        
 
        // Do any additional setup after loading the view.
    }
    
    // MARK: - tableView DataSource
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfHolidays.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let holiday = listOfHolidays[indexPath.row]
        
        cell.textLabel?.text = holiday.name
        cell.detailTextLabel?.text = holiday.date.iso
        
        return cell
        
    }
    
    
}

// MARK: - extension for the search bar
extension HolidaysTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        /* check to see if the search bar has text   */
        guard let searchBarText = searchBar.text else {return}
        /* now use the holidayRequest and initialize it with a countryCode  */
        let holidayRequest = HolidayRequest(countryCode: searchBarText)
        
        /* now we use the above object ^ to get the holidats that we are interested in
         and append the closure that it takes as a parameter, and access the `result` object that we have specified
         and switch through the results that you get back
         we have two cases,
         1.the failure case in which wew take an error object and print it
         2. the success case
         -here we get a bunch of holidays and assign them to self and our list of holidays(remember that this means our holiday object)
         
         */
        
        holidayRequest.getHolidays{[weak self] result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let holidays):
                self?.listOfHolidays = holidays
                
                
                /* from here we want to make our list a computed property (line 22)   */
                
            }
        }
    }
}

