import Foundation

class ChromeDriver {

  let session: Session

  init(session: Session) {
    self.session = session
  }

  convenience init?(baseUrl: URL) {
    guard let session = Session(baseUrl: baseUrl) else {
      return nil
    }
    self.init(session: session)
  }

  convenience init?(url: String) {
    guard let baseUrl = URL(string: url) else {
      return nil
    }
    self.init(baseUrl: baseUrl)
  }

  func sendCommand(url: URL, request: Any) -> [String: Any]? {
    guard let command = Command(url: url, request: request) else {
      return nil
    }
    return command.execute()
  }

  func sendCommand(path: String, request: Any) -> [String: Any]? {
    guard let url = URL(string: path, relativeTo: session.baseUrl) else {
      return nil
    }
    return sendCommand(url: url, request: request)
  }

  func setTimeout(type: String, millis: Int) {
    let request: [String: Any] = ["type": type, "ms": millis]
    let _ = sendCommand(path: "session/\(session.sessionId)/timeouts", request: request)
  }

  func openUrl(url: String) {
    guard let url = URL(string: url) else {
      return
    }
    let request = ["url": url.absoluteString]
    let _ = sendCommand(path: "session/\(session.sessionId)/url", request: request)
  }

  func findElement(using: String, value: String) -> String? {
    let request = ["using": using, "value": value]
    guard let response = sendCommand(path: "session/\(session.sessionId)/element", request: request),
          let value = response["value"] as? [String: Any],
          let element = value["ELEMENT"] as? String else {
      return nil
    }
    return element
  }

  func setFrame(using: String, value: String) {
    if let element = findElement(using: using, value: value) {
      let request = ["id": [
        "ELEMENT": element
      ]]
      let _ = sendCommand(path: "session/\(session.sessionId)/frame", request: request)
    }
  }

  func setText(using: String, value: String, text: String) {
    if let element = findElement(using: using, value: value) {
      let request = [
        "id": element,
        "value": [text]
      ] as [String: Any]
      let _ = sendCommand(path: "session/\(session.sessionId)/element/\(element)/value", request: request)
    }
  }

  func click(using: String, value: String) {
    if let element = findElement(using: using, value: value) {
      let request = ["id": element]
      let _ = sendCommand(path: "session/\(session.sessionId)/element/\(element)/click", request: request)
    }
  }

}
