import SwiftUI

struct Searchbar: View {
    @Binding var query: String
    let cancel: Command?
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField("Search", text: $query)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            if (cancel != nil) {
                Button(action: cancel!) {
                    Text("Clear")
                }
                .buttonStyle(BorderlessButtonStyle())
            }
        }
    }
}


struct Searchbar_Previews: PreviewProvider {
    static var previews: some View {
        List {
            Searchbar(
                query: State(initialValue: "").projectedValue,
                cancel: nop
            )
        }
    }
}
import Core

struct SearchbarConnector: Connector {
    func map(graph: Graph) -> some View {
        Searchbar(
            query: Binding(
                get: { graph.search.query },
                set: { graph.search.query = $0 }
            ),
            cancel: graph.search.canClear
                ? graph.search.clear
                : nil
        )
    }
}
