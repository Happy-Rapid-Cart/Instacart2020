//
//  CartViewController.swift
//  HappyRapidCart
//
//  Created by Jasmine Omeke on 12/5/20.
//

import UIKit
import Parse
import AlamofireImage

class CartViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    
    
    @IBOutlet weak var cartTableView: UITableView!
    var products = [PFObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cartTableView.delegate = self
        cartTableView.dataSource = self

        // Do any additional setup after loading the view.
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // use Parse
        let query = PFQuery(className: "Cart")
        query.includeKey("user_id")
        query.limit = 20 //get the last 20 items
        
        query.findObjectsInBackground { (products, error) in
            if products != nil {
                self.products = products!
                self.cartTableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cartTableCell") as! CartCell
        let product = products[indexPath.row]
        
        
        cell.productTitleLabel.text = product["product_name"] as? String
        cell.priceLabel.text = product["price"] as? String
        cell.quantityTextField.text = product["product_quantity"] as? String
        cell.productSizeLabel.text = product["product_size"] as? String
        
        let imageFile = product["product_image"] as! PFFileObject
        let urlString = imageFile.url!
        let url = URL(string: urlString)!
        
        cell.productImage?.af_setImage(withURL: url)
        
        
        return cell
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
