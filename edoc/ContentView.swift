//
//  ContentView.swift
//  edoc
//
//  Created by Jeremy Eiser-Herczeg on 3/19/24.
//

import SwiftUI

import SwiftData

enum languages: String, CaseIterable {
    case py
    case c
    case cpp
    case js
    case swift
    case lua
    case ts
    case java
    case txt
    
    var displayName: String {
        switch self {
        case .py:
            return "Python"
        case .cpp:
            return "C++"
        case .js:
            return "Javascript"
        case .ts:
            return "Typescript"
        case .txt:
            return "Text"
        default:
            return self.rawValue.capitalized
        }
    }
}

struct ContentView: View {
    @State private var docLang: languages = .txt
    
    @State private var currDir: URL? = nil
    @State private var dirContents: [URL] = []
    
    @State private var currFile: URL? = nil
    @State private var currFileContents: String = ""
    
    var body: some View {
        NavigationSplitView {
            VStack() {
                HStack() {
                    Spacer()
                    Button(action: {openFolder()}) {
                        Image(systemName: "square.and.arrow.down")
                    }.buttonStyle(.borderless).keyboardShortcut("o")
                    Button(action: {saveFile()}) {
                        Image(systemName: "square.and.arrow.up")
                    }.buttonStyle(.borderless).keyboardShortcut("s")
                    Button(action: {newFile()}) {
                        Image(systemName: "doc.badge.plus")
                    }.buttonStyle(.borderless).keyboardShortcut("n")
                }
                Spacer()
                List(dirContents, id: \.self){ fileURL in
                    Button(fileURL.lastPathComponent) {
                        currFile = fileURL
                        do {
                            currFileContents = try String(contentsOf: fileURL)
                        } catch {
                            print("Error reading file: \(error.localizedDescription)")

                        }
                    }.buttonStyle(.borderless)
                }
            }
            .padding(5.0)
        } detail: {
            VStack {
                TextEditor(text: $currFileContents)
                    .monospaced()
                    .padding(5)
                HStack(alignment: .center) {
                    Spacer()
                    Label(docLang.displayName, systemImage: "doc.plaintext")
                }
                .padding(/*@START_MENU_TOKEN@*/.horizontal/*@END_MENU_TOKEN@*/)
                Spacer()
            }
        }
    }
    
    func saveFile() {
        if let currFile {
            do {
                try currFileContents.write(to: currFile, atomically: true, encoding: .utf8)
                print("File Saved Successfully!")
            } catch {
                print("Error saving file: \(error.localizedDescription)")
                
            }
        } else {
            newFile()
        }
    }
    
    func openFolder() {
        let openPanel = NSOpenPanel()
                openPanel.canChooseFiles = false
                openPanel.canChooseDirectories = true
                openPanel.allowsMultipleSelection = false
                openPanel.canCreateDirectories = true
        openPanel.begin{result in
            if result == .OK {
                currDir = openPanel.url
                do {
                    let contents = try FileManager.default.contentsOfDirectory(at: currDir!, includingPropertiesForKeys: nil, options: [])
                    dirContents = contents
                }
                catch {
                    print("Error accessing directory: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func newFile() {
        let newFile = currDir!.path() + "/file"
        print(newFile)
            if FileManager.default.createFile(atPath: newFile, contents: nil) {
                print("File created successfully!")
            } else {
                print("Error creating file")
            }
        }
}

struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewLayout(.sizeThatFits)
    }
}

struct TextArea: NSViewRepresentable {
    @Binding var text: String
        
        func makeNSView(context: Context) -> NSTextView {
            let textView = NSTextView()
            textView.isEditable = true
            textView.isAutomaticQuoteSubstitutionEnabled = false
            textView.isAutomaticDashSubstitutionEnabled = false
            textView.isAutomaticTextReplacementEnabled = false
            textView.textContainerInset = CGSize(width: 5, height: 5)
            return textView
        }
        
        func updateNSView(_ nsView: NSTextView, context: Context) {
            nsView.string = text
        }
}
