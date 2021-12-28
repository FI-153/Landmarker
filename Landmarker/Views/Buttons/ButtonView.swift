//
//  BackButton.swift
//  Landmarker
//
//  Created by Federico Imberti on 27/12/21.
//

import SwiftUI

struct ButtonView: View {
    
    let imageName:String
    let isSfSymbol:Bool
        
    var body: some View {
        if isSfSymbol {
            Image(systemName: imageName)
                .sheetButtonImage(isSFSymbol: true)
            
        } else {
            Image(imageName)
                .sheetButtonImage(isSFSymbol: false)
        }

    }
}

extension Image {
    func sheetButtonImage(isSFSymbol:Bool) -> some View {
        self
            .resizable()
            .scaledToFit()
            .scaleEffect(isSFSymbol ? 1 : 1.4)
            .font(.headline)
            .frame(width: 20, height: 20)
            .padding()
            .foregroundColor(.primary)
            .background(.thickMaterial)
            .cornerRadius(10)
            .shadow(radius: 4)
        
    }
}



struct BackButtonView_Previews: PreviewProvider {
    static var previews: some View {
        HStack{
            ButtonView(imageName: "xmark", isSfSymbol: true)
            ButtonView(imageName: "wikipedia-logo", isSfSymbol: false)
        }
    }
}
