//
//  AddToCartViewController.swift
//  
//
//  Created by Divya Mirchandani on 9/12/16.
//
//

import UIKit

class AddToCartViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var productName: UILabel!
    var product: Clothes?
    var pickerEntries = [Int]()
    var cart: [Clothes]?
    var items: Int = 0
    var quantity = 1
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var totalPrice: UILabel!
    @IBOutlet weak var picker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker.delegate = self
        
        productName.text = product?.name
        productPrice.text = "£\(product!.price)"
        totalPrice.text = "£\(product!.price)"
        let stock: Int! = product?.stock
        
        for i in 1...stock {
            pickerEntries.append(i)
        }
        
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
        else {
            cart = [Clothes]()
        }
        
        if let prod = product?.stock {
            items = prod - numberInCart
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addToCart(sender: UIButton) {
        self.product?.cartId = self.getUniqueCartId()
        if let number = self.product?.numberInCart {
            self.product?.numberInCart = number + 1
        }
        else {
            self.product?.numberInCart = 1
        }
        self.cart?.append(self.product!)
        let _ = NSKeyedArchiver.archiveRootObject(self.cart!, toFile: Cart.ArchiveURL.path!)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func cancel(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return items
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return String(pickerEntries[row])
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        quantity = pickerEntries[row]
        print(quantity)
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
