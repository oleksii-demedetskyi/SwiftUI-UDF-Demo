//
//  File.swift
//  
//
//  Created by Oleksii Demedetskyi on 25.09.2020.
//

import Foundation

extension Graph {
    public func movie(id: Movie.Id) -> MovieNode {
        return MovieNode(graph: self, id: id)
    }
}

public struct MovieNode {
    let graph: Graph
    let id: Movie.Id
    
    var entity: Movie { graph.state.allMovies.byId[id]! }
    
    public var title: String { entity.title }
    public var description: String { entity.description }
}
