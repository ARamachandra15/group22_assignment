//
//  QuestViewController.swift
//  spr699_assignment6
//
//  Created by Jorge Rivero III on 3/29/19.
//  Copyright © 2019 Samuel Randall. All rights reserved.
//

import UIKit
import CoreData

class Enemy{
    let enemies: Array<String> = ["Dragon", "Moblin", "Witch", "Mummy"]
    let randInt: Int = Int.random(in: 0 ... 3)
    var name: String
    var hp: Int = Int.random(in: 10 ... 80)
    
    init() {
        self.name = enemies[randInt]
    }
}

class QuestViewController: UIViewController {
    
    var adv: NSManagedObject? = nil
    
    @IBOutlet weak var questLog: UITextView!
    @IBOutlet weak var portrait: UIImageView!
    @IBOutlet weak var advName: UILabel!
    @IBOutlet weak var advAttack: UILabel!
    @IBOutlet weak var advHP: UILabel!
    @IBOutlet weak var advLevel: UILabel!
    @IBOutlet weak var advClass: UILabel!
    
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Currently these to not update in real time, might need to be moved to a quest function
        
        configureInitialValues()
        
        adv!.setValue(adv!.value(forKeyPath: "totalHP") as! Int, forKey: "currentHP")
        self.timer = startQuest(withInitialEnemy: Enemy())
    }
    
    deinit {
        timer?.invalidate()
    }
    
    enum QuestEvent {
        case enemyDied(String)
        case update(String)
        case playerDied(String)
    }
    
    func playerAttack(enemy: Enemy) -> QuestEvent {
        
        let attack = (adv!.value(forKeyPath: "attack") as! Double) * Double.random(in: 1...25)
        enemy.hp -= Int(attack)
        
        if enemy.hp < 0{
            return .enemyDied("\(adv!.value(forKeyPath: "name") as! String) attacks for \(Int(attack)) damage\nThe \(enemy.name) is deafeated")
        }
        
        return .update("\(adv!.value(forKeyPath: "name") as! String) attacks for \(Int(attack)) damage")
    }
    
    
    func enemyAttack(enemy: Enemy) -> QuestEvent {
        
        let action = ["Attack", "Wait"].randomElement()!
        var playerHP: Int = adv!.value(forKeyPath: "currentHP") as! Int
        var event: String = ""
        
        if action == "Attack"{
            let attack: Int = Int.random(in: 10...50)
            playerHP -= attack
            adv!.setValue(playerHP, forKey: "currentHP")
            event = "The \(enemy.name) attacks for \(attack) damage"
        }else{
            event = "The \(enemy.name) is waiting..."
        }
        
        if playerHP <= 0 {
            return .playerDied(event)
        }
        
        return .update(event)
        
    }
    
    func startQuest(withInitialEnemy enemy: Enemy) -> Timer {
        
        let adv = self.adv!
        var advLevel = adv.value(forKey: "level") as! Int
        var enemy = enemy
        let start = "Beginning Quest...\nA \(enemy.name) has appeared"
        var event: QuestEvent = .update(start)
        var playerTurn = true
        var numDefeated: Int = 0
        self.updateView(event: start)
        
        let timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { [weak self] timer in
            
            guard let `self` = self else { return }
            
            if numDefeated % 5 == 0 && numDefeated != 0{
                advLevel += 1
                adv.setValue(advLevel, forKey: "level")
            }
            
            if playerTurn {
                event = self.playerAttack(enemy: enemy)
            } else {
                event = self.enemyAttack(enemy: enemy)
            }
            
            switch event {
            case .enemyDied(let diedString):
                enemy = Enemy()
                let newEnemy: String = "\nA \(enemy.name) has appeared"
                self.updateView(event: (diedString + newEnemy))
                numDefeated += 1
            case .update(let updateString):
                self.updateView(event: updateString)
            case .playerDied(let updateString):
                self.updateView(event: (updateString + "\n\(adv.value(forKey: "name") as! String) has died"))
                timer.invalidate()
            }
            
            playerTurn.toggle()
        }
        
        return timer
    }
    
    func configureInitialValues() {
        let adv = self.adv!

        self.questLog.text = ""
        self.advHP.text = "\(adv.value(forKeyPath: "currentHP") as! Int)/\(adv.value(forKeyPath: "totalHP") as! Int)"
        self.advLevel.text =  "Level: \(adv.value(forKeyPath: "level") as! Int)"
        self.advClass.text =  "Class: \(adv.value(forKeyPath: "profession") as! String)"
        //            self.portrait.image = adv.value(forKeyPath: "portrait") as? UIImage
        self.advName.text = adv.value(forKeyPath: "name") as? String
        self.advAttack.text =  "Attack: \(adv.value(forKeyPath: "attack") as! Double)"
        //self.advLevel.text = "Level: \(adv.value(advLevel, forKey: "level") as! String)"
    }
    
    func updateView(event: String) {
        DispatchQueue.main.async {
            let adv = self.adv!
            
            self.questLog.text += event + "\n"
            if (adv.value(forKeyPath: "currentHP") as! Int) < 0 {
                self.advHP.text = "0/\(adv.value(forKeyPath: "totalHP") as! Int)"
            }else{
                self.advHP.text = "\(adv.value(forKeyPath: "currentHP") as! Int)/\(adv.value(forKeyPath: "totalHP") as! Int)"
            }
            
            self.advLevel.text =  "Level: \(adv.value(forKeyPath: "level") as! Int)"
            self.advClass.text =  "Class: \(adv.value(forKeyPath: "profession") as! String)"
//            self.portrait.image = adv.value(forKeyPath: "portrait") as? UIImage
            self.advName.text = adv.value(forKeyPath: "name") as? String
            self.advAttack.text =  "Attack: \(adv.value(forKeyPath: "attack") as! Double)"
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
