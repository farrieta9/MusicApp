//
//  Extensions.swift
//  SongBar
//
//  Created by Francisco Arrieta on 9/5/16.
//  Copyright © 2016 lil9porkchop. All rights reserved.
//

import UIKit

extension UIColor {
	static func rgb(_ red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
		return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
	}
}


let imageCache = NSCache()  // Rename to cachedImages
extension UIImageView {
    func loadImageUsingURLString(_ urlString: String) {
        let url = URL(string: urlString)
        
        image = nil
        image = UIImage(named: "default_profile.png")
        
        if let imageFromCache = imageCache.object(forKey: urlString) as? UIImage {
            self.image = imageFromCache
            return
        }
        
        if urlString == "" {
            return // has no image in firebase
        }
        
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            if error != nil {
                print(error)
                return
            }
            DispatchQueue.main.async(execute: {
                
                let imageToCache = UIImage(data: data!)
                
                imageCache.setObject(imageToCache!, forKey: urlString)
                
                self.image = imageToCache
            })
            }) .resume()
    }
}

extension Date {
    
    func getElapsedInterval() -> String {
        
        var interval = (Calendar.current as NSCalendar).components(.year, from: self, to: Date(), options: []).year
        
        if interval! > 0 {
            return interval == 1 ? "\(interval)" + " " + "year" :
                "\(interval)" + "yr ago"
        }
        
        interval = (Calendar.current as NSCalendar).components(.month, from: self, to: Date(), options: []).month
        if interval! > 0 {
            return interval == 1 ? "\(interval)" + " " + "month" :
                "\(interval)" + "m"
        }
        
        interval = (Calendar.current as NSCalendar).components(.day, from: self, to: Date(), options: []).day
        if interval! > 0 {
            return interval == 1 ? "\(interval)" + " " + "day" :
                "\(interval)" + "d"
        }
        
        interval = (Calendar.current as NSCalendar).components(.hour, from: self, to: Date(), options: []).hour
        if interval! > 0 {
            return interval == 1 ? "\(interval)" + " " + "hour" :
                "\(interval)" + "h"
        }
        
        interval = (Calendar.current as NSCalendar).components(.minute, from: self, to: Date(), options: []).minute
        if interval! > 0 {
            return interval == 1 ? "\(interval)" + " " + "minute" :
                "\(interval)" + " min"
        }
        
        return "a moment ago"
    }
}
