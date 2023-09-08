//
//  CodeEditorModel.swift
//  PaxOSLua
//
//  Created by Antoine Bollengier on 08.09.2023.
//

import Foundation

class CodeEditorModel: ObservableObject {
    static let shared = CodeEditorModel()
    
    let FM = FileManager.default
        
    @Published var currentFile: File?
    
    @Published var currentOperation: Operations = .nothing
    
    init() {}
    
    func loadFile(path: String) {
        setNewOperation(.loading)
        guard FM.fileExists(atPath: path) else { setNewOperation(.error("File does not exists at path (\(path))")); return }
        
        guard let fileData = FM.contents(atPath: path) else { setNewOperation(.error("Failed to load file (\(path))")); return }
        
        setNewFile(File(path: path, content: String(decoding: fileData, as: UTF8.self)))
        setNewOperation(.loaded)
    }
    
    func setNewFile(_ file: File?) {
        DispatchQueue.main.async {
            self.currentFile = file
        }
    }
    
    func setNewOperation(_ op: Operations) {
        DispatchQueue.main.async {
            self.currentOperation = op
        }
    }
    
    struct File {
        var path: String
        var content: String
    }
}
