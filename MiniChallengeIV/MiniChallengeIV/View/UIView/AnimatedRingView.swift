//
//  AnimatedRingView.swift
//  MiniChallengeIV
//
//  Created by Fábio Maciel de Sousa on 11/05/20.
//  Copyright © 2020 Murilo Teixeira. All rights reserved.
//

import UIKit

class AnimatedRingView: UIView {
    private static let animationDuration = CFTimeInterval(60)
    private let π = CGFloat.pi
    private let startAngle = 1.5 * CGFloat.pi
    private let circleStrokeWidth = CGFloat(2)
    private let ringStrokeWidth = CGFloat(8)
    var proportion = CGFloat(0) {
        didSet {
            setNeedsLayout()
        }
    }

    private lazy var circleLayer: CAShapeLayer = {
        let circleLayer = CAShapeLayer()
        circleLayer.strokeColor = UIColor.gray.cgColor
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.lineWidth = self.circleStrokeWidth
        self.layer.addSublayer(circleLayer)
        return circleLayer
    }()
    
    private lazy var ringlayer: CAShapeLayer = {
        let ringlayer = CAShapeLayer()
        ringlayer.fillColor = UIColor.clear.cgColor
        ringlayer.strokeColor = UIColor.gray.cgColor
        ringlayer.lineCap = CAShapeLayerLineCap.round
        ringlayer.lineWidth = self.ringStrokeWidth
        self.layer.addSublayer(ringlayer)
        return ringlayer
    }()
    
    private lazy var pinlayer: CAShapeLayer = {
        let pinlayer = CAShapeLayer()
        pinlayer.fillColor = UIColor.gray.cgColor
        let size = CGSize(width: 20, height: 20)
        let xPos = self.frame.size.width/2 - size.width / 2
        let yPos = -size.height/5
//        pinlayer.path = UIBezierPath(ovalIn: CGRect(x: xPos, y: yPos, width: size.width, height: size.height)).cgPath
        self.layer.addSublayer(pinlayer)
        return pinlayer
    }()

    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundColor = .white
        let radius = (min(frame.size.width, frame.size.height) - ringStrokeWidth - 2)/2
        let pinRadius = 12
        let size = self.frame.size
        let pos = CGPoint(x: size.width/2, y: size.height/2)
        let circlePath = UIBezierPath(arcCenter: pos, radius: radius, startAngle: startAngle, endAngle: startAngle + 2 * π, clockwise: true)
        circleLayer.path = circlePath.cgPath
        ringlayer.path = circlePath.cgPath
        ringlayer.strokeEnd = proportion
        pinlayer.position = pos
        pinlayer.path = CGPath(ellipseIn: CGRect(x: -pinRadius, y: Int(-radius) - pinRadius, width: 2 * pinRadius, height: 2 * pinRadius), transform: nil)
        
    }

    func animateRing(From startProportion: CGFloat, To endProportion: CGFloat, Duration duration: CFTimeInterval = animationDuration) {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = duration
        animation.fromValue = startProportion
        animation.toValue = endProportion
        animation.timingFunction = CAMediaTimingFunction(name: .linear)
        ringlayer.strokeEnd = endProportion
        ringlayer.strokeStart = startProportion
        ringlayer.add(animation, forKey: "animateRing")
        
        let pinAnimation = CABasicAnimation(keyPath: "transform.rotation")
        pinAnimation.fromValue = 0
        pinAnimation.toValue = 2 * CGFloat.pi
        pinAnimation.timingFunction = CAMediaTimingFunction(name: .linear)
        pinAnimation.duration = duration
        pinAnimation.isAdditive = true
        pinlayer.add(pinAnimation, forKey: nil)
    }

}
