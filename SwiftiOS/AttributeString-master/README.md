# AttributeString

copy from http://alisoftware.github.io/swift/2018/12/15/swift5-stringinterpolation-part1/

# use

```
let string: AttributeString = """
        Hello \("AliGator", .color(.red)), isn't this \("cool", .color(.blue), .underline( .single,.purple))?
        
        \(wrap: """
        \(" Merry Xmas! ", .font(.systemFont(ofSize: 36)), .color(.red), .bgColor(.yellow))
        \(image: UIImage(named:"lofter")!, scale: 0.2)
        """)

        Go there to \("learn more about String Interpolation", .link(URL(string: "https://github.com/apple/swift-evolution/blob/master/proposals/0228-fix-expressiblebystringinterpolation.md")!), .underline( .single,.blue))!
        """
label.attributedText = string.attributedString
label.sizeToFit()
```
