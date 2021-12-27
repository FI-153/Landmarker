//
//  Toggle3DButtonView.swift
//  Landmarker
//
//  Created by Federico Imberti on 26/12/21.
//

import SwiftUI

struct Toggle3DButtonView: View {
    
    @Binding var is3DShown:Bool
    
    var body: some View {
        Button {
            withAnimation(.easeInOut){
                is3DShown.toggle()
            }
            
        } label: {
            Text("3D")
                .foregroundColor(is3DShown ? .white : .black)
                .font(.system(size: 25, weight: .bold))
                .background(
                    ZStack{
                        if is3DShown {
                            coloredBackground
                        }
                        opacqueBackground
                    }
                )
        }
        
    }
}

extension Toggle3DButtonView {
    private var coloredBackground: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(
                LinearGradient(colors: [Color.accentColor, Color.secondary], startPoint: .bottomLeading, endPoint: .topTrailing)
            )
            .frame(width: 55, height: 55)
            .transition(.scale.combined(with: .opacity))
    }
    
    private var opacqueBackground: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(Material.ultraThinMaterial)
            .frame(width: 60, height: 60)
    }
    
}



struct Toggle3DButtonView_Previews: PreviewProvider {
    static var previews: some View {
        Toggle3DButtonView(is3DShown: .constant(true))
    }
}
