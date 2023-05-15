import SwiftUI

struct PersonListView: View {
    @StateObject private var viewModel = PersonListViewModel()

    var body: some View {
        NavigationStack {
            VStack {
                List(viewModel.items) { item in
                    VStack {
                        Text(item.name ?? "Unknown name")
                        Text(item.email ?? "No e-mail")
                        Text(item.phone ?? "No phone")
                    }
                }
            }
        }
    }
}

struct PersonListView_Previews: PreviewProvider {
    static var previews: some View {
        PersonListView()
    }
}
