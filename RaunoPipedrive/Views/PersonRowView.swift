import SwiftUI

struct PersonRowView: View {
    var item: PersonListViewModel.ListItem

    var body: some View {
        VStack {
            Text(item.name)
                .font(.title2)
                .frame(maxWidth: .infinity, alignment: .leading)
        }.frame(alignment: .leading)
    }
}
