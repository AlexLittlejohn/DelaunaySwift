//
//  DelaunayError.swift
//  DelaunayTriangulationSwift
//
//  Created by Alex Littlejohn on 2016/01/08.
//  Copyright © 2016 zero. All rights reserved.
//

enum DelaunayError: ErrorType {
    /// This occurs if two points supplied are exactly the same
    /// Ensure that your supplied vertices are cleaned of duplicates
    case CoincidentPoints
}

