//
//  LoadableImage.swift
//  InnowiseTest
//
//  Created by Alex on 23.02.24.
//

import SwiftUI

/// subview for visual representation of image that can be loaded
struct LoadableImage: View {
    /// image to display
    let image: Binding<ImageData?>
    /// clojure for trying to reload button
    let reloadImage: () -> Void
    
    var body: some View {
        VStack {
            switch image.wrappedValue?.state {
            case .loading:
                Spacer()
                Spinner()
                    .aspectRatio(contentMode: .fit)
                Spacer()
            case .error(let error):
                Spacer()
                Image(systemName: Strings.Sources.errorIcon)
                    .font(.largeTitle)
                    .foregroundStyle(.red)
                Text(error.localizedDescription)
                    .font(.caption2)
                    .foregroundStyle(.red)
                    .padding(.horizontal, DrawingConstants.standardSpacing)
                Button(
                    Strings.LoadableImage.reload,
                    systemImage: Strings.Sources.reloadIcon) {
                        reloadImage()
                    }.buttonStyle(.bordered)
                Spacer()
            case .loaded(let imageData):
                Image(uiImage: .init(data: imageData)!)
                    .resizable(resizingMode: .stretch)
                    .aspectRatio(contentMode: .fit)
            case .none:
                Spacer()
                Spinner()
                    .aspectRatio(contentMode: .fit)
                Spacer()
            }
        }
    }
}

#Preview("loading") {
    LoadableImage(image:
            .constant(
                .init(
                    url: URL(string: "https://www.google.com/")!,
                    state: .loading
                )
            ), reloadImage: {}
    )
}

#Preview("loaded") {
    LoadableImage(image:
            .constant(
                .init(
                    url: URL(string: "https://www.google.com/")!,
                    state: .loaded(imageData: UIImage(systemName: Strings.Sources.settingsIcon)!.pngData()!)
                )
            ), reloadImage: {}
    )
}

#Preview("error") {
    LoadableImage(image:
            .constant(
                .init(
                    url: URL(string: "https://www.google.com/")!,
                    state: .error(error: PersistenceErrors.noImageInContext)
                )
            ), reloadImage: {}
    )
}
