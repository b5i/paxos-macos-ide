//
//  SimulatorModel.swift
//  PaxOSLua
//
//  Created by Antoine Bollengier on 08.09.2023.
//

import Foundation

class SimulatorModel: ObservableObject {
    let vm: VirtualMachine
    
    init(machine: VirtualMachine) {
        self.vm = machine
    }
    
    enum GUI_TYPES {
        case  BASIC_TYPE,
              BOX_TYPE,
              BUTTON_TYPE,
              IMAGE_TYPE,
              KEYBOARD_TYPE,
              LABEL_TYPE,
              WINDOW_TYPE,
              SWITCH_TYPE,
              LIST_TYPE,
              WINDOW_BAR_TYPE
    }
    
    func setupPaxOSMethods() {
        vm.globals["print"] = vm.createFunction([String.arg]) { args in
            print(args.values)
            return .nothing
        }
        
//        vm.globals["Gui"] = vm.createFunction([Int.arg, Int.arg, Int.arg, Int.arg, Int.arg], <#T##fn: SwiftFunction##SwiftFunction##(Arguments) -> SwiftReturnValue#>)
    }
}
