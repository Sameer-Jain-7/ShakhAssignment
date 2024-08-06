//
//  MyCell.swift
//  AssignmentShakh
//
//  Created by Sameer Jain on 06/08/24.
//

import UIKit
import AVKit

class MyCell: UICollectionViewCell {
    @IBOutlet weak var thumbnail1: UIImageView!
    @IBOutlet weak var thumbnail2: UIImageView!
    @IBOutlet weak var thumbnail3: UIImageView!
    @IBOutlet weak var thumbnail4: UIImageView!
    
    @IBOutlet weak var innerView: UIView!
    
    private var playerLayers: [AVPlayerLayer] = []
    private var videoURLs: [String] = []
    private var currentVideoIndex = 0
    private var playbackTimer: Timer?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupThumbnailViews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        stopPlayback()
    }
    
    func configureWithVideos(_ videos: [Video]) {
        stopPlayback()
        
        playerLayers.forEach { $0.removeFromSuperlayer() }
        playerLayers.removeAll()
        
        videoURLs = videos.map { $0.video }
        
        let thumbnails = [thumbnail1, thumbnail2, thumbnail3, thumbnail4]
        for (index, video) in videos.enumerated() {
            if index < thumbnails.count {
                let imageView = thumbnails[index]
                loadImage(from: video.thumbnail) { image in
                    imageView?.image = image
                }
            }
        }
        
        playVideosSequentially()
    }
    
    private func setupThumbnailViews() {
        [thumbnail1, thumbnail2, thumbnail3, thumbnail4].forEach { imageView in
            imageView?.contentMode = .scaleAspectFill
            imageView?.clipsToBounds = true
        }
    }
    
    private func loadImage(from url: String, completion: @escaping (UIImage?) -> Void) {
        guard let imageUrl = URL(string: url) else {
            completion(UIImage(named: "placeholder"))
            return
        }
        
        URLSession.shared.dataTask(with: imageUrl) { data, response, error in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    completion(image)
                }
            } else {
                DispatchQueue.main.async {
                    completion(UIImage(named: "placeholder"))
                }
            }
        }.resume()
    }
    
    private func playVideosSequentially() {
        guard !videoURLs.isEmpty else { return }
        
        playbackTimer?.invalidate()
        currentVideoIndex = 0
        
        playNextVideo()
    }
    
    private func playNextVideo() {
        guard currentVideoIndex < videoURLs.count else {
            currentVideoIndex = 0
            playNextVideo()
            return
        }
        
        let videoURL = videoURLs[currentVideoIndex]
        let thumbnail = [thumbnail1, thumbnail2, thumbnail3, thumbnail4][currentVideoIndex]
        
        playVideo(from: videoURL, in: thumbnail) { [weak self] in
            self?.currentVideoIndex += 1
            self?.playNextVideo()
        }
    }
    
    private func playVideo(from url: String, in imageView: UIImageView?, completion: @escaping () -> Void) {
        guard let videoURL = URL(string: url) else { return }
        let player = AVPlayer(url: videoURL)
        player.rate = 2.0
        
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = imageView?.bounds ?? .zero
        playerLayer.videoGravity = .resizeAspectFill
        imageView?.layer.addSublayer(playerLayer)
        playerLayers.append(playerLayer)
        
        player.play()
        
        playbackTimer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { _ in
            player.pause()
            playerLayer.removeFromSuperlayer()
            completion()
        }
    }
    
    private func stopPlayback() {
        playbackTimer?.invalidate()
        playerLayers.forEach { $0.removeFromSuperlayer() }
        playerLayers.removeAll()
    }
}
