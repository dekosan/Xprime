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

final class QuickHelpViewController: NSViewController {

    let symbol: String

    init(symbol: String) {
        self.symbol = symbol
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError() }

    override func loadView() {
        guard let txtURL = Bundle.main.url(forResource: symbol.uppercased(), withExtension: "txt", subdirectory: "Help") else {
            print("⚠️ No .txt file found.")
            return
        }

        // Create a scroll view
        let scrollView = NSScrollView()
        scrollView.hasVerticalScroller = true
        scrollView.hasHorizontalScroller = false
        scrollView.autohidesScrollers = true
        scrollView.drawsBackground = false   // Make scroll view background transparent

        // Create the text view
        let textView = NSTextView()
        textView.isEditable = false
        textView.isSelectable = false
        textView.drawsBackground = false     // Make text view background transparent

        do {
            let text = try String(contentsOf: txtURL, encoding: .utf8)
            textView.string = text
        } catch {
            #if DEBUG
            NSLog("Failed to load TXT for symbol \(symbol): \(error.localizedDescription)")
            #endif
            return
        }

        // Apply highlighting
        textView.syntaxHighlight()
        textView.highlightBold("Syntax:", caseInsensitive: false)
        textView.highlightBold("Example:", caseInsensitive: false)
        textView.highlightBold("Note:", caseInsensitive: false)

        // Embed text view in scroll view
        scrollView.documentView = textView
        scrollView.translatesAutoresizingMaskIntoConstraints = false

        let view = NSView()
        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor.clear.cgColor   // Transparent background
        view.addSubview(scrollView)

        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10),
        ])

        self.view = view
        preferredContentSize = NSSize(width: 500, height: 250)
    }
}


