import SwiftUI

struct PersonRowView: View {
    var item: PersonListViewModel.Person

    var body: some View {
        VStack {
            Text(item.name ?? "Unnamed contact")
                .font(.title2)
                .frame(maxWidth: .infinity, alignment: .leading)
            emailView
                .frame(maxWidth: .infinity, alignment: .leading)
            phoneView
                .frame(maxWidth: .infinity, alignment: .leading)
        }.frame(alignment: .leading)
    }

    @ViewBuilder private var emailView: some View {
        if let email = item.email, email.count > 0 {
            Text("E-mail: \(email)")
        }
        EmptyView()
    }

    @ViewBuilder private var phoneView: some View {
        if let phone = item.phone, phone.count > 0 {
            Text("Phone: \(phone)")
        }
        EmptyView()
    }
}
