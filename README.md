<div align="center">

<p align="center">
  <img src="Resource/InTouch_AppIcon.png" width="160"/>
</p>

# HyRead
![Static Badge](https://img.shields.io/badge/Swift-5.0-orange?logo=swift&style=for-the-badge) ![Static Badge](https://img.shields.io/badge/License-MIT-blue?style=for-the-badge) ![Static Badge](https://img.shields.io/badge/iOS-16.0+-lightgrey?style=for-the-badge)

HyRead, access your book collection both online and offline, while marking your favorite reads anytime, anywhere.
</div>

<br />

<div align="center">

**[INTRODUCTION]() • 
[REQUIREMENTS]() •   
[TECH IMPLEMENTATION]() • 
[TECH STACK]() • 
[AUTHOR]() • 
[LICENSE]()**

</div>

<br />
## 💡 Introduction
- View user's book list online or offline
- Mark books as your favorite and view in your collection

<br />

<table>
  <tr align="center">
    <td>My Books Page</td>
     <td>My Favorites Page</td>
  </tr>
  <tr>
    <td><img src="Resource/HyRead_Home.png" width="300"/></td>
    <td><img src="Resource/HyRead_Favorite.png" width="300"/></td>
  </tr>
 </table>

<br />



## ⚙️ Requirements
- iOS 16.0+


## 📲 Tech Implementation
- Implemented the **MVVM** architecture along with **Combine** framework for reactive programming.
- Used **Core Data** for persistent storage, ensuring consistent access both online and offline.
- Utilized **CryptoKit** to encrypt the sensitive data stored in **Core Data**, ensuring enhanced security.
- Employed **Keychain** to securely store the key used for **CryptoKit** encryption.


<br />

<table>
  <tr align="center">
    <td>Encrypted Local Data</td>
  </tr>
  <tr>
    <td><img src="Resource/HyRead_encrypt.png" width="300"/></td>
  </tr>
 </table>

<br />

  
## 📐 Tech Stack
- [UIKit](https://developer.apple.com/documentation/uikit/) - Construct and manage a graphical, event-driven user interface for your iOS, iPadOS, or tvOS app.
- [Combine](https://developer.apple.com/documentation/combine) - Customize handling of asynchronous events by combining event-processing operators.
- [Core Data](https://developer.apple.com/documentation/coredata) - Persist or cache data on a single device, allowing offline access.
- [CryptoKit](https://developer.apple.com/documentation/cryptokit/) - Perform cryptographic operations securely and efficiently.
- [Keychain services](https://developer.apple.com/documentation/security/keychain_services/)) - Securely store small chunks of data on behalf of the user.
- [Kingfisher](https://github.com/onevcat/Kingfisher) - Downloading and caching images from the web.
- [SwiftLint](https://github.com/realm/SwiftLint) - A tool to enforce Swift style and conventions.

## 👨🏻‍💻 Author
 **Red Wang**
* Email: [red0wang9@gmail.com]()
* Linkedin: [Red Wang](https://www.linkedin.com/in/red-wang-19a49623a/)
* GitHub: [@r1ddx](https://github.com/r1ddx2)

## 📝 License

Copyright © 2023 [Red Wang](https://github.com/r1ddx2).<br />
This project is [MIT](https://github.com/r1ddx2/InTouch/blob/main/LICENSE) licensed.
