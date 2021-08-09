//
//  fdir.swift
//  fdir
//
//  Created by Diego Freniche Brito on 13/7/21.
//

import Foundation
import ANSITerminal
import ArgumentParser
import DescriptionFile

@main
struct fdir: ParsableCommand {
    // --i --init option
    @Flag(name: [.customLong("init"), .customShort("i")],
          help: "Creates a new hidden \(DescriptionFile.fileName) file")
    var initDescriptionFile = false
    
    // --u --update option
    @Flag(name: [.customLong("update"), .customShort("u")],
          help: "Updates existing \(DescriptionFile.fileName) file with contents of folder")
    var updateDescription = false
    
    // --a --all
    @Flag(name: [.customLong("all"), .customShort("a")],
          help: "Includes all files")
    var includeAllFiles = false
    
//    @Flag(name: [.customLong("long"), .customShort("l")],
//          help: "Shows long list")
//    var showLongList = false
    
//    @Flag(name: [.customLong("no-ansi-colors"), .customShort("n")],
//          help: "Don't use ANSI colors")
//    var noAnsiColors = false
    
    /// Main function, starting point. Parsable command already adds a static main func that prints help
    func run() throws {
        // read current files & folders from directory. Some of these can or can't be in description file
        let fileNames = try readFilesInDirectory(includeHidden: includeAllFiles || initDescriptionFile || updateDescription)
        let folderNames = try readFoldersInDirectory()
        
        // read the description file
        let descriptionLines = DescriptionFile.readLines()
        
        // what's the longest name in file & folders? (for tabulation purposes)
        let longestNameLength = max(calculateLongestName(fileNames + folderNames), DescriptionFile.longestName(inLines: descriptionLines))
        
        // we want to create a new description file
        if initDescriptionFile {
            if DescriptionFile.alreadyExists() {
                if TextDialog(question: "Overwrite file").readAnswer() == .YES {
                    DescriptionFile.createNewDescriptionFile(fileNames: fileNames, folderNames: folderNames)
                }
            } else {
                DescriptionFile.createNewDescriptionFile(fileNames: fileNames, folderNames: folderNames)
            }
            
            return
        }
        
        // we want to update an existing description file
        if updateDescription {
            if !DescriptionFile.update(description: descriptionLines, withFolders: folderNames, andFiles: fileNames) {
                print("No \(DescriptionFile.fileName) file found. Probably you'll need to init first with fdir -i")
            }
            return
        }
        
        showTotalsLine(folderNames: folderNames, fileNames: fileNames)
        
        printOutput(filesOrFolders: folderNames, descriptionLines: descriptionLines, ANSIColors: "<>".white.bold.onBlack, tab: longestNameLength)
        printOutput(filesOrFolders: fileNames, descriptionLines: descriptionLines, ANSIColors: "<>".gray.onBlack, tab: longestNameLength)
    }
    
    func printOutput(filesOrFolders: [String], descriptionLines: [DescriptionFile.Line], ANSIColors: String = "", tab: Int = 0) {
        let output = filesOrFolders.map { (fileName: String) -> String  in
            guard let index = descriptionLines.firstIndex(where: { $0.name.starts(with: fileName)}) else { return fileName }
            
            let line = descriptionLines[index]
            if line.comment.isEmpty {
                return "\(line.name)"
            } else {
                return "\(line.name) \(String(repeating: " ", count: tab - line.name.lengthOfBytes(using: .utf8) )) \(DescriptionFile.separator) \(line.comment)"
            }
        }
        
        for line in output {
            print(ANSIColors.replacingOccurrences(of: "<>", with: line))
        }
    }
    
    // shows number of folders, files
    func showTotalsLine(folderNames: [String], fileNames: [String]) {
        print(String(repeating: " ", count: 80).green.onWhite + "\r", terminator:"")

        print("fdir - [\(folderNames.count)] folders, [\(fileNames.count)] files".green.onWhite)
    }
    
    func calculateLongestName(_ elements: [String]) -> Int {
        guard let longest = elements.max(by: { $1.count > $0.count}) else {
           return 0
        }
        
        return longest.lengthOfBytes(using: .utf8)
    }
}



