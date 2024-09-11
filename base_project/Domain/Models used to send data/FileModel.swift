//
//  FileModel.swift
//  base_project
//
//  Created by Pranav Singh on 29/08/22.
//

import Foundation

//MARK: - FileModel
struct FileModel: Codable{
    let file: Data
    let fileKeyName: String
    let fileName: String
    // mime type is file type(image, video etc.)
    let mimeType: String
}
