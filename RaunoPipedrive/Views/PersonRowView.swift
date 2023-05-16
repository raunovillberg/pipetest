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

struct PersonRowView_Previews: PreviewProvider {
    static var previews: some View {
        PersonRowView(item: PersonListViewModel.ListItem(id: 0, name: "Nimi"))
    }
}
