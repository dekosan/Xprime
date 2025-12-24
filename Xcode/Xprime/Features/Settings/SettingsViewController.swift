// The MIT License (MIT)
//
// Copyright (c) 2025 Insoft.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the Software), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED AS IS, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import Cocoa


final class SettingsViewController: NSViewController, NSTextFieldDelegate {
    
    
    @IBOutlet weak var librarySearchPath: NSTextField!
    @IBOutlet weak var headerSearchPath: NSTextField!
    @IBOutlet weak var macOS: NSButton!
    @IBOutlet weak var Wine: NSButton!
    @IBOutlet weak var compressionSwitch: NSSwitch!
    @IBOutlet weak var calculator: NSImageView!
    @IBOutlet weak var archiveProjectAppOnly: NSSwitch!
    
    @IBOutlet weak var calculatorComboButton: NSComboButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        librarySearchPath.delegate = self
        headerSearchPath.delegate = self
        
        librarySearchPath.stringValue = AppSettings.librarySearchPath
        headerSearchPath.stringValue = AppSettings.headerSearchPath
        
        if !FileManager.default.fileExists(atPath: "/Applications/Wine.app/Contents/MacOS/wine") {
            macOS.isEnabled = false
            Wine.isEnabled = false
            AppSettings.HPPrime = "macOS"
        } else {
            if AppSettings.HPPrime == "macOS" {
                macOS.state = .on
                Wine.state = .off
            } else {
                macOS.state = .off
                Wine.state = .on
            }
        }
        
        compressionSwitch.state = AppSettings.compression ? .on : .off
        archiveProjectAppOnly.state = AppSettings.archiveProjectAppOnly ? .on : .off
        
        if HPServices.hpPrimeCalculatorExists(named: AppSettings.calculatorName) {
            calculator.image = NSImage(named: "ConnectivityKit")
        } else {
            calculator.image = NSImage(named: "VirtualCalculator")
        }
        
        let menu = NSMenu()
        menu.addItem(withTitle: "Virtual Calculator", action: #selector(optionSelected(_:)), keyEquivalent: "")
        menu.addItem(withTitle: "HP Connectivity Kit", action: #selector(optionSelected(_:)), keyEquivalent: "")
        menu.addItem(.separator())
       
        
        let connectivityKitURL = FileManager.default.homeDirectoryForCurrentUser
            .appendingPathComponent("Documents/HP Connectivity Kit/Calculators")
        
        let contents = try? FileManager.default.contentsOfDirectory(
            at: connectivityKitURL,
            includingPropertiesForKeys: [.isDirectoryKey],
            options: [.skipsHiddenFiles]
        )

        contents?
            .filter { (try? $0.resourceValues(forKeys: [.isDirectoryKey]).isDirectory) == true }
            .forEach { url in
                if url.lastPathComponent != "Prime" && url.lastPathComponent != "HP Prime" {
                    menu.addItem(
                        withTitle: url.lastPathComponent,
                        action: #selector(optionSelected(_:)),
                        keyEquivalent: ""
                    )
                }
            }

        calculatorComboButton.menu = menu
        if let defaultItem = menu.items.first {
            calculatorComboButton.title = defaultItem.title
        }
        
        switch AppSettings.calculatorName {
        case "Prime":
            calculatorComboButton.title = "Virtual Calculator"
            break;
            
        case "HP Prime":
            calculatorComboButton.title = "HP Connectivity Kit"
            break;
            
        default:
            calculatorComboButton.title = AppSettings.calculatorName
        }
        
    }
  
    func controlTextDidChange(_ obj: Notification) {
        guard let textField = obj.object as? NSTextField else { return }

        switch textField.tag {
        case 1:
            AppSettings.headerSearchPath = textField.stringValue
            break;
        case 2:
            AppSettings.librarySearchPath = textField.stringValue
            break;
        default:
            break
        }
    }
    
    @IBAction func calculatorComboButtonTapped(_ sender: NSComboButton) {
        // Handle selection or present menu items here
    }
    
    @objc func optionSelected(_ sender: NSMenuItem) {
        calculatorComboButton.title = sender.title
        if sender.title == "Virtual Calculator" {
            calculator.image = NSImage(named: "VirtualCalculator")
            AppSettings.calculatorName = "Prime"
        } else {
            if sender.title == "Connectivity Kit" {
                AppSettings.calculatorName = "HP Prime"
            } else {
                AppSettings.calculatorName = sender.title
            }
            calculator.image = NSImage(named: "ConnectivityKit")
        }
    }

    
    @IBAction func platform(_ sender: NSButton) {
        if sender.title == "macOS" {
            AppSettings.HPPrime = sender.state == .on ? "macOS" : "Wine"
        } else {
            AppSettings.HPPrime = sender.state == .on ? "Wine" : "macOS"
        }
    }
    
    @IBAction func compressionSwitchToggled(_ sender: NSSwitch) {
        AppSettings.compression = sender.state == .on
    }
    
    @IBAction func archiveProjectAppOnlySwitchToggled(_ sender: NSSwitch) {
        AppSettings.archiveProjectAppOnly = sender.state == .on
    }
    
    @IBAction func defaultSettings(_ sender: Any) {
        headerSearchPath.stringValue = "$(SDK)/include"
        librarySearchPath.stringValue = "$(SDK)/lib"
        macOS.state = .on
        Wine.state = .off
        compressionSwitch.state = .off
        calculatorComboButton.title = "Virtual Calculator"
        calculator.image = NSImage(named: "VirtualCalculator")
        
        AppSettings.headerSearchPath = "$(SDK)/include"
        AppSettings.librarySearchPath = "$(SDK)/lib"
        AppSettings.HPPrime = "macOS"
        AppSettings.compression = false
        AppSettings.calculatorName = "Virtual Calculator"
        AppSettings.archiveProjectAppOnly = true
    }
    
 
    @IBAction func close(_ sender: Any) {
        self.view.window?.close()
    }
}

