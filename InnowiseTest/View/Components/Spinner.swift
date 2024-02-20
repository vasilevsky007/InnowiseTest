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
            .padding(.all, 20)
            .scaleEffect(CGSize(width: 2, height: 2))
    }
}

#Preview {
    Spinner()
}
