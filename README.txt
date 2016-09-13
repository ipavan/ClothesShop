ClothesShop README

Please note: ClothesShop was built and tested using XCode6.4 and targeted for iOS 8. It will not compile on XCode 7 due to the differences in syntax for some methods between Swift 1.2 and Swift 2.

******************************
How Clothes Shop is organized
******************************

Clothes Shop initialy provides a user with the choice to choose from three views using tab bar navigation. It allows them to view the entire list of products in the Products section. They can view their Wish List and make changes to it in the Wish List section and view and edit their Cart in the Cart section. The Products sections provides the user with a collection view of all the available products. Upon selecting any product, they are presented with details of the product and the option to add the item to their wishlist and if available, to their cart.

**********************
The Products Section
**********************

The products are presented to the user using a UICollectionView. Each product is contained in a UICollectionViewCell which contains a placeholder picture for the product along with a label for it's name and price.  If the user is unable to retrieve the list of products, they are presented with an error and prompted to try again.  Once a product is selected, the collection view cell segue's into a table view controller showing a detailed description of the product which includes it's name, price, category and stock availability. The user is also presented with the option to add the item to their wishlist or their cart using UIButtons. Any product can be added to to the user's wishlist regardless of how many are in stock. The user is unable to add more than the available stock to their cart. If the item is unavailable the user is no longer presented with the option to add the item to their cart. When the user selects add to cart, a POST request is fired. If an error response is received, nothing is done, if it's successful, an array of Clothes objects stores the users cart. 

Flow of views -> ClothesCollectionViewController (Main product view) -> ProductTableViewController (detailed product list)

ClothesCollectionViewController is comprised of ClothesCollectionViewCell

ProductTableViewController is comprised of ProductTableViewCell, PriceTableViewCell, CategoryTableViewCell, ShoeImageTableViewCell, AvailabilityTableViewCell and WishlistTableViewCell



**********************
The Wishlist
**********************

A user's wishlist is presented using a table view. Each cell in the wishlist displays the products name, price and a placeholder image. Additionally the user can add the item to their cart from their wishlist if it's available. If the item is no longer available the user is presented with an error message. Similar to the products section, a POST request is sent when the user adds an item to their cart. The user can delete any item in their wishlist by either using the Edit bar button or swiping to the left and hitting Delete.

WishListTableViewController is comprised of WishesTableViewCell

*********************
The Cart
*********************
The Cart is presented using a table view. Each cell in the cart displays the products name, price and a placeholder image. Additionally the user is able to delete any item from their cart which sends a DELETE request and deletes the item from the cart if the request is successful. The total price of the items in the cart is also presented in the last row of the table view. 

CartTableViewController is comprised of CartTableViewCell
