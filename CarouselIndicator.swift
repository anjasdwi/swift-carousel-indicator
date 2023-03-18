//
//  CarouselIndicator.swift
//  AnjasDwi
//
//  Created by Anjas Dwi on 01/03/23.
//

import UIKit

open class CarouselIndicator: UIView {

    // Public properties
    public var width: CGFloat = 6
    public var widthFocussed: CGFloat = 27
    public var currentIndex: Int = 0
    public var colorFocussed: UIColor = .green
    public var color: UIColor = .lightGray

    public var datasCount: Int = 1 {
        didSet {
            setupDots()
        }
    }

    // Private properties
    private var dotViews = [UIView]()
    private var dotConstraints = [NSLayoutConstraint]()

    // This property created using custom DSL UIKit
    // You can see more about custom DSL UIKit in My another repository
    // https://github.com/anjasdwi/swift-uikit-simplify-dsl
    lazy var mainSV = UIStackView()
        .distribution(.fill)
        .axis(.horizontal)
        .spacing(6)
        .translatesAutoresizingMaskIntoConstraints(false)

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupLayouts()
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// Setup views
    private func setupViews() {
        addSubview(mainSV)
    }

    /// Setup layouts
    private func setupLayouts() {
        NSLayoutConstraint.activate([
            mainSV.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainSV.topAnchor.constraint(equalTo: topAnchor),
            bottomAnchor.constraint(equalTo: mainSV.bottomAnchor)
        ])
    }

    /// Setup dot views
    private func setupDots() {
        clearAllViews()

        for i in 0...datasCount-1 {
            let dotView = UIView().with {
                $0.translatesAutoresizingMaskIntoConstraints = false
                $0.backgroundColor = color
                $0.layer.cornerRadius = width / 2
                dotConstraints.append($0.widthAnchor.constraint(equalToConstant: width))

                NSLayoutConstraint.activate([
                    $0.heightAnchor.constraint(equalToConstant: width),
                    dotConstraints[i]
                ])
            }
            dotViews.append(dotView)
            mainSV.addArrangedSubview(dotViews[i])
        }
    }

    /// Clear All views to avoid redundant views
    private func clearAllViews() {
        dotViews.removeAll()
        dotConstraints.removeAll()
        mainSV.subviews.forEach { $0.removeFromSuperview() }
    }

    /// Set or update the view to change the focus of the dot view
    ///
    /// - Parameters:
    ///     - index: new foucussed index
    public func setFocusIndex(to index: Int) {
        // Validate index
        guard dotViews.indices.contains(index),
              dotConstraints.indices.contains(index)
        else { return }

        // Reset color to unfocussed indicator
        dotViews[currentIndex].backgroundColor(color)
        dotConstraints[currentIndex].constant = width

        // Set color to focussed indicator
        dotViews[index].backgroundColor(colorFocussed)
        dotConstraints[index].constant = widthFocussed

        // Animate focussed indicator
        UIView.animate(withDuration: 0.5) {
            self.layoutIfNeeded()
        }

        // Update current index to new index
        currentIndex = index
    }
}
