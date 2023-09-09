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
    
    let fileObserver: FilesObserverModel
        
    @Published var currentFile: File?
    
    @Published var currentOperation: Operations = .nothing
    
    init() {
        self.fileObserver = FilesObserverModel(path: nil, filesDidChange: {_ in})
        self.fileObserver.filesDidChange = { [weak self] event in
            print(event?.rawValue)
            if event?.rawValue == 17 || event?.rawValue == 32 {
                usleep(300000)
            }
            self?.reloadFile()
        }
    }
    
    func loadFile(path: String) {
        setNewOperation(.loading)
        guard FM.fileExists(atPath: path) else { setNewOperation(.error("File does not exists at path (\(path))")); return }
        
        guard let fileData = FM.contents(atPath: path) else { setNewOperation(.error("Failed to load file (\(path))")); return }
        
        setNewFile(File(path: path, content: String(decoding: fileData, as: UTF8.self)))
        setNewOperation(.loaded)
    }
    
    func reloadFile() {
        guard let file = currentFile, FM.fileExists(atPath: file.path) else { setNewFile(nil); return }
        
        setNewOperation(.loading)
        
        guard let fileData = FM.contents(atPath: file.path) else { setNewOperation(.error("Failed to reload file (\(file.path))")); return }
        
        DispatchQueue.main.async {
            self.currentFile?.content = String(decoding: fileData, as: UTF8.self)
        }
        setNewOperation(.loaded)
    }
    
    func setNewFile(_ file: File?) {
        self.fileObserver.path = file?.path
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
