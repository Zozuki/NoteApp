//
//  DetailViewController.swift
//  Challenge7
//
//  Created by MacBook Air on 02.12.2020.
//  Copyright © 2020 MacBook Air. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet var textNote: UITextView!
    var notes = [Note]()
    var text = String()
    var index = Int()
    var edit =  String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textNote.text = text
        
        let notificationCenter = NotificationCenter.default
              notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
              notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name:
                UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        let defaults = UserDefaults.standard
        if let savedNotes = defaults.object(forKey: "notes") as? Data {
            let decoder = JSONDecoder()
            do {
               notes = try decoder.decode([Note].self, from: savedNotes)
            } catch {
               print("Fail decode")
            }
        }
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let delete = UIBarButtonItem(title: "Delete", style: .plain, target: self, action: #selector(deleteNote))

        toolbarItems = [spacer, delete]
        
        navigationController?.isToolbarHidden = false
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action:  #selector(shareTapped))
        
        
        
    }
    
    @objc func deleteNote() {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "notes") as? ViewController {
            notes.remove(at: index)
            vc.notes = notes
            save()
            edit = ""
            self.navigationController?.pushViewController(vc, animated: false)
        }
    }
    
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

        if notification.name == UIResponder.keyboardWillHideNotification {
            textNote.contentInset = .zero
        } else {
            textNote.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }

        textNote.scrollIndicatorInsets = textNote.contentInset

        let selectedRange = textNote.selectedRange
        textNote.scrollRangeToVisible(selectedRange)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear( true)
        if edit == "Yes" {
            changeNote()
        } else if edit == "No" {
            saveNewNote()
        }
    }
  
    func changeNote() {
        notes[index].text = textNote.text
        save()
        if let vc = storyboard?.instantiateViewController(withIdentifier: "notes") as? ViewController {
            vc.notes = notes
            self.navigationController?.pushViewController(vc, animated: false)
        }
        
    }
    
    func saveNewNote() {
//        let note = Note(text: textNote.text)
//        notes.append(note)
        notes.last?.text = textNote.text
        save()
        if let vc = storyboard?.instantiateViewController(withIdentifier: "notes") as? ViewController {
            vc.notes = notes
//            print("Notes in detail: \(notes.count)")
            self.navigationController?.pushViewController(vc, animated: false)
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
    
    @objc func shareTapped() {
        let vc = UIActivityViewController(activityItems: [textNote.text!], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }

}
