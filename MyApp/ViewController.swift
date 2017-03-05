//
//  ViewController.swift
//  MyApp
//
//  Created by Stanislav Sidelnikov on 3/5/17.
//  Copyright © 2017 Stanislav Sidelnikov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var resultTextView: UITextView!
    
    var settings: Settings!

    override func viewDidLoad() {
        super.viewDidLoad()
        settings = Settings()
    }

    @IBAction func askServer(_ sender: UIButton) {
        let endponit = "company/blog/introducing-yandex-s-machine-intelligence-and-research-division/"
        let url = URL(string: settings.apiBaseUrl + "/" + endponit)!
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { (data, response, error) in
            let text: String?
            if let error = error {
                text = error.localizedDescription
            } else if let response = response as? HTTPURLResponse {
                if 200..<300 ~= response.statusCode {
                    if let data = data, let string = String(data: data, encoding: .utf8) {
                        text = string
                    } else {
                        text = "Got response with code \(response.statusCode) but no data inside."
                    }
                } else {
                    text = "Server responded with code \(response.statusCode)."
                }
            } else {
                text = "Got no response :("
            }
            DispatchQueue.main.async { [weak self] in
                self?.resultTextView.text = text
                self?.dataTask = nil
            }
        }
        dataTask?.cancel()
        resultTextView.text = "Loading..."
        dataTask = task
        dataTask?.resume()
    }

    private var dataTask: URLSessionDataTask?
}

