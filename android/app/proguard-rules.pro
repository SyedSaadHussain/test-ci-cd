# Flutter
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }

# Keep your application class
-keep class com.example.mosque_management_system.MyApplication { *; }

# Prevent stripping annotations
-keepattributes *Annotation*