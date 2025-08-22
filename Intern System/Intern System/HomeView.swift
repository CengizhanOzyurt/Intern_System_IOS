import SwiftUI

struct HomeView: View {
    let fullName: String

    var body: some View {
        VStack {
            Text("Welcome")
                .font(.title2)
                .padding(.bottom, 10)
            
            Text(fullName)
                .font(.title)
                .bold()
                .foregroundColor(.blue)
        }
        .navigationTitle("Home Page")
    }
}
