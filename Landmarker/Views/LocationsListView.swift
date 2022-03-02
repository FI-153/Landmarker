//
//  LocationsListView.swift
//  Landmarker
//
//  Created by Federico Imberti on 25/12/21.
//

import SwiftUI
import Combine

struct LocationsListView: View {
    
    @EnvironmentObject var locationManager:LocationsManager
    @StateObject var vm = LocationListViewModel()
    @Binding var isLocationListShown:Bool
        
    var body: some View {
        
        ScrollView(showsIndicators: false){
			
            ForEach(locationManager.locations){ location in
				showLocationButton(for: location)
					.padding(.vertical, 10)

            }
			
            .padding()
            
        }

    }
}

extension LocationsListView {
	
	private func showLocationButton(for location: Landmark) -> some View {
		Button {
			locationManager.showLocation(location)
			
			withAnimation(.spring()) {
				isLocationListShown = false
			}
		} label: {
			listRowView(location: location)
				.padding(.vertical, 4)
				.background(Color.clear)
		}
	}
	
    private func listRowView(location:Landmark) -> some View{
        HStack{
            
            Group{
                
                if let image = vm.thumbnails.first(where: { (key: String, _: UIImage) in
                    key.hasPrefix(location.id)
                }) {
                    Image(uiImage: image.value)
                        .resizable()
                } else {
                    ProgressView()
                }
                
            }
            .scaledToFill()
            .frame(width: 45, height: 45)
            .cornerRadius(10)
            
            showTextSection(for: location)
				.frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer()
            
            showDirectionsButton(for: location)
        }

    }
	
	private func showTextSection(for location: Landmark) -> some View{
		VStack(alignment: .leading) {
			Text(location.name)
				.font(.headline)
				.foregroundColor(.primary)
			
			Text(location.cityName)
				.font(.subheadline)
				.foregroundColor(.secondary)
		}
	}
	
	private func showDirectionsButton(for location: Landmark) -> some View {
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

class LocationListViewModel:ObservableObject {
    let downloadImagesManager = DownloadImagesManager.shared
    var cancellables = Set<AnyCancellable>()
    
    @Published var thumbnails: [String:UIImage] = [:]
    init(){
        addSubscriberToPreviewImage()
    }
    
    func addSubscriberToPreviewImage(){
        downloadImagesManager.$downloadedThumbnails.sink { downloadedImages in
            self.thumbnails = downloadedImages
        }
        .store(in: &cancellables)
    }
    
}
