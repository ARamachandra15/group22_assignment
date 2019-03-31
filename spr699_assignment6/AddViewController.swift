//
//  AddViewController.swift
//  spr699_assignment6
//
//  Created by Slijepcevic, Milica on 3/24/19.
//  Copyright © 2019 Samuel Randall. All rights reserved.
//

import UIKit
import CoreData

protocol AddAdventurerDelegate {
    func addAdventurer(name: String, profession: String, level: Int, HP: Int, attack: Float)
}

class AddViewController: UIViewController {
     
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var classText: UITextField!
    
    var delegate: AddAdventurerDelegate? = nil
    
    @IBAction func cancel(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func save(_ sender: UIButton) {
        
        let name = nameText.text ?? ""
        let profession = classText.text ?? ""
        
        if (name != "") && (profession != ""){
            let hp = Int.random(in: 65 ... 100)
            let att = Float.random(in: 1 ... 10)
            delegate?.addAdventurer(name: name, profession: profession, level: 1, HP: hp, attack: att)
            navigationController?.popViewController(animated: true)
        }
        
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
