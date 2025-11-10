import UIKit
import Flutter
import Foundation
import IOSSecuritySuite

@main
@objc class AppDelegate: FlutterAppDelegate {

  // Declare the channel as a class property
    private var channel: FlutterMethodChannel!

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    // Set up the method channel using the app's main Flutter view controller
    let controller = window?.rootViewController as! FlutterViewController
    // Set up the method channel
    channel = FlutterMethodChannel(name: "com.example.mosque_management_system/debugger", binaryMessenger: controller.binaryMessenger)

    // Set the method call handler
    channel.setMethodCallHandler { [weak self] (call, result) in
      if call.method == "isDebuggerAttached" {
        result(self?.isDebuggerAttached() ?? false)
      }else if call.method == "isDebuggerAttached1" {
            result(self?.isDebuggerAttached2() ?? false)
      } else {
        result(FlutterMethodNotImplemented)
      }
    }

    // Deny symbol hooks for critical functions
    // Deny symbol hooks for critical functions
          //IOSSecuritySuite.denySymbolHook("$s16IOSSecuritySuiteAAC13amIJailbrokenSbyFZ") // Prevent hooking of amIJailbroken
          //IOSSecuritySuite.denySymbolHook("$s10Foundation5NSLogyySS_s7CVarArg_pdtF") // Prevent hooking of NSLog
          //IOSSecuritySuite.denySymbolHook("abort") // Prevent hooking of abort

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  private func isDebuggerAttached() -> String  {

  //let amIRuntimeHooked: Bool = amIRuntimeHook(dyldWhiteList: dylds, detectionClass: SomeClass.self, selector: #selector(SomeClass.someFunction), isClassMethod: false)


    let jailbreakStatus = IOSSecuritySuite.amIJailbrokenWithFailMessage()
     if IOSSecuritySuite.amIReverseEngineered() || jailbreakStatus.jailbroken
     {
           return "true"
     }

// First Condition
          let applicationsPath = "/Applications"
                let fileManager = FileManager.default

                // Check if the directory exists
                if fileManager.fileExists(atPath: applicationsPath) {
                    do {
                        // Attempt to read the contents of the directory
                        let contents = try fileManager.contentsOfDirectory(atPath: applicationsPath)
                        return "true"
                    } catch {

                    }
                }

// Second Condition

//         let fileManager = FileManager.default
//
//         if let rootPath = NSHomeDirectory().removingPercentEncoding {
//             if fileManager.isWritableFile(atPath: rootPath) {
//                 return "true"
//             }
//         }

         // Check for common jailbreak files
             let jailbreakPaths = [
                                "/Applications/palera1n.app",
                                "/Applications/Cydia.app",
                                 "/Applications/FakeCarrier.app",
                                 "/Applications/Icy.app",
                                 "/Applications/IntelliScreen.app",
                                 "/Applications/MxTube.app",
                                 "/Applications/RockApp.app",
                                 "/Applications/SBSetttings.app",
                                 "/Applications/WinterBoard.app",
                                 "/Applications/blackra1n.app",
                                 "/Applications/Terminal.app",
                                 "/Applications/Pirni.app",
                                 "/Applications/iFile.app",
                                 "/Applications/iProtect.app",
                                 "/Applications/Backgrounder.app",
                                 "/Applications/biteSMS.app",
                                 "/Applications/limera1n.app",
                                 "/Applications/greenpois0n.app",
                                 "/Applications/blacksn0w.app",
                                 "/Applications/redsn0w.app",
                                 "/Applications/Absinthe.app",
                                   "/Applications/Cydia.app",               // Cydia
                                   "/Applications/Zebra.app", // Zebra
                                   "/Applications/Sileo.app", // Check for Sileo
                                   "/Applications/WinRa.app", // Hypothetical WinRa path, not typical
                                   "/Applications/Installer.app",           // Installer 5
                                   "/Library/MobileSubstrate/DynamicLibraries", // Common directory for tweaks
                                   "/Library/MobileSubstrate/MobileSubstrate.dylib", // Mobile Substrate
                                   "/var/mobile/Library/Caches/com.saurik.Cydia", // Cydia cache (might indicate tweaks installed)
                                  "/Applications/Cydia.app",
                                   "/Library/MobileSubstrate/MobileSubstrate.dylib",
                                   "/bin/bash",
                                   "/usr/sbin/sshd"
             ]

//             let jailbreakPaths = [
//                                "/Applications/Cydia.app",
//                                   "/Library/MobileSubstrate/MobileSubstrate.dylib",
//                                   "/bin/bash",
//                                   "/usr/sbin/sshd",
//                                   "/etc/apt"
//              ]
//
             for path in jailbreakPaths {
                 if FileManager.default.fileExists(atPath: path) {
                     return "true"
                 }
             }

               //let applicationsPath = "/Applications"
//               let applicationsPath = "/Applications"
//                     let fileManager = FileManager.default
//
//                     // Check if the directory exists
//                     if fileManager.fileExists(atPath: applicationsPath) {
//                         do {
//                             // Attempt to read the contents of the directory
//                             let contents = try fileManager.contentsOfDirectory(atPath: applicationsPath)
//                             return "true"
//                         } catch {
//
//                         }
//                     }

             // Check if we can write to the root directory
//              do {
//
//                //  try "test".write(toFile: "/private/jailbreak_test.txt", atomically: true, encoding: .utf8)
//
//
//                 // try FileManager.default.removeItem(atPath: "/private/jailbreak_test.txt")
//                  //return true
//              } catch {
//                  // Writing failed, not necessarily jailbroken
//              }

               //Check if specific jailbreak-related apps can be opened
                 let jailbreakApps = [
                     "cydia://",
                     "sileo://",
                     "zbra://",
                     "filza://",
                     "activator://",
                     "icy://",
                     "rock://",
                     "sbsettings://"
                 ]

                 for app in jailbreakApps {
                     if let url = URL(string: app), UIApplication.shared.canOpenURL(url) {
                        return "true"
                     }
                 }

             return ""
    }

    private func isDebuggerAttached2() -> Bool {
           // Check for common jailbreak files
                        let jailbreakPaths = [
                            "/Applications/Cydia.app",
                            "/Library/MobileSubstrate/MobileSubstrate.dylib",
                            "/bin/bash",
                            "/usr/sbin/sshd",
                            "/etc/apt"
                        ]

                        for path in jailbreakPaths {
                            if FileManager.default.fileExists(atPath: path) {
                                return true
                            }
                        }

                        // Check if we can write to the root directory
                        do {
                            try "test".write(toFile: "/private/jailbreak_test.txt", atomically: true, encoding: .utf8)
                            try FileManager.default.removeItem(atPath: "/private/jailbreak_test.txt")
                            return true
                        } catch {
                            // Writing failed, not necessarily jailbroken
                        }

                          // Check if specific jailbreak-related apps can be opened
                            let jailbreakApps = [
                                "cydia://",
                                "icy://",
                                "rock://",
                                "sbsettings://"
                            ]

                            for app in jailbreakApps {
                                if let url = URL(string: app), UIApplication.shared.canOpenURL(url) {
                                    return true
                                }
                            }

                        return false
        }


}
