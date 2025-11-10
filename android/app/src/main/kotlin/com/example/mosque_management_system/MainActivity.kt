package com.example.mosque_management_system

import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.io.File
import android.util.Log
import java.io.BufferedReader
import java.io.FileReader
import java.io.InputStreamReader



class MainActivity : FlutterFragmentActivity() {
    private val CHANNEL = "com.example.root_detection"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        Log.d("MainActivity", "✅ Flutter MethodChannel initialized: $CHANNEL")

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            Log.d("MainActivity", "✅ Method called: ${call.method}")

            when (call.method) {
                "checkRoot" -> {
                    val isRooted = isDeviceRooted()
                    Log.d("MainActivity", "✅ Root check result: $isRooted")
                    result.success(isRooted)
                }
                "checkBootloader" -> {
                    val isBootloaderUnlocked = isBootloaderUnlocked()
                    Log.d("MainActivity", "✅ Bootloader unlock check result: $isBootloaderUnlocked")
                    result.success(isBootloaderUnlocked)
                }
                "getSystemProperties" -> {
                    val securityProperties = getSecurityProperties()
                    Log.d("MainActivity", "✅ Security Properties: $securityProperties")
                    result.success(securityProperties)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    // ✅ Function to check if the device is rooted
    private fun isDeviceRooted(): Boolean {
        return detectZygiskViaShell()  || detectMagiskViaMounts() ||  isMagiskInstalled() || detectSuUsingLs()
                || isMagiskFilesPresent() || isLSPosedActive() || isZygiskEnabled()
         || isMagiskProcessRunning()
    }

    // ✅ 1️⃣ Check If Magisk, Shamiko, or LSPosed Files Exist
    private fun isMagiskFilesPresent(): Boolean {
        val magiskFiles = listOf(
            "/sbin/.magisk", "/data/adb/magisk",
            "/dev/.magisk_unblock", "/dev/magisk",
            "/sbin/.core/img", "/sbin/magisk",
            "/data/adb/modules/zygisk_lsposed"
        )

        for (file in magiskFiles) {
            if (File(file).exists()) {
                Log.e("MagiskDetection", "🚨 Magisk detected in filesystem: $file")
                return true
            }
        }

        Log.d("MagiskDetection", "✅ No Magisk detected via file check.")
        return false
    }

    // ✅ 2️⃣ Detect LSPosed or Magisk Using `/proc/self/maps`
    private fun isLSPosedActive(): Boolean {
        return try {
            val reader = BufferedReader(FileReader("/proc/self/maps"))
            val output = reader.readText().trim()

            if (output.contains("lsposed") || output.contains("zygisk")) {
                Log.e("LSPosedDetection", "🚨 LSPosed (Xposed on Zygisk) detected in memory!")
                return true
            }

            Log.d("LSPosedDetection", "✅ LSPosed NOT detected in memory.")
            false
        } catch (e: Exception) {
            Log.e("LSPosedDetection", "❌ Error checking LSPosed in memory", e)
            false
        }
    }

    // ✅ 3️⃣ Check Zygisk Using `SystemProperties.get()` (Bypasses `getprop`)

    private fun getSystemPropertytest(key: String): String {
        return try {
            val systemProperties = Class.forName("android.os.SystemProperties")
            val getMethod = systemProperties.getMethod("get", String::class.java, String::class.java)
            getMethod.invoke(null, key, "") as String
        } catch (e: Exception) {
            Log.e("SystemProperties", "❌ Error accessing system property: $key", e)
            ""
        }
    }
    private fun isZygiskEnabled(): Boolean {
        return try {
            val zygiskState = getSystemPropertytest("persist.magisk.zygisk")
            if (zygiskState == "1") {
                Log.e("ZygiskDetection", "🚨 Zygisk is ENABLED! (Magisk is running)")
                return true
            }

            Log.d("ZygiskDetection", "✅ Zygisk is NOT enabled.")
            false
        } catch (e: Exception) {
            Log.e("ZygiskDetection", "❌ Error checking Zygisk", e)
            false
        }
    }


    // ✅ Get multiple system properties at once
    private fun getSecurityProperties(): Map<String, String> {
        return mapOf(
            "OEM Unlock Supported" to getSystemProperty("ro.oem_unlock_supported"),
            "Device Security" to getSystemProperty("ro.secure"),
            "SELinux Status" to getSystemProperty("ro.boot.selinux"),
            "Knox Status" to getSystemProperty("ro.boot.warranty_bit"),
            "Root Access Enabled" to getSystemProperty("persist.sys.root_access"),
            "Dynamic Partitions" to getSystemProperty("ro.boot.dynamic_partitions"),
            "Slot Suffix" to getSystemProperty("ro.boot.slot_suffix")
        )
    }

    // ✅ Function to get system properties using getprop
    private fun getSystemProperty(property: String): String {
        return try {
            val process = Runtime.getRuntime().exec(arrayOf("getprop", property))
            val reader = BufferedReader(InputStreamReader(process.inputStream))
            val output = reader.readText().trim()
            reader.close()
            Log.d("SystemProperty", "✅ $property: $output")
            output.ifEmpty { "Unknown" }
        } catch (e: Exception) {
            Log.e("SystemProperty", "❌ Error fetching $property", e)
            "Error"
        }
    }

    // ✅ Detect Magisk mount points (bypasses MagiskHide)
    private fun detectMagiskViaMounts(): Boolean {
        val paths = arrayOf(
            "/sbin/.magisk",
            "/data/adb/magisk",
            "/data/adb/modules"
        )
        for (path in paths) {
            if (File(path).exists()) {
                Log.d("RootCheck", "✅ Magisk detected at: $path")
                return true
            }
        }
        return false
    }

    // ✅ Check if Magisk Manager App is installed (bypasses MagiskHide)
    private fun isMagiskInstalled(): Boolean {
        val magiskPackages = arrayOf(
            "com.topjohnwu.magisk",
            "com.topjohnwu.magisk.beta",
            "com.topjohnwu.magisk.canary"
        )

        for (pkg in magiskPackages) {
            try {
                applicationContext.packageManager.getPackageInfo(pkg, 0)
                Log.d("RootCheck_mah", "✅ Magisk Manager app found: $pkg")
                return true
            } catch (e: Exception) {
                continue
            }
        }
        return false
    }

    // ✅ Detect `su` using `ls -l` instead of `which su` (bypasses MagiskHide)
    private fun detectSuUsingLs(): Boolean {
        return try {
            val process = Runtime.getRuntime().exec(arrayOf("sh", "-c", "ls -l /system/bin/su"))
            val result = process.inputStream.bufferedReader().readLine()

            Log.d("processMAhrukh","process:$process")
            Log.d("resultMahrukh","result:$result")

            if (result != null && result.contains("su")) {
                Log.d("RootCheck", "✅ Root access detected using ls -l")
                return true
            }

            Log.d("RootCheck", "❌ Root not detected via ls -l")
            false
        } catch (e: Exception) {
            Log.e("RootCheck", "❌ Error executing ls -l command", e)
            false
        }
    }



    private fun detectMagiskViaMountInfo(): Boolean {
        return try {
            val process = Runtime.getRuntime().exec("cat /proc/self/mountinfo")
            val reader = BufferedReader(InputStreamReader(process.inputStream))
            val output = reader.readText().trim()

            if (output.contains("magisk") || output.contains("/debug_ramdisk/.magisk")) {
                Log.e("RootDetection", "🚨 Magisk detected in /proc/self/mountinfo!")
                return true
            }

            Log.d("RootDetection", "✅ Magisk NOT found in /proc/self/mountinfo")
            false
        } catch (e: Exception) {
            Log.e("RootDetection", "❌ Error checking /proc/self/mountinfo", e)
            false
        }
    }

    private fun isMagiskProcessRunning(): Boolean {
        return try {
            val processDir = File("/proc")
            val processList = processDir.listFiles() ?: return false

            for (file in processList) {
                if (!file.isDirectory) continue

                val cmdLineFile = File(file, "cmdline")
                if (cmdLineFile.exists()) {
                    val cmdLine = cmdLineFile.readText().trim()

                    // 🚨 Ignore self (your app should not be detected)
                    if (cmdLine.contains("com.example.mosque_management_system")) continue

                    // ✅ Check for Magisk-related processes
                    if (cmdLine.contains("magiskd") || cmdLine.contains("io.github.huskydg.magisk")) {
                        Log.e("RootCheck", "🚨 Magisk process detected: $cmdLine ✅")
                        return true
                    }
                }
            }

            Log.d("RootCheck", "✅ No Magisk process detected via `/proc`")
            false
        } catch (e: Exception) {
            Log.e("RootCheck", "❌ Error reading `/proc`", e)
            false
        }
    }




    // ✅ 1️⃣ Run shell command to detect Zygisk using `lsof | grep zygisk`

    private fun detectZygiskViaShell(): Boolean {
        Log.d("My_zygisk", "🔥 Running shell command to check Zygisk...")

        return try {
            Log.d("su_found", "✅ Trying `su` via `which su`")

            // ✅ Use shell to check if `su` exists
            val process = Runtime.getRuntime().exec(arrayOf("sh", "-c", "which su || echo not_found"))
            val reader = BufferedReader(InputStreamReader(process.inputStream))
            val output = reader.readText().trim()
            process.waitFor()

            if (output == "not_found" || output.isEmpty()) {
                Log.d("su_found", "❌ `su` binary NOT found")
                return false
            }

            Log.d("su_found", "✅ `su` binary found at: $output")

            // ✅ Now confirm `su` actually works by running a simple command
            val suTest = Runtime.getRuntime().exec(arrayOf(output, "-c", "echo rooted || echo not_rooted"))
            val suTestReader = BufferedReader(InputStreamReader(suTest.inputStream))
            val suTestOutput = suTestReader.readText().trim()
            suTest.waitFor()

            if (suTestOutput == "rooted") {
                Log.d("su_found", "✅ `su` command is working!")
                return checkZygisk(output)  // Run Zygisk check
            }

            Log.d("su_found", "❌ `su` command failed. Root access may be blocked.")
            return false
        } catch (e: Exception) {
            Log.e("RootCheck", "❌ Error executing shell command", e)
            return false
        }
    }



    // ✅ Helper function to check for Zygisk using `su`
    private fun checkZygisk(suPath: String): Boolean {
        return try {
            Log.d("RootCheck", "✅ Running Zygisk check via: $suPath")

            val zygiskProcess = Runtime.getRuntime().exec(arrayOf(suPath, "-c", "lsof | grep zygisk || echo not_found"))
            val zygiskReader = BufferedReader(InputStreamReader(zygiskProcess.inputStream))
            val zygiskOutput = zygiskReader.readText().trim()
            zygiskProcess.waitFor()

            if (zygiskOutput == "not_found" || zygiskOutput.isEmpty()) {
                Log.d("RootCheck", "❌ Zygisk NOT found via shell command")
                return false
            }

            Log.d("RootCheck", "✅ Zygisk detected via shell command: \n$zygiskOutput")
            return true
        } catch (e: Exception) {
            Log.e("RootCheck", "❌ Error executing Zygisk check", e)
            return false
        }
    }


    // ✅ 2️⃣ Run `getprop | grep zygisk` to detect Zygisk system properties
    private fun detectZygiskViaGetprop(): Boolean {
        return try {
            val process = Runtime.getRuntime().exec(arrayOf("su", "-c", "getprop ro.init.zygisk"))
            val reader = BufferedReader(InputStreamReader(process.inputStream))
            val output = reader.readText().trim()
            process.waitFor()

            Log.d("RootCheck", "✅ getprop output: $output")

            // Convert "1" to true and anything else to false
            output == "1"
        } catch (e: Exception) {
            Log.e("RootCheck", "❌ Error executing getprop command", e)
            false
        }
    }




    // ✅ Function to check if the bootloader is unlocked
    private fun isBootloaderUnlocked(): Boolean {
          return isBootloaderTampered () || isBootloaderflashlocked()
    }

        private fun isBootloaderflashlocked(): Boolean {
        return try {
            val systemPropertiesClass = Class.forName("android.os.SystemProperties")
            val getMethod = systemPropertiesClass.getMethod("get", String::class.java)

            val bootloaderState = getMethod.invoke(null, "ro.boot.flash.locked") as String
            bootloaderState == "0" // "0" means bootloader is unlocked
        } catch (e: Exception) {
            Log.e("BootloaderCheck", "Error checking bootloader", e)
            false
        }
    }

    // ✅ Check if bootloader has been modified (Magisk modifies this)
    private fun isBootloaderTampered(): Boolean {
        return try {
            val systemPropertiesClass = Class.forName("android.os.SystemProperties")
            val getMethod = systemPropertiesClass.getMethod("get", String::class.java)

            val bootState = getMethod.invoke(null, "ro.boot.verifiedbootstate") as String
            Log.d("RootCheck", "Bootloader Verified State: $bootState")

            return bootState.lowercase() != "green" // If it's not "green", it's tampered.
        } catch (e: Exception) {
            Log.e("RootCheck", "Error checking bootloader state", e)
            false
        }
    }

//    private fun isEmulator(): Boolean {
//        return try {
//            val systemPropertiesClass = Class.forName("android.os.SystemProperties")
//            val getMethod = systemPropertiesClass.getMethod("get", String::class.java)
//
//            val qemu = getMethod.invoke(null, "ro.boot.qemu") as? String
//            qemu == "1"
//        } catch (e: Exception) {
//            false
//        }
//    }



}
