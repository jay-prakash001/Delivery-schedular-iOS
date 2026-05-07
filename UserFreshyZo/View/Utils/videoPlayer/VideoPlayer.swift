import SwiftUI
import AVFoundation

struct AutoPlayVideoView: UIViewRepresentable {
    
    let url: URL
    
    func makeUIView(context: Context) -> PlayerContainerView {
        
        let view = PlayerContainerView()
        
        do {
            let session = AVAudioSession.sharedInstance()
            
            try session.setCategory(
                .playback,
                mode: .moviePlayback,
                options: []
            )
            
            try session.setActive(true)
            
        } catch {
            print("Audio Session Error:", error)
        }
        
        let player = AVPlayer(url: url)
        
        player.isMuted = false
        player.volume = 1.0
        
        view.player = player
        
        view.playerLayer.player = player
        view.playerLayer.videoGravity = .resizeAspectFill
        
        // autoplay
        player.play()
        
        // loop
        NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: player.currentItem,
            queue: .main
        ) { _ in
            
            player.seek(to: .zero)
            player.play()
        }
        
        return view
    }
    
    func updateUIView(
        _ uiView: PlayerContainerView,
        context: Context
    ) {}
}

final class PlayerContainerView: UIView {
    
    // STRONG reference
    var player: AVPlayer?
    
    override static var layerClass: AnyClass {
        AVPlayerLayer.self
    }
    
    var playerLayer: AVPlayerLayer {
        layer as! AVPlayerLayer
    }
    
    deinit {
        player?.pause()
    }
}
