//
//  Helpers.swift
//  iTunes Client App
//
//  Created by GÜRHAN YUVARLAK on 10.10.2022.
//

import UIKit

class Helpers {
    // UIAlertController
    func alert(title: String, message: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(defaultAction)
        return alert
    }
}
