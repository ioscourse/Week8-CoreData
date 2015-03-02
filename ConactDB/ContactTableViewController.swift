//
//  ContactTableViewController.swift
//  ConactDB
//
//  Created by Charles Konkol on 2/26/15.
//  Copyright (c) 2015 Rock Valley College. All rights reserved.
//

import UIKit
//0) Add Import Statements for CoreDate
import CoreData
import Foundation

//1) Add , UITableViewDelegate to ContactTableViewController
class ContactTableViewController: UITableViewController, UITableViewDelegate {

//2) Add variable to hold NSManagedObject
    var contactArray = [NSManagedObject]()
    
//3) Add viewDidAppear (loads whenever view appears). Ignore error for loaddb line.
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        loaddb()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
//4) Add func loaddb to load database and refresh table
    func loaddb()
    {
       
        let appDelegate =
        UIApplication.sharedApplication().delegate as AppDelegate
        
        let managedContext = appDelegate.managedObjectContext!
        
       
        let fetchRequest = NSFetchRequest(entityName:"Contact")
        
        
        var error: NSError?
        
        let fetchedResults =
        managedContext.executeFetchRequest(fetchRequest,
            error: &error) as [NSManagedObject]?
        
        if let results = fetchedResults {
            contactArray = results
            tableView.reloadData()
        } else {
            println("Could not fetch \(error), \(error!.userInfo)")
        }

    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//5) Change to return 1
       return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//6) Change to return contactArray.count
        return contactArray.count
    }

 
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//7) Uncomment & Change to below to load rows
        let cell =
        tableView.dequeueReusableCellWithIdentifier("Cell")
            as UITableViewCell
        
        let person = contactArray[indexPath.row]
        cell.textLabel.text = person.valueForKey("fullname") as String?
        cell.detailTextLabel?.text = ">>"
        
        return cell
    }

//8) Add to show row clicked
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        println("You selected cell #\(indexPath.row)")
    }
    
//9) Uncomment
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

//10) Uncomment
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
//11 Change to delete swiped row
        if editingStyle == .Delete {
            let appDelegate =
            UIApplication.sharedApplication().delegate as AppDelegate
            let context = appDelegate.managedObjectContext!
            context.deleteObject(contactArray[indexPath.row])
            var error: NSError? = nil
            if !context.save(&error) {
                println("Unresolved error \(error)")
                abort()
            }
            else
            {
                loaddb()
            }
        }
    }
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    
    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return NO if you do not want the item to be re-orderable.
    return true
    }
    */
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//12) Uncomment & Change to go to proper record on Viewcontroller
            if segue.identifier == "UpdateContacts" {
                if let destination = segue.destinationViewController as? ContactViewController {
                    if let SelectIndex = tableView.indexPathForSelectedRow()?.row {
 
                        let selectedDevice:NSManagedObject = contactArray[SelectIndex] as NSManagedObject
                            destination.contactdb = selectedDevice
                    }
                }
            }
         
        }
  
        
    
 

}
