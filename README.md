# ![cart](https://user-images.githubusercontent.com/49815957/99154934-a07b3d80-2681-11eb-9d2c-c64aa2152f46.jpg)
 Instacart2020
Delivery iOS mobile app

![Build](https://github.com/Happy-Rapid-Cart/Instacart2020/workflows/Build/badge.svg?)

# Happy Rapid Cart
Unit 8: Group Milestone README



## Table of Contents
1. [Overview](#Overview)
1. [Product Spec](#Product-Spec)
1. [Wireframes](#Wireframes)

## Overview
### Description
Aggregates grocery store options and matches user to a store they'd like to submit a grocery order to. 

### App Evaluation
- **Category:** Shopping
- **Mobile:** This app would be primarily developed for mobile.
- **Story:** Allows user to specify choose a nearby grocery store to purchase items for quick delivery. Additionally, a user may pick a favorite item and see which stores have it. Once given that information, they can proceed to purchase from the store that has the specific item they need. This saves the user's time from having to click into each nearby store to see if they have the item.
- **Market:** Users of all ages, but we'd specifically target primary grocery shoppers of the household.
- **Habit:** This app would be used at the same freuency the user completes grocery shopping on a weekly, bi-weekly, or monthly cadence.
- **Scope:** First we match users to their nearby stores. Then we allow the user to filter stores that have their favorite item.

## Product Spec
### 1. User Stories (Required and Optional)

**Required Must-have Stories**

* User opens the app 
* User logs in to see previous grocery purchases and preferences; They hae an easy way to re-order
* User selects a store to buy 
* User adds food items to their cart
* User can examine what's in their cart

**Optional Nice-to-have Stories**

* Log of past purchases
* Log of past purchases by diet or food type
* User taps recipe idea and those items are assembled in their cart from the nearest store
* User messages with shopper while cart is being shopped for.
* User picks a favorite food they like. Then they are shown, in a subsequent screen, which stores have that time.

### 2. Screen Archetypes


* Stores list screen (Stream)
     * Here the user can view a list of the nearby stores based on the user's location.
     *  The use user can pick a store to shop from.
     *   Each store cell will have a logo photo, store's name, and a description sentence.
     *    The screen will be a table view of the stores.
 
 
* Shopping Grid (Stream)
   * The user can shop online products.
   * The user can search product's by names or brands.
   * Each product has a picture, name, and price.
   * Flying products to the cart animation whenever the user add products.
   * The screen is a collection view of product cells.

### 3. Navigation (template still below)

**Tab Navigation** (Tab to Screen)

* Tab a store to go to the shopping products screen


**Flow Navigation** (Screen to Screen)
* stores list -> shopping screen


## Wireframes

![D1A986DC-A970-43A1-9196-ED21282B72F5](https://user-images.githubusercontent.com/49815957/99134913-d242c480-25ed-11eb-8bb1-cc7481433b18.jpeg)

![Screen Shot 2020-11-13 at 8 22 21 PM](https://user-images.githubusercontent.com/49815957/99134944-fbfbeb80-25ed-11eb-9ef9-2fcb92a80dde.png)

## Networking

* List of network requests by screen
 * Stores List Screen
   * (Read/GET) Query all grocery stores where user is located
    ```swift
     import Foundation

    let headers = [
     "x-rapidapi-key": "424a32be03msha7607291c170bf5p1b1afejsnf0c2172df00d",
     "x-rapidapi-host": "trueway-places.p.rapidapi.com"
    ]

    let request = NSMutableURLRequest(url: NSURL(string: "https://trueway-places.p.rapidapi.com/FindPlacesNearby?location=37.783366%2C-122.402325&type=cafe&radius=150&language=en")! as URL,
                                            cachePolicy: .useProtocolCachePolicy,
                                        timeoutInterval: 10.0)
    request.httpMethod = "GET"
    request.allHTTPHeaderFields = headers

    let session = URLSession.shared
    let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
     if (error != nil) {
      print(error)
     } else {
      let httpResponse = response as? HTTPURLResponse
      print(httpResponse)
     }
    })

    dataTask.resume()
    ```
    
   
 * Shopping Grid Screen
   * (Read/GET) Query all grocery products based on the user input in the search bar
   ```swift
   import Foundation

   let headers = [
    "x-rapidapi-key": "424a32be03msha7607291c170bf5p1b1afejsnf0c2172df00d",
    "x-rapidapi-host": "target1.p.rapidapi.com"
   ]

   let request = NSMutableURLRequest(url: NSURL(string: "https://target1.p.rapidapi.com/products/list?storeId=911&endecaId=5xtg6&sortBy=relevance&pageSize=20&searchTerm=apples&pageNumber=1")! as URL,
                                           cachePolicy: .useProtocolCachePolicy,
                                       timeoutInterval: 10.0)
   request.httpMethod = "GET"
   request.allHTTPHeaderFields = headers

   let session = URLSession.shared
   let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
    if (error != nil) {
     print(error)
    } else {
     let httpResponse = response as? HTTPURLResponse
     print(httpResponse)
    }
   })

   dataTask.resume()
   ```
   
   ### Existing API Endpoints
   * Base URL - target1.p.rapidapi.com
   
   |HTTP Verb|Endpoint|Description|
   ||products/list?storeId=911&endecaId=5xtg6&sortBy=relevance&pageSize=20&searchTerm=apples&pageNumber=1|get all products that include the dearch term|


   * Base URL - trueway-places.p.rapidapi.com
   |HTTP Verb|Endpoint|Description|
   ||FindPlacesNearby?location=37.783366%2C-122.402325&type=cafe&radius=150&language=en|get all stoes based on the location|
