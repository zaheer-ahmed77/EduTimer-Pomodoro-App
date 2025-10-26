import org.gradle.api.JavaVersion
plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.studytimer_app"
    compileSdk = 34
    ndkVersion = flutter.ndkVersion

    // WOH PURANA JAVA 11 WALA BLOCK HUMNE HATA DIYA HAI

    kotlinOptions {
        // ISE BHI 1_8 PAR UPDATE KAR DIYA HAI
        jvmTarget = JavaVersion.VERSION_1_8.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.example.studytimer_app"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = 34
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    // YEH WALA BLOCK BILKUL THEEK HAI
    compileOptions {
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_1_8
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

// NAYA: YEH BLOCK ADD KIYA GAYA HAI (Aapke code mein missing tha)
dependencies {
    // Yeh line pehle se mojood honi chahiye (agar nahi to add karein)
    implementation("androidx.core:core-ktx:1.10.1")
    
    // YEH LINE ERROR FIX KARNE KE LIYE ZAROORI HAI
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.4")
}