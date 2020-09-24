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

struct SearchbarConnector: Connector {
    func map(state: AppState, store: EnvironmentStore) -> some View {
        Searchbar(
            query: Binding(
                get: { state.searchResults.query },
                set: store.bind(Action.updateSearchQuery)
            ),
            cancel: state.searchResults.canClearSearch
                ? store.bind(.clearSearchQuery)
                : nil
        )
    }
}
