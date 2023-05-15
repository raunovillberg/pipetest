import SwiftUI

struct PersonRowView: View {
    var item: PersonListViewModel.Person

    var body: some View {
        VStack {
            Text(item.name ?? "Unnamed contact")
                .font(.title2)
                .frame(maxWidth: .infinity, alignment: .leading)
        }.frame(alignment: .leading)
    }
}
