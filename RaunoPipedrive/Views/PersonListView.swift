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
        if let items = viewModel.items {
            if items.isEmpty {
                Text("No contacts found.\nPlease add some in your Pipedrive account.")
                if let url = URL(string: "https://www.pipedrive.com") {
                    Spacer()
                    Link("Go to Pipedrive", destination: url)
                }
            }

            List(items) { item in
                NavigationLink {
                    PersonDetailsView(personId: item.id)
                    Spacer()
                } label: {
                    PersonRowView(item: item)
                }
            }
        } else {
            ProgressView()
        }
    }
}

struct PersonListView_Previews: PreviewProvider {
    static var previews: some View {
        PersonListView()
    }
}
