import Foundation

class Command {

  let request: URLRequest

  init(request: URLRequest) {
    self.request = request
  }

  func execute() -> [String: Any]? {
    var result: [String: Any]? = nil
    let semaphore = DispatchSemaphore.init(value: 0)

    print(">>> \(self.request.url!.absoluteURL)")
    print(String(data: self.request.httpBody!, encoding: .utf8)!)

    let task = URLSession.shared.dataTask(with: self.request) { (data, response, error) in
      defer {
        semaphore.signal()
      }

      guard let data = data, let response = response, error == nil else {
        print("<<< \(error)")
        return
      }

      if let httpResponse = response as? HTTPURLResponse {
        print("<<< \(httpResponse.statusCode)")
      } else {
        print("<<< \(response.debugDescription)")
      }

      guard let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any],
            let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted),
            let string = String(data: jsonData, encoding: .utf8) else {
        return
      }
      print(string)
      result = json
    }

    task.resume()
    semaphore.wait(timeout: DispatchTime.distantFuture)
    return result
  }

}

extension Command {

  convenience init?(url: URL, request: Any) {
    do {
      let data = try JSONSerialization.data(withJSONObject: request, options: .prettyPrinted)

      var request = URLRequest(url: url)
      request.allHTTPHeaderFields?["Content-Type"] = "application/json"
      request.httpBody = data
      request.httpMethod = "POST"

      self.init(request: request)
    } catch {
      return nil
    }
  }

}
