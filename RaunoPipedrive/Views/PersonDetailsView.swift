import SwiftUI

struct PersonDetailsView: View {
    typealias Person = PersonDetailsViewModel.Details

    @StateObject private var viewModel = PersonDetailsViewModel()
    let personId: Int

    var body: some View {
        if let person = viewModel.details {
            detailsView(for: person)
        } else {
            ProgressView()
                .onAppear {
                    viewModel.onViewAppeared(id: personId)
                }
        }
    }

    @ViewBuilder private func detailsView(for person: Person) -> some View {
        VStack(alignment: .center, spacing: 8) {
            pictureView(for: person)
            nameView(for: person)
            emailView(for: person)
            phoneView(for: person)
        }
    }

    @ViewBuilder private func pictureView(for person: Person) -> some View {
        let imageSideSize: CGFloat = 128
        if let pictureUrl = person.pictureUrl {
            AsyncImage(url: pictureUrl) { image in
                image.resizable()
                    .frame(width: imageSideSize, height: imageSideSize)
            } placeholder: {
                // Same size for placeholder to prevent UI "moving" upon finishing
                ProgressView()
                    .frame(width: imageSideSize, height: imageSideSize)
            }
        }
    }

    @ViewBuilder private func nameView(for person: Person) -> some View {
        if let name = person.name, name.count > 0 {
            Text(name)
                .font(.largeTitle)
                .navigationTitle(name)
        }
    }

    @ViewBuilder private func emailView(for person: Person) -> some View {
        if let email = person.email,
           email.count > 0,
           let url = URL(string: "mailto:\(email)") {
            Link("E-mail: \(email)", destination: url)
                .font(.title2)
        }
    }

    @ViewBuilder private func phoneView(for person: Person) -> some View {
        if let phone = person.phone,
           phone.count > 0,
           let url = URL(string: "tel:\(phone)") {
            Link("Phone: \(phone)", destination: url)
                .font(.title2)
        }
    }
}
