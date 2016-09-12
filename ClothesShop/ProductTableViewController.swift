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
    var cart: [Clothes]?
    var items = 0

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cart = NSKeyedUnarchiver.unarchiveObjectWithFile(Cart.ArchiveURL.path!) as? [Clothes]
        var numberInCart = 0
        if let productInCart = cart {
            //list contains values
            for cartProduct in productInCart as [Clothes] {
                if cartProduct.productId == self.product?.productId {
                    numberInCart += 1
                }
            }
        }
        
        
        items = 0
        if let prod = product?.stock {
            items = prod - numberInCart
            //print("items: \(items), prod: \(prod), number: \(numberInCart) \n")
        }
        
        if items > 0 {
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
                cell.status.text = "\(items) left In Stock!"
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
            return CGFloat(275)
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


    
    @IBAction func addToCart(sender: UIButton) {
        self.product?.cartId = self.getUniqueCartId()
        
        if let x = self.cart {
            //do nothing
        } else {
            self.cart = [Clothes]()
        }
        
        let url = NSURL(string: "http://private-anon-2fbfc01d86-ddshop.apiary-mock.com/cart")!
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.HTTPBody = "{\n  \"productId\": \(self.product?.productId)\n}".dataUsingEncoding(NSUTF8StringEncoding);
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if let response = response, data = data {
                print(response)
                dispatch_async(dispatch_get_main_queue(), {
                    self.cart?.append(self.product!)
                    let _ = NSKeyedArchiver.archiveRootObject(self.cart!, toFile: Cart.ArchiveURL.path!)
                    self.tableView.reloadData()
                    
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
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "addToCart" {
            let addToCart = segue.destinationViewController as! AddToCartViewController
            addToCart.product = self.product
        }
    }
    

}
