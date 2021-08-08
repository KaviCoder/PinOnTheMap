//
//  TableViewController.swift
//  PinOnTheMap
//
//  Created by Kavya Joshi on 7/29/21.
//

import UIKit

class ListViewController: UITableViewController {
    var pinButton : UIBarButtonItem!
   var logOutButton : UIBarButtonItem!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        addNavigationButtons()

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return PinClient.mapData.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCells", for: indexPath)
        print(PinClient.mapData.count)
        print(indexPath.row)
        print(PinClient.mapData.count - indexPath.row)
        let recordToBeDisplayed = PinClient.mapData[PinClient.mapData.count - indexPath.row - 1]
        
        cell.textLabel?.text = recordToBeDisplayed.firstName + recordToBeDisplayed.lastName
            cell.imageView?.image = UIImage(named: "icon_pin")
        // Configure the cell...
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let app = UIApplication.shared
         
            app.open(URL(string: PinClient.mapData[PinClient.mapData.count - indexPath.row].mediaURL)!, options: [:])
    
        
        
        
        
        
    }
   
    //MARK:- Navigation Items
    func  addNavigationButtons()
    {
      
        pinButton = UIBarButtonItem(image: UIImage(named: "icon_pin"), style: .done, target: self, action: #selector(pinPressed(_:)))
    
        self.navigationItem.rightBarButtonItem = self.pinButton
        
        logOutButton = UIBarButtonItem( image : UIImage(named: "logout"), style: .done, target: self, action: #selector(logOutPressed(_:)))
        self.navigationItem.leftBarButtonItem = self.logOutButton
    }
    
   @objc func pinPressed(_ sender: UIBarButtonItem)  {
       
        performSegue(withIdentifier: "createPin", sender: self)
    }

   
    @objc func logOutPressed(_ sender: UIBarButtonItem) {
     
        PinClient.myDeleteRequest(id: HandleLogin.StoryBoardName.loggedOut.rawValue)
      
    }
    
}
    
   
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


