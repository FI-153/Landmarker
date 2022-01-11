//
//  LocationsListView.swift
//  Landmarker
//
//  Created by Federico Imberti on 25/12/21.
//

import SwiftUI

struct LocationsListView: View {
    
    @EnvironmentObject var locationManager:LocationsManager
    @Binding var isLocationListShown:Bool
    
    let downloadImagesManager = DownloadImagesManager.shared
    
    var body: some View {
        
        ScrollView(showsIndicators: false){
            ForEach(locationManager.locations){ location in
                Button {
                    locationManager.showLocation(location: location)
                    
                    withAnimation(.spring()) {
                        isLocationListShown = false
                    }
                } label: {
                    listRowView(location: location)
                        .padding(.vertical, 4)
                        .background(Color.clear)
                }
                .padding(.vertical, 10)

            }
            .padding()
            
        }

    }
}

extension LocationsListView {
    private func listRowView(location:Location) -> some View{
        HStack{
            
            Group{
                if let imageName = downloadImagesManager.downloadedThumbnails[location.id]{
                    Image(uiImage: imageName)
                        .resizable()
                } else {
                    ProgressView()
                }
                
            }
            .scaledToFill()
            .frame(width: 45, height: 45)
            .cornerRadius(10)
            
            VStack(alignment: .leading) {
                Text(location.name)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text(location.cityName)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer()
            
            Button {
                LocationsManager.getDirections(to: location)
            } label: {
            Image(systemName: "location.fill")
                .padding(.horizontal)
                .symbolRenderingMode(.none)
                .foregroundColor(.primary)
            }
        }

    }
}



struct LocationsListView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.red.ignoresSafeArea()
            
            LocationsListView(isLocationListShown: .constant(true))
                .environmentObject(LocationsManager())
        }
    }
}
