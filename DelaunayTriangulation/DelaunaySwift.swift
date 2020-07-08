//
//  Delaunay.swift
//  DelaunayTriangulationSwift
//
//  Created by Alex Littlejohn on 2016/01/08.
//  Copyright © 2016 zero. All rights reserved.
//

/// Generates a supertraingle containing all other triangles
internal func supertriangle(_ points: [Point]) -> [Point] {
    var xmin = Double(Int32.max)
    var ymin = Double(Int32.max)
    var xmax = -Double(Int32.max)
    var ymax = -Double(Int32.max)
    
    for i in 0..<points.count {
        if points[i].x < xmin { xmin = points[i].x }
        if points[i].x > xmax { xmax = points[i].x }
        if points[i].y < ymin { ymin = points[i].y }
        if points[i].y > ymax { ymax = points[i].y }
    }
    
    let dx = xmax - xmin
    let dy = ymax - ymin
    let dmax = max(dx, dy)
    let xmid = xmin + dx * 0.5
    let ymid = ymin + dy * 0.5
    
    return [
        Point(x: xmid - 20 * dmax, y: ymid - dmax),
        Point(x: xmid, y: ymid + 20 * dmax),
        Point(x: xmid + 20 * dmax, y: ymid - dmax)
    ]
}

/// Calculate the intersecting circumcircle for a set of 3 points
internal func circumcircle(_ i: Point, j: Point, k: Point) -> Circumcircle {
    let x1 = i.x
    let y1 = i.y
    let x2 = j.x
    let y2 = j.y
    let x3 = k.x
    let y3 = k.y
    let xc: Double
    let yc: Double
    
    let fabsy1y2 = abs(y1 - y2)
    let fabsy2y3 = abs(y2 - y3)
    
    if fabsy1y2 < Double.ulpOfOne {
        let m2 = -((x3 - x2) / (y3 - y2))
        let mx2 = (x2 + x3) / 2
        let my2 = (y2 + y3) / 2
        xc = (x2 + x1) / 2
        yc = m2 * (xc - mx2) + my2
    } else if fabsy2y3 < Double.ulpOfOne {
        let m1 = -((x2 - x1) / (y2 - y1))
        let mx1 = (x1 + x2) / 2
        let my1 = (y1 + y2) / 2
        xc = (x3 + x2) / 2
        yc = m1 * (xc - mx1) + my1
    } else {
        let m1 = -((x2 - x1) / (y2 - y1))
        let m2 = -((x3 - x2) / (y3 - y2))
        let mx1 = (x1 + x2) / 2
        let mx2 = (x2 + x3) / 2
        let my1 = (y1 + y2) / 2
        let my2 = (y2 + y3) / 2
        xc = (m1 * mx1 - m2 * mx2 + my2 - my1) / (m1 - m2)
        
        if fabsy1y2 > fabsy2y3 {
            yc = m1 * (xc - mx1) + my1
        } else {
            yc = m2 * (xc - mx2) + my2
        }
    }
    
    let dx = x2 - xc
    let dy = y2 - yc
    let rsqr = dx * dx + dy * dy
    
    return Circumcircle(point1: i, point2: j, point3: k, x: xc, y: yc, rsqr: rsqr)
}

/// Deduplicate a collection of edges
internal func dedup(_ edges: [Point]) -> [Point] {
    
    var e = edges
    var a: Point?, b: Point?, m: Point?, n: Point?
    
    var j = e.count
    while j > 0 {
        j -= 1
        b = j < e.count ? e[j] : nil
        j -= 1
        a = j < e.count ? e[j] : nil
        
        var i = j
        while i > 0 {
            i -= 1
            n = e[i]
            i -= 1
            m = e[i]
            
            if (a == m && b == n) || (a == n && b == m) {
                e.removeSubrange(j...j + 1)
                e.removeSubrange(i...i + 1)
                break
            }
        }
    }
    
    return e
}

public func triangulate(_ points: [Point]) -> [Triangle] {
    
    var _points = Array(Set.init(points))
    
    guard _points.count >= 3 else {
        return [Triangle]()
    }

    let n = _points.count
    var open = [Circumcircle]()
    var completed = [Circumcircle]()
    var edges = [Point]()
    
    /* Make an array of indices into the point array, sorted by the
    * points' x-position. */
    let indices = [Int](0..<n).sorted {  _points[$0].x < _points[$1].x }
    
    /* Next, find the points of the supertriangle (which contains all other
    * triangles) */
    
    _points += supertriangle(_points)
    
    /* Initialize the open list (containing the supertriangle and nothing
    * else) and the closed list (which is empty since we havn't processed
    * any triangles yet). */
    open.append(circumcircle(_points[n], j: _points[n + 1], k: _points[n + 2]))
    
    /* Incrementally add each point to the mesh. */
    for i in 0..<n {
        let c = indices[i]
        
        edges.removeAll()
        
        /* For each open triangle, check to see if the current point is
        * inside it's circumcircle. If it is, remove the triangle and add
        * it's edges to an edge list. */
        for j in (0..<open.count).reversed() {
            
            /* If this point is to the right of this triangle's circumcircle,
            * then this triangle should never get checked again. Remove it
            * from the open list, add it to the closed list, and skip. */
            let dx = _points[c].x - open[j].x
            
            if dx > 0 && dx * dx > open[j].rsqr {
                completed.append(open.remove(at: j))
                continue
            }
            
            /* If we're outside the circumcircle, skip this triangle. */
            let dy = _points[c].y - open[j].y
            
            if dx * dx + dy * dy - open[j].rsqr > Double.ulpOfOne {
                continue
            }
            
            /* Remove the triangle and add it's edges to the edge list. */
            edges += [
                open[j].point1, open[j].point2,
                open[j].point2, open[j].point3,
                open[j].point3, open[j].point1
            ]
            
            open.remove(at: j)
        }
        
        /* Remove any doubled edges. */
        edges = dedup(edges)
        
        /* Add a new triangle for each edge. */
        var j = edges.count
        while j > 0 {
            
            j -= 1
            let b = edges[j]
            j -= 1
            let a = edges[j]
            open.append(circumcircle(a, j: b, k: _points[c]))
        }
    }
    
    /* Copy any remaining open triangles to the closed list, and then
    * remove any triangles that share a point with the supertriangle,
    * building a list of triplets that represent triangles. */
    completed += open
    
    let ignored: Set<Point> = [_points[n], _points[n + 1], _points[n + 2]]
    
    let results = completed.compactMap { (circumCircle) -> Triangle? in
        
        let current: Set<Point> = [circumCircle.point1, circumCircle.point2, circumCircle.point3]
        let intersection = ignored.intersection(current)
        if intersection.count > 0 {
            return nil
        }
        
        return Triangle(point1: circumCircle.point1, point2: circumCircle.point2, point3: circumCircle.point3)
    }
    
    /* Yay, we're done! */
    return results
}

