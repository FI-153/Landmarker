//
//  LocationsView.swift
//  Landmarker
//
//  Created by Federico Imberti on 25/12/21.
//

import SwiftUI
import MapKit

struct LocationsView: View {
    
    @EnvironmentObject private var vm:LocationsViewModel
    
    var body: some View {
        ZStack{
            MapView(coordinate: vm.mapLocation.coordinates, is3DEnabled: vm.is3DShown)
                .ignoresSafeArea()
            
//            Map(coordinateRegion: $vm.mapRegion,
//                annotationItems: vm.locations) { location in
//                MapAnnotation(coordinate: location.coordinates) {
//                    LocationMapAnnotationView()
//                        .scaleEffect(vm.mapLocation == location ? 1 : 0.7)
//                        .shadow(radius: 10)
//                        .onTapGesture {
//                            vm.showNextLocation(location: location)
//                        }
//                }
//            }
//                .ignoresSafeArea()
            
            VStack(spacing: 0){
                header
                    .padding()
                
                Spacer()
                
                locationPreviewStack
            }
        }
        .sheet(isPresented: $vm.isSheetShown) {
            LocationDetailView(location: vm.mapLocation, isSheetShown: $vm.isSheetShown)
        }
    }
}

extension LocationsView{
    private var header: some View {
        VStack {
            Text("\(vm.mapLocation.name), \(vm.mapLocation.cityName)")
                .font(.title2)
                .bold()
                .frame(height: 55)
                .frame(maxWidth: .infinity)
                .animation(.none, value: vm.mapLocation)
                .overlay(alignment: .leading) {
                    Button {
                        vm.toggleLocationsList()
                    } label: {
                        Image(systemName: "arrow.down")
                            .font(.headline)
                            .foregroundColor(.primary)
                            .padding()
                            .rotationEffect(.degrees(vm.isLocationListShown ? -180 : 0))
                    }
                }
            
            //drop down menu of the locations
            if vm.isLocationListShown {
                LocationsListView()
            }
            
        }
        .background(.thickMaterial)
        .cornerRadius(10)
        .shadow(radius: 20)
        
    }
    
    private var locationPreviewStack: some View {
        ZStack{
            //Used ForEach to alloe for the transition to happend when the current location is changed
            ForEach(vm.locations){ location in
                
                //Display the preview of only the current location
                if vm.mapLocation == location {
                    LocationPreviewView(location: location, vm: vm)
                        .shadow(color: Color.black.opacity(0.3), radius: 20)
                        .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                }
            }
        }

    }
}


struct Previews_LocationsView_Previews: PreviewProvider {
    static var previews: some View {
        LocationsView()
            .environmentObject(LocationsViewModel())
    }
}
