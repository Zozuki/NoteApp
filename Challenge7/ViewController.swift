//
//  ViewController.swift
//  Challenge7
//
//  Created by MacBook Air on 02.12.2020.
//  Copyright © 2020 MacBook Air. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    var notes = [Note]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
        let defaults = UserDefaults.standard
        if let savedNotes = defaults.object(forKey: "notes") as? Data {
            let decoder = JSONDecoder()
            do {
                notes = try decoder.decode([Note].self, from: savedNotes)
            } catch {
                print("Fail decode")
            }
        }
        print(notes.count)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add note", style: .plain, target: self, action: #selector(newNote))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Delete all", style: .plain, target: self, action: #selector(deleteAll))
    
    }

    @objc func deleteAll() {
        notes.removeAll()
        tableView.reloadData()
        save()
//        print("Notes in main: \(notes.count)")
    }
    
    @objc func newNote() {
        let note = Note(text: "")
        notes.append(note)
        save()
        tableView.reloadData()
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            navigationController?.pushViewController(vc, animated: true)
//            let note = Note(text: "")
//            notes.append(note)
            vc.notes = notes
            vc.edit = "No"
            
        }
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "note", for: indexPath)
        let note = notes[indexPath.row]
        cell.textLabel?.text = note.text
        cell.textLabel?.textColor = .white
        cell.textLabel?.font.withSize(CGFloat(15))
        save()
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
            if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
                let note = notes[indexPath.row]
                vc.notes = notes
                vc.text = note.text
                vc.index = indexPath.row
                vc.edit = "Yes"
//                save()
                navigationController?.pushViewController(vc, animated: true)
            }
    
    }
    
    func save() {
        let jsonEncoder = JSONEncoder()
        if let savedData = try? jsonEncoder.encode(notes) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "notes")
        } else {
            print("Failed to save note.")
        }
    }
}

