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
            organizationView(for: person)
            ForEach(person.email) { email in
                emailView(
                    address: email.address,
                    label: email.label
                )
            }
            ForEach(person.phone) { phone in
                phoneView(
                    number: phone.number,
                    label: phone.label
                )
            }
        }.padding()
    }

    @ViewBuilder private func pictureView(for person: Person) -> some View {
        let imageSideSize: CGFloat = 128
        if let pictureUrl = person.pictureUrl {
            AsyncImage(url: pictureUrl) { image in
                image.resizable()
                    .frame(width: imageSideSize, height: imageSideSize)
                    .cornerRadius(8)
            } placeholder: {
                // Same size for placeholder to prevent UI "moving" upon finishing
                ProgressView()
                    .frame(width: imageSideSize, height: imageSideSize)
            }
        } else {
            Image(systemName: "person.crop.square.fill")
                .resizable()
                .frame(width: imageSideSize, height: imageSideSize)
                .cornerRadius(8)
        }
    }

    @ViewBuilder private func nameView(for person: Person) -> some View {
        Text(person.name)
            .font(.largeTitle)
            .navigationTitle(person.name)
            .frame(maxWidth: .infinity, alignment: .leading)
            .textSelection(.enabled)
    }

    @ViewBuilder private func organizationView(for person: Person) -> some View {
        Text("Organization: \(person.organization)")
            .font(.title2)
            .frame(maxWidth: .infinity, alignment: .leading)
            .textSelection(.enabled)
    }

    @ViewBuilder private func emailView(
        address: String,
        label: String
    ) -> some View {
        if let url = URL(string: "mailto:\(address)") {
            Link("\(address) - \(label)", destination: url)
                .font(.title2)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    @ViewBuilder private func phoneView(
        number: String,
        label: String
    ) -> some View {
        if let url = URL(string: "tel:\(number)") {
            Link("\(number) - \(label)", destination: url)
                .font(.title2)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}
