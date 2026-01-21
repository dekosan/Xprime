// The MIT License (MIT)
//
// Copyright (c) 2025-2026 Insoft.
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

// MARK: - Model

final class FileNode {
    let url: URL
    var children: [FileNode] = []
    let isDirectory: Bool

    init(url: URL) {
        self.url = url
        self.isDirectory = url.hasDirectoryPath
    }
}

func buildTree(at url: URL) -> FileNode {
    let node = FileNode(url: url)

    guard node.isDirectory else { return node }

    let contents = (try? FileManager.default.contentsOfDirectory(
        at: url,
        includingPropertiesForKeys: [.isDirectoryKey],
        options: [.skipsHiddenFiles]
    )) ?? []

    node.children = contents
        .sorted { $0.lastPathComponent < $1.lastPathComponent }
        .map(buildTree)

    return node
}

// MARK: - View Controller

final class FileTreeViewController: NSViewController {

    private var outlineView: NSOutlineView!
    private var rootNode: FileNode!

//    override func loadView() {
//        view = NSView()
//    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupOutlineView()

        
        
        let rootURL = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
        rootNode = buildTree(at: rootURL)

        outlineView.reloadData()
        outlineView.expandItem(nil, expandChildren: true)
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        
        guard let window = view.window else { return }
        
        // Make window background transparent
        window.titleVisibility = .hidden
        window.isOpaque = false
        window.backgroundColor = NSColor(white: 0, alpha: 0.9)
        window.titlebarAppearsTransparent = true
        
        window.center()
        window.level = .floating
        window.hasShadow = true
        
       
        window.titlebarAppearsTransparent = true
        window.styleMask = [.nonactivatingPanel, .titled]
        window.styleMask.insert(.fullSizeContentView)
    }

    private func setupOutlineView() {
        outlineView = NSOutlineView()
        outlineView.dataSource = self
        outlineView.delegate = self
        outlineView.headerView = nil
        outlineView.rowSizeStyle = .small

        let column = NSTableColumn(identifier: .init("Name"))
        column.title = "Name"
        outlineView.addTableColumn(column)
        outlineView.outlineTableColumn = column

        let scrollView = NSScrollView()
        scrollView.documentView = outlineView
        scrollView.hasVerticalScroller = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(scrollView)

        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - Data Source

extension FileTreeViewController: NSOutlineViewDataSource {

    func outlineView(
        _ outlineView: NSOutlineView,
        numberOfChildrenOfItem item: Any?
    ) -> Int {
        let node = item as? FileNode ?? rootNode
        return node?.children.count ?? 0
    }

    func outlineView(
        _ outlineView: NSOutlineView,
        isItemExpandable item: Any
    ) -> Bool {
        (item as? FileNode)?.isDirectory == true
    }

    func outlineView(
        _ outlineView: NSOutlineView,
        child index: Int,
        ofItem item: Any?
    ) -> Any {
        let node = item as? FileNode ?? rootNode
        return node?.children[index] ?? 0
    }
}

// MARK: - Delegate

extension FileTreeViewController: NSOutlineViewDelegate {

    func outlineView(
        _ outlineView: NSOutlineView,
        viewFor tableColumn: NSTableColumn?,
        item: Any
    ) -> NSView? {

        let node = item as! FileNode
        let identifier = NSUserInterfaceItemIdentifier("FileCell")

        let cell = outlineView.makeView(
            withIdentifier: identifier,
            owner: self
        ) as? NSTableCellView ?? {

            let cell = NSTableCellView()
            cell.identifier = identifier

            // Icon
            let imageView = NSImageView()
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.imageScaling = .scaleProportionallyDown
            cell.imageView = imageView
            cell.addSubview(imageView)

            // Text
            let textField = NSTextField(labelWithString: "")
            textField.translatesAutoresizingMaskIntoConstraints = false
            cell.textField = textField
            cell.addSubview(textField)

            NSLayoutConstraint.activate([
                imageView.leadingAnchor.constraint(equalTo: cell.leadingAnchor, constant: 4),
                imageView.centerYAnchor.constraint(equalTo: cell.centerYAnchor),
                imageView.widthAnchor.constraint(equalToConstant: 16),
                imageView.heightAnchor.constraint(equalToConstant: 16),

                textField.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 6),
                textField.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: -4),
                textField.centerYAnchor.constraint(equalTo: cell.centerYAnchor)
            ])

            return cell
        }()

        // Configure content
        cell.textField?.stringValue = node.url.lastPathComponent
        cell.imageView?.image = NSWorkspace.shared.icon(forFile: node.url.path)

        return cell
    }
}
