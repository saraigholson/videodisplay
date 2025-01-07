//
//  ViewController.swift
//  videodisplay
//
//  Created by Sarai on 4/4/24.
//import UIKi
import UIKit
import SceneKit
import ARKit
import AVFoundation
import AVKit

class ViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    var player: AVPlayer!
    var isContainerVisible = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.delegate = self
        setupUI()
    }
    
    func setupUI() {
        // Create a container view with a customized appearance
        let containerView = UIView()
        containerView.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0) // Light gray background
        containerView.layer.cornerRadius = 10 // Rounded corners
        containerView.layer.borderWidth = 1 // Add border
        containerView.layer.borderColor = UIColor.lightGray.cgColor // Border color
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
        
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 50), // Adjust top spacing
            containerView.widthAnchor.constraint(equalToConstant: 250), // Adjust width
            containerView.heightAnchor.constraint(equalToConstant: 300) // Adjust height
        ])
        
        // Add subviews to the container view
        // Add building name label
        let buildingNameLabel = UILabel()
        buildingNameLabel.text = "Hunter McDaniel"
        buildingNameLabel.font = UIFont.boldSystemFont(ofSize: 16)
        buildingNameLabel.textColor = .orange // Set text color to orange
        buildingNameLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(buildingNameLabel)
        
        NSLayoutConstraint.activate([
            buildingNameLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            buildingNameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20)
        ])
        
        // Add department list label with bullet points
        let departmentsLabel = UILabel()
        departmentsLabel.text = "Departments:\n• Psychology\n• Nursing\n• Chemistry\n• Computer Science"
        departmentsLabel.numberOfLines = 0
        departmentsLabel.textColor = .orange // Set text color to orange
        departmentsLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(departmentsLabel)
        
        NSLayoutConstraint.activate([
            departmentsLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            departmentsLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            departmentsLabel.topAnchor.constraint(equalTo: buildingNameLabel.bottomAnchor, constant: 20)
        ])
        
        // Add a play video button
        let playVideoButton = UIButton(type: .system)
        playVideoButton.setTitle("Play Video", for: .normal)
        playVideoButton.addTarget(self, action: #selector(playVideo), for: .touchUpInside)
        playVideoButton.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(playVideoButton)
        
        NSLayoutConstraint.activate([
            playVideoButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            playVideoButton.topAnchor.constraint(equalTo: departmentsLabel.bottomAnchor, constant: 20)
        ])
        
        // Add an open VSU webpage button
        let openWebpageButton = UIButton(type: .system)
        openWebpageButton.setTitle("Open VSU Webpage", for: .normal)
        openWebpageButton.addTarget(self, action: #selector(openVSUWebpage), for: .touchUpInside)
        openWebpageButton.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(openWebpageButton)
        
        NSLayoutConstraint.activate([
            openWebpageButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            openWebpageButton.topAnchor.constraint(equalTo: playVideoButton.bottomAnchor, constant: 20)
        ])
        
        // Hide the container initially
        containerView.isHidden = true
    }
    
    @objc func playVideo() {
        guard let fileURL = Bundle.main.url(forResource: "IMG_9452", withExtension: "MOV") else {
            print("Video file not found.")
            return
        }
        player = AVPlayer(url: fileURL)
        
        // Present the video player
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        present(playerViewController, animated: true) {
            self.player.play()
        }
    }
    
    @objc func openVSUWebpage() {
        guard let url = URL(string: "https://www.vsu.edu/") else {
            print("Invalid URL.")
            return
        }
        UIApplication.shared.open(url)
    }
    
    // ARSCNViewDelegate methods...
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARImageTrackingConfiguration()
        if let trackingImages = ARReferenceImage.referenceImages(inGroupNamed: "Playing cards", bundle: nil) {
            configuration.trackingImages = trackingImages
            configuration.maximumNumberOfTrackedImages = 1
        }
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    func addVideoNode(above node: SCNNode) {
        // Add code to add video node
    }
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
        if let imageAnchor = anchor as? ARImageAnchor, imageAnchor.referenceImage.name == "Figure02" {
            isContainerVisible = true // Set the flag to show the container
            let size = imageAnchor.referenceImage.physicalSize
            let plane = SCNPlane(width: size.width, height: size.height)
            plane.firstMaterial?.diffuse.contents = UIColor.white.withAlphaComponent(0.5)
            plane.cornerRadius = 0.005
            let planeNode = SCNNode(geometry: plane)
            planeNode.eulerAngles.x = -.pi / 2
            node.addChildNode(planeNode)
            addVideoNode(above: node)
        }
        return node
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        if isContainerVisible {
            // Show the container view
            for subview in self.view.subviews {
                if subview is UIView {
                    subview.isHidden = false
                }
            }
        }
    }
}
