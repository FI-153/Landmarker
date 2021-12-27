//
//  LocationPreviewView.swift
//  Landmarker
//
//  Created by Federico Imberti on 25/12/21.
//

import SwiftUI

struct LocationPreviewView: View {
    
    let location:Location
    
    @ObservedObject var vm:LocationsViewModel
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 0.0) {
            VStack(alignment: .leading, spacing: 16.0) {
                imageSection
                titleSection
            }
            
            VStack(spacing: 8.0){
                learnMoreButton
                nextButton
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(.ultraThinMaterial)
                .offset(y: 65)
                .overlay(alignment: .topTrailing, content: {
                    Toggle3DButtonView(is3DShown: $vm.is3DShown)
                        .padding(.horizontal)
                })
        )
        .frame(maxHeight: 250)
        .cornerRadius(10)
        .padding()
    }
}

extension LocationPreviewView {
    private var imageSection: some View {
        ZStack{
            if let imageName = location.imageNames.first {
                Image(imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                    .cornerRadius(10)
            }
        }
        .padding(6)
        .background(Color.white)
        .cornerRadius(10)

    }

    private var titleSection: some View {
        VStack(alignment: .leading, spacing: 6.0) {
            Text(location.name)
                .font(.title2)
                .bold()
            
            Text(location.cityName)
                .font(.subheadline)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
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
            vm.showNextLocation(location: vm.getNextLocation())
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
            LocationPreviewView(location: LocationsDataService.locations[0], vm: LocationsViewModel())
        }
    }
}
