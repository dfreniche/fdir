//
//  Description.swift
//  fdir
//
//  Created by Diego Freniche Brito on 13/7/21.
//

import Foundation
import Files


/// Utilities to create / read Description file
struct Description {
    
    static let fileName = ".descript.ion"
    
    static func save(content fileContent: String, name fileName: String = Description.fileName) {

        let fileURL = URL(fileURLWithPath: fileName)

        //writing
        do {
            try fileContent.write(to: fileURL, atomically: false, encoding: .utf8)
        }
        catch {
            
            print("File exists!")
        }
    }
    
    static func read(name fileName: String = Description.fileName) -> [String] {

        let fileURL = URL(fileURLWithPath: fileName)

        //reading
        do {
            let descriptionFileContent = try String(contentsOf: fileURL, encoding: .utf8)
            return descriptionFileContent.split(separator: "\n").map {
                "\($0)"
            }
        }
        catch {/* error handling here */}
    
        return []
    }
}
