//
//  AVAudioPlayer+Additions.swift
//  Glowing Spheres
//
//  Created by Martin List on 21.01.24.
//  Copyright © 2024 Martin List. All rights reserved.
//

import AVFoundation

final class AudioPlayer {
    static var main = AudioPlayer()

    private var themeSong: AVAudioPlayer?
    private var soundEffect: AVAudioPlayer?

    private init() {
        let themePath = Bundle.main.path(forResource: "Theme", ofType: "m4a") ?? ""
        let themeURL = URL(fileURLWithPath: themePath)
        self.themeSong = try? AVAudioPlayer(contentsOf: themeURL)

        themeSong?.volume = 0.3
        themeSong?.numberOfLoops = -1

        let soundPath = Bundle.main.path(forResource: "Matched", ofType: "wav") ?? ""
        let soundURL = URL(fileURLWithPath: soundPath)
        soundEffect = try? AVAudioPlayer(contentsOf: soundURL)

        try? AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default)
        try? AVAudioSession.sharedInstance().setActive(true)
    }

    public func playThemeSong() {
        if !(themeSong?.isPlaying ?? true) {
            themeSong?.play()
        }
    }

    public func stopThemeSong() {
        themeSong?.stop()
    }

    public func playSoundEffect() {
        soundEffect?.prepareToPlay()
        soundEffect?.play()
    }
}
