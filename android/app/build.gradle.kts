import java.io.FileInputStream
import java.util.Base64
import java.util.Properties

val keystorePropertiesFile = rootProject.file("key.properties")
val keystoreProperties = Properties()
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

val dartDefines: Map<String, String> =
    (project.findProperty("dart-defines") as String?)
        ?.split(",")
        ?.map { String(Base64.getDecoder().decode(it)) }
        ?.associate { it.substringBefore("=") to it.substringAfter("=") }
        ?: emptyMap()

plugins {
    id("com.android.application")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "app.bunpod"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        applicationId = "app.bunpod"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName

        // Firebase starts natively from these before Dart runs, so they must
        // match the Dart options or initializeApp throws duplicate-app.
        resValue("string", "google_app_id", dartDefines["FIREBASE_ANDROID_APP_ID"] ?: "")
        resValue("string", "google_api_key", dartDefines["FIREBASE_ANDROID_API_KEY"] ?: "")
        resValue("string", "gcm_defaultSenderId", dartDefines["FIREBASE_MESSAGING_SENDER_ID"] ?: "")
        resValue("string", "project_id", dartDefines["FIREBASE_PROJECT_ID"] ?: "")
        resValue("string", "google_storage_bucket", dartDefines["FIREBASE_STORAGE_BUCKET"] ?: "")
    }

    buildFeatures {
        resValues = true
    }

    signingConfigs {
        create("release") {
            keyAlias = keystoreProperties["keyAlias"] as String?
            keyPassword = keystoreProperties["keyPassword"] as String?
            storeFile = keystoreProperties["storeFile"]?.let { file(it as String) }
            storePassword = keystoreProperties["storePassword"] as String?
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}
