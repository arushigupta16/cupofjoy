//
//  ViewController.swift
//  CupOfJoy
//
//  Created by Arushi Gupta on 9/6/21.
//

import UIKit

class ViewController: UIViewController {

    // want to create an outlet for our table view
    // this outlet will control the table view on the storyboard
    
    @IBOutlet var tableView: UITableView!
    
    // create an array in order to hold all the coffee orders an individual has placed and track where they went
    // will be an array of strings
    // first this task array will be empty
    var orders = [String]()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // When the view loads, we want to showcase all the current/past orders that the user has saved
        self.title = "Coffee"
        
        // table views delegate itself and the tableView is the data source
        tableView.delegate = self
        tableView.dataSource = self
        
        // need to set up original user defaults if there are 0 coffee orders and user is using this for first time
        
        if !UserDefaults().bool(forKey: "setup") {
            // only want to come into this if statement once
            UserDefaults().set(true, forKey: "setup")
            UserDefaults().set(0, forKey: "count")
        }
        updateOrders()
    }
    
    func updateOrders() {
        orders.removeAll()
        
        guard let count = UserDefaults().value(forKey: "count") as? Int else {
            return
        }
        
        // iterate from 0 to inclusive count
        // get each order and add it to an order array
        for x in 0..<count {
            if let order = UserDefaults().value(forKey: "order_\(x+1)") as? String {
                orders.append(order)
            }
        }
        tableView.reloadData()
    }
    
    
    
    //handles when we click on "Add New Order" Button
    //show another view controller that allows the user to make a new coffee entry
    @IBAction func didTapAdd() {
        let viewController = storyboard?.instantiateViewController(identifier: "entry") as! EntryViewController
        viewController.title = "New Coffee Order"
        viewController.update = {
            // every time that we call update we want to reload the table view
            // Use Dispatch in order to prioritize this
            DispatchQueue.main.async {
                self.updateOrders()
            }
        }
        // we now want to push a new view controller so we will do that manually inside this navigation view
        navigationController?.pushViewController(viewController, animated: true)
    }
}

// now want to implement how we handle interactions with different data cells
// will be done with extensions
// add a delegate and data source

// delegate will handle taps on the cell
extension ViewController: UITableViewDelegate{
    
    func tableView( _ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // after we select a specific coffee order, we then want it to be deselected based on the provided index path
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ViewController: UITableViewDataSource {
    // before starting this, moving back to storyboard (where we actually create the UI for this app)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //number of orders the user has placed in the past
        return orders.count
    }
    
    // now we want to return the cell for the given row that the user has clicked on
    // cellforrowatindexpath
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // need to dequeue a cell
        // this allows us to essentially reuse the cell but only swap out the text and this allows us to do that
        // use identifier that I made in Main.storyboard
        let cell1 = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath)
        
        //changing the actual text to be what the coffee order is
        //indexPath.row represents the actual position of the cell1 in the table view
        cell1.textLabel?.text = orders[indexPath.row]
        
        return cell1
    }
}