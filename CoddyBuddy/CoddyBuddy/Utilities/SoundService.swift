//  SoundService.swift
//  Created by Aum Chauhan on 11/08/23.

import Foundation
import AVKit

class SoundService {
    private init() { }
    
    static var music: AVAudioPlayer?
    
    static func playSound() {
        if let AudioPathURL = Bundle.main.url(forResource: "copy", withExtension: ".mp3"){
            do {
                music = try AVAudioPlayer(contentsOf: AudioPathURL)
                music?.play()
            } catch let error {
                print("\(error.localizedDescription)")
            }
        }
    }
}
