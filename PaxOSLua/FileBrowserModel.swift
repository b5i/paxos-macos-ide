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
    
    let filesObserver: FilesObserverModel
    
    var path: String? {
        didSet {
            if path != nil {
                filesObserver.path = path
                loadAvailableFiles()
            }
        }
    }
    
    init() {
        self.path = nil
        self.filesObserver = FilesObserverModel(path: nil, filesDidChange: {_ in }, observe: [.attrib, .delete, .rename, .revoke, .write])
        self.filesObserver.filesDidChange = { [weak self] _ in
            self?.loadAvailableFiles()
        }
        self.path = Bundle.main.path(forResource: "test", ofType: nil)!
        self.filesObserver.path = self.path
        self.loadAvailableFiles()
    }
    
    @Published var availableFiles: [String] = []
    
    @Published var currentOperation: Operations = .nothing
    
    func loadAvailableFiles() {
        guard let path = path else { return }
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
