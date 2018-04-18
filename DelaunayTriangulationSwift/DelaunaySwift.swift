//
//  Delaunay.swift
//  DelaunayTriangulationSwift
//
//  Created by Alex Littlejohn on 2016/01/08.
//  Copyright © 2016 zero. All rights reserved.
//

import Darwin

@objc open class Delaunay : NSObject {
    
    public override init() { }
    
    /* Generates a supertraingle containing all other triangles */
    fileprivate func supertriangle(_ vertices: [Vertex]) -> [Vertex] {
        var xmin = Double(Int32.max)
        var ymin = Double(Int32.max)
        var xmax = -Double(Int32.max)
        var ymax = -Double(Int32.max)
        
        for i in 0..<vertices.count {
            if vertices[i].x < xmin { xmin = vertices[i].x }
            if vertices[i].x > xmax { xmax = vertices[i].x }
            if vertices[i].y < ymin { ymin = vertices[i].y }
            if vertices[i].y > ymax { ymax = vertices[i].y }
        }
        
        let dx = xmax - xmin
        let dy = ymax - ymin
        let dmax = max(dx, dy)
        let xmid = xmin + dx * 0.5
        let ymid = ymin + dy * 0.5
        
        return [
            Vertex(x: xmid - 20 * dmax, y: ymid - dmax),
            Vertex(x: xmid, y: ymid + 20 * dmax),
            Vertex(x: xmid + 20 * dmax, y: ymid - dmax)
        ]
    }
    
    /* Calculate a circumcircle for a set of 3 vertices */
    fileprivate func circumcircle(_ i: Vertex, j: Vertex, k: Vertex) -> Circumcircle {
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
        
        return Circumcircle(vertex1: i, vertex2: j, vertex3: k, x: xc, y: yc, rsqr: rsqr)
    }
    
    fileprivate func dedup(_ edges: [Vertex]) -> [Vertex] {
        
        var e = edges
        var a: Vertex?, b: Vertex?, m: Vertex?, n: Vertex?
        
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
    
    open func triangulate(_ vertices: [Vertex]) -> [Triangle] {
        
        var _vertices = Array(Set.init(vertices)) 
//        var _vertices = vertices.removeDuplicates()
        
        guard _vertices.count >= 3 else {
            return [Triangle]()
        }

        let n = _vertices.count
        var open = [Circumcircle]()
        var completed = [Circumcircle]()
        var edges = [Vertex]()
        
        /* Make an array of indices into the vertex array, sorted by the
        * vertices' x-position. */
        var indices = [Int](0..<n).sorted {  _vertices[$0].x < _vertices[$1].x }
        
        /* Next, find the vertices of the supertriangle (which contains all other
        * triangles) */
        
        _vertices += supertriangle(_vertices)
        
        /* Initialize the open list (containing the supertriangle and nothing
        * else) and the closed list (which is empty since we havn't processed
        * any triangles yet). */
        open.append(circumcircle(_vertices[n], j: _vertices[n + 1], k: _vertices[n + 2]))
        
        /* Incrementally add each vertex to the mesh. */
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
                let dx = _vertices[c].x - open[j].x
                
                if dx > 0 && dx * dx > open[j].rsqr {
                    completed.append(open.remove(at: j))
                    continue
                }
                
                /* If we're outside the circumcircle, skip this triangle. */
                let dy = _vertices[c].y - open[j].y
                
                if dx * dx + dy * dy - open[j].rsqr > Double.ulpOfOne {
                    continue
                }
                
                /* Remove the triangle and add it's edges to the edge list. */
                edges += [
                    open[j].vertex1, open[j].vertex2,
                    open[j].vertex2, open[j].vertex3,
                    open[j].vertex3, open[j].vertex1
                ]
                
//                edges += [
//                    Edge(vertex1: open[j].vertex1, vertex2: open[j].vertex2),
//                    Edge(vertex1: open[j].vertex2, vertex2: open[j].vertex3),
//                    Edge(vertex1: open[j].vertex3, vertex2: open[j].vertex1)
//                ]
                
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
                open.append(circumcircle(a, j: b, k: _vertices[c]))
            }
        }
        
        /* Copy any remaining open triangles to the closed list, and then
        * remove any triangles that share a vertex with the supertriangle,
        * building a list of triplets that represent triangles. */
        completed += open
        
        let ignored: Set<Vertex> = [_vertices[n], _vertices[n + 1], _vertices[n + 2]]
        
        let results = completed.flatMap { (circumCircle) -> Triangle? in
            
            let current: Set<Vertex> = [circumCircle.vertex1, circumCircle.vertex2, circumCircle.vertex3]
            let intersection = ignored.intersection(current)
            if intersection.count > 0 {
                return nil
            }
            
            return Triangle(vertex1: circumCircle.vertex1, vertex2: circumCircle.vertex2, vertex3: circumCircle.vertex3)
        }
        
        /* Yay, we're done! */
        return results
    }
}
