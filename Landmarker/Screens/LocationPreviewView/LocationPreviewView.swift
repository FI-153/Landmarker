//
//  LocationPreviewView.swift
//  Landmarker
//
//  Created by Federico Imberti on 25/12/21.
//

import SwiftUI
import Combine

struct LocationPreviewView: View {

    @EnvironmentObject var locationManager:LocationsManager
    @StateObject var vm:LocationPreviewViewModel

    internal init(location: Landmark, is3DShown: Binding<Bool>, isSheetShown:Binding<Bool>) {
        self._vm = StateObject(wrappedValue: LocationPreviewViewModel(location: location, is3DShown: is3DShown, isSheetShown: isSheetShown))
    }
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 0.0) {
            VStack(alignment: .leading, spacing: 16.0) {
                imageSection
					.padding(6)
					.cornerRadius(10)
				
                titleSection
					.frame(maxWidth: .infinity, alignment: .leading)
            }
            
            VStack(spacing: 8.0){
                learnMoreButton
                nextButton
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(.thickMaterial)
                .offset(y: 70)
        )
        .cornerRadius(10)
        .padding(.horizontal)
        .padding(.bottom, 40)
    }
    
}

extension LocationPreviewView {
    
    private var imageSection: some View {
        ZStack{
            Group{
                if let image = vm.thumbnailImage {
                    Image(uiImage: image)
                        .resizable()
                } else {
                    ProgressView()
                }
            }
            .scaledToFill()
            .frame(width: 100, height: 100)
            .cornerRadius(10)
        }
        
    }
    
    private var titleSection: some View {
        VStack(alignment: .leading, spacing: 6.0) {
            Text(vm.location.name)
                .font(.title2)
                .bold()
            
            Text(vm.location.cityName)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
    
    private var learnMoreButton: some View {
        Button {
            vm.isSheetShown.toggle()
        } label: {
            Text("Learn more")
                .font(.headline)
                .frame(width: 125, height: 35)
        }
        .buttonStyle(.borderedProminent)
    }
    
    private var nextButton: some View {
        Button {
            locationManager.showNextLocation()
        } label: {
            Text("Next")
                .font(.headline)
                .frame(width: 125, height: 35)
        }
        .buttonStyle(.bordered)
    }

}


struct LocationPreviewView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            LocationPreviewView(location: Landmark.mockLandmarks[0], is3DShown: .constant(false), isSheetShown: .constant(false))
        }
    }
}
