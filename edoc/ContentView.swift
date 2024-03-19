//
//  ContentView.swift
//  edoc
//
//  Created by Jeremy Eiser-Herczeg on 3/19/24.
//

import SwiftUI

import SwiftData

struct ContentView: View {
    @State private var files: [URL] = []
    @State private var fileContents: String = ""
    
    var body: some View {
        NavigationSplitView {
            VStack {
                Button("Open Folder") {
                    openFolder()
                }
                List(files, id: \.self) { fileURL in
                    Button(action: {
                        print("wowza")
                    }) {
                        Text(fileURL.lastPathComponent)
                    }
                }
            }

        } detail: {
            TextEditor(text: $fileContents)
                .monospaced()
                .frame(minWidth: 200, minHeight: 1)
                .padding(5)
        }
        
    }
    
    func openFolder() {
        let openPanel = NSOpenPanel()
                openPanel.canChooseFiles = false
                openPanel.canChooseDirectories = true
                openPanel.allowsMultipleSelection = false
                openPanel.begin { response in
                    if response == .OK {
                        if let folderURL = openPanel.url {
                            do {
                                let contents = try FileManager.default.contentsOfDirectory(at: folderURL, includingPropertiesForKeys: nil, options: [])
                                files = contents
                            } catch {
                                print("Error while accessing directory: \(error.localizedDescription)")
                            }
                        }
                    }
                }

    }
}

struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
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
