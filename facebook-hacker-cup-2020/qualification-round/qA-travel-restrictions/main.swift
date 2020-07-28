#!/usr/bin/swift
import Foundation

public class File {
    var inFileURL : URL?
    var outFileURL : URL?

    public init?(fileName: String) {
        inFileURL = URLFromCurrentDirectory(fileName: fileName, fileExtension: "txt")
        outFileURL = URLFromCurrentDirectory(fileName: fileName, fileExtension: "txt")
    }

    public func read() -> String {
        return readFile(url: inFileURL!)
    }

    public func write(data: String) {
        if let _ = outFileURL {
            writeToFile(url: outFileURL!, data: data)
            print("Done: out file is ready to upload")
        }
    }

    func exists() -> Bool {
        return FileManager.default.fileExists(atPath: (inFileURL!.path))
    }

    func URLFromCurrentDirectory(fileName:String, fileExtension:String) ->  URL {
        let fileURL = "file://" + FileManager.default.currentDirectoryPath + "/" + fileName + ".\(fileExtension)"

        return URL(string: fileURL)!
    }

    func readFile(url: URL) -> String {
        var result = ""
        
        do {
            result = try String(contentsOf: url)
        } catch let error as NSError {
            print("Failed reading from URL: \(url), Error: " + error.localizedDescription)
        }
        
        return result
    }

    func writeToFile(url: URL, data: String) {
        do {
            try data.write(to: url, atomically: true, encoding: .utf8)
        } catch let error as NSError {
            print("Failed writing to URL: \(url), Error: " + error.localizedDescription)
        }
    }
}


func travelRestrictions(inbounds: String, outbounds: String) -> String {
    var result = [String]()
    let numberOfAirlines = inbounds.count
    
    for startIndex in 0..<numberOfAirlines {
        var currentResult = [String]()

        var lastPremission = true
        for left in stride(from: startIndex, through: 0, by: -1) {
            let inBoundPremissionIndex = inbounds.index(inbounds.startIndex, offsetBy: left)
            let inBoundPremission = inbounds[inBoundPremissionIndex...inBoundPremissionIndex]
            
            if left == startIndex {
                currentResult.insert("Y", at: 0)
                continue
            }
            
            let outBoundPremissionIndex = outbounds.index(outbounds.startIndex, offsetBy: left + 1)
            let outBoundPremission = outbounds[outBoundPremissionIndex...outBoundPremissionIndex]
            
            if outBoundPremission == "Y", inBoundPremission == "Y", lastPremission {
                currentResult.insert("Y", at: 0)
                lastPremission = true
            } else {
                currentResult.insert("N", at: 0)
                lastPremission = false
            }
        }

        lastPremission = true
        for right in (startIndex + 1)..<numberOfAirlines {
            let inBoundPremissionIndex = inbounds.index(inbounds.startIndex, offsetBy: right)
            let inBoundPremission = inbounds[inBoundPremissionIndex...inBoundPremissionIndex]
            
            if right == startIndex {
                currentResult.append("Y")
                continue
            }
            
            let outBoundPremissionIndex = outbounds.index(outbounds.startIndex, offsetBy: right - 1)
            let outBoundPremission = outbounds[outBoundPremissionIndex...outBoundPremissionIndex]
            
            if outBoundPremission == "Y", inBoundPremission == "Y", lastPremission {
                currentResult.append("Y")
                lastPremission = true
            } else {
                currentResult.append("N")
                lastPremission = false
            }
        }
        
        result.append(currentResult.joined())
    }
    
    return result.joined(separator: "\n")
}


public class Algorithm {
    
    // Here is the function where you need to white your solution.
    public class func exec(inData: String) -> String {
        var outData = ""
        
        var lines = inData.split{$0 == "\n"}.map(String.init)
        
        lines.removeFirst()

        var index = 0
        var count = 1

        while index < lines.count {
            let inBounds = lines[index + 1]
            let outBounds = lines[index + 2]
            outData += "Case #\(count): \n"
            outData += travelRestrictions(inbounds: inBounds, outbounds: outBounds)
            if index + 3 < lines.count {
                outData += "\n"
            }
                
            index += 3
            count += 1
        }
        
        return outData
    }
}


let inputText = File(fileName: "travel_restrictions_input")?.read()
let outputText = Algorithm.exec(inData: inputText ?? "")

let outfile = File(fileName: "travel_restrictions_output")
outfile?.write(data: outputText)
