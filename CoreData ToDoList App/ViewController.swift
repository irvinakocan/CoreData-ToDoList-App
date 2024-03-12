//
//  ViewController.swift
//  CoreData ToDoList App
//
//  Created by Macbook Air 2017 on 12. 3. 2024..
//

import UIKit

class ViewController: UIViewController {
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private var items = [ToDoListItem]()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ItemTableViewCell.self,
                           forCellReuseIdentifier: ItemTableViewCell.identifier)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "To Do List"
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(didTapAdd))
        
        getAllItems()
        setTableView()
    }
    
    @objc private func didTapAdd() {
        let alert = UIAlertController(title: "New item",
                                      message: "Enter new item",
                                      preferredStyle: .alert)
        
        alert.addTextField()
        let action = UIAlertAction(title: "Submit", style: .cancel, handler: {
            [weak self] _ in
            guard let text = alert.textFields?.first?.text, !text.isEmpty else {
                return
            }
            self?.createItem(name: text)
        })
        alert.addAction(action)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default))
        
        present(alert, animated: true)
    }
    
    private func setTableView() {
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
}

// MARK: Table View delegating
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ItemTableViewCell.identifier, for: indexPath) as? ItemTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(text: item.name ?? "")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = items[indexPath.row]
        
        let sheet = UIAlertController(title: "Edit", message: nil, preferredStyle: .actionSheet)
        
        // Editing the item
        sheet.addAction(UIAlertAction(title: "Edit",
                                      style: .default,
                                      handler: { [weak self] _ in
            let alert = UIAlertController(title: "Edit item",
                                          message: "Edit your item",
                                          preferredStyle: .alert)
            alert.addTextField()
            alert.textFields?.first?.text = item.name
            alert.addAction(UIAlertAction(title: "Save",
                                          style: .cancel,
                                          handler: { [weak self] _ in
                guard let newName = alert.textFields?.first?.text, !newName.isEmpty else { return }
                self?.updateItem(item: item, newName: newName)
            }))
            alert.addAction(UIAlertAction(title: "Cancel",
                                          style: .default))
            self?.present(alert, animated: true)
        }))
        
        // Deleting the item
        sheet.addAction(UIAlertAction(title: "Delete",
                                      style: .destructive,
                                      handler: { [weak self] _ in
            self?.deleteItem(item: item)
        }))
        
        // Canceling the sheet
        sheet.addAction(UIAlertAction(title: "Cancel",
                                      style: .cancel))
        
        present(sheet, animated: true)
    }
}

// MARK: Core Data
extension ViewController {
    
    private func getAllItems() {
        do {
            items = try context.fetch(ToDoListItem.fetchRequest())
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        catch {
            // handle
        }
    }
    
    private func createItem(name: String) {
        let newItem = ToDoListItem(context: context)
        newItem.name = name
        newItem.createdAt = Date.now
        newItem.isDone = false
        
        do {
            try context.save()
            getAllItems()
        }
        catch {
            // handle
        }
    }
    
    private func updateItem(item: ToDoListItem, newName: String) {
        item.name = newName
        
        do {
            try context.save()
            getAllItems()
        }
        catch {
            // handle
        }
    }

    private func deleteItem(item: ToDoListItem) {
        context.delete(item)
        
        do {
            try context.save()
            getAllItems()
        }
        catch {
            // handle
        }
    }
}
