//
//  FullScreenVideoView.swift
//  CodeBase
//
//  Created by Алихан  on 25.02.2025.
//

import SwiftUI
import AVKit

struct FullScreenVideoView: View {
    let videoURL: URL
    let onDismiss: () -> Void
    
    @State private var player: AVPlayer? = nil
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            if let player = player {
                VideoPlayer(player: player)
                    .ignoresSafeArea()
                    .onAppear {
                        player.volume = 1.0
                        player.play()
                    }
            } else {
                ProgressView()
                    .onAppear {
                        let newPlayer = AVPlayer(url: videoURL)
                        newPlayer.volume = 1.0
                        self.player = newPlayer
                        newPlayer.play()
                    }
            }
            
            Button(action: {
                onDismiss()
            }) {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 30))
                    .foregroundColor(.white)
                    .padding()
            }
        }
        .onAppear {
            do {
                try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
                try AVAudioSession.sharedInstance().setActive(true)
            } catch {
                print("Audio session setup error: \(error)")
            }
        }
    }
}


