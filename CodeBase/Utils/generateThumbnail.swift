//
//  generateThumbnail.swift
//  CodeBase
//
//  Created by Алихан  on 25.02.2025.
//

import AVFoundation
import UIKit

func generateThumbnail(from url: URL, completion: @escaping (UIImage?) -> Void) {
    DispatchQueue.global().async {
        let asset = AVAsset(url: url)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.appliesPreferredTrackTransform = true
        imageGenerator.requestedTimeToleranceAfter = .zero
        imageGenerator.requestedTimeToleranceBefore = .zero
        let time = CMTime(seconds: 0.1, preferredTimescale: 600)
        do {
            let cgImage = try imageGenerator.copyCGImage(at: time, actualTime: nil)
            let thumbnail = UIImage(cgImage: cgImage)
            DispatchQueue.main.async {
                completion(thumbnail)
            }
        } catch {
            print("Preview generation error: \(error)")
            DispatchQueue.main.async {
                completion(nil)
            }
        }
    }
}


