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
        if viewModel.items.isEmpty {
            Text("No contacts found.\nPlease add some in your Pipedrive account!")
        }

        List(viewModel.items) { item in
            NavigationLink {
                PersonDetailsView(personId: item.id)
                    .frame(alignment: .top)
            } label: {
                PersonRowView(item: item)
            }
        }
    }
}

struct PersonListView_Previews: PreviewProvider {
    static var previews: some View {
        PersonListView()
    }
}
