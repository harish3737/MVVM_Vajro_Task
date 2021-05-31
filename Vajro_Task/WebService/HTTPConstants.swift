//
//  HTTPConstants.swift
//  Vajro_Task
//
//  Created by Sethuram Vijayakumar on 26/05/21.
//

import Foundation
enum ApiConstant : String{
    case ContentType = "Content-Type"
    case Authorization = "Authorization"
    case applicationJSON = "application/json"
    case Bearer = "Bearer"
}

enum ApiClientError : Error{
    case noInternet
    case apiConnection
    case serverError
    case none

}

extension ApiClientError : LocalizedError{
    var errorDescription : String?{
        switch self {
            case .noInternet :
                return HttpError.noInternet
            case .apiConnection :
                return HttpError.apiConnection
            case .serverError :
                return HttpError.serverError
            default:
                return HttpError.somthingWentWrong
        }
    }
}

struct HttpError{
    static let noInternet = "Please check your internet connection"
    static let apiConnection = "Check api Method, network connetion , this error from app side only"
    static let serverError = "Api server Error , Check with backend Geeks"
    static let somthingWentWrong = "SomeThing Went Wrong"
}

extension Int{
    func isResponseOK() -> Bool{
        return (200...299).contains(self)
    }
}

