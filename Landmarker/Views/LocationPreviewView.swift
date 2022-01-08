//
//  LocationPreviewView.swift
//  Landmarker
//
//  Created by Federico Imberti on 25/12/21.
//

import SwiftUI

struct LocationPreviewView: View {
    let location:Location

    @EnvironmentObject var locationManager:LocationsManager
    @Binding var is3DShown:Bool
    @Binding var isSheetShown:Bool
    
    let imageCacheManager = ImageCacheManager.shared
    let downloadImageManager = DownloadImagesManager.shared

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
            if let downloadedImage = downloadImageManager.downloadedImages[location.id] {
                Image(uiImage: downloadedImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                    .cornerRadius(10)

            } else if let cachedImage = imageCacheManager.fetchImage(named: location.id as NSString) {
                Image(uiImage: cachedImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                    .cornerRadius(10)
                
            } else {
                ProgressView()
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                    .cornerRadius(10)
            }
            
            
        }
        .padding(6)
        .cornerRadius(10)
        
    }

    private var titleSection: some View {
        VStack(alignment: .leading, spacing: 6.0) {
            Text(location.name)
                .font(.title2)
                .bold()
            
            Text(location.cityName)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var learnMoreButton: some View {
        Button {
            isSheetShown.toggle()
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
            LocationPreviewView(location: DownloadDataManager.mockLocations[0], is3DShown: .constant(false), isSheetShown: .constant(false))
        }
    }
}
