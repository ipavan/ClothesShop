//
//  CartTableViewController.swift
//  
//
//  Created by Divya Mirchandani on 9/12/16.
//
//

import UIKit

class CartTableViewController: UITableViewController {

    var cart: [Clothes]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setInitialValues()
        
    }
    
    func setInitialValues() {
        self.cart = NSKeyedUnarchiver.unarchiveObjectWithFile(Cart.ArchiveURL.path!) as? [Clothes]
        
        if let x = self.cart {
            //do nothing
        }
        else {
            self.cart = [Clothes]()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(animated: Bool) {
        self.setInitialValues()
        self.tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let x = cart?.count {
            return x + 1
        }
        else {
            return 1
        }
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var numberOfRows = 1
        if let x = cart?.count {
            numberOfRows = x + 1
        }
        
        switch indexPath.row {
        case numberOfRows - 1:
            let cell = tableView.dequeueReusableCellWithIdentifier("totalPriceCell", forIndexPath: indexPath) as! TotalPriceTableViewCell
            if numberOfRows == 1 {
                cell.totalPriceLabel.text = "Nothing in your cart"
                cell.priceLabel.text = ""
            }
            else {
                cell.totalPriceLabel.text = "Total Price"
                var total = 0
                if let productsInCart = cart {
                    //list contains values
                    for cartProduct in productsInCart as [Clothes] {
                        total = total + cartProduct.price
                    }
                }
                cell.priceLabel.text = String("£\(total)")
            }
            return cell
        default:
            let cell = tableView.dequeueReusableCellWithIdentifier("cartCell", forIndexPath: indexPath) as! CartTableViewCell
            cell.cartCellName.text = cart?[indexPath.row].name
            if let x = cart?[indexPath.row].price {
                cell.cartCellPrice.text = "£" + String(x)
            }
            cell.removeFromCartButton.tag = indexPath.row
            return cell
        }
    }
    
    @IBAction func removeFromCart(sender: UIButton) {
        
        let product = cart?[sender.tag]
        
        let cartId: Int = (product?.cartId)!
        
        let url = NSURL(string: "http://private-anon-2fbfc01d86-ddshop.apiary-mock.com/cart/\(cartId)")!
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "DELETE"
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if let response = response, data = data {
                print(response)
                dispatch_async(dispatch_get_main_queue(), {
                    self.cart?.removeAtIndex(sender.tag)
                    let _ = NSKeyedArchiver.archiveRootObject(self.cart!, toFile: Cart.ArchiveURL.path!)
                    let indexPath = NSIndexPath(forRow: sender.tag, inSection: 0)
                    self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                    self.tableView.reloadData()
                })
            } else {
                print(error)
                dispatch_async(dispatch_get_main_queue(), {
                    let alert = UIAlertController(title: "Something went wrong!", message: nil, preferredStyle: .Alert)
                    let action = UIAlertAction(title: "Sorry!", style: .Default, handler: nil)
                    
                    alert.addAction(action)
                    
                    self.presentViewController(alert, animated: true, completion: nil)
                })
            }
        }
        
        task.resume()
    }

}
