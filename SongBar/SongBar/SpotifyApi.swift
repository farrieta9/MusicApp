//
//  SpotifyApi.swift
//  SongBar
//
//  Created by Francisco Arrieta on 9/10/16.
//  Copyright © 2016 lil9porkchop. All rights reserved.
//

import Foundation

class SpotifyApi {
    
    static let spotifyBaseAPI = "https://api.spotify.com/v1/search?&type=track&limit=20&q="
    
    static func search(query: String, completion: (tracks: [SpotifyTrack]) -> Void) {
        //        print("You entered: " + query)
        
        
        guard let escapedQuery = query.stringByAddingPercentEncodingWithAllowedCharacters(
            .URLHostAllowedCharacterSet()),
            let url = NSURL(string: spotifyBaseAPI + escapedQuery)
            else {
                return
        }
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) {
            (data, response, error) in
            
            if error != nil {
                print("Error: \(error!.code.description)")
                return
            }
            
            var json: [String: AnyObject]
            do {
                json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! [String : AnyObject]
            } catch {
                return
            }
            
            let tracks = parseTracksFrom(json)
            
            completion(tracks: tracks)
        }
        task.resume()
    }
    
    static func parseTracksFrom(json: [String: AnyObject]) -> [SpotifyTrack] {
        var tracks = [SpotifyTrack]()
        guard let jsonTracks = json["tracks"] as? [String: AnyObject],
            let jsonItems = jsonTracks["items"] as? [[String: AnyObject]]
            else {
                return tracks
        }
        for jsonItem in jsonItems {
            tracks.append(SpotifyTrack(itemJSON: jsonItem))
        }
        
        return tracks
    }
}