//
//  BackgroundMusic.swift
//  Pierre The Penguin
//
//  Created by Siddharth Shekar on 25/11/17.
//  Copyright © 2017 Growl Games Studio. All rights reserved.
//

import AVFoundation

class BackgroundMusic: NSObject {
        // create the class as a singleton
        static let instance = BackgroundMusic()
        var musicPlayer = AVAudioPlayer()
    
    func playBackgroundMusic(){
        // Start the background music:
        if let musicPath = Bundle.main.path(forResource:"Sound/BackgroundMusic.m4a", ofType: nil) {
            let url = URL(fileURLWithPath: musicPath)
            
            do {
                musicPlayer = try AVAudioPlayer(contentsOf: url)
                musicPlayer.numberOfLoops = -1
                musicPlayer.prepareToPlay()
                musicPlayer.play()
            }
            catch { /* Couldn't load music file */ }
        }
        
        if isMuted(){
            pauseMusic()
        }
        
    }//playBackgroundMusic
    
    func pauseMusic(){
        UserDefaults.standard.set(true, forKey: "BackgroundMusicMuteState")
        musicPlayer.pause()
    }
    
    func playMusic(){
        UserDefaults.standard.set(false, forKey: "BackgroundMusicMuteState")
        musicPlayer.play()
    }
    
    // Check mute state
    func isMuted() -> Bool {
        if UserDefaults.standard.bool(forKey:"BackgroundMusicMuteState") {
            return true
        } else {
            return false
        }
    }
    
    func setVolume(volume: Float){
        
        musicPlayer.volume = volume
    }
}

