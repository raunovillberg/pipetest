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
            emailView(for: person)
            phoneView(for: person)
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
        }
    }

    @ViewBuilder private func nameView(for person: Person) -> some View {
        if let name = person.name, name.count > 0 {
            Text(name)
                .font(.largeTitle)
                .navigationTitle(name)
                .frame(maxWidth: .infinity, alignment: .leading)
                .textSelection(.enabled)
        }
    }

    @ViewBuilder private func organizationView(for person: Person) -> some View {
        if let org = person.organization, org.count > 0 {
            Text("Organization: \(org)")
                .font(.title2)
                .frame(maxWidth: .infinity, alignment: .leading)
                .textSelection(.enabled)
        }
    }

    @ViewBuilder private func emailView(for person: Person) -> some View {
        if let email = person.email?.value,
           email.count > 0,
           let url = URL(string: "mailto:\(email)") {
            let displayString: String = {
                let base = "E-mail: \(email)"
                if let label = person.email?.label, label.count > 0 {
                    return "\(base) (\(label))"
                }
                return base
            }()

            Link(displayString, destination: url)
                .font(.title2)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    @ViewBuilder private func phoneView(for person: Person) -> some View {
        if let phone = person.phone?.value,
           phone.count > 0,
           let url = URL(string: "tel:\(phone)") {
            let displayString: String = {
                let base = "Phone: \(phone)"
                if let label = person.phone?.label, label.count > 0 {
                    return "\(base) (\(label))"
                }
                return base
            }()

            Link(displayString, destination: url)
                .font(.title2)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}
