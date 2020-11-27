//
//  StroesViewController.swift
//  HappyRapidCart
//
//  Created by Maria Shehata on 11/26/20.
//

import UIKit
import Foundation

class StroesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var supermarkets = [[String:Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self

        let headers = [
            "x-rapidapi-host": "trueway-places.p.rapidapi.com",
            "x-rapidapi-key": "424a32be03msha7607291c170bf5p1b1afejsnf0c2172df00d"
        ]

        let request = NSMutableURLRequest(url: NSURL(string: "https://trueway-places.p.rapidapi.com/FindPlacesNearby?type=supermarket&radius=10000&language=en&location=27.3859013%252C-82.56020378")! as URL,cachePolicy: .reloadIgnoringLocalCacheData,timeoutInterval: 10.0)
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
                 self.supermarkets = dataDictionary["results"] as! [[String : Any]]
                
                 self.tableView.reloadData()

            }
        })

        dataTask.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return supermarkets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StoreCell") as! StoreCell
        let supermarket = self.supermarkets[indexPath.row]
        let name = supermarket["name"] as! String
        
        cell.storeLabel.text = name
        cell.storeImage.image = UIImage(named: "store")
        
        // check for store names
        let storeNames = ["Walmart", "ALDI", "Publix", "Whole Foods"]
        for store in storeNames{
            if name.contains(store) {
                cell.storeImage.image = UIImage(named: store)
            }
        }
        
        // configure cell shape
        cell.storeView.layer.cornerRadius = 8
        cell.storeImage.layer.cornerRadius = 8
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 100
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
