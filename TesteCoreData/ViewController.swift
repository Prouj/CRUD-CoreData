//
//  ViewController.swift
//  TesteCoreData
//
//  Created by Paulo Uchôa on 13/10/20.
//

import UIKit
import CoreData

class ViewController: UIViewController {
 
    @IBOutlet weak var tableView: UITableView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var items:[Person]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        fetchPeople()
       
    }
    
    
    func fetchPeople() {
        
        do {
            
            let request = Person.fetchRequest() as NSFetchRequest<Person>

            let sort = NSSortDescriptor(key: "name", ascending: true)
            request.sortDescriptors = [sort]
            
//            let name = "Paulo"
//            let filter = NSPredicate(format: "name == %@", name)
//            request.predicate = filter
            
            self.items = try context.fetch(request)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        catch {
            print("Erro")
        }
    }
    
    
    @IBAction func addTapped(_ sender: Any) {
        
        let alert = UIAlertController(title: "Add Person", message: "What is their name?", preferredStyle: .alert)
        alert.addTextField()
        
        let submitButton = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let textfiel = alert.textFields![0]
            
            let newPerson = Person(context: self.context)
            newPerson.name = textfiel.text
            newPerson.gender = "Male"
            newPerson.age = 20
            
            do{
                try self.context.save()
            }
            catch{
                
            }
            
            self.fetchPeople()
            
        }
        
        alert.addAction(submitButton)
        self.present(alert, animated: true, completion: nil)
        
    }
}


extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items?.count ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PersonCell", for: indexPath)
        
        let person = self.items![indexPath.row]
        
        
        cell.textLabel?.text = person.name
        
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let person = self.items![indexPath.row]
        
        let alert = UIAlertController(title: "Edit Person", message: "Edit name:", preferredStyle: .alert)
        alert.addTextField()
        
        let textfield = alert.textFields![0]
        textfield.text = person.name
        
        let saveButton = UIAlertAction(title: "Save", style: .default) { (action) in
            
            
            let textfield = alert.textFields![0]
            
            person.name = textfield.text
            
            do {
                try  self.context.save()
            }
            catch {
                
            }
           
            
            self.fetchPeople()
            
        }
        
        alert.addAction(saveButton)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
            
            let personToRemove = self.items![indexPath.row]
            
            self.context.delete(personToRemove)
            
            do {
                try self.context.save()
            }
            catch{
                
            }
            
            self.fetchPeople()
        }
        
        return UISwipeActionsConfiguration(actions: [action])
    }
}

