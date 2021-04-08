// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(macOS)
  import AppKit
#elseif os(iOS)
  import UIKit
#elseif os(tvOS) || os(watchOS)
  import UIKit
#endif

// Deprecated typealiases
@available(*, deprecated, renamed: "ImageAsset.Image", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias AssetImageTypeAlias = ImageAsset.Image

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Asset Catalogs

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
internal enum Asset {
  internal static let educateIconBroadcast = ImageAsset(name: "educate_icon_broadcast")
  internal static let messageVideoGoback = ImageAsset(name: "message_video_goback")
  internal static let messageVideoPlay = ImageAsset(name: "message_video_play")
  internal static let messageVideoReplay = ImageAsset(name: "message_video_replay")
  internal static let messageVideoScreen = ImageAsset(name: "message_video_screen")
  internal static let messageVideoSupend = ImageAsset(name: "message_video_supend")
  internal static let messageVideoThumb = ImageAsset(name: "message_video_thumb")
  internal static let messageVideoToplay = ImageAsset(name: "message_video_toplay")
  internal static let hengliAppIcon = ImageAsset(name: "HENGLI_APP_ICON")
  internal static let iconDispalyDisable = ImageAsset(name: "icon_dispaly_disable")
  internal static let iconDisplayNormal = ImageAsset(name: "icon_display_normal")
  internal static let iconHideNormal = ImageAsset(name: "icon_hide_normal")
  internal static let loginIconNO = ImageAsset(name: "login_icon_NO")
  internal static let loginIconYES = ImageAsset(name: "login_icon_YES")
  internal static let loginIconScan = ImageAsset(name: "login_icon_scan")
  internal static let tieba = ImageAsset(name: "tieba")
  internal static let 在 = ImageAsset(name: "在")
}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

// MARK: - Implementation Details

internal struct ImageAsset {
  internal fileprivate(set) var name: String

  #if os(macOS)
  internal typealias Image = NSImage
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  internal typealias Image = UIImage
  #endif

  internal var image: Image {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    let image = Image(named: name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    let name = NSImage.Name(self.name)
    let image = (bundle == .main) ? NSImage(named: name) : bundle.image(forResource: name)
    #elseif os(watchOS)
    let image = Image(named: name)
    #endif
    guard let result = image else {
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }
}

internal extension ImageAsset.Image {
  @available(macOS, deprecated,
    message: "This initializer is unsafe on macOS, please use the ImageAsset.image property")
  convenience init?(asset: ImageAsset) {
    #if os(iOS) || os(tvOS)
    let bundle = BundleToken.bundle
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSImage.Name(asset.name))
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
