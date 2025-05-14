//  ViewController.swift
//  videodisplay
//bbbhhhhbhbgthtyttgtbgfr
//  Created by Sarai on 4/4/24.
//import UIKi

import UIKit
import SceneKit
import ARKit
import AVFoundation

class ViewController: UIViewController, ARSCNViewDelegate {
    
    // MARK: - Outlets and Properties
    
    // AR View for displaying augmented reality content
    @IBOutlet var sceneView: ARSCNView!
    
    // Video player components
    var player: AVPlayer!          // Handles video playback
    var playerLayer: AVPlayerLayer! // Displays video content
    
    // UI State tracking
    var isContainerVisible = false  // Tracks if AR content is visible
    
    // UI Components
    var topContainerView: UIView!    // Container for title
    var bottomContainerView: UIView! // Container for menu options
    var playPauseButton: UIButton!  // Controls video playback
    var backButton: UIButton!       // Returns to main menu
    var videoBackButton: UIButton!  // Appears when video ends

    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set up AR view delegate and initialize UI
        sceneView.delegate = self
        setupUI()
    }
    
    // MARK: - UI Setup
    
    /// Configures all user interface elements
    func setupUI() {
        setupTopContainer()
        setupBottomContainer()
        setupPlayPauseButton()
        setupBackButton()
        setupVideoBackButton()
        
        // Initially hide containers until AR marker is detected
        bottomContainerView.isHidden = true
        topContainerView.isHidden = true
    }
    
    /// Creates and configures the top title container
    private func setupTopContainer() {
        topContainerView = createContainerView(width: 200, height: 50)
        view.addSubview(topContainerView)
        NSLayoutConstraint.activate([
            topContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            topContainerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 30)
        ])
        
        // Add title label to container
        let titleLabel = createLabel(text: "Hunter McDaniel", fontSize: 12, isBold: true)
        topContainerView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: topContainerView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: topContainerView.centerYAnchor)
        ])
    }
    
    /// Creates and configures the bottom menu container
    private func setupBottomContainer() {
        bottomContainerView = createContainerView(width: 300, height: 150)
        view.addSubview(bottomContainerView)
        NSLayoutConstraint.activate([
            bottomContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bottomContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50)
        ])
        
        // Create horizontal stack for menu sections
        let horizontalStackView = UIStackView()
        horizontalStackView.axis = .horizontal
        horizontalStackView.distribution = .fillEqually
        horizontalStackView.spacing = 0
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        bottomContainerView.addSubview(horizontalStackView)
        
        NSLayoutConstraint.activate([
            horizontalStackView.leadingAnchor.constraint(equalTo: bottomContainerView.leadingAnchor, constant: 10),
            horizontalStackView.trailingAnchor.constraint(equalTo: bottomContainerView.trailingAnchor, constant: -10),
            horizontalStackView.topAnchor.constraint(equalTo: bottomContainerView.topAnchor, constant: 10),
            horizontalStackView.bottomAnchor.constraint(equalTo: bottomContainerView.bottomAnchor, constant: -10)
        ])
        
        // Add menu sections
        horizontalStackView.addArrangedSubview(createMenuSection(
            title: "Departments",
            items: [
                ("Psychology", "https://www.vsu.edu/cnhs/departments/psychology/faculty-staff/"),
                ("Nursing", "https://www.vsu.edu/cnhs/departments/nursing/faculty-staff/"),
                ("Chemistry", "https://www.vsu.edu/cnhs/departments/chemistry/faculty-staff/"),
                ("Computer Science", "https://www.vsu.edu/cet/departments/computer-science/faculty-staff/")
            ])
        )
        
        horizontalStackView.addArrangedSubview(createMenuSection(
            title: "Tour",
            items: [("Play Video", "")]
        ))
        
        horizontalStackView.addArrangedSubview(createMenuSection(
            title: "Learn More",
            items: [
                ("VSU Website", "https://www.vsu.edu"),
                ("Hunter McDaniel Building", "https://sites.google.com/view/vsu-hunter-mcdaniel-building/home")
            ])
        )
    }
    
    /// Configures the play/pause button for video control
    private func setupPlayPauseButton() {
        playPauseButton = UIButton(type: .system)
        playPauseButton.setTitle("Pause", for: .normal)
        playPauseButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        playPauseButton.setTitleColor(.white, for: .normal)
        playPauseButton.backgroundColor = UIColor(white: 0.2, alpha: 0.8)
        playPauseButton.layer.cornerRadius = 5
        playPauseButton.translatesAutoresizingMaskIntoConstraints = false
        playPauseButton.addTarget(self, action: #selector(togglePlayPause), for: .touchUpInside)
        bottomContainerView.addSubview(playPauseButton)
        
        NSLayoutConstraint.activate([
            playPauseButton.trailingAnchor.constraint(equalTo: bottomContainerView.trailingAnchor, constant: -10),
            playPauseButton.bottomAnchor.constraint(equalTo: bottomContainerView.bottomAnchor, constant: -10),
            playPauseButton.widthAnchor.constraint(equalToConstant: 60),
            playPauseButton.heightAnchor.constraint(equalToConstant: 30)
        ])
        playPauseButton.isHidden = true // Initially hidden
    }
    
    /// Configures the back button to return to main menu
    private func setupBackButton() {
        backButton = UIButton(type: .system)
        backButton.setTitle("Back", for: .normal)
        backButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        backButton.setTitleColor(.white, for: .normal)
        backButton.backgroundColor = UIColor(white: 0.2, alpha: 0.8)
        backButton.layer.cornerRadius = 5
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.addTarget(self, action: #selector(goBackToMenu), for: .touchUpInside)
        bottomContainerView.addSubview(backButton)
        
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: bottomContainerView.leadingAnchor, constant: 10),
            backButton.bottomAnchor.constraint(equalTo: bottomContainerView.bottomAnchor, constant: -10),
            backButton.widthAnchor.constraint(equalToConstant: 60),
            backButton.heightAnchor.constraint(equalToConstant: 30)
        ])
        backButton.isHidden = true // Initially hidden
    }
    
    /// Configures the button that appears when video ends
    private func setupVideoBackButton() {
        videoBackButton = UIButton(type: .system)
        videoBackButton.setTitle("Back to Menu", for: .normal)
        videoBackButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        videoBackButton.setTitleColor(.white, for: .normal)
        videoBackButton.backgroundColor = UIColor(white: 0.2, alpha: 0.8)
        videoBackButton.layer.cornerRadius = 10
        videoBackButton.translatesAutoresizingMaskIntoConstraints = false
        videoBackButton.addTarget(self, action: #selector(goBackToMenu), for: .touchUpInside)
        view.addSubview(videoBackButton)
        
        NSLayoutConstraint.activate([
            videoBackButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            videoBackButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30),
            videoBackButton.widthAnchor.constraint(equalToConstant: 120),
            videoBackButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        videoBackButton.isHidden = true // Initially hidden
    }
    
    // MARK: - UI Factory Methods
    
    /// Creates a styled container view with specified dimensions
    private func createContainerView(width: CGFloat, height: CGFloat) -> UIView {
        let containerView = UIView()
        containerView.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
        containerView.layer.cornerRadius = 10
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.lightGray.cgColor
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.widthAnchor.constraint(equalToConstant: width),
            containerView.heightAnchor.constraint(equalToConstant: height)
        ])
        return containerView
    }
    
    /// Creates a styled label with customizable text properties
    private func createLabel(text: String, fontSize: CGFloat, isBold: Bool = false, textColor: UIColor = .black) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = isBold ? UIFont.boldSystemFont(ofSize: fontSize) : UIFont.systemFont(ofSize: fontSize)
        label.textColor = textColor
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    /// Creates a vertical menu section with title and items
    private func createMenuSection(title: String, items: [(String, String)]) -> UIView {
        let sectionView = UIView()
        sectionView.translatesAutoresizingMaskIntoConstraints = false
        
        // Section title
        let titleLabel = createLabel(text: title, fontSize: 12, isBold: true)
        sectionView.addSubview(titleLabel)
        
        // Items stack
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 2
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false
        sectionView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: sectionView.leadingAnchor, constant: 5),
            titleLabel.topAnchor.constraint(equalTo: sectionView.topAnchor, constant: 5),
            stackView.leadingAnchor.constraint(equalTo: sectionView.leadingAnchor, constant: 5),
            stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            stackView.trailingAnchor.constraint(equalTo: sectionView.trailingAnchor, constant: -5)
        ])
        
        // Add items to section
        for (name, url) in items {
            let button = UIButton(type: .system)
            button.setTitle(name, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 10)
            
            if url.isEmpty {
                button.setTitleColor(.systemBlue, for: .normal)
                if name == "Play Video" {
                    button.addTarget(self, action: #selector(playVideo), for: .touchUpInside)
                }
            } else {
                button.setTitleColor(.orange, for: .normal)
                button.accessibilityHint = url
                button.addTarget(self, action: #selector(openDepartmentLink(_:)), for: .touchUpInside)
            }
            
            stackView.addArrangedSubview(button)
        }
        
        return sectionView
    }
    
    // MARK: - Action Methods
    
    /// Toggles between play and pause states for the video
    @objc func togglePlayPause() {
        if player.timeControlStatus == .playing {
            player.pause()
            playPauseButton.setTitle("Play", for: .normal)
        } else {
            player.play()
            playPauseButton.setTitle("Pause", for: .normal)
        }
    }
    
    /// Handles returning to the main menu from video playback
    @objc func goBackToMenu() {
        player?.pause()
        playerLayer?.removeFromSuperlayer()
        
        // Show menu containers
        bottomContainerView.isHidden = false
        topContainerView.isHidden = false
        
        // Hide video controls
        playPauseButton.isHidden = true
        backButton.isHidden = true
        videoBackButton.isHidden = true
        
        // Remove video end observer
        NotificationCenter.default.removeObserver(
            self,
            name: .AVPlayerItemDidPlayToEndTime,
            object: player?.currentItem
        )
    }
    
    /// Opens department links in Safari
    @objc func openDepartmentLink(_ sender: UIButton) {
        guard let urlString = sender.accessibilityHint,
              let url = URL(string: urlString) else { return }
        UIApplication.shared.open(url)
    }
    
    /// Starts video playback
    @objc func playVideo() {
        guard let fileURL = Bundle.main.url(forResource: "IMG_9452", withExtension: "MOV") else {
            print("Video file not found.")
            return
        }
        
        // Set up new player
        player = AVPlayer(url: fileURL)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = bottomContainerView.bounds
        playerLayer.videoGravity = .resizeAspectFill
        bottomContainerView.layer.addSublayer(playerLayer)
        
        // Start playback
        player.play()
        
        // Set up video end observer
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(videoDidEnd),
            name: .AVPlayerItemDidPlayToEndTime,
            object: player.currentItem
        )
        
        // Update UI for video playback
        playPauseButton.isHidden = false
        playPauseButton.setTitle("Pause", for: .normal)
        backButton.isHidden = false
        bottomContainerView.isHidden = false
        topContainerView.isHidden = true
        videoBackButton.isHidden = true
    }
    
    /// Handles video playback completion
    @objc func videoDidEnd() {
        videoBackButton.isHidden = false
        playPauseButton.setTitle("Play", for: .normal)
    }
    
    // MARK: - ARKit Methods
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Set up image tracking configuration
        let configuration = ARImageTrackingConfiguration()
        
        if let trackingImages = ARReferenceImage.referenceImages(
            inGroupNamed: "Playing cards",
            bundle: nil
        ) {
            configuration.trackingImages = trackingImages
            configuration.maximumNumberOfTrackedImages = 1
        }
        
        // Run AR session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Pause AR session when view disappears
        sceneView.session.pause()
    }
    
    /// Called when ARKit detects an image anchor
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
        
        if let imageAnchor = anchor as? ARImageAnchor,
           imageAnchor.referenceImage.name == "Figure02" {
            // Show UI when target image is detected
            if !isContainerVisible {
                isContainerVisible = true
                DispatchQueue.main.async {
                    self.topContainerView.isHidden = false
                    self.bottomContainerView.isHidden = false
                }
            }
        } else {
            // Hide UI when target image is lost
            DispatchQueue.main.async {
                self.topContainerView.isHidden = true
                self.bottomContainerView.isHidden = true
                self.isContainerVisible = false
            }
        }
        
        return node
    }
    
    // MARK: - Status Bar
    
    override var prefersStatusBarHidden: Bool {
        return true // Hide status bar for fullscreen experience
    }
}
