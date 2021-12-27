//
//  LocationsListView.swift
//  Landmarker
//
//  Created by Federico Imberti on 25/12/21.
//

import SwiftUI

struct LocationsListView: View {
    @EnvironmentObject var locationManager:LocationsManager
    
    var body: some View {
        List{
            ForEach(locationManager.locations){ location in
                Button {
                    locationManager.showNextLocation(location: location)
                } label: {
                    listRowView(location: location)
                        .background(Color.clear)
                        .padding(.vertical, 4)

                }

            }
        }
        .listStyle(.plain)
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
                
                Text(location.cityName)
                    .font(.subheadline)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }

    }
}



struct LocationsListView_Previews: PreviewProvider {
    static var previews: some View {
        LocationsListView()
            .environmentObject(LocationsManager())
    }
}
