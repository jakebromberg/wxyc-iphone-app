//
//  PlaycutHeader.swift
//  WXYC
//
//  Created by Jake Bromberg on 12/13/18.
//  Copyright © 2018 WXYC. All rights reserved.
//

import UIKit

@objc class PlayerHeader: UITableViewHeaderFooterView {
    private let containerView: UIView
    private let playButton: UIButton
    private let cassetteContainer: UIView
    private let cassetteLeftArch: UIImageView
    private let cassetteLeftReel: UIImageView
    private let cassetteCenter: UIImageView
    private let cassetteBackground: UIImageView
    private let cassetteRightReel: UIImageView
    private let cassetteRightArch: UIImageView
    
    required convenience init?(coder aDecoder: NSCoder) {
        self.init(reuseIdentifier: nil)
    }
    
    override required init(reuseIdentifier: String?) {
        self.containerView = UIView()
        self.containerView.translatesAutoresizingMaskIntoConstraints = false
        
        playButton = UIButton(type: .custom)
        playButton.setImage(UIImage(named: "play-button"), for: .normal)
        //playButton.setContentCompressionResistancePriority(.required, for: .horizontal)
        playButton.setContentHuggingPriority(.required, for: .horizontal)
        playButton.contentMode = .scaleAspectFit
        playButton.translatesAutoresizingMaskIntoConstraints = false

        cassetteContainer = UIView()
        cassetteContainer.translatesAutoresizingMaskIntoConstraints = false

        let cassetteLeftArchImage = UIImage(named: "Cassette Left Arch")
        cassetteLeftArch = UIImageView(image: cassetteLeftArchImage)
        cassetteLeftArch.contentMode = .scaleAspectFit
        cassetteLeftArch.translatesAutoresizingMaskIntoConstraints = false
        cassetteLeftArch.setContentHuggingPriority(.required, for: .horizontal)
//        cassetteContainer.setContentCompressionResistancePriority(.required, for: .horizontal)

        cassetteRightArch = UIImageView(image: UIImage(named: "Cassette Right Arch"))
        cassetteRightArch.contentMode = .scaleAspectFit
        cassetteRightArch.translatesAutoresizingMaskIntoConstraints = false

        cassetteLeftReel = UIImageView(image: UIImage(named: "cassette reel"))
        cassetteLeftReel.contentMode = .scaleAspectFit
        cassetteLeftReel.translatesAutoresizingMaskIntoConstraints = false

        cassetteRightReel = UIImageView(image: UIImage(named: "cassette reel"))
        cassetteRightReel.contentMode = .scaleAspectFit
        cassetteRightReel.translatesAutoresizingMaskIntoConstraints = false

        cassetteCenter = UIImageView(image: UIImage(named: "Cassette Center"))
        cassetteCenter.contentMode = .scaleAspectFit
        cassetteCenter.translatesAutoresizingMaskIntoConstraints = false

        cassetteBackground = UIImageView(image: UIImage(named: "Cassette Background"))
        cassetteBackground.contentMode = .scaleToFill
        cassetteBackground.translatesAutoresizingMaskIntoConstraints = false

        super.init(reuseIdentifier: reuseIdentifier)
        
        setUpViews()
    }
    
    private func setUpViews() {
        let cassetteLeftArchImage = UIImage(named: "Cassette Left Arch")!
        let cassetteRightArchImage = UIImage(named: "Cassette Right Arch")!

        self.containerView.layer.borderColor = UIColor(white: 0.7, alpha: 1.0).cgColor
        self.containerView.layer.borderWidth = 1.0
        self.containerView.layer.cornerRadius = 5.0
        self.containerView.layer.masksToBounds = true

//        self.layoutMargins = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)

        self.contentView.addSubview(self.containerView)
        self.containerView.addSubview(self.playButton)
        self.containerView.addSubview(self.cassetteContainer)
        
        self.cassetteContainer.addSubview(self.cassetteBackground)
        self.cassetteContainer.addSubview(self.cassetteCenter)
        self.cassetteContainer.addSubview(self.cassetteLeftArch)
        self.cassetteContainer.addSubview(self.cassetteLeftReel)
        self.cassetteContainer.addSubview(self.cassetteRightArch)
        self.cassetteContainer.addSubview(self.cassetteRightReel)
        
        self.contentView.addConstraints([
            self.contentView.layoutMarginsGuide.topAnchor.constraint(equalTo: self.containerView.topAnchor),
            self.contentView.layoutMarginsGuide.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor),
            self.contentView.layoutMarginsGuide.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor),
            self.contentView.layoutMarginsGuide.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor),

            self.containerView.topAnchor.constraint(equalTo: self.playButton.topAnchor),
            self.containerView.bottomAnchor.constraint(equalTo: self.playButton.bottomAnchor),
            self.containerView.leadingAnchor.constraint(equalTo: self.playButton.leadingAnchor),
            
            self.playButton.heightAnchor.constraint(equalTo: self.playButton.widthAnchor),
            self.playButton.trailingAnchor.constraint(equalTo: self.cassetteContainer.leadingAnchor),

            self.containerView.topAnchor.constraint(equalTo: self.cassetteContainer.topAnchor),
            self.containerView.trailingAnchor.constraint(equalTo: self.cassetteContainer.trailingAnchor),
            self.containerView.bottomAnchor.constraint(equalTo: self.cassetteContainer.bottomAnchor),
//            self.playButton.leadingAnchor.constraint(equalTo: self.cassetteContainer.trailingAnchor),
            
            self.cassetteBackground.topAnchor.constraint(equalTo: self.cassetteContainer.topAnchor),
            self.cassetteBackground.trailingAnchor.constraint(equalTo: self.cassetteContainer.trailingAnchor),
            self.cassetteBackground.bottomAnchor.constraint(equalTo: self.cassetteContainer.bottomAnchor),
            self.cassetteBackground.leadingAnchor.constraint(equalTo: self.cassetteContainer.leadingAnchor),

            self.cassetteLeftArch.topAnchor.constraint(equalTo: self.cassetteContainer.topAnchor),
            self.cassetteLeftArch.leadingAnchor.constraint(equalTo: self.cassetteContainer.leadingAnchor),
            self.cassetteLeftArch.bottomAnchor.constraint(equalTo: self.cassetteContainer.bottomAnchor),
            
            self.cassetteLeftArch.trailingAnchor.constraint(equalTo: self.cassetteLeftReel.centerXAnchor, constant: -4.0),
            self.cassetteLeftArch.centerYAnchor.constraint(equalTo: self.cassetteLeftReel.centerYAnchor),
            self.cassetteLeftArch.widthAnchor.constraint(equalTo: self.cassetteLeftArch.heightAnchor, multiplier: cassetteLeftArchImage.size.width / cassetteLeftArchImage.size.height),

            self.cassetteCenter.topAnchor.constraint(equalTo: self.cassetteContainer.topAnchor),
            self.cassetteCenter.centerXAnchor.constraint(equalTo: self.cassetteContainer.centerXAnchor),
            self.cassetteCenter.bottomAnchor.constraint(equalTo: self.cassetteContainer.bottomAnchor),

            self.cassetteRightArch.leadingAnchor.constraint(equalTo: self.cassetteRightReel.centerXAnchor, constant: 4.0),
            self.cassetteRightArch.centerYAnchor.constraint(equalTo: self.cassetteRightReel.centerYAnchor),
            self.cassetteRightArch.widthAnchor.constraint(equalTo: self.cassetteLeftArch.heightAnchor, multiplier: cassetteRightArchImage.size.width / cassetteRightArchImage.size.height),

            self.cassetteRightArch.topAnchor.constraint(equalTo: self.cassetteContainer.topAnchor),
            self.cassetteRightArch.trailingAnchor.constraint(equalTo: self.cassetteContainer.trailingAnchor),
            self.cassetteRightArch.bottomAnchor.constraint(equalTo: self.cassetteContainer.bottomAnchor),
            
            ])
    }
    
    override class var requiresConstraintBasedLayout: Bool {
        return true
    }
}
