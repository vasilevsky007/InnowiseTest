//
//  Spinner.swift
//  InnowiseTest
//
//  Created by Alex on 20.02.24.
//

import SwiftUI

struct Spinner: View {
    var body: some View {
        ProgressView()
            .padding(.all, DrawingConstants.Spinner.size)
            .scaleEffect(DrawingConstants.Spinner.scale)
    }
}

#Preview {
    Spinner()
}
