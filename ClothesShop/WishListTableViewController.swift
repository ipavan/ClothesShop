//
//  WishListTableViewController.swift
//  
//
//  Created by Divya Mirchandani on 9/11/16.
//
//

import UIKit

class WishListTableViewController: UITableViewController {
    
    var wishList = [Clothes]()
    var cart: [Clothes]?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = editButtonItem()
        
        let wishes = NSKeyedUnarchiver.unarchiveObjectWithFile(Wishlist.ArchiveURL.path!) as? [Clothes]
        if let list = wishes {
            wishList = list
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        let wishes = NSKeyedUnarchiver.unarchiveObjectWithFile(Wishlist.ArchiveURL.path!) as? [Clothes]
        if let list = wishes {
            wishList = list
        }
        
        self.cart = NSKeyedUnarchiver.unarchiveObjectWithFile(Cart.ArchiveURL.path!) as? [Clothes]
        if let x = self.cart {
            //do nothing
        }
        else {
            self.cart = [Clothes]()
        }
        
        self.tableView.reloadData()
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
        return wishList.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("wishesCell", forIndexPath: indexPath) as! WishesTableViewCell

        cell.productPrice.text = "£\(wishList[indexPath.row].price)"
        cell.productName.text = wishList[indexPath.row].name
        
        cell.addToCartButton.tag = indexPath.row
        
        return cell
    }
    
    @IBAction func addToCart(sender: UIButton) {
        
        let product: Clothes = wishList[sender.tag]
        
        var numberInCart = 0
        if let x = cart {
            for item in x as [Clothes] {
                if item.productId == product.productId {
                    numberInCart += 1
                }
            }
        }
        
        if numberInCart < product.stock {
            let url = NSURL(string: "http://private-anon-2fbfc01d86-ddshop.apiary-mock.com/cart")!
            let request = NSMutableURLRequest(URL: url)
            request.HTTPMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            request.HTTPBody = "{\n  \"productId\": \(product.productId)\n}".dataUsingEncoding(NSUTF8StringEncoding);
            
            let session = NSURLSession.sharedSession()
            let task = session.dataTaskWithRequest(request) { data, response, error in
                if let response = response, data = data {
                    print(response)
                    //print(String(_cocoaString: data))
                    dispatch_async(dispatch_get_main_queue(), {
                        self.cart?.append(product)
                        let _ = NSKeyedArchiver.archiveRootObject(self.cart!, toFile: Cart.ArchiveURL.path!)
                        
                        let alert = UIAlertController(title: "Added To Cart!", message: nil, preferredStyle: .Alert)
                        let action = UIAlertAction(title: "Great!", style: .Default, handler: nil)
                        
                        alert.addAction(action)
                        
                        self.presentViewController(alert, animated: true, completion: nil)
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
        else {
            let alert = UIAlertController(title: "No More In Stock!", message: nil, preferredStyle: .Alert)
            let action = UIAlertAction(title: "Sorry!", style: .Default, handler: nil)
            
            alert.addAction(action)
            
            presentViewController(alert, animated: true, completion: nil)
        }

    }
    
    func getUniqueCartId() -> Int {
        let id = NSKeyedUnarchiver.unarchiveObjectWithFile(UniqueCartIds.ArchiveURL.path!) as? UniqueCartIds
        if let cartId = id {
            //file exists
            var uniqueId = cartId
            uniqueId.cartId += 1
            let _ = NSKeyedArchiver.archiveRootObject(uniqueId, toFile: UniqueCartIds.ArchiveURL.path!)
            return uniqueId.cartId
        }
        else {
            //no file exists
            let uniqueId = UniqueCartIds(cartId: 1)
            let _ = NSKeyedArchiver.archiveRootObject(uniqueId, toFile: UniqueCartIds.ArchiveURL.path!)
            return uniqueId.cartId
        }
    }

    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            wishList.removeAtIndex(indexPath.row)
            let _ = NSKeyedArchiver.archiveRootObject(self.wishList, toFile: Wishlist.ArchiveURL.path!)
            
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            
        }    
    }
    

}
