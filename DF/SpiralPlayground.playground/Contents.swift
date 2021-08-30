//: A Cocoa based Playground to present user interface

import AppKit
import PlaygroundSupport

let nibFile = NSNib.Name("MyView")
var topLevelObjects : NSArray?

Bundle.main.loadNibNamed(nibFile, owner:nil, topLevelObjects: &topLevelObjects)
let views = (topLevelObjects as! Array<Any>).filter { $0 is NSView }

func add(text: String, x: Int, y: Int) {
    let label = NSButton(title: text, target: nil, action: nil)
    label.frame.origin.x = CGFloat(x * 40 + 200)
    label.frame.origin.y = CGFloat(y * 40 + 400)
    (views[0] as! NSView).addSubview(label)
}

for location in Grid.coordinatesInSpiral(offset: .zero, radius: 5).enumerated() {
    add(text: "\(location.offset)", x: location.element.x, y: location.element.y)
}

// Present the view in Playground
PlaygroundPage.current.liveView = views[0] as! NSView
