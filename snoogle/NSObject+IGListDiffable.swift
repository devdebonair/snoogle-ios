//
//  NSObject+IGListDiffable.swift
//  snoogle
//
//  Created by Vincent Moore on 3/25/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import IGListKit

extension NSObject: IGListDiffable {
    public func primaryKey() -> NSObjectProtocol {
        return self
    }
    
    public func diffIdentifier() -> NSObjectProtocol {
        return primaryKey()
    }
    
    public func isEqual(toDiffableObject object: IGListDiffable?) -> Bool {
        return isEqual(self)
    }
}
