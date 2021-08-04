//
//  fdir.swift
//  fdir
//
//  Created by Diego Freniche Brito on 13/7/21.
//

import Foundation
import ANSITerminal
import ArgumentParser
import Files

@main
struct fdir: ParsableCommand {
    // --i --init option
    @Flag(name: [.customLong("init"), .customShort("i")],
          help: "Creates a new hidden \(Description.fileName) file")
    var initDescriptionFile = false
    
    // --u --update option
    @Flag(name: [.customLong("update"), .customShort("u")],
          help: "Updates existing \(Description.fileName) file with contents of folder")
    var updateDescription = false
    
    // --a --all
    @Flag(name: [.customLong("all"), .customShort("a")],
          help: "Includes all files")
    var includeAllFiles = false
    
    @Flag(name: [.customLong("long"), .customShort("l")],
          help: "Shows long list")
    var showLongList = false
    
    @Flag(name: [.customLong("no-ansi-colors"), .customShort("n")],
          help: "Don't use ANSI colors")
    var noAnsiColors = false
    
    /// Main function, starting point
    func run() throws {
        var fileNames = try readFilesInDirectory(includeHidden: includeAllFiles)
        let folderNames = try readFoldersInDirectory()
        
        let descriptionLines = Description.read()

        func createDescriptionFile() {
            fileNames.insert(".descript.ion - This file", at: 0)
            Description.save(content: (folderNames + fileNames).joined(separator: "\n"))
            print("descript.ion file created!")
        }
        
        if initDescriptionFile {
            let descriptionFileExists = try Folder(path: ".").containsFile(named: Description.fileName)
            if descriptionFileExists {
                if TextDialog(question: "Overwrite file").showDialog() == .YES {
                    createDescriptionFile()
                }
            } else {
                createDescriptionFile()
            }
            
            return
        }
        
        showTotalsLine(folderNames: folderNames, fileNames: fileNames)
        
        printOutput(filesOrFolders: folderNames, descriptionLines: descriptionLines, ANSIColors: "<>".white.bold.onBlack)
        printOutput(filesOrFolders: fileNames, descriptionLines: descriptionLines, ANSIColors: "<>".gray.onBlack)
    }
    
    func printOutput(filesOrFolders: [String], descriptionLines: [String], ANSIColors: String = "") {
        let output = filesOrFolders.map { (fileName: String) -> String  in
            guard let index = descriptionLines.firstIndex(where: { $0.starts(with: fileName)}) else { return fileName }
            return "\(descriptionLines[index])"
        }
        
        for line in output {
            print(ANSIColors.replacingOccurrences(of: "<>", with: line))
        }
    }
    
    func readFoldersInDirectory() throws -> [String] {
        var folderNames: [String] = []
        
        try Folder(path: ".").subfolders.enumerated().forEach { (index, file) in
//            print("index: \(index)".blue.onWhite + " folder: \(file.name)")
            folderNames.append(file.name)
        }
        
        return folderNames
    }
    
    func readFilesInDirectory(includeHidden: Bool = false) throws -> [String] {
        var fileNames: [String] = []
        
        if includeHidden {
            try Folder(path: ".").files.includingHidden.enumerated().forEach { (index, file) in
                fileNames.append(file.name)
            }
        } else {
            try Folder(path: ".").files.enumerated().forEach { (index, file) in
                fileNames.append(file.name)
            }
        }
                
        return fileNames
    }
    
    // shows number of folders, files
    func showTotalsLine(folderNames: [String], fileNames: [String]) {
        print(String(repeating: " ", count: 80).green.onWhite + "\r", terminator:"")

        print("fdir - [\(folderNames.count)] folders, [\(fileNames.count)] files".green.onWhite)
    }
}



