//
//  SwipeCardsDataSource.swift
//  ComboTranslate
//
//  Created by  Егор Шуляк on 3.10.21.
//

import Foundation
import UIKit

protocol SwipeCardsDataSource {
    func numberOfCardsToShow() -> Int
    func card(at index: Int) -> CardView
    func emptyView() -> UIView?
}

protocol SwipeCardsDelegate: AnyObject {
    func swipeDidEnd(on view: CardView)
    func swipeDidStart(on view: CardView)
    func swipeDidNotEnded(on view: CardView)
}
