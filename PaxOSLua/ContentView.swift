//
//  ContentView.swift
//  PaxOSLua
//
//  Created by Antoine Bollengier on 05.09.2023.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject private var PFM = ProjectFilesManager.shared
    var body: some View {
        NavigationSplitView{
            FileBrowserView()
        } content: {
            CodeEditorView()
        } detail: {
            LuaEmulatorView()
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction, content: {
                Image(systemName: "play.fill")
            })
        }
        .disabled(PFM.showPopup != nil)
        .blur(radius: (PFM.showPopup != nil) ? 5 : 0)
        .opacity((PFM.showPopup != nil) ? 0.4 : 1)
        .overlay(alignment: .center, content: {
            if let popupView = PFM.showPopup {
                AnyView(popupView)
            }
        })
    }
}

#Preview {
    ContentView()
}
