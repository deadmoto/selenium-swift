import Foundation

class Session {

  let baseUrl: URL
  let sessionId: String

  init(baseUrl: URL, sessionId: String) {
    self.baseUrl = baseUrl
    self.sessionId = sessionId
  }

  convenience init?(baseUrl: URL) {
    let chromeCapabilities = ["desiredCapabilities": ["browserName": "chrome"]]
    guard let url = URL(string: "session", relativeTo: baseUrl),
          let command = Command(url: url, request: chromeCapabilities),
          let response = command.execute(),
          let sessionId = response["sessionId"] as? String else {
      return nil
    }
    self.init(baseUrl: baseUrl, sessionId: sessionId)
  }

}
