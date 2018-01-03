//
//  CustomLayout.swift
//  InfiniteLayout_Example
//
//  Created by Arnaud Dorgans on 28/12/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import InfiniteLayout

class CustomLayout: InfiniteLayout {
    
    let minimumScale: CGFloat = 0.75
    let rangeRatio: CGFloat = 1

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect).flatMap {
            self.copyLayoutAttributes(from: $0)
        }
        guard let visibleRect = self.visibleCollectionViewRect() else {
            return attributes
        }
        let centeredOffset = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        for attributes in attributes ?? [] {
            let diff = self.scrollDirection == .horizontal ? centeredOffset.x - attributes.center.x : centeredOffset.y - attributes.center.y
            let scale = max(min(diff / (min(visibleRect.width, visibleRect.height) * rangeRatio), 1), -1)
            attributes.transform = attributes.transform.translatedBy(x: abs(scale * (visibleRect.width / 2)), y: 0)
            attributes.transform = attributes.transform.rotated(by: scale * (CGFloat.pi / 2))
        }
        return attributes
    }
}
