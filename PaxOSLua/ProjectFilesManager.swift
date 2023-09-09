//
//  ProjectFilesManager.swift
//  PaxOSLua
//
//  Created by Antoine Bollengier on 09.09.2023.
//

import Foundation
import SwiftUI

class ProjectFilesManager: ObservableObject {
    static let shared = ProjectFilesManager()
    
    init() {}
    
    @Published var showPopup: (any View)?
    
    func showNewFile() {
        DispatchQueue.main.async {
            self.showPopup = CreateNewFileView()
        }
    }
    
    struct CreateNewFileView: View {
        let fileTypes: [FileType] = [
            .init(name: "Configuration file", icon: "gear", fileExtension: ".conf"),
            .init(name: "Lua file", icon: nil, fileExtension: ".lua"),
            .init(name: "Other file", icon: nil, fileExtension: "")
        ]
        var body: some View {
            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: 15)
                    .foregroundStyle(.white.opacity(0.2))
                NavigationStack {
                    VStack {
                        HStack {
                            ForEach(fileTypes, id: \.name) { fileType in
                                NavigationLink {
                                    NewFileCreationView(fileType: fileType)
                                } label: {
                                    VStack {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 15)
                                                .frame(width: 50, height: 50)
                                                .foregroundStyle(.gray)
                                            Image(systemName: fileType.icon ?? "terminal")
                                        }
                                        Text(fileType.name)
                                            .multilineTextAlignment(.center)
                                    }
                                    .padding()
                                }
                            }
                        }
                        .padding(50)
                        Spacer()
                        Button {
                            ProjectFilesManager.shared.showPopup = nil
                        } label: {
                            Text("Cancel")
                        }
                        .padding(.bottom)
                    }
                }
            }
            .frame(width: 600, height: 400)
        }
    }
    
    struct NewFileCreationView: View {
        let fileType: FileType
        @State private var fileName: String
        init(fileType: FileType) {
            self.fileType = fileType
            self.fileName = fileType.fileExtension
        }
        var body: some View {
            VStack {
                TextField("Filename", text: $fileName)
                
                Button {
                    if let path = FileBrowserModel.shared.path {
                        print(FileManager.default.createFile(atPath: path+"/"+fileName, contents: "".data(using: .utf8)))
                        ProjectFilesManager.shared.showPopup = nil
                    }
                } label: {
                    Text("Create file")
                }
            }
        }
    }
    
    struct FileType {
        let name: String
        let icon: String?
        let fileExtension: String
    }
}
