//
//  Helper.swift
//  Animated
//
//  Created by Dang Hoang on 2022/06/01.
//

import Foundation
import SwiftUI

// Draged 50% of the screen in left or right direction
public var thresholdPercentage: CGFloat = 0.5

public enum RememberAndNope: Int {
    case remember, nopes, none
}

public enum RecodingState: Int {
    case able, unable, recoding, processing, stoped, none
}

enum CardSide {
    case front, back
    
    var nextSide: CardSide {
        return self == .front ? .back : .front
    }
    
    var transitionDirectionAnimationOption: UIView.AnimationOptions {
        return self == .front ? .transitionFlipFromRight : .transitionFlipFromLeft
    }
}
