//
//  Description.swift
//  fdir
//
//  Created by Diego Freniche Brito on 13/7/21.
//

import Foundation
import Files

/// Utilities to create / read the .descript.ion file
///
/// A .descript.ion file contains all files and folders in a folder with some comments added to them
/// ```
/// docs-realm : contains the tutorial in docs-realm/tutorial/rn
/// realm-tutorial-react-native
/// .descript.ion : This file
/// expo-steps.md : description of steps to make expo work, should be copied to README  in docs-realm
/// ```
public struct DescriptionFile {
    
    public struct Line {
        public let name: String
        public let comment: String
    }
    
    /// Default file name for .descript.ion files
    public static let fileName  = ".descript.ion"
    
    /// separator between filename and comment
    public static let separator: Character = ":"
    
    /// Checks if we already have a descript.ion file in current folder
    /// - Returns: true if the file is already there
    public static func alreadyExists() -> Bool {
        do {
            return try Folder(path: ".").containsFile(named: DescriptionFile.fileName)
        } catch {
            // do nothing
        }
        
        return false
    }
    
    public static func readLines() -> [Line] {
       return processLines(read())
    }
    
    public static func processLines(_ rawLines: [String]) -> [Line] {
        var descriptionLines: [Line] = []
        
        for rawLine in rawLines {
            let rawLineParts = rawLine.split(separator: separator, maxSplits: 1)
            if rawLineParts.isEmpty || rawLineParts.count == 1 {
                descriptionLines.append(Line(name: rawLine, comment: ""))
            } else {
                // we just expect element name & description
                if rawLineParts.count > 2 {
                    print("More than one separator found in line \(rawLine), please fix.")
                }

                let newLine = Line(name: String(rawLineParts[0]).trimmingCharacters(in: .whitespacesAndNewlines),
                                       comment: String(rawLineParts[1]).trimmingCharacters(in: .whitespacesAndNewlines))
                descriptionLines.append(newLine)
            }
        }
        
        return descriptionLines
    }
    
    public static func longestName(inLines lines: [Line]) -> Int {
        guard let max: DescriptionFile.Line = lines.max(by: { $1.name.count > $0.name.count}) else {
           return 0
        }
        
        return max.name.lengthOfBytes(using: .utf8)
    }
    
    public static func createNewDescriptionFile(fileNames: [String], folderNames:[String]) {
        var files = fileNames
        
        if let index = files.firstIndex(where: {$0.starts(with: DescriptionFile.fileName)}) {
            files[index] = ".descript.ion : This file"
        }
        
        DescriptionFile.save(content: (folderNames + files).joined(separator: "\n"))
        print("descript.ion file created!")
    }
    
    private static func save(content fileContent: String, name fileName: String = DescriptionFile.fileName) {

        let fileURL = URL(fileURLWithPath: fileName)

        //writing
        do {
            try fileContent.write(to: fileURL, atomically: false, encoding: .utf8)
        }
        catch {
            
            print("File exists!")
        }
    }
    
    public static func read(name fileName: String = DescriptionFile.fileName) -> [String] {

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
    
    public static func update(description: [Line], withFolders folders: [String], andFiles files: [String], file fileName: String = DescriptionFile.fileName) -> Bool {

        func replaceExistingElements(_ elements: [String]) -> [String] {
            var newElements: [String] = []

            for element in elements {
                if let index = description.firstIndex(where: { $0.name.starts(with: "\(element)")}) {
                    if description[index].comment.isEmpty {
                        newElements.append("\(element)")
                    } else {
                        newElements.append("\(element) \(separator) \(description[index].comment)")
                    }
                } else {
                    newElements.append("\(element)")
                }
            }
            
            return newElements
        }
        
        if description.isEmpty {
            return false
        }
        
        DescriptionFile.save(content: (replaceExistingElements(folders) + replaceExistingElements((files))).joined(separator: "\n"))
        print("descript.ion file updated!")
        
        return true
    }
    
    
    /// Prints a description line with format:
    /// `file or folder name - description`
    /// `description` is separated by a dash
    static func printDescriptionLine(_ line: String) {
        guard let index = line.firstIndex(where: { $0 == "-"}) else { return }
    }
}
