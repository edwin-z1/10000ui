//
//  Namespace.swift
//  10000ui-swift
//
//  Created by 张亚东 on 04/07/2017.
//  Copyright © 2017 Jumei. All rights reserved.
//

import Foundation

class NamespaceBox<Source> {
    
    var source: Source
    
    init(_ source: Source) {
        self.source = source
    }
}

protocol Namespace {
    
    associatedtype U
    
    static var bs: NamespaceBox<U>.Type { get }
    
    var bs: NamespaceBox<U> { get }
}

extension Namespace {
    
    static var bs: NamespaceBox<Self>.Type {
        return NamespaceBox<Self>.self
    }
    
    var bs: NamespaceBox<Self> {
        return NamespaceBox(self)
    }
}

extension NSObject: Namespace {}
