//
//  ProductDetailView.swift
//  TableSwift
//
//  Created by Sivakumar R on 26/02/25.
//

import SwiftUI

struct ProductDetailView: View {
    let product: Product

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // 🔹 Product Image
                AsyncImage(url: URL(string: product.imageUrl)) { phase in
                    if let image = phase.image {
                        image.resizable().scaledToFit()
                    } else if phase.error != nil {
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.gray)
                    } else {
                        ProgressView()
                    }
                }
                .frame(height: 250)
                .cornerRadius(10)

                // 🔹 Product Name
                Text(product.name)
                    .font(.largeTitle)
                    .fontWeight(.bold)

                // 🔹 Product Price
                Text("$\(product.price, specifier: "%.2f")")
                    .font(.title2)
                    .foregroundColor(.green)

                // 🔹 Product Description
                Text(product.description)
                    .font(.body)
                    .foregroundColor(.secondary)

                Spacer()
            }
            .padding()
        }
        .navigationTitle("Product Details")
    }
}
