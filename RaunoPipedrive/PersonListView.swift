import SwiftUI

struct PersonListView: View {
    @StateObject private var viewModel = PersonListViewModel()

    var body: some View {
        NavigationStack {
            VStack {
                contactsView
            }.navigationTitle("Contacts")
        }
    }

    @ViewBuilder
    private var contactsView: some View {
        List(viewModel.items) { item in
            NavigationLink {
                PersonDetailsView()
            } label: {
                PersonListRow(item: item)
            }
        }
    }
}

struct PersonListView_Previews: PreviewProvider {
    static var previews: some View {
        PersonListView()
    }
}
