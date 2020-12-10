//
//  ShoppingGridViewController.swift
//  HappyRapidCart
//
//  Created by Maria Shehata on 12/4/20.
//

import UIKit
import Foundation
import AlamofireImage
import Parse

class ShoppingGridViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate, ProductCellDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var cartImage: UIImage!
    var lableNoOfCartItem: UILabel!
    var counterItem = 0
    
    var products = [[String:Any]]()
    //var productsToBuy = [[String:Any]]()
    var searchBarVariable = "cereal"
    var clickedProduct: IndexPath? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self

        // modify layout
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        
        
        let width = (view.frame.size.width - layout.minimumInteritemSpacing * 2) / 2
        //let width = view.frame.size.width / 2
        layout.itemSize =   CGSize(width: width, height: width)
        
        
        // network call for the products
        let headers = [
            "x-rapidapi-host": "target1.p.rapidapi.com",
            "x-rapidapi-key": "424a32be03msha7607291c170bf5p1b1afejsnf0c2172df00d"
        ]
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://target1.p.rapidapi.com/products/list?sortBy=relevance&pageSize=20&searchTerm=\(searchBarVariable)&pageNumber=3&storeId=911&endecaId=5xtg6")! as URL, cachePolicy: .useProtocolCachePolicy,timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            
            if let error = error{
                print(error.localizedDescription)
                //self.products = []
                //have no cells shown
                // instead show a label saying "No items found"
            } else if let data = data {
                let httpResponse = response as? HTTPURLResponse
                print(httpResponse?.statusCode)
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                print(dataDictionary)
                if dataDictionary["products"] != nil {
                    self.products = dataDictionary["products"] as! [[String : Any]]
                    
                }
                else {
                    self.products = []
                    
                }
                self.collectionView.reloadData()
                
                //print(self.products)

            }

        })

        dataTask.resume()
        
    }
    
    
    func productClicked(_ tag: Int) {
        
        print("we begin")
   
        //performSegue(withIdentifier: "viewProfile", sender: self)
        let product = self.products[tag]
        let title = product["title"] as! String
        
        let range = title.range(of: "-")
        
        var finalTitle = title
        if title.contains("-"){
           finalTitle = title.substring(to: range!.lowerBound)
        }
        
        if finalTitle.contains("&#38;"){
            let rangeTitle = finalTitle.range(of: "&#38;")
            finalTitle = finalTitle.substring(to: rangeTitle!.lowerBound)
        }
        
        var size  = ""
        if title.contains("-"){
            size = title.substring(from: range!.upperBound)
        }
        
        if size.contains("-"){
            let rangeSize = size.range(of: "-")
            size = size.substring(to: rangeSize!.lowerBound)
        }
        
        let priceDic = product["price"] as! [String: Any]
        let price = priceDic["formatted_current_price"] as! String
        let imageDic = product["images"] as! [String: Any]
        let imageURLString = imageDic["primaryUri"] as! String
        
        
        
        let imageData = NSData.init(contentsOf: NSURL(string: imageURLString) as! URL)
        let picture = PFFileObject(name: "product.png", data: imageData! as Data)
        
        //query
        
        
        // Add new entry if not found
        let cart = PFObject(className: "Cart")
        cart["user_id"] = PFUser.current()!
        cart["product_name"] = finalTitle
        cart["product_image"] = picture
        cart["product_size"] = size
        cart["price"] = price
        cart["product_quantity"] = 1
        
        cart.saveInBackground { (success, error) in
            if success {
                print("saved!")
                
            } else {
                print(error!.localizedDescription)
            }
        }
        
        // animation part
        
        /*
        let buttonPosition : CGPoint = sender.convert(sender.bounds.origin, to: self.tableViewProduct)
        let indexPath = self.tableViewProduct.indexPathForRow(at: buttonPosition)!
        let cell = collectionView.cellForRow(at: indexPath) as! ShoppingGridCell
        let imageViewPosition : CGPoint = cell.imageViewProduct.convert(cell.imageViewProduct.bounds.origin, to: self.view)
        let imgViewTemp = UIImageView(frame: CGRect(x: imageViewPosition.x, y: imageViewPosition.y, width: cell.imageViewProduct.frame.size.width, height: cell.imageViewProduct.frame.size.height))
        
        imgViewTemp.image = cell.imageViewProduct.image
        
        animation(tempView: imgViewTemp)
         */
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    
    /*
    @IBAction func addProductToCartArr(_ sender: Any) {
        print("add item")
        let cell = sender as! UICollectionViewCell
        let indexPath = collectionView.indexPath(for: cell)
        let product = self.products[indexPath!.item]
        self.productsToBuy.append(product)
    }
 */
    
    
    
 
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShoppingGridCell", for: indexPath) as! ShoppingGridCell
        cell.delegate = self
        cell.addButton.tag = indexPath.item
        
        
        let product = self.products[indexPath.item]
        let title = product["title"] as! String
        
        let range = title.range(of: "-")
        
        var finalTitle = title
        if title.contains("-"){
           finalTitle = title.substring(to: range!.lowerBound)
        }
        
        if finalTitle.contains("&#38;"){
            let rangeTitle = finalTitle.range(of: "&#38;")
            finalTitle = finalTitle.substring(to: rangeTitle!.lowerBound)
        }
        
        var size  = ""
        if title.contains("-"){
            size = title.substring(from: range!.upperBound)
        }
        
        if size.contains("-"){
            let rangeSize = size.range(of: "-")
            size = size.substring(to: rangeSize!.lowerBound)
        }
        
        let priceDic = product["price"] as! [String: Any]
        let price = priceDic["formatted_current_price"] as! String
        let imageDic = product["images"] as! [String: Any]
        let imageURLString = imageDic["primaryUri"] as! String
        let imageURL = URL(string: imageURLString)
        
        cell.productLabel.text = finalTitle
        cell.priceLabel.text = price
        cell.productImage.af_setImage(withURL: imageURL!)
        cell.productSizer.text = size

        // configure cell shape
        cell.productImage.layer.cornerRadius = 8
        cell.cellView.layer.cornerRadius = 8
        
        cell.contentView.layer.borderWidth = 1
        
        // shadow
        cell.contentView.layer.borderColor = UIColor.clear.cgColor
        cell.layer.shadowColor = UIColor.black.cgColor
        
        cell.layer.shadowOffset = CGSize(width: 3, height: 3)
        cell.layer.shadowOpacity = 0.7
        cell.layer.shadowRadius = 4.0
       
        cell.contentView.layer.masksToBounds = true
        cell.layer.masksToBounds = false
       // cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, byRoundingCorners: cell.contentView.layer.cornerRadius).cgPath
        
        return cell

    }
    
    
    // layout function
    /*
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let height = view.frame.size.height
        let width = view.frame.size.width
        // in case you you want the cell to be 40% of your controllers view
        return CGSize(width: width * 0.4, height: height * 0.4)
    }
    */


    // search bar functions
   
    func collectionView(_ collectionView: UICollectionView,viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView{
    let searchView: UICollectionReusableView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SearchBar", for: indexPath) as! SearchBarView
        
        // shape of cart counter label in the header seaction
    
        //searchView.lableNoOfCartItem.layer.cornerRadius = lableNoOfCartItem.frame.size.height / 2
        //searchView.lableNoOfCartItem.clipsToBounds = true
        

        return searchView
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    
    
        if (searchBar.text!.isEmpty) {
            print("search bar text is empty")

        }else{
            self.searchBarVariable = searchBar.text!
            print("self.searchBarVariable =", self.searchBarVariable)
            // network request
            let headers = [
                "x-rapidapi-host": "target1.p.rapidapi.com",
                "x-rapidapi-key": "424a32be03msha7607291c170bf5p1b1afejsnf0c2172df00d"
            ]
            
            let request = NSMutableURLRequest(url: NSURL(string: "https://target1.p.rapidapi.com/products/list?sortBy=relevance&pageSize=20&searchTerm=\(searchBarVariable)&pageNumber=1&storeId=911&endecaId=5xtg6")! as URL, cachePolicy: .useProtocolCachePolicy,timeoutInterval: 10.0)
            request.httpMethod = "GET"
            request.allHTTPHeaderFields = headers

            let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
            let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                if let error = error{
                    print(error.localizedDescription)
                    //self.products = []
                    //have no cells shown
                    // instead show a label saying "No items found"
                } else if let data = data {
                    //let httpResponse = response as? HTTPURLResponse
                    //print(httpResponse)
                    let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                    //print(dataDictionary)
                    if dataDictionary["products"] != nil {
                        self.products = dataDictionary["products"] as! [[String : Any]]
                        
                    }
                    else {
                        self.products = []
                        
                    }
                    self.collectionView.reloadData()
                    
                    //print(self.products)

                }
            })

            dataTask.resume()
        }

        
    }
    
    
    
    // animatim function
    /*
    func animation(tempView : UIView)  {
        self.view.addSubview(tempView)
        UIView.animate(withDuration: 1.0,
                       animations: {
                        tempView.animationZoom(scaleX: 1.5, y: 1.5)
        }, completion: { _ in
            
            UIView.animate(withDuration: 0.5, animations: {
                
                tempView.animationZoom(scaleX: 0.2, y: 0.2)
                tempView.animationRoted(angle: CGFloat(Double.pi))
                
                tempView.frame.origin.x = self.buttonCart.frame.origin.x
                tempView.frame.origin.y = self.buttonCart.frame.origin.y
                
            }, completion: { _ in
                
                tempView.removeFromSuperview()
                
                UIView.animate(withDuration: 1.0, animations: {
                    
                    self.counterItem += 1
                    self.lableNoOfCartItem.text = "\(self.counterItem)"
                    self.buttonCart.animationZoom(scaleX: 1.4, y: 1.4)
                }, completion: {_ in
                    self.buttonCart.animationZoom(scaleX: 1.0, y: 1.0)
                })
                
            })
            
        })
    }
 
 */
    
    // MARK: - Navigation
    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        print("Loading up cart view")
        let cartViewController = segue.destination as! CartViewController
        cartViewController.products = self.productsToBuy
    }
 */
    
    

}



// extension for the animation
extension UIView{
    func animationZoom(scaleX: CGFloat, y: CGFloat) {
        self.transform = CGAffineTransform(scaleX: scaleX, y: y)
    }
    
    func animationRoted(angle : CGFloat) {
        self.transform = self.transform.rotated(by: angle)
    }
}
