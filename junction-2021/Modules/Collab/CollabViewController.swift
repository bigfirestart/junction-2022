//
//  CollabViewController.swift
//  junction-2021
//
//  Created by b.belotserkovtsev on 21.11.2021.
//

import UIKit

class CollabViewController: UIViewController {
    @IBOutlet weak var wrapperView: UIView!
    @IBOutlet weak var opponentImageView: UIImageView!
    @IBOutlet weak var opponentNameLabel: UILabel!
    @IBOutlet weak var pointsCountLabel: UILabel!
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var linkIconImage: UIImageView!
    @IBOutlet weak var markButton: UIButton!

    @IBOutlet weak var secondWrapperView: UIView!
    @IBOutlet weak var firstImage: UIImageView!
    @IBOutlet weak var secondImage: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .appBackground()
        title = "Collab"

        wrapperView.layer.cornerRadius = 14
        wrapperView.layer.applyFigmaShadow(color: .shadow(), x: 0, y: 4, blur: 8, spread: 0)
        wrapperView.backgroundColor = .white

        opponentImageView.image = AvatarFactory.getRandomAvatar()
        opponentImageView.layer.cornerRadius = 20

        linkIconImage.image = R.image.chainIcon()
        emailLabel.textColor = .systemBlue

//        personImage.image = R.image.bluePerson()

        markButton.layer.cornerRadius = 8

        secondWrapperView.layer.cornerRadius = 14
        secondWrapperView.layer.applyFigmaShadow(color: .shadow(), x: 0, y: 4, blur: 8, spread: 0)
        secondWrapperView.backgroundColor = .white

        firstImage.image = AvatarFactory.getRandomAvatar()
        firstImage.layer.cornerRadius = 20

        secondImage.image = R.image.chainIcon()

    }
}
