//
//  ProductTableViewController.swift
//  
//
//  Created by Divya Mirchandani on 9/11/16.
//
//

import UIKit

class ProductTableViewController: UITableViewController {
    
    var product: Clothes?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if product?.stock > 0 {
            return 7
        }
        else {
            return 6
        }
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCellWithIdentifier("shoesPicture", forIndexPath: indexPath) as! ShoeImageTableViewCell
            cell.shoePic.image = UIImage(named: "shoes")
            return cell
        case 1:
            let cell = tableView.dequeueReusableCellWithIdentifier("productName", forIndexPath: indexPath) as! ProductTableViewCell
            cell.productName.text = product?.name
            return cell
        case 2:
            let cell = tableView.dequeueReusableCellWithIdentifier("price", forIndexPath: indexPath) as! PriceTableViewCell
            if let price = product?.price {
                cell.price.text = "£\(price)"
            }
            return cell
        case 3:
            let cell = tableView.dequeueReusableCellWithIdentifier("category", forIndexPath: indexPath) as! CategoryTableViewCell
            cell.category.text = product?.category
            return cell
        case 4:
            let cell = tableView.dequeueReusableCellWithIdentifier("availability", forIndexPath: indexPath) as! AvailabilityTableViewCell
            if product?.stock > 0 {
                cell.status.text = "In Stock!"
            }
            else {
                cell.status.text = "Out of Stock"
            }
            return cell
        case 5:
            let cell = tableView.dequeueReusableCellWithIdentifier("wishlist", forIndexPath: indexPath) as! WishlistTableViewCell
            cell.productId = product?.productId
            return cell
        case 6:
            let cell = tableView.dequeueReusableCellWithIdentifier("cart", forIndexPath: indexPath) as! UITableViewCell
            return cell
        default:
            let cell = tableView.dequeueReusableCellWithIdentifier("cart", forIndexPath: indexPath) as! UITableViewCell
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return CGFloat(312)
        default:
            return 44
        }
    }

    @IBAction func addToWishlist(sender: UIButton) {
        let alert = UIAlertController(title: "Added to wishlist!", message: nil, preferredStyle: .Alert)
        
        let action = UIAlertAction(title: "Great!", style: .Default, handler: { action in
            //get the wishlist
            var wishes = NSKeyedUnarchiver.unarchiveObjectWithFile(Wishlist.ArchiveURL.path!) as? [Clothes]
            if let wishlist = wishes {
                //list contains values
                for wish in wishlist as [Clothes] {
                    if wish.productId == self.product?.productId {
                        //product is already in wish list
                        print("nothing to be added")
                        return
                    }
                }
            }
            else {
                //no wishlist exist, create an empty one
                wishes = [Clothes]()
            }
            //product is not in wish list, add it
            wishes?.append(self.product!)
            //save the new wish list
            let _ = NSKeyedArchiver.archiveRootObject(wishes!, toFile: Wishlist.ArchiveURL.path!)
            return
            })
        
        alert.addAction(action)
        
        presentViewController(alert, animated: true, completion: nil)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
