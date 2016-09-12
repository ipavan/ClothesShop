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
        productPrice.text = "None"
        totalPrice.text = "none"
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
                    if let totalProducts = self.product?.numberInCart {
                        numberInCart = totalProducts
                    }
                }
            }
        }
        
        if let prod = product?.stock {
            print("items: \(items), prod: \(prod), number: \(numberInCart)")
            items = prod - numberInCart
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addToCart(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: {
            
        })
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
