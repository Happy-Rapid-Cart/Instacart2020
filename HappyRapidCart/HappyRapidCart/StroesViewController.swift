//
//  StroesViewController.swift
//  HappyRapidCart
//
//  Created by Maria Shehata on 11/26/20.
//

import UIKit
import Foundation

class StroesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var tableView: UITableView!
    
    var supermarkets: [Supermarket] = []
    var searchBarVariable = "cereal"
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var filteredSuperMarkets: [Supermarket] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self

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
                print(error!)
            } else if let data = data {
                 let httpResponse = response as? HTTPURLResponse
                 //print(httpResponse)
                 let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                 //print(dataDictionary)
                 let results = dataDictionary["results"] as! [[String : Any]]
                self.supermarkets = results
                self.filteredSuperMarkets = results
                
                 self.tableView.reloadData()

            }
        })

        dataTask.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredSuperMarkets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StoreCell") as! StoreCell
        let supermarket = self.filteredSuperMarkets[indexPath.row]
        
        
        cell.s = supermarket
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 120
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

extension StroesViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != "" {
            filteredSuperMarkets = supermarkets.filter{(s: Supermarket) -> Bool in
                return s.name.lowercased().contains(searchText.lowercased())
            }
        }
        else {
            filteredSuperMarkets = supermarkets
        }
        tableView.reloadData()
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
    }

    // when search bar cancel button is clicked
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder() //remove keyboard
        filteredSuperMarkets = supermarkets
        tableView.reloadData()
    }
}
