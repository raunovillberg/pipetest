import SwiftUI

struct PersonListRow: View {
    var item: PersonListViewModel.Person

    var body: some View {
        VStack {
            Text(item.name ?? "Unknown name")
            Text(item.email ?? "No e-mail")
            Text(item.phone ?? "No phone")
        }
    }
}
