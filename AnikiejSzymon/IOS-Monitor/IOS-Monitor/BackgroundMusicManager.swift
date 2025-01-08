import AVFoundation

// "Office Tour - Corporate Background Music" by SunnyVibesAudio from https://pixabay.com/music/upbeat-office-tour-corporate-background-music-250621/



class BackgroundMusicManager: ObservableObject {
    private var audioPlayer: AVAudioPlayer?
    @Published var isPlaying: Bool = false
    
    init() {
        setupAudioPlayer()
    }
    
    private func setupAudioPlayer() {
        if let path = Bundle.main.path(forResource: "background_music", ofType: "mp3") {
            let url = URL(fileURLWithPath: path)
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.numberOfLoops = -1 // Infinite loop
                audioPlayer?.volume = 0.1
                audioPlayer?.prepareToPlay()
            } catch {
                print("Error loading audio file: \(error)")
            }
        }
    }

    func togglePlayback() {
        guard let player = audioPlayer else { return }
        if player.isPlaying {
            player.pause()
            isPlaying = false
        } else {
            player.play()
            isPlaying = true
        }
    }

}