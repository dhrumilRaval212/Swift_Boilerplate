//
//  AppMessages.swift
//  iOS_Basic_Structure
//
//  Created by Dhrumil Raval on 15/01/24.
//

import Foundation

//MARK: AppMessages
struct AppMessages {
    static let internetConnectionMsg      = "Please, check your internet connection"
    static let ok                         = "Ok"
    
    //MARK:- Api Strings
    static let status = "status"
    static let statusCode = "statusCode"
    static let message = "message"
    static let title = "title"
    static var wentWrong: String { "Something went wrong, please try again." }
    static var unableToParse: String { "Sorry unable to parse the response, please try again." }
    static let error = "error"
    static let unAuthorized = "User unAuthorized. Please login again!"
}


