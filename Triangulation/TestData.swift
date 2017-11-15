//
//  TestData.swift
//  DelaunaySwift
//
//  Created by Volodymyr Boichentsov on 14/11/2017.
//  Copyright © 2017 zero. All rights reserved.
//

import Foundation
import GameplayKit
import DelaunaySwift

/// Generate set of vertices for our triangulation to use
func generateVertices(_ size: CGSize, cellSize: CGFloat, variance: CGFloat = 0.75, seed: UInt64 = numericCast(arc4random())) -> [Vertex] {
    
    // How many cells we're going to have on each axis (pad by 2 cells on each edge)
    let cellsX = (size.width + 4 * cellSize) / cellSize
    let cellsY = (size.height + 4 * cellSize) / cellSize
    
    // figure out the bleed widths to center the grid
    let bleedX = ((cellsX * cellSize) - size.width)/2
    let bleedY = ((cellsY * cellSize) - size.height)/2
    
    let _variance = cellSize * variance / 4
    
    var points = [Vertex]()
    let minX = -bleedX
    let maxX = size.width + bleedX
    let minY = -bleedY
    let maxY = size.height + bleedY
    
    let generator = GKLinearCongruentialRandomSource(seed: seed)
    var index:Int = 0
    for i in stride(from: minX, to: maxX, by: cellSize) {
        for j in stride(from: minY, to: maxY, by: cellSize) {
            
            let x = i + cellSize/2 + CGFloat(generator.nextUniform()) + CGFloat.random(-_variance, _variance)
            let y = j + cellSize/2 + CGFloat(generator.nextUniform()) + CGFloat.random(-_variance, _variance)
            
            points.append(Vertex(x: Double(x), y: Double(y), i:index))
            
            index += 1
        }
    }
    
    return points
}


func generateVertices() -> [Vertex] {
    
    let points = [
        Vertex(x: 355.230469, y: 297.437500),
        Vertex(x: 326.996094, y: 302.445312),
        Vertex(x: 297.417969, y: 323.437500),
        Vertex(x: 275.316406, y: 330.824219),
        Vertex(x: 248.277344, y: 337.218750),
        Vertex(x: 217.414062, y: 331.582031),
        Vertex(x: 222.710938, y: 305.828125),
        Vertex(x: 178.609375, y: 280.003906),
        Vertex(x: 147.433594, y: 277.027344),
        Vertex(x: 128.050781, y: 275.207031),
        Vertex(x: 107.046875, y: 281.660156),
        Vertex(x: 80.703125, y: 295.761719),
        Vertex(x: 66.230469, y: 292.707031),
        Vertex(x: 62.867188, y: 271.082031),
        Vertex(x: 52.335938, y: 244.062500),
        Vertex(x: 49.562500, y: 218.578125),
        Vertex(x: 49.562500, y: 195.683594),
        Vertex(x: 49.082031, y: 173.074219),
        Vertex(x: 50.558594, y: 151.972656),
        Vertex(x: 51.550781, y: 126.667969),
        Vertex(x: 53.398438, y: 110.875000),
        Vertex(x: 65.875000, y: 79.074219),
        Vertex(x: 113.449219, y: 45.722656),
        Vertex(x: 150.531250, y: 40.214844),
        Vertex(x: 183.570312, y: 37.839844),
        Vertex(x: 213.722656, y: 37.839844),
        Vertex(x: 256.632812, y: 37.132812),
        Vertex(x: 293.664062, y: 37.132812),
        Vertex(x: 327.710938, y: 51.617188),
        Vertex(x: 344.054688, y: 74.617188),
        Vertex(x: 307.632812, y: 74.074219),
        Vertex(x: 266.683594, y: 74.816406),
        Vertex(x: 256.308594, y: 74.816406),
        Vertex(x: 231.437500, y: 75.582031),
        Vertex(x: 205.078125, y: 76.156250),
        Vertex(x: 211.632812, y: 103.492188),
        Vertex(x: 246.117188, y: 107.816406),
        Vertex(x: 263.960938, y: 108.074219),
        Vertex(x: 283.066406, y: 108.554688),
        Vertex(x: 305.468750, y: 109.128906),
        Vertex(x: 331.613281, y: 109.128906),
        Vertex(x: 342.121094, y: 109.648438),
        Vertex(x: 403.175781, y: 154.804688),
        Vertex(x: 414.871094, y: 173.812500),
        Vertex(x: 425.191406, y: 189.351562),
        Vertex(x: 432.890625, y: 201.656250),
        Vertex(x: 405.640625, y: 205.996094),
        Vertex(x: 392.339844, y: 188.476562),
        Vertex(x: 369.175781, y: 188.738281),
        Vertex(x: 339.246094, y: 189.246094),
        Vertex(x: 316.542969, y: 190.023438),
        Vertex(x: 297.242188, y: 191.812500),
        Vertex(x: 261.750000, y: 196.078125),
        Vertex(x: 241.085938, y: 205.714844),
        Vertex(x: 227.667969, y: 216.320312),
        Vertex(x: 227.667969, y: 231.386719),
        Vertex(x: 230.679688, y: 246.789062),
        Vertex(x: 245.593750, y: 271.511719),
        Vertex(x: 260.476562, y: 280.574219),
        Vertex(x: 284.718750, y: 270.093750),
        Vertex(x: 298.046875, y: 268.871094),
        Vertex(x: 329.246094, y: 261.445312),
        Vertex(x: 352.542969, y: 257.820312),
        Vertex(x: 373.046875, y: 252.421875),
        Vertex(x: 386.300781, y: 249.964844),
        Vertex(x: 400.261719, y: 247.996094),
        Vertex(x: 422.105469, y: 246.265625),
        Vertex(x: 445.746094, y: 249.179688),
        Vertex(x: 472.015625, y: 270.238281),
        Vertex(x: 479.511719, y: 286.984375),
        Vertex(x: 483.464844, y: 308.718750),
        Vertex(x: 483.175781, y: 328.773438),
        Vertex(x: 483.515625, y: 362.542969),
        Vertex(x: 480.570312, y: 381.292969),
        Vertex(x: 477.656250, y: 393.003906),
        Vertex(x: 459.140625, y: 406.371094),
        Vertex(x: 447.546875, y: 411.664062),
        Vertex(x: 422.050781, y: 411.664062),
        Vertex(x: 405.015625, y: 411.664062),
        Vertex(x: 398.527344, y: 397.152344),
        Vertex(x: 397.269531, y: 384.304688),
        Vertex(x: 397.269531, y: 372.085938),
        Vertex(x: 398.085938, y: 352.035156),
        Vertex(x: 389.132812, y: 333.449219),
        Vertex(x: 381.988281, y: 318.738281),
        Vertex(x: 373.375000, y: 309.085938)
    ]
    return points
}


func holes() -> [[Vertex]] {
    
    let holes = [
        [
            Vertex(x: 95.210938, y: 242.546875),
            Vertex(x: 86.761719, y: 233.433594),
            Vertex(x: 84.093750, y: 218.695312),
            Vertex(x: 84.593750, y: 205.703125),
            Vertex(x: 91.140625, y: 197.566406),
            Vertex(x: 104.851562, y: 197.828125),
            Vertex(x: 121.113281, y: 204.687500),
            Vertex(x: 129.207031, y: 222.410156),
            Vertex(x: 130.347656, y: 240.324219),
            Vertex(x: 109.847656, y: 246.628906)
        ], 
        [
            Vertex(x: 176.878906, y: 172.531250),
            Vertex(x: 164.804688, y: 172.531250),
            Vertex(x: 150.117188, y: 170.792969),
            Vertex(x: 141.910156, y: 171.035156),
            Vertex(x: 125.933594, y: 169.148438),
            Vertex(x: 97.855469, y: 165.535156),
            Vertex(x: 82.812500, y: 156.078125),
            Vertex(x: 82.812500, y: 131.925781),
            Vertex(x: 82.812500, y: 113.371094),
            Vertex(x: 95.164062, y: 101.132812),
            Vertex(x: 112.789062, y: 92.945312),
            Vertex(x: 116.765625, y: 109.378906),
            Vertex(x: 108.207031, y: 132.714844),
            Vertex(x: 111.132812, y: 147.378906),
            Vertex(x: 120.539062, y: 147.378906),
            Vertex(x: 138.656250, y: 139.355469),
            Vertex(x: 145.125000, y: 128.515625),
            Vertex(x: 158.941406, y: 122.441406),
            Vertex(x: 169.308594, y: 134.734375),
            Vertex(x: 188.113281, y: 139.937500),
            Vertex(x: 208.738281, y: 137.722656),
            Vertex(x: 217.179688, y: 149.343750),
            Vertex(x: 217.179688, y: 162.550781),
            Vertex(x: 206.863281, y: 161.281250),
            Vertex(x: 197.039062, y: 167.085938),
            Vertex(x: 196.097656, y: 176.984375),
            Vertex(x: 189.292969, y: 168.316406),
            Vertex(x: 180.410156, y: 160.816406),
            Vertex(x: 176.417969, y: 162.761719),
            Vertex(x: 176.660156, y: 168.636719)
        ], 
        [
            Vertex(x: 433.136719, y: 340.503906),
            Vertex(x: 423.667969, y: 335.187500),
            Vertex(x: 418.257812, y: 325.687500),
            Vertex(x: 414.320312, y: 312.246094),
            Vertex(x: 406.863281, y: 297.156250),
            Vertex(x: 402.105469, y: 285.882812),
            Vertex(x: 407.140625, y: 276.753906),
            Vertex(x: 421.750000, y: 275.695312),
            Vertex(x: 434.765625, y: 288.496094),
            Vertex(x: 439.761719, y: 304.183594),
            Vertex(x: 436.914062, y: 316.437500),
            Vertex(x: 445.179688, y: 320.769531),
            Vertex(x: 454.527344, y: 321.894531),
            Vertex(x: 464.757812, y: 328.566406),
            Vertex(x: 458.785156, y: 338.906250),
            Vertex(x: 448.308594, y: 343.589844)
        ]
    ]
    return holes
}
