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
        if let error = viewModel.error {
            Text("Error: \(error)")
        }
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
                }.disabled(viewModel.usingCachedData)
            }
            if viewModel.usingCachedData {
                Text("No Internet connectivity.\nDisplaying cached list of contacts.\nMay not be up-to-date.")
                    .multilineTextAlignment(.center)
                    .font(.title3)
                    .padding()
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
