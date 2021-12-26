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
            toggle3d()
        } label: {
            
            Text("3D")
                .foregroundColor(is3DShown ? .white : .black)
                .font(.system(size: 25, weight: .bold))
                .background(
                    
                    ZStack{
                        if is3DShown {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(
                                    LinearGradient(colors: [Color.red, Color.blue.opacity(0.8)], startPoint: .bottomLeading, endPoint: .topTrailing)
                                )
                                .frame(width: 55, height: 55)
                                .transition(.scale.combined(with: .opacity))
                        }
                        
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Material.ultraThinMaterial)
                            .frame(width: 60, height: 60)
                    }
                )
        }
        
    }
    
    func toggle3d(){
        withAnimation(.easeInOut){
            is3DShown.toggle()
        }
    }
}

struct Toggle3DButtonView_Previews: PreviewProvider {
    static var previews: some View {
        Toggle3DButtonView(is3DShown: .constant(true))
    }
}
