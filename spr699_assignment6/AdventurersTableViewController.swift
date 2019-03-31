//
//  AdventurersTableViewController.swift
//  spr699_assignment6
//
//  Created by Slijepcevic, Milica on 3/24/19.
//  Copyright © 2019 Samuel Randall. All rights reserved.
//

import UIKit
import CoreData


class AdventurersTableViewController: UITableViewController, AddAdventurerDelegate{
    
    var list: [NSManagedObject] = []

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Adventurer")
        var response: [NSManagedObject]? = nil
        
        do {
            response = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        if let response = response {
            self.list = response
        }
        
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCell.EditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        switch editingStyle {
        case .delete:
            // remove the deleted item from the model
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
            }
            
            let managedContext = appDelegate.persistentContainer.viewContext
            managedContext.delete(list[indexPath.row] )
            list.remove(at: indexPath.row)
            do {
                try managedContext.save()
            } catch _ {
            }
            
            // remove the deleted item from the `UITableView`
            self.tableView.deleteRows(at: [indexPath as IndexPath], with: .fade)
        default:
            return
        }
    }
    
    //Swipe to Delete
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            list.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let adv = list[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier, for: indexPath) as! TableViewCell
        
        //cell.textLabel?.text = adv.value(forKeyPath: "name") as? String
        //cell.imageView?.image = UIImage(named: headline.name)
        //cell.textLabel?.text = adv.value(forKeyPath: "name") as? String
        cell.nameLabel.text = adv.value(forKeyPath: "name") as? String
        cell.professionLabel.text = adv.value(forKeyPath: "profession") as? String
        cell.levelLabel.text = adv.value(forKeyPath: "level") as? String
        cell.HPLabel.text = adv.value(forKeyPath: "totalHP") as? String
        cell.attackLabel.text = adv.value(forKeyPath: "attack") as? String
        
        return cell
    }

    func addAdventurer(name: String, profession: String, level: Int, HP: Int, attack: Float) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Adventurer", in: managedContext)!
        
        let adv = NSManagedObject(entity: entity, insertInto: managedContext)
        
        adv.setValue(name, forKey: "name")
        adv.setValue(profession, forKey: "profession")
        adv.setValue(level, forKey: "level")
        adv.setValue(HP, forKey: "totalHP")
        
        adv.setValue(attack, forKey: "attack")
        adv.setValue(HP, forKey: "currentHP")
        
        do {
            try managedContext.save()
            
            list.append(adv)
            tableView.reloadData()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        } catch {
            print(error.localizedDescription)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? AddViewController {
            destination.delegate = self
        }
        if let destination = segue.destination as? QuestViewController{
            let indexPath = tableView.indexPathForSelectedRow
            let num = indexPath!.row
            destination.adv = list[num]
        }
    }

    //@IBAction func private weak var collectionView: UICollection
    /*
    @IBAction func buttonDeletePressed(_ sender: UIButton) {
        do {
            
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
            }
            
            let managedContext = appDelegate.persistentContainer.viewContext
            //let managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext
            //let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Adventurer")
            //var response: [NSManagedObject]? = nil
            
            let index = sender.tag
            managedContext.delete(list[index] as NSManagedObject)
            list.remove(at: index)
            //let _ : NSError! = nil
            do {
                try managedContext.save()
                self.tableView.reloadData()
            } catch {
                print("error : \(error)")
            }
        }

    }
    */
    
}
