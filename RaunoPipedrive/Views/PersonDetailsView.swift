import SwiftUI

struct PersonDetailsView: View {
    typealias Person = PersonListViewModel.Person // TODO: Refactor into separate model

    @StateObject private var viewModel = PersonDetailsViewModel()
    let id: Int

    var body: some View {
        if let person = viewModel.details {
            detailsView(for: person)
        } else {
            ProgressView()
                .onAppear {
                    viewModel.onViewAppeared(id: id)
                }
        }
    }

    @ViewBuilder private func detailsView(for person: Person) -> some View {
        if let name = person.name, name.count > 0 {
            Text(name).navigationTitle(name)
        }

        EmptyView()
    }
}
