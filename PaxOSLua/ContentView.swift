//
//  ContentView.swift
//  PaxOSLua
//
//  Created by Antoine Bollengier on 05.09.2023.
//

import SwiftUI

struct ContentView: View {
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
    }
}

#Preview {
    ContentView()
}
