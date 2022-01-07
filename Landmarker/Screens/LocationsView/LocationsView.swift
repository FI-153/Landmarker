//
//  LocationsView.swift
//  Landmarker
//
//  Created by Federico Imberti on 25/12/21.
//

import SwiftUI
import MapKit

struct LocationsView: View {
    
    @EnvironmentObject private var locationManager:LocationsManager
    @StateObject private var vm:LocationsViewModel = LocationsViewModel()
    
    private let maxWidthForIpad:CGFloat = 700
    private let locationsDataService = DownloadDataManager.shared
    
    var body: some View {
        
        if locationsDataService.isLoading {
            loadingView
        } else {
            ZStack{
                MapView(location: locationManager.mapLocation, is3DEnabled: vm.is3DShown)
                    .ignoresSafeArea()
                
                //Overlay of the map
                VStack(spacing: 0){
                    header
                        .padding()
                        .frame(maxWidth: maxWidthForIpad)
                    
                    Spacer()
                    
                    locationPreviewStack
                        .frame(maxWidth: maxWidthForIpad)
                        .overlay(alignment: .topTrailing) {
                            toggle3dButton
                                .padding(.horizontal)
                        }
                    
                    
                }
            }
            .sheet(isPresented: $vm.isSheetShown) {
                LocationDetailView(isSheetShown: $vm.isSheetShown, location: locationManager.mapLocation)
            }
        }
    }
}

extension LocationsView{
    private var loadingView: some View {
        ZStack {
            Image("logo-launch")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            ProgressView()
                .foregroundColor(.black)
        }
    }
    
    private var header: some View {
        VStack {
            Text("\(locationManager.mapLocation.name), \(locationManager.mapLocation.cityName)")
                .font(.title2)
                .bold()
                .frame(height: 55)
                .frame(maxWidth: .infinity)
                .animation(.none, value: locationManager.mapLocation)
                .overlay(alignment: .leading) {
                    Button {
                        vm.toggleLocationsList()
                    } label: {
                        Image(systemName: "arrow.down")
                            .font(.headline)
                            .foregroundColor(.primary)
                            .padding()
                            .rotationEffect(.degrees(vm.arrowRotationAmount))
                    }
                }
            
            //drop down menu of the locations
            if vm.isLocationListShown {
                LocationsListView(isLocationListShown: $vm.isLocationListShown)
            }
            
        }
        .background(.thickMaterial)
        .cornerRadius(10)
        .shadow(color: .black.opacity(0.3), radius: 20)
        
    }
    
    private var locationPreviewStack: some View {
        ZStack{
            //Used ForEach to allow for the transition to happend when the current location is changed
            ForEach(locationManager.locations){ location in
                
                //Display the preview of only the current location
                if locationManager.mapLocation == location {
                    LocationPreviewView(location: location, is3DShown: $vm.is3DShown, isSheetShown: $vm.isSheetShown)
                        .frame(maxWidth: maxWidthForIpad)
                        .frame(maxWidth: .infinity)
                        .transition(.asymmetric(
                            insertion: .move(edge: .trailing),
                            removal: .move(edge: .leading))
                        )
                }
            }
            .shadow(color: Color.black.opacity(0.3), radius: 20)
        }
        
    }
    
    private var toggle3dButton: some View {
        Button {
            vm.toggle3D()
        } label: {
            Image("")
                .sheetButtonImage(isSFSymbol: true)
                .overlay{
                    if vm.is3DShown {
                        Image(systemName: "view.2d")
                            .foregroundColor(.primary)
                            .font(.headline)
                            .transition(.asymmetric(insertion: .move(edge: .bottom), removal: .move(edge: .top)).combined(with: .opacity))
                    } else {
                        Image(systemName: "view.3d")
                            .foregroundColor(.primary)
                            .font(.headline)
                            .transition(.asymmetric(insertion: .move(edge: .top), removal: .move(edge: .bottom)).combined(with: .opacity))
                    }

                }
                .shadow(color: Color.black.opacity(0.3), radius: 20)
                
        }
        
    }
}



struct Previews_LocationsView_Previews: PreviewProvider {
    static var previews: some View {
        LocationsView()
            .environmentObject(LocationsManager())
    }
}
