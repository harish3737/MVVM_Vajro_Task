//
//  ArticlesModel.swift
//  Vajro_Task
//
//  Created by Sethuram Vijayakumar on 26/05/21.
//

import Foundation
struct Model : Codable {
        let articles : [Article]?
        let status : String?
}

struct Article : Codable {
    let author : String?
    let body_html : String?
    let image : Image?
    let summary_html : String?
    let title : String?
}

struct Image : Codable {
        let alt : String?
        let createdAt : String?
        let height : Int?
        let src : String?
        let width : Int?
}
