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
    
    var body: some View {
        
        ScrollView{
            ForEach(locationManager.locations){ location in
                Button {
                    locationManager.showLocation(location: location)
                    
                    withAnimation(.spring()) {
                        isLocationListShown = false
                    }
                } label: {
                    listRowView(location: location)
                        .padding(.vertical, 4)
                        .background(.ultraThickMaterial)
                }

            }
            .padding()
            
        }

    }
}

extension LocationsListView {
    private func listRowView(location:Location) -> some View{
        HStack{
            if let imageName = location.imageNames.first {
                Image(imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 45, height: 45)
                    .cornerRadius(10)
            }
            
            VStack(alignment: .leading) {
                Text(location.name)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text(location.cityName)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
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
