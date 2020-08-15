//
//  HolidayRequest.swift
//  HolidayCalendar
//
//  Created by Mimi Shahzad on 8/15/20.
//  Copyright © 2020 Mimi Shahzad. All rights reserved.
//

import Foundation


/* this is the enum from below  */
enum HolidayError:Error {
    case noDataAvailable
    case cannotProcessData
}


/* first step  is to configure what we need to access  */
struct HolidayRequest {
    
    /* frist define whta url you want to access  */
    let resourceURL : URL
    /* as well as the api key  */
    let API_KEY = "ea8ef07a2fbdf7701da4fee5cd4d94a0460fadce"
    
    /* next step is to initialize the struct with a country parameter of type string  */
    init(countryCode:String){
        
        
        /* create a dateObject to make this work for any date  */
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "yyyy"
        let currentYear = format.string(from: date)
        
        /* here we create a resourceString and build a resourceURL for our purposes  */
        let resourceString = "https://calendarific.com/api/v2/holidays?api_key=\(API_KEY)&country=\(countryCode)&year=\(currentYear)"
        
        /* now we need a URL from the resourceString so use the infamous guard let  */
        //we are making a resourceURL that takes in a URL in the form of a string.
        guard let resourceURL = URL(string: resourceString) //and if this fails give it a fatal error
            else {fatalError()}
        
        //now assign self's resourceURL to be resourceURL so you can access it in the scope of the entire holiday request struct
        self.resourceURL = resourceURL
    }
    
    /* almost done we just need a function to get holidays which is the APIRequest
     one we have the info that we need we pass it to a completion handler or a completion closure*/
    
    func getHolidays (completion: @escaping(Result<[HolidayDetail], HolidayError>) -> Void) {//void becayse there is no return type.
        
        let dataTask = URLSession.shared.dataTask(with: resourceURL) { data, _, _ in
            /* now we will receive data,  response, or a possible error represented like this:
             'data, _, _ in' and this all happens async*/
            
            /* now we will see what happens when the response comes back
             check to see if the json came back: `guard let jsonData = data`
             (line 64)
             */
            
            //if we have data we can continue otherwise call the completion handler to say it was a failure and no data came back
            guard let jsonData = data else { completion(.failure(.noDataAvailable))
                return //because we cannot continue
            }
            //if we have jSOn data create a do try and use a json decoder and access the holidays response
            
            do{
                let decoder = JSONDecoder()
                let holidayResponse = try decoder.decode(HolidayResponse.self, from: jsonData)
                
                /*now we want to create a holidayDetails object because that is what we want from the response
                 so we are accessing the holidayResponse object, the response inside of that and the `holidays` array inside of that. */
                let holidayDetails = holidayResponse.response.holidays
                /*the call the completion handler which we know is a success if we're here, and then pass along the `holidayDetails` */
                completion(.success(holidayDetails))
                
            }//if the all of the above fails then we want to catch the error:
            catch{
                //call completion handler and say that we could not process the data
                completion(.failure(.cannotProcessData))
            }
            
        }
        
        /* then call resume on the datatask  */
        dataTask.resume()
        
        /* Note:a closure escapes a function when the closure is passed as an argument to the function but is called after the function returns
         */
        
        /* we are returning an array of holiday details with this line Result<[HolidayDetails]>
         
         -we alos need to give it an error because a resuilt has a success case and a failure case
         so if successful it will give us a holidayDetail otherwise it will give an error.
         
         to define the type of error add an enum to the top of the file ⬆
         this enum:
         enum HolidayError:Error {
         case noDataAvailable
         case cannotProcessData
         }
         
         now we can change the error type from Error to HolidayError
         
         */
        
        /* now we can create a datatask (line 54)  */
        
        
    }
}
