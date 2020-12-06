//
//  ShoppingGridViewController.swift
//  HappyRapidCart
//
//  Created by Maria Shehata on 12/4/20.
//

import UIKit
import Foundation
import AlamofireImage

class ShoppingGridViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var products = [[String:Any]]()
    var searchBarVariable = "apples"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self

        // modify layout
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumLineSpacing = 4
        layout.minimumInteritemSpacing = 4
        
        let width = (view.frame.size.width - layout.minimumInteritemSpacing * 2) / 3
        layout.itemSize =   CGSize(width: width, height: width * 3/2)
        
        
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
            if (error != nil) {
                print(error)
            } else if let data = data {
                let httpResponse = response as? HTTPURLResponse
                //print(httpResponse)
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                //print(dataDictionary)
                self.products = dataDictionary["products"] as! [[String : Any]]
                self.collectionView.reloadData()
                
                //print(self.products)

            }
        })

        dataTask.resume()
        
    }
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShoppingGridCell", for: indexPath) as! ShoppingGridCell
        
        let product = self.products[indexPath.item]
        let title = product["title"] as! String
        let priceDic = product["price"] as! [String: Any]
        let price = priceDic["formatted_current_price"] as! String
        let imageDic = product["images"] as! [String: Any]
        let imageURLString = imageDic["primaryUri"] as! String
        let imageURL = URL(string: imageURLString)
        
        cell.productLabel.text = title
        cell.priceLabel.text = price
        cell.productImage.af_setImage(withURL: imageURL!)

        // configure cell shape
        cell.productImage.layer.cornerRadius = 8
        cell.cellView.layer.cornerRadius = 8
        
        // shadow
        cell.cellView.layer.shadowColor = UIColor.black.cgColor
        cell.cellView.layer.shadowOffset = CGSize(width: 3, height: 3)
        cell.cellView.layer.shadowOpacity = 0.7
        cell.cellView.layer.shadowRadius = 4.0
        
        return cell

    }
    
    
    // layout function
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let height = view.frame.size.height
        let width = view.frame.size.width
        // in case you you want the cell to be 40% of your controllers view
        return CGSize(width: width * 0.4, height: height * 0.4)
    }


    // search bar functions
   
    func collectionView(_ collectionView: UICollectionView,viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView{
    let searchView: UICollectionReusableView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SearchBar", for: indexPath)

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
                if (error != nil) {
                    print(error)
                    //have no cells shown
                    // instead show a label saying "No items found"
                } else if let data = data {
                    let httpResponse = response as? HTTPURLResponse
                    //print(httpResponse)
                    let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                    //print(dataDictionary)
                    self.products = dataDictionary["products"] as! [[String : Any]]
                    self.collectionView.reloadData()
                    
                    //print(self.products)

                }
            })

            dataTask.resume()
        }

        
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
