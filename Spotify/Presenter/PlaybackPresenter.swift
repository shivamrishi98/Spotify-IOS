//
//  PlaybackPresenter.swift
//  Spotify
//
//  Created by Shivam Rishi on 05/03/21.
//

import Foundation
import UIKit
import AVFoundation

protocol PlayerDataSource:AnyObject {
    var songName:String? { get }
    var subTitle:String? { get }
    var imageURL:URL? { get }
}

final class PlaybackPresenter {
    
    static let shared = PlaybackPresenter()
    
    private var track:AudioTrack?
    private var tracks = [AudioTrack]()
    
    var currentTrack:AudioTrack? {
        if let track = track,
           tracks.isEmpty {
            return track
        } else if let player = self.playerQueue,
                  !tracks.isEmpty {
            let item = player.currentItem
            let items = player.items()
            guard let index = items.firstIndex(where: {
                $0 == item
            }) else {
                return nil
            }
            
            return tracks[index]
        }
        
        return nil
    }
    
    var player:AVPlayer?
    var playerQueue:AVQueuePlayer?
    
     func startPlayback(from viewController:UIViewController,
                              track:AudioTrack) {
        guard let url = URL(string: track.preview_url ?? "") else {
            return
        }
        player = AVPlayer(url: url)
        player?.volume = 0.5
        self.track = track
        self.tracks = []
        let vc = PlayerViewController()
        vc.title = track.name
        vc.dataSource = self
        vc.delegate = self
        viewController.present(
            UINavigationController(rootViewController: vc), animated: true) { [weak self] in
            self?.player?.play()
        }
        
    }
    
     func startPlayback(from viewController:UIViewController,
                              tracks:[AudioTrack]) {
        self.tracks = tracks
        self.track = nil
        
        let items:[AVPlayerItem] = tracks.compactMap({
            guard let url = URL(string: $0.preview_url ?? "") else {
                return nil
            }
            return AVPlayerItem(url: url)
        })
        
        playerQueue = AVQueuePlayer(items: items)
        playerQueue?.volume = 0.5
        
        let vc = PlayerViewController()
        vc.dataSource = self
        vc.delegate = self
        viewController.present(
            UINavigationController(rootViewController: vc), animated: true) { [weak self] in
            self?.playerQueue?.play()
        }
     }
    
}

extension PlaybackPresenter: PlayerViewControllerDelegate {
    
    func didTapPlayPause() {
        if let player = player {
            if player.timeControlStatus == .playing {
                player.pause()
            } else if player.timeControlStatus == .paused {
                player.play()
            }
        } else if let player = playerQueue {
            if player.timeControlStatus == .playing {
                player.pause()
            } else if player.timeControlStatus == .paused {
                player.play()
            }
        }
    }
    
    func didTapForward() {
        if tracks.isEmpty {
            // Not playlist or album
            player?.pause()
        } else if let player = playerQueue {
            player.advanceToNextItem()
        }
    }
    
    func didTapBackward() {
        if tracks.isEmpty {
            // Not playlist or album
            player?.pause()
            player?.play()
        } else if let firstItem = playerQueue?.items().first {
            
            playerQueue?.pause()
            playerQueue?.removeAllItems()
            playerQueue = AVQueuePlayer(items: [firstItem])
            playerQueue?.play()
            playerQueue?.volume = 0.5
        }
    }
    
    func didSlideSlider(_ value: Float) {
        player?.volume = value
    }
    
    
}

extension PlaybackPresenter: PlayerDataSource {
    
    var songName: String? {
        return currentTrack?.name
    }
    
    var subTitle: String? {
        return currentTrack?.artists.first?.name
    }
    
    var imageURL: URL? {
        return URL(string: currentTrack?.album?.images.first?.url ?? "")
    }
    
    
}


