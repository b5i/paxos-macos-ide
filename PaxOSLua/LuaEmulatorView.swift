//
//  LuaEmulatorView.swift
//  PaxOSLua
//
//  Created by Antoine Bollengier on 05.09.2023.
//

import SwiftUI

struct LuaEmulatorView: View {
    private var machine = VirtualMachine(openLibs: true)
    var body: some View {
        Button {
            let path = Bundle.main.path(forResource: "main", ofType: "lua", inDirectory: "test")!
            let error = machine.loadFile(path: path)
            if let error = error {
                print(error)
            }
        } label: {
            Text("Launch script")
        }
    }
}

#Preview {
    LuaEmulatorView()
}
