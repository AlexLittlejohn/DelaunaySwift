//
//  Delaunay.swift
//  Delaunay
//
//  Created by Volodymyr Boichentsov on 14/11/2017.
//  Copyright © 2017 sakrist. All rights reserved.
//

import Darwin
import Foundation

// Original
// https://github.com/mkacz91/Triangulations


open class ConformingDelaunay : NSObject {
    
    public override init() { }
    
    // Given a polygon as a list of vertex indices, returns it in a form of
    // a doubly linked list.
    func constructLinkedPolygon(_ vertices: [Point]) -> [PointNode] {
        var nodes = [PointNode]()
        nodes.append(PointNode(vertices[0]))
        for i in 1..<vertices.count {
            let node = PointNode(vertices[i])
            nodes[i-1].next = node
            node.prev = nodes[i-1]
            nodes.append(node)
        }
        if nodes.last != nil {
            nodes.last!.next = nodes[0]
            nodes[0].prev = nodes.last
        }
        return nodes
    }
    
    // remove duplicate points
    func _removeDuplicates(_ vertices: [Point]) -> [Point] {
        var _vertices = Array(Set(vertices))
        _vertices.sort { (p1, p2) -> Bool in
            return p1.index < p2.index
        }
        return _vertices
    }
    
    
    func aux(_ ab:Edge, _ cd: Edge) -> (Bool) {
        return cd.a.index != ab.a.index && 
            cd.a.index != ab.b.index && 
            cd.b.index != ab.a.index && 
            cd.b.index != ab.b.index &&
            ab.intersect(edge: cd)
    }
    
    // Checks wether any edge on path [nodeBeg, nodeEnd] intersects the segment ab.
    // If nodeEnd is not provided, nodeBeg is interpreted as lying on a cycle and
    // the whole cycle is tested. Edges spanned on equal (===) vertices are not
    // considered intersecting.
    func intersects (ab:Edge, nodeBeg:PointNode, nodeEnd:PointNode? = nil) -> Bool {
        var nodeBeg = nodeBeg
        var nodeEnd = nodeEnd
        
        if (nodeEnd == nil) {
            if aux(ab, nodeBeg.edge) {
                return true
            }
            nodeEnd = nodeBeg
            nodeBeg = nodeBeg.next!
        }
        var node = nodeBeg
        while (node !== nodeEnd) {
            if aux(ab, node.edge) {
                return true
            }
            node = node.next!
        }
        return false
    }
    
    func findDeepestInside(_ abc:Triangle ) -> ((PointNode, PointNode, PointNode?) -> PointNode?) {
        var ac = Edge(abc.point1, abc.point3);
        func best(nodeBeg:PointNode, nodeEnd:PointNode, bestNode:PointNode?) -> PointNode? {
            var bestNode = bestNode
            var maxDepthSq = (bestNode != nil)
                ? ac.distanceSqrt(bestNode!.point) : -1;
            var node = nodeBeg;
            repeat {
                let v = node.point
                if (v.index != abc.point1.index && 
                    v.index != abc.point2.index && 
                    v.index != abc.point3.index && abc.contain(v)) {
                    let depthSq = ac.distanceSqrt(v);
                    if (depthSq > maxDepthSq) {
                        maxDepthSq = depthSq
                        bestNode = node
                    }
                }
                node = node.next!
            } while (node !== nodeEnd)
            return bestNode;
        }
        return best
    }
    
    // Given an origin c and direction defining vertex d, returns a comparator for
    // points. The points are compared according to the angle they create with
    // the vector cd.
    func angleCompare(_ c:Point, _ d:Point) -> ((Point, Point) -> Double) {
        let cd = c - d
        // Compare angles ucd and vcd
        func angleCmp(_ u:Point, _ v:Point) -> Double {
            let cu = c - u
            let cv = c - v
            let cvxcu = cv.cross(cu)
            // Check if they happen to be equal
            if cvxcu == 0 && cu.dot(cv) >= 0 {
                return 0
            }
            let cuxcd = cu.cross(cd)
            let cvxcd = cv.cross(cd)
            // If one of the angles has magnitude 0, it must be strictly smaller than
            // the other one.
            if (cuxcd == 0 && cd.dot(cu) >= 0) {
                return -1
            }
            if (cvxcd == 0 && cd.dot(cv) >= 0) {
                return 1
            }
            // If the points u and v are on the same side of cd, the one that is on the
            // right side of the other must form a smaller angle.
            if (cuxcd * cvxcd >= 0) {
                return cvxcu
            }
            // The one on the left side of cd side forms a smaller angle.
            return cuxcd
        }
        return angleCmp
    }
    
    // Given a triangulation graph, produces the quad-edge datastructure for fast
    // local traversal. The result consists of two arrays: coEdges and sideEdges
    // with one entry per edge each. The coEdges array is returned as list of vertex
    // index pairs, whereas sideEdges are represented by edge index quadruples.
    //
    // Consider edge ac enclosed by the quad abcd. Then its co-edge is bd and the
    // side edges are: bc, cd, da, ab, in that order. Although the graph is not
    // directed, the edges have direction implied by the implementation. The order
    // of side edges is determined by the de facto orientation of the primary edge
    // ac and its co-edge bd, but the directions of the side edges are arbitrary.
    //
    // External edges are handled by setting indices describing one supported
    // triangle to undefined. Which triangle it will be is not determined.
    //
    // WARNING: The procedure will change the orientation of edges.
    func makeQuadEdge(nodes: inout [PointNode], edges: inout [Edge]) -> ([[Int]], [[Int]]) {
        // Prepare datas tructures for fast graph traversal.
        var coEdges = [[Int]]()
        var sideEdges = [[Int]]()
        
        var outEdges = [[Int]]()
        for _ in 0 ..< nodes.count {
            outEdges.append([Int]())
        }
        for j in 0 ..< edges.count {
            let e = edges[j];
            outEdges[e.a.index].append(j);
            outEdges[e.b.index].append(j);
            
            coEdges.append([Int]())
            sideEdges.append([Int]())
        }
        
        // Process edges around each vertex.
        for i in 0 ..< nodes.count {
            let v = nodes[i];
            var js = outEdges[i];
            
            // Reverse edges, so that they point outward and sort them angularily.
            for k in 0..<js.count {
                if (edges[js[k]].a.index != i) {
                    edges[js[k]].swap()
                }
            }
            
            let angleCmp = angleCompare(v.point, edges[js[0]].b);
            js.sort { (j1, j2) -> Bool in
                return angleCmp(edges[j1].b, edges[j2].b) <= 0
            }
            
            // Associate each edge with neighbouring edges appropriately.
            let js_count = js.count
            for k in 0 ..< js_count {
                let jPrev = js[(js_count + k - 1) % js_count]
                let j     = js[k]
                let jNext = js[(k + 1) % js_count]
                // Node that although we could determine the whole co-edge just now, we
                // we choose to push only the endpoint edges[jPrev][1]. The other end,
                // i.e., edges[jNext][1] will be, or already was, put while processing the
                // edges of the opposite vertex, i.e., edges[j][1].
                coEdges[j].append(edges[jPrev].b.index)
                sideEdges[j].append(jPrev)
                sideEdges[j].append(jNext)
            }
        }
        
        for j in 0 ..< edges.count {
            if (!edges[j].external) {
                continue 
            }            
            // If the whole mesh is a triangle, just remove one of the duplicate entries
            if (coEdges[j][0] == coEdges[j][1]) {
                coEdges[j][1] = -1
                sideEdges[j][1] = -1
                sideEdges[j][2] = -1
                continue
            }
            // If the arms of a supported triangle are also external, remove.
            if (edges[sideEdges[j][0]].external && edges[sideEdges[j][3]].external) {
                coEdges[j][0] = -1 
                sideEdges[j][0] = -1 
                sideEdges[j][3] = -1
            }
            if (edges[sideEdges[j][1]].external && edges[sideEdges[j][2]].external) {
                coEdges[j][1] = -1 
                sideEdges[j][1] = -1
                sideEdges[j][2] = -1
            }
        }
     
        return (coEdges, sideEdges)
    }
    
    
    // Refines the given triangulation graph to be a Conforming Delaunay
    // Triangulation (abr. CDT). Edges with property fixed = true are not altered.
    //
    // The edges are modified in place and returned is an array of indeces tried to
    // flip. The flip was performed unless the edge was fixed. If a trace array is
    // provided, the algorithm will log key actions into it.
    func refineToDelaunay(nodes: inout [PointNode], edges: inout [Edge], 
                          coEdges: inout [[Int]], sideEdges: inout [[Int]] /*, trace */) -> [Int] {
        // We mark all edges as unsure, i.e., we don't know whether the enclosing
        // quads of those edges are properly triangulated.
        var unsure = [Bool](repeating:false, count: edges.count)
        var tried = [Int](repeating:-1, count: edges.count)
        var unsureEdges = [Int]()
        for j in 0 ..< edges.count {
            if (!edges[j].fixed) {
                unsureEdges.append(j)
            }
        }
        
        var cookie = 0;
        func maintainDelaunay(_ nodes: inout [PointNode], _ edges: inout [Edge], 
                              _ coEdges: inout [[Int]], _ sideEdges: inout [[Int]], 
                              _ unsureEdges: inout [Int] /*, trace */) -> [Int] {
            cookie += 1
            var triedEdges = unsureEdges;
            for l in 0 ..< unsureEdges.count {
                unsure[unsureEdges[l]] = true
                tried[unsureEdges[l]] = cookie
            }
            
            // The procedure used is the incremental Flip Algorithm. As long as there are
            // any, we fix the triangulation around an unsure edge and mark the
            // surrounding ones as unsure.
            while (unsureEdges.count > 0) {
                let j = unsureEdges.pop()!
                unsure[j] = false;
                
                if (!edges[j].fixed &&
                    ensureDelaunayEdge(&nodes, &edges, &coEdges, &sideEdges, j)) {
                    var newUnsureCnt = 0
                    for k in 0..<4  {
                        let jk = sideEdges[j][k]
                        if (!unsure[jk]) {
                            if (tried[jk] != cookie) {
                                triedEdges.append(jk)
                                tried[jk] = cookie
                            }
                            if (!edges[jk].fixed) {
                                unsureEdges.append(jk)
                                unsure[jk] = true
                                newUnsureCnt += 1
                            }
                        }
                    }
                }
            }
            
            return triedEdges
        }
        
        let r = maintainDelaunay(&nodes, &edges, &coEdges, &sideEdges, &unsureEdges /*, trace */)
        
        return r
    }
    
    
    func arraySubst2(_ a: inout [Int],_ x:Int,_ y:Int) {
        if (a[0] == x) {
            a[0] = y
        } else {
            a[1] = y
        }
    }
    
    func arraySubst4(_ a: inout [Int],_ x:Int,_ y:Int) {
        if (a[0] == x) {
            a[0] = y
        } else if (a[1] == x) { 
            a[1] = y
        } else if (a[2] == x) {
            a[2] = y
        } else {
            a[3] = y
        }           
    }
    
    // Given edges along with their quad-edge datastructure, flips the chosen edge
    // j, maintaining the quad-edge structure integrity.
    func flipEdge (_ nodes: inout [PointNode], 
                   _ edges: inout [Edge],
                   _ coEdges: inout [[Int]],
                   _ sideEdges: inout [[Int]], 
                   _ j:Int) {
        let edge = edges[j]
        let coEdge = coEdges[j]
        let j0 = sideEdges[j][0]
        let j1 = sideEdges[j][1]
        let j2 = sideEdges[j][2]
        let j3 = sideEdges[j][3]
        
        // Amend side edges
        arraySubst2(&coEdges[j0], edge.a.index, coEdge[1])
        arraySubst4(&sideEdges[j0], j , j1)
        arraySubst4(&sideEdges[j0], j3, j )
        
        arraySubst2(&coEdges[j1], edge.a.index, coEdge[0])
        arraySubst4(&sideEdges[j1], j , j0)
        arraySubst4(&sideEdges[j1], j2, j )
        
        arraySubst2(&coEdges[j2], edge.b.index, coEdge[0])
        arraySubst4(&sideEdges[j2], j , j3)
        arraySubst4(&sideEdges[j2], j1, j )
        
        arraySubst2(&coEdges[j3], edge.b.index, coEdge[1])
        arraySubst4(&sideEdges[j3], j , j2)
        arraySubst4(&sideEdges[j3], j0, j )
        
        // Flip
        if let ind = nodes[edge.a.index].edges.index(of: edge) {
            nodes[edge.a.index].edges.remove(at: ind)
        }
        if let ind = nodes[edge.b.index].edges.index(of: edge) {
            nodes[edge.b.index].edges.remove(at: ind)
        }
        
        edges[j] = Edge(nodes[coEdges[j][0]].point, nodes[coEdges[j][1]].point)
        edges[j].external = edge.external
        edges[j].fixed = edge.fixed
        nodes[coEdges[j][0]].edges.append(edges[j])
        nodes[coEdges[j][1]].edges.append(edges[j])
        coEdges[j] = [edge.a.index, edge.b.index] // in order to not effect the input
        
        // Amend primary edge
        let tmp = sideEdges[j][0]
        sideEdges[j][0] = sideEdges[j][2]
        sideEdges[j][2] = tmp
    }
    
    
    
    func isDelaunayEdge(_ nodes: inout [PointNode], 
                         _ edge:Edge, 
                         _ coEdge: [Int]) -> Bool {
        let a = edge.a
        let c = edge.b
        let b = nodes[coEdge[0]].point
        let d = nodes[coEdge[1]].point
        
        return !CircumCircle(a, c, b).contain(d) &&
            !CircumCircle(a, c, d).contain(b)
    }
    
    // Given edges along with their quad-edge datastructure, flips the chosen edge
    // j if it doesn't form a Delaunay triangulation with its enclosing quad.
    // Returns true if a flip was performed.
    func ensureDelaunayEdge(_ nodes: inout [PointNode], _ edges: inout [Edge], 
                            _ coEdges: inout [[Int]], _ sideEdges: inout [[Int]], 
                            _ j:Int) -> Bool {
        if (isDelaunayEdge(&nodes, edges[j], coEdges[j])) {
            return false
        }
        flipEdge(&nodes, &edges, &coEdges, &sideEdges, j)
        return true
    }
    
    
    
    open func triangulate(_ vertices: [Point]) -> [Triangle] {
        return self.triangulate(vertices, nil)
    }
    
    open func triangulate(_ vertices: [Point], _ holesVertices:[[Point]]?) -> [Triangle] {

        var _vertices = _removeDuplicates(vertices)
        
        var allNodes = constructLinkedPolygon(_vertices)
        var polies = [allNodes.first!]
        
        var holes = [PointNode]()
        let countHoles = holesVertices?.count ?? 0
        for i in 0..<countHoles {
            let hole = constructLinkedPolygon(holesVertices![i])
            holes.append(hole.first!)
            allNodes += hole
        }
        
        var edges = [Edge]()
        for item in allNodes {
            var edge = item.edge
            edge.external = true
            edge.fixed = true
            edges.append(edge)
            
            item.edges.append(edge)
            item.next?.edges.append(edge)
        }
        
        // We handle only the outer polygons. We start with only one, but more are
        // to come because of splitting. The holes are eventually merged in.
        // In each iteration a diagonal is added.
        var diagonals = [Edge]()
        while (polies.count > 0) {
            let poly = polies.pop()!
        
            // First we find a locally convex vertex.
            var node = poly
            var convex = false
            var a:Point, b:Point, c:Point 
            repeat {
                a = (node.prev?.point)!
                b = node.point
                c = (node.next?.point)!
                convex = (a - b).cross(b - c) < 0
                node = node.next!
            } while (!convex && node !== poly)
            if !convex {
                continue
            }
            let aNode = node.prev!.prev!
            let bNode = node.prev!
            let cNode = node
        
            // We try to make a diagonal out of ac. This is possible only if it lies
            // completely inside the polygon.
            var acOK = true
            
            // Ensuring there are no intersections of ac with other edges doesn't
            // guarantee that ac lies within the poly. It is also possible that the
            // whole polygon is inside the triangle abc. Therefore we early reject the
            // case when the immediate neighbors of vertices a and c are inside abc.
            // Note that if ac is already an edge, it will also be rejected.
            let abcTriangle = Triangle(a, b, c);
            acOK = !abcTriangle.contain(aNode.prev!.point) && 
                   !abcTriangle.contain(cNode.next!.point)
            
            let ac = Edge(a, c)
            
            // Now we proceed with checking the intersections with ac.
            if acOK {
                acOK = !intersects(ab: ac, nodeBeg: cNode.next!, nodeEnd: aNode.prev!)
            }
            var l = 0
            while ( acOK && l < holes.count) {
                acOK = !intersects(ab: ac, nodeBeg: holes[l])
                l += 1
            }
            
            var split = false
            var fromNode:PointNode?
            var toNode:PointNode?
            if (acOK) {
                // No intersections. We can easily connect a and c.
                fromNode = cNode
                toNode = aNode
                split = true
            } else {
                // If there are intersections, we have to find the closes vertex to b in
                // the direction perpendicular to ac, i.e., furthest from ac. It is
                // guaranteed that such a vertex forms a legal diagonal with b.
                let findBest = findDeepestInside(abcTriangle)
                var best = cNode.next !== aNode
                    ? findBest(cNode.next!, aNode, nil) : nil
                var lHole = -1;
                for l in 0..<holes.count {
                    let newBest = findBest(holes[l], holes[l], best)
                    if newBest !== best {
                        lHole = l
                    }
                    best = newBest
                }
                
                fromNode = bNode
                toNode = best
                
                if (lHole < 0) {
                    // The nearest vertex does not come from a hole. It is lies on the outer
                    // polygon itself (or is undefined).
                    split = true
                } else {
                    // The nearest vertex is found on a hole. The hole will be merged into
                    // the currently processed poly, so we remove it from the hole list.
                    holes.remove(at: lHole)
                    split = false
                }
            }
            
            if (toNode == nil) {
                // It was a triangle all along!
                continue
            }
            
            let edge = Edge(fromNode!.point, toNode!.point)
            diagonals.append(edge)
            allNodes[fromNode!.point.index].edges.append(edge)
            allNodes[toNode!.point.index].edges.append(edge)

//            if (trace != nil) {
//                trace.push({
//                    selectFace: makeArrayPoly(poly),
//                    addDiag: [fromNode.i, toNode.i]
//                });
//            }
            
            let poly1 = PointNode( fromNode!.point, fromNode?.next)
            poly1.prev = PointNode(toNode!.point, poly1, toNode?.prev)
            fromNode?.next?.prev = poly1
            toNode?.prev?.next = poly1.prev
            
            fromNode?.next = toNode
            toNode?.prev = fromNode
            let poly2 = fromNode
            
            if split {
                polies.append(poly1)
                polies.append(poly2!)
            } else {
                polies.append(poly2!)
            }
        }
        
        edges += diagonals
        
        var (coEdges, sideEdges) = makeQuadEdge(nodes:&allNodes, edges: &edges)
        
        _ = refineToDelaunay(nodes: &allNodes, edges: &edges, coEdges: &coEdges, sideEdges: &sideEdges)
         
        
        var tris = [Triangle]()
        
        var edgesCopy = [Edge]()
        for e in edges { 
            edgesCopy.append(e)
            if !e.external {
                let pairEdge = Edge(e.b, e.a)
                allNodes[e.a.index].edges.append(pairEdge)
                allNodes[e.b.index].edges.append(pairEdge)
                edgesCopy.append(pairEdge)
            }
        }
        
//        edgesCopy.sort { (e1, e2) -> Bool in
//            if e1.a.index == e2.a.index {
//                return e1.b.index < e2.b.index 
//            }
//            return e1.a.index < e2.a.index
//        }
        
        func findTriangle(_ e0:Edge) -> Triangle? {
            let node1 = allNodes[e0.b.index]
            for e1 in node1.edges {
                if e0 != e1 {
                    let node2 = (e1.a.index == node1.point.index ) ? allNodes[e1.b.index] : allNodes[e1.a.index]
                    for e2 in node2.edges {
                        if e1 != e2 && (e0.a.index == e2.b.index || e0.a.index == e2.a.index) {
                            edgesCopy.remove(at: 0)
                            if let ind = edgesCopy.index(of: e1) {
                                edgesCopy.remove(at: ind)
                            }
                            if let ind = edgesCopy.index(of: e2) {
                                edgesCopy.remove(at: ind)
                            }
                            if let ind = allNodes[e0.a.index].edges.index(of: e0) {
                                allNodes[e0.a.index].edges.remove(at: ind)
                            }
                            if let ind = allNodes[e0.b.index].edges.index(of: e0) {
                                allNodes[e0.b.index].edges.remove(at: ind)
                            }
                            if let ind = allNodes[e1.a.index].edges.index(of: e1) {
                                allNodes[e1.a.index].edges.remove(at: ind)
                            }
                            if let ind = allNodes[e1.b.index].edges.index(of: e1) {
                                allNodes[e1.b.index].edges.remove(at: ind)
                            }
                            if let ind = allNodes[e2.a.index].edges.index(of: e2) {
                                allNodes[e2.a.index].edges.remove(at: ind)
                            }
                            if let ind = allNodes[e2.b.index].edges.index(of: e2) {
                                allNodes[e2.b.index].edges.remove(at: ind)
                            }
                            
                            return Triangle(e0.a, e0.b, node2.point)           
                        }
                    }
                }
            }
            edgesCopy.remove(at: 0)
            print("Edge was deleted, because no triangle for it. \(e0)")
            return nil
        }
        
        while edgesCopy.count > 0 {
            let e0 = edgesCopy[0]
            if let t = findTriangle(e0) {
                tris.append(t)
            }
        }
        
//        for e in edges {
//            tris.append(Triangle(e.a, e.a, e.b))
//        }
        
        
        return tris        
    }
    
}
