//
//  VSVideoSpeeder.swift
//  Reely - Create Transform & Donate
//
//  Created by MacBook Air on 28/05/1943 Saka.
//

import UIKit
import AVFoundation

enum SpeedoMode {
    case Slower
    case Faster
}

class VSVideoSpeeder: NSObject {
    
    /// Singleton instance of `VSVideoSpeeder`
    static var shared: VSVideoSpeeder = {
       return VSVideoSpeeder()
    }()

    /// Range is b/w 1x, 2x and 3x. Will not happen anything if scale is out of range. Exporter will be nil in case url is invalid or unable to make asset instance.
    func scaleAsset(fromURL url: URL,  by scale: Int64, withMode mode: SpeedoMode, completion: @escaping (_ exporter: AVAssetExportSession?) -> Void) {

        /// Check the valid scale
        if scale < 1 || scale > 3 {
            /// Can not proceed, Invalid range
            completion(nil)
            return
        }

        /// Asset
        let asset = AVAsset(url: url)

        /// Video Tracks
        let videoTracks = asset.tracks(withMediaType: AVMediaType.video)
        if videoTracks.count == 0 {
            /// Can not find any video track
            completion(nil)
            return
        }

        /// Get the scaled video duration
        let scaledVideoDuration = (mode == .Faster) ? CMTimeMake(value: asset.duration.value / scale, timescale: asset.duration.timescale) : CMTimeMake(value: asset.duration.value * scale, timescale: asset.duration.timescale)
        let timeRange = CMTimeRangeMake(start: CMTime.zero, duration: asset.duration)

        /// Video track
        let videoTrack = videoTracks.first!

        let mixComposition = AVMutableComposition()
        let compositionVideoTrack = mixComposition.addMutableTrack(withMediaType: AVMediaType.video, preferredTrackID: kCMPersistentTrackID_Invalid)

        /// Audio Tracks
        let audioTracks = asset.tracks(withMediaType: AVMediaType.audio)
        if audioTracks.count > 0 {
            /// Use audio if video contains the audio track
            let compositionAudioTrack = mixComposition.addMutableTrack(withMediaType: AVMediaType.audio, preferredTrackID: kCMPersistentTrackID_Invalid)

            /// Audio track
            let audioTrack = audioTracks.first!
            do {
                try compositionAudioTrack?.insertTimeRange(timeRange, of: audioTrack, at: CMTime.zero)
                compositionAudioTrack?.scaleTimeRange(timeRange, toDuration: scaledVideoDuration)
            } catch _ {
                /// Ignore audio error
            }
        }

        do {
            try compositionVideoTrack?.insertTimeRange(timeRange, of: videoTrack, at: CMTime.zero)
            compositionVideoTrack?.scaleTimeRange(timeRange, toDuration: scaledVideoDuration)

            /// Keep original transformation
            compositionVideoTrack?.preferredTransform = videoTrack.preferredTransform

            /// Initialize Exporter now
            let outputFileURL : NSURL = NSURL(fileURLWithPath: NSHomeDirectory() + "/Documents/reelyVideo\(Date()).mp4")
           /// Note:- Please use directory path if you are testing with device.

            do { // delete old video
                try FileManager.default.removeItem(at: outputFileURL as URL)
            } catch { print(error.localizedDescription) }
            
            UserDefaults.standard.set(outputFileURL as URL, forKey: "finalVideo")
            
            let exporter = AVAssetExportSession(asset: mixComposition, presetName: AVAssetExportPresetHighestQuality)
            exporter?.outputURL = outputFileURL as URL
            exporter?.outputFileType = AVFileType.mov
            exporter?.shouldOptimizeForNetworkUse = true
            exporter?.exportAsynchronously(completionHandler: {
                completion(exporter)
            })

            
        } catch let error {
           // print(error.localizedDescription)
            completion(nil)
            return
        }
    }

}
