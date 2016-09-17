//
//  MusicPlayer.swift
//  SongBar
//
//  Created by Francisco Arrieta on 9/10/16.
//  Copyright © 2016 lil9porkchop. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

enum MusicStatus {
    case play
    case pause
}

class MusicPlayer {
    
    static var audioPlay: AVPlayer!
    static var musicStatus: MusicStatus = .pause
    static var playView: UIView?
    static var titleLabel: UILabel?
    static var playButton: UIButton?
    static var detailLabel: UILabel?
    
    static func playSong(_ track: SpotifyTrack) {
        if let url = URL(string: track.previewUrl) {
            audioPlay = AVPlayer(url: url)
            audioPlay.play()
            musicStatus = .play
            playView?.isHidden = false
            titleLabel?.text = track.title
            detailLabel?.text = track.artist
            let image = UIImage(named: "pause")
            playButton?.setImage(image, for: UIControlState())
        }
    }
    
}
