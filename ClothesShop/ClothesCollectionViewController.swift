//
//  ClothesCollectionViewController.swift
//  
//
//  Created by Divya Mirchandani on 9/10/16.
//
//

import UIKit

let reuseIdentifier = "clothesCell"

class ClothesCollectionViewController: UICollectionViewController {
    
    var clothes: Array<Clothes> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = NSURL(string: "http://private-anon-2fbfc01d86-ddshop.apiary-mock.com/products")!
        let request = NSMutableURLRequest(URL: url)
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if let response = response, data = data {
                
                //retrieves the data and puts it in an array
                var json: Array<AnyObject>?
                
                json = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(), error: nil) as? Array
                
                if let products = json {
                    self.populateClothes(products)
                }
                
            } else {
                print(error)
            }
        }
        
        task.resume()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()    }
    
    // MARK: Data Initialization
    
    func populateClothes(products: Array<AnyObject>) {
        
        /*
        Takes in an array of JSON formatted products,
        iterates through each item and creates an instance of Clothes
        with the data. The clothes array is updated with the new values
        and the collection view is updated on the main thread using the
        updated clothes array values.
        */
        
        
        var category: String, name: String, oldPrice: Int?, price: Int, productId: Int, stock: Int
        
        //iterate
        for item in products {
            if let details = item as? [String:AnyObject] {
                if let cat = details["category"] as? String {
                    category = cat
                }
                else {
                    category = ""
                }
                if let n = details["name"] as? String {
                    name = n
                }
                else {
                    name = ""
                }
                if let old = details["oldPrice"] as? Int {
                    oldPrice = old
                }
                else {
                    oldPrice = nil
                }
                if let p = details["price"] as? Int {
                    price = p
                }
                else {
                    price = -1
                }
                if let id = details["productId"] as? Int {
                    productId = id
                }
                else {
                    productId = -1
                }
                if let s = details["stock"] as? Int {
                    stock = s
                }
                else {
                    stock = -1
                }
                
                let newItem = Clothes(productId: productId, name: name, category: category, price: price, oldPrice: oldPrice, stock: stock, numberInCart: nil)
                clothes.append(newItem)
            }
        }
        
        //update UI on the main thread
        dispatch_async(dispatch_get_main_queue(), {
            self.collectionView?.reloadData()
        })
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return clothes.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! ClothesCollectionViewCell
    
        cell.shoeName.text = clothes[indexPath.row].name
        cell.shoePrice.text = "£" + String(clothes[indexPath.row].price)
    
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showProductDetail" {
            let productView = segue.destinationViewController as! ProductTableViewController
            if let selectedProduct = sender as? ClothesCollectionViewCell {
                let indexPath = collectionView?.indexPathForCell(selectedProduct)
                let product = clothes[indexPath!.row]
                productView.product = product
            }
        }
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */

}
