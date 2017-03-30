import Foundation

if let driver = ChromeDriver(url: "http://127.0.0.1:9515") {
  driver.setTimeout(type: "implicit", millis: 10000)
  driver.openUrl(url: "https://www.icloud.com")
  driver.setFrame(using: "id", value: "auth-frame")
  driver.setText(using: "id", value: "appleId", text: "appleId")
  driver.setText(using: "id", value: "pwd", text: "pwd")
  driver.click(using: "class name", value: "icon_sign_in")
}
