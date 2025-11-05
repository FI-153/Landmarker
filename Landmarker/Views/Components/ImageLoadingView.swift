//
//  ImageLoadingView.swift
//  Landmarker
//
//  Created by Federico Imberti on 2025-11-05.
//

import SwiftUI

struct ImageLoadingView: View {
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.gray.opacity(0.3))
            ProgressView()
        }
    }
}

#Preview {
    ImageLoadingView()
        .frame(width: 100, height: 100)
        .cornerRadius(16)
}
