//
//  LocationDetailView.swift
//  Landmarker
//
//  Created by Federico Imberti on 27/12/21.
//

import SwiftUI
import MapKit
import Combine

struct LocationDetailView: View {
    
    @StateObject private var vm:LocationDetailViewModel
    
    init(isSheetShown:Binding<Bool>, location:Landmark){
        _vm = StateObject(wrappedValue: LocationDetailViewModel(isSheetShown: isSheetShown, location: location))
    }

    var body: some View {
        ScrollView(showsIndicators: false){
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
            
            if !vm.images.isEmpty{
				showImages
            } else {
                ProgressView()
            }
        }
        .frame(height: 500)
        .tabViewStyle(PageTabViewStyle())

    }
	
	private var showImages: some View{
		ForEach(vm.images, id: \.self){ image in
			
			Image(uiImage: image)
				.resizable()
				.scaledToFill()
				.frame(width: UIDevice.current.userInterfaceIdiom == .pad ? nil : UIScreen.main.bounds.width)
		}
	}
    
    private var titleSection: some View {
        VStack(alignment: .leading, spacing: 8){
            Text(vm.location.name)
                .font(.largeTitle)
                .fontWeight(.semibold)
            
            Text(vm.location.cityName)
                .font(.title3)
                .foregroundColor(.secondary)
        }
        
    }
    
    private var descriptionSection: some View {
        VStack(alignment: .leading, spacing: 8){
            Text(vm.location.description)
                .font(.headline)
                .foregroundColor(.secondary)
		}
	}
	
	private var mapSection: some View {
		Map(coordinateRegion: .constant(
			MKCoordinateRegion(
				center: vm.location.coordinates,
				span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
			)
		),
			annotationItems: [vm.location]) { location in
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
			
			closeButton
				.padding(.bottom, 10)
            
            if let url = URL(string: vm.location.link) {
				showWikipediaButton(for: url)
					.padding(.bottom, 10)
            }
            
            directionButton
            
        }
        .padding()
    }
	
	private var closeButton: some View {
		Button {
			vm.isSheetShown.toggle()
		} label: {
			ButtonView(imageName: "xmark", isSfSymbol: true)
		}
	}
	
	private func showWikipediaButton(for url:URL) -> some View{
		Link(destination: url) {
			ButtonView(imageName: "wikipedia-logo", isSfSymbol: false)
		}
	}
	
	private var directionButton: some View{
		Button {
			LocationsManager.getDirections(to: vm.location)
		} label: {
			ButtonView(imageName: "location.fill", isSfSymbol: true)
		}
	}
    
}



struct LocationDetailView_Previews: PreviewProvider {
    static var previews: some View {
        LocationDetailView(isSheetShown: .constant(true), location: Landmark.mockLandmarks[0])
    }
}
