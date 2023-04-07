![coddybuddy@90x](https://user-images.githubusercontent.com/83302656/230607563-a3efb0a8-406e-4de6-91ae-712ae5216df8.png)
# CoddyBuddy
“CoddyBuddy” is an online community-driven question and answer website that is focused primarily on programming-related topics. It allows users to ask questions and receive answers from other community members.

In addition to its question-and-answer format, CoddyBuddy is also known for its reputation system, which rewards users for providing helpful answers and participating in the community.
# Installing packages to workspace

## Using Swift Package Manager

### 1. Installing Firebase SDK
1.  In Xcode, install the Firebase libraries by navigating to **File > Add Packages**
2.  In the prompt that appears, select the Firebase GitHub repository:
```
https://github.com/firebase/firebase-ios-sdk.git
```
3. Checkmarks the following Firebase libraries :
```
FirebaseFirestoreSwift
FirebaseAuth
FirebaseFirestore
FirebaseStorage
```

### 2. Adding Lottie Animation
1.  In Xcode, install the Lottie libraries by navigating to **File > Add Packages**
2.  In the prompt that appears, select the Lottie GitHub repository:
```
https://github.com/airbnb/lottie-ios.git
```

### 3. OpenAI
1.  In Xcode, install the OpenAI libraries by navigating to **File > Add Packages**
2.  In the prompt that appears, select the OpenAI GitHub repository:
```
https://github.com/adamrushy/OpenAISwift
```

---

## Using CocoaPods

### 1. Installing Firebase SDK, Lottie Animation & OpenAI
1. Create a `Podfile` if you don't already have one. From the root of your project directory, run the following command :
```
pod init
```
2.  To your `Podfile`, add the following Firebase pods in your app.
```
# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'CoddyBuddy' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for CoddyBuddy
  pod 'FirebaseCore'
  pod 'FirebaseFirestoreSwift'
  pod 'FirebaseAuth'
  pod 'FirebaseFirestore'
  pod 'FirebaseStorage'
  pod 'lottie-ios'
  pod 'OpenAIKit'
end

```
3. Install the pods, then open your `.xcworkspace` file to see the project in Xcode :
```
pod install --repo-update
```


## License
Licensed under the [GNU General Public License v3.0](LICENSE)

