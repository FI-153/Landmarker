//
//  LocationDetailView.swift
//  Landmarker
//
//  Created by Federico Imberti on 27/12/21.
//

import SwiftUI
import MapKit

struct LocationDetailView: View {
    
    @StateObject private var vm:LocationDetailViewModel
    
    let location:Location
    
    init(isSheetShown:Binding<Bool>, location:Location){
        _vm = StateObject(wrappedValue: LocationDetailViewModel(isSheetShown: isSheetShown))
        self.location = location
    }

    var body: some View {
        ScrollView{
            VStack{
                imageSection
                    .shadow(radius: 20)
                
                VStack(alignment: .leading, spacing: 16){
                    titleSection
                    Divider()
                    descriptionSection
                    Divider()
                    mapSection
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            }
        }
        .ignoresSafeArea()
        .background(.ultraThinMaterial)
        .overlay(alignment: .topTrailing) {
            buttonsSection
        }
    }
}

extension LocationDetailView {
    private var imageSection: some View {
        TabView{
            ForEach(location.imageNames, id: \.self){ imageName in
                Image(imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: UIDevice.current.userInterfaceIdiom == .pad ? nil : UIScreen.main.bounds.width)
            }
        }
        .frame(height: 500)
        .tabViewStyle(PageTabViewStyle())

    }
    
    private var titleSection: some View {
        VStack(alignment: .leading, spacing: 8){
            Text(location.name)
                .font(.largeTitle)
                .fontWeight(.semibold)
            
            Text(location.cityName)
                .font(.title3)
                .foregroundColor(.secondary)
        }
        
    }
    
    private var descriptionSection: some View {
        VStack(alignment: .leading, spacing: 8){
            Text(location.description)
                .font(.headline)
                .foregroundColor(.secondary)
        }
    }
    
    private var mapSection: some View {
        Map(coordinateRegion: .constant( MKCoordinateRegion(center: location.coordinates,
                                                        span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
                                                        )
                                       ),
            annotationItems: [location]) { location in
            MapAnnotation(coordinate: location.coordinates) {
                LocationMapAnnotationView()
            }
        }
            .allowsHitTesting(false)
            .aspectRatio(1, contentMode: .fit)
            .cornerRadius(30)
    }
    
    private var buttonsSection: some View{
        VStack(){
            
            //Close
            Button {
                vm.isSheetShown.toggle()
            } label: {
                ButtonView(imageName: "xmark", isSfSymbol: true)
            }
            .padding(.bottom, 10)
            
            //Wikipedia - links to the page
            if let url = URL(string: location.link) {
                Link(destination: url) {
                    ButtonView(imageName: "wikipedia-logo", isSfSymbol: false)
                }
                .padding(.bottom, 10)
            }
            
            //Directions - plot directions
            Button {
                vm.getDirections(to: location)
            } label: {
                ButtonView(imageName: "location.fill", isSfSymbol: true)
            }
            
        }
        .padding()
    }
    
}



struct LocationDetailView_Previews: PreviewProvider {
    static var previews: some View {
        LocationDetailView(isSheetShown: .constant(true), location: LocationsDataService.locations[0])
    }
}
