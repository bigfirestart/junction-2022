//
//  UIImage+Extension.swift
//  junction-2021
//
//  Created by k.lukyanov on 20.11.2021.
//

import UIKit

class AvatarFactory {
	static func getUserAvatar() -> UIImage? {
		return R.image.avatar1()
	}
	
	static func getRandomAvatar() -> UIImage? {
		let list = [
			R.image.avatar1(),
			R.image.avatar2(),
			R.image.avatar3(),
			R.image.avatar4(),
			R.image.avatar5()
		]
		return list[Int.random(in: 0..<5)]
	}
}
