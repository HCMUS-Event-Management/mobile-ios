//
//  IconTextButton.swift
//  mobile
//
//  Created by NguyenSon_MP on 09/02/2023.
//

import UIKit

struct IconTextButtonViewModel {
    let text: String
    let image: UIImage?
    let backgroundColor: UIColor?
}

final class IconTextButton: UIButton {
    private let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .center
        label.textColor = .white
        label.font = .systemFont(ofSize: 20, weight: .regular)
        return label
    }()
    
    private let imageViewIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(label)
        addSubview(imageViewIcon)
        clipsToBounds = true
        layer.cornerRadius = 20
        layer.borderWidth = 1
        layer.borderColor = UIColor.systemBackground.cgColor
    }

    
    required init?(coder: NSCoder) {
        print(coder)
        super.init(coder: coder)
    }
    
    func config(with viewModel: IconTextButtonViewModel) {
        print(viewModel)
        label.text = viewModel.text
        backgroundColor = viewModel.backgroundColor
        imageViewIcon.image = viewModel.image
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        label.sizeToFit()
        let iconSize: CGFloat = 18
        let iconX: CGFloat = (frame.size.width - label.frame.size.width - iconSize - 5)
        imageViewIcon.frame = CGRect(x: iconX, y: (frame.size.height - iconSize)/2, width: iconSize, height: iconSize)
        imageViewIcon.frame = CGRect(x: iconX + iconSize + 5, y: 0, width: label.frame.size.width, height: frame.size.height)
    }
}
