//
//  Supermarkets.swift
//  HappyRapidCart
//
//  Created by Jasmine Omeke on 12/9/20.
//

import Foundation
import AlamofireImage

class Supermarket {
    var name: String
    var image: UIImage

    init(dict: [String: Any]) {
        name = dict["name"] as! String
        image = Supermarket.getImage(name: name)

    }

    
    //Helper function to get the first category from the restaurant
    static func getImage(name: String) -> UIImage{
            let size = CGSize(width: 148, height: 100)
            let scaledImage = UIImage(named: "store")?.af_imageScaled(to: size)
            
            var finalImage = scaledImage
            
            // check for store names
            let storeNames = ["Walmart", "ALDI", "Publix", "Whole Foods", "Family Dollar", "Jumbo", "Garden Marketplace", "Mi Gente", "Oriental Market", "Oriental Supermarket"]
            for store in storeNames{
                if name.contains(store) {
                    finalImage = UIImage(named: store)?.af_imageScaled(to: size)
                }
            }
        return finalImage!
        }
    
}
