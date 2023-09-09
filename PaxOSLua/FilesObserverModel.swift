//
//  FilesObserverModel.swift
//  PaxOSLua
//
//  Created by Antoine Bollengier on 09.09.2023.
//

import Foundation


//https://medium.com/over-engineering/monitoring-a-folder-for-changes-in-ios-dc3f8614f902
class FilesObserverModel {
    // MARK: Properties
    
    /// A file descriptor for the monitored directory.
    private var monitoredFolderFileDescriptor: CInt = -1
    /// A dispatch queue used for sending file changes in the directory.
    private let folderMonitorQueue = DispatchQueue(label: "FolderMonitorQueue", attributes: .concurrent)
    /// A dispatch source to monitor a file descriptor created from the directory.
    private var folderMonitorSource: DispatchSourceFileSystemObject?
    /// URL for the directory being monitored.
    var path: String? {
        didSet {
            stopMonitoring()
            startMonitoring()
        }
    }
    
    var filesDidChange: (DispatchSource.FileSystemEvent?) -> ()
    
    var toObserve: DispatchSource.FileSystemEvent = .all
    
    // MARK: Initializers
    init(path: String?, filesDidChange: @escaping (DispatchSource.FileSystemEvent?) -> (), observe: DispatchSource.FileSystemEvent = .all) {
        self.path = path
        self.filesDidChange = filesDidChange
        self.toObserve = observe
    }
    // MARK: Monitoring
    /// Listen for changes to the directory (if we are not already).
    func startMonitoring() {
        guard folderMonitorSource == nil && monitoredFolderFileDescriptor == -1, let path = path, FileManager.default.fileExists(atPath: path) else {
            return
        }
        // Open the directory referenced by URL for monitoring only.
        monitoredFolderFileDescriptor = open(path, O_EVTONLY)
        // Define a dispatch source monitoring the directory for additions, deletions, and renamings.
        folderMonitorSource = DispatchSource.makeFileSystemObjectSource(fileDescriptor: monitoredFolderFileDescriptor, eventMask: toObserve, queue: folderMonitorQueue)
        // Define the block to call when a file change is detected.
        folderMonitorSource?.setEventHandler { [weak self] in
            self?.filesDidChange(self?.folderMonitorSource?.data)
        }
        // Define a cancel handler to ensure the directory is closed when the source is cancelled.
        folderMonitorSource?.setCancelHandler { [weak self] in
            guard let strongSelf = self else { return }
            close(strongSelf.monitoredFolderFileDescriptor)
            strongSelf.monitoredFolderFileDescriptor = -1
            strongSelf.folderMonitorSource = nil
        }
        // Start monitoring the directory via the source.
        folderMonitorSource?.resume()
    }
    /// Stop listening for changes to the directory, if the source has been created.
    func stopMonitoring() {
        folderMonitorSource?.cancel()
    }
    
    deinit {
        stopMonitoring()
    }
}
