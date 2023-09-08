//
//  FileBrowserModel.swift
//  PaxOSLua
//
//  Created by Antoine Bollengier on 08.09.2023.
//

import Foundation

class FileBrowserModel: ObservableObject {
    static let shared = FileBrowserModel()
    
    let FM = FileManager.default
    
    init() {
        loadAvailableFiles()
    }
    
    @Published var availableFiles: [String] = []
    
    @Published var currentOperation: Operations = .nothing
    
    func loadAvailableFiles(path: String = Bundle.main.path(forResource: "test", ofType: nil)!) {
        setNewOperation(.loading)
        do {
            let files = try FM.contentsOfDirectory(atPath: path).map({ path+"/"+$0 })
            DispatchQueue.main.async {
                self.availableFiles = files
            }
            setNewOperation(.loaded)
        } catch {
            setNewOperation(.error("Failed to list files in directory (\(String(describing: Bundle.main.path(forResource: "test", ofType: nil))))"))
        }
    }
    
    func setNewOperation(_ op: Operations) {
        DispatchQueue.main.async {
            self.currentOperation = op
        }
    }
}
