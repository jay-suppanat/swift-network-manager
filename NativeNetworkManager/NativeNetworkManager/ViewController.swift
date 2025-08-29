//
//  ViewController.swift
//  NativeNetworkManager
//
//  Created by Jay on 29/8/2568 BE.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var reponseLabel: UILabel!
    
    @IBAction func requestGET(_ sender: UIButton) {
        let random = self.randomFootballerName()
        TestNetworkClient.requestTestGetService(firstName: random["firstName"] ?? "", lastName: random["lastName"] ?? "") { response in
            self.reponseLabel.text = (response.args?.firstName ?? "") + " " + (response.args?.lastName ?? "")
        }
    }
    
    @IBAction func requestPOST(_ sender: UIButton) {
        let random = self.randomFootballerName()
        TestNetworkClient.requestTestPOSTService(firstName: random["firstName"] ?? "", lastName: random["lastName"] ?? "") { response in
            self.reponseLabel.text = (response.data?.firstName ?? "") + " " + (response.data?.lastName ?? "")
        }
    }
    
    @IBAction func requestPUT(_ sender: UIButton) {
    }
    
    @IBAction func requestDELETE(_ sender: UIButton) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func randomFootballerName() -> [String: String] {
        let footballers = [
            ("Lionel", "Messi"),
            ("Cristiano", "Ronaldo"),
            ("Kylian", "Mbappé"),
            ("Neymar", "Jr"),
            ("Kevin", "De Bruyne"),
            ("Erling", "Haaland"),
            ("Robert", "Lewandowski"),
            ("Mohamed", "Salah"),
            ("Zlatan", "Ibrahimović"),
            ("Luka", "Modrić")
        ]
        
        guard let randomPlayer = footballers.randomElement() else {
            return ["firstName": "Unknown", "lastName": "Player"]
        }
        
        return ["firstName": randomPlayer.0, "lastName": randomPlayer.1]
    }
}

