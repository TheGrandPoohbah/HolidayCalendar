//
//  Holiday.swift
//  HolidayCalendar
//
//  Created by Mimi Shahzad on 8/15/20.
//  Copyright © 2020 Mimi Shahzad. All rights reserved.
//

import Foundation


/* create a data model
 
 work from the inside out accordign to the response, so you have a response which contains the dictionary holidays
 -the ditionary holiuadys returns us an array of objects we will call them holiday details
 
 START AT THE BOTTOM
 
 */


/* we are returning a response with a single dictionary defined below called Holidays  */
struct HolidayResponse: Decodable {
    var response: Holidays
}

//⬆ one more thing
/* you want the first dictionary in the response which is known as 'holidays to contain a list of holidayDertail objects (which contain a name and a date of type DateInfo)   */
struct Holidays: Decodable {
    var holidays:[HolidayDetail] //this is returning a var holidays which is an array of HolidayDetail objects which we defined below ⬇
}

/* You only have to parse the values that you want from the API response, so we only want the name and the date from the response so we only need their data-types represented in the struct  */
struct HolidayDetail: Decodable {
    var name: String
    var date: DateInfo //this is to reflect the object that we created in the struct below ⬇
}

/* this is called DaeInfo which will be the type that we call date.   */
struct DateInfo : Decodable {
    var iso: String
}

/* we are moving from the bottom up for this tutorial so just follow it this way ⬆  */
