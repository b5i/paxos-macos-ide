//
//  FileBrowserView.swift
//  PaxOSLua
//
//  Created by Antoine Bollengier on 08.09.2023.
//

import SwiftUI

struct FileBrowserView: View {
    @ObservedObject private var FBM = FileBrowserModel.shared
    @ObservedObject private var CEM = CodeEditorModel.shared
    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading) {
                    
                    ForEach(FBM.availableFiles, id: \.self) { file in
                        if let filename = file.components(separatedBy: "/").last {
                            ZStack {
                                RoundedRectangle(cornerRadius: 3)
                                    .foregroundStyle(CEM.currentFile?.path == file ? .gray.opacity(0.5) : .clear)
                                    .padding(.horizontal)
                                Text(filename)
                                    .padding(5)
                                    .onTapGesture {
                                        CEM.loadFile(path: file)
                                    }
                            }
                        } else {
                            Color.clear.frame(width: 0, height: 0)
                        }
                    }
                    .onAppear {
                        print(FBM.availableFiles)
                    }
                }
            }
            Button {
                ProjectFilesManager.shared.showNewFile()
            } label: {
                ZStack {
                    Rectangle()
                        .opacity(0)
                    Image(systemName: "plus")
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(.green)
                        .frame(width: 10, height: 10)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: 25)
        }
    }
}

#Preview {
    FileBrowserView()
}
