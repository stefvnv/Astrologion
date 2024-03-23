import SwiftUI
import CoreLocation

struct SelectLocationView: View {
    @EnvironmentObject var viewModel: RegistrationViewModel
    @State private var showCreatePasswordView = false
    @State private var locationText: String = ""
    
    private let geocoder = CLGeocoder()
    
    var body: some View {
        VStack(spacing: 12) {
            Text("Enter your location of birth")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.top)
            
            LocationSearchView(location: $locationText)
            
            Button(action: {
                geocodeLocationName(locationText)
            }) {
                Text("Next")
                    .modifier(IGButtonModifier())
            }
            .disabled(locationText.isEmpty)
            .opacity(locationText.isEmpty ? 0.5 : 1.0)
            
            Spacer()
        }
        .navigationDestination(isPresented: $showCreatePasswordView, destination: {
            CreatePasswordView().environmentObject(viewModel)
        })
    }
    
    private func geocodeLocationName(_ locationName: String) {
        geocoder.geocodeAddressString(locationName) { (placemarks, error) in
            if let placemark = placemarks?.first, let location = placemark.location {
                self.viewModel.latitude = location.coordinate.latitude
                self.viewModel.longitude = location.coordinate.longitude
                print("Coordinates: \(location.coordinate.latitude), \(location.coordinate.longitude)")
                self.showCreatePasswordView = true
            } else {
                // If there was an error or no location found, print it to the console
                print("No location found for \(locationName)")
                if let error = error {
                    print("Geocoding error: \(error.localizedDescription)")
                }
            }
        }
    }
}
