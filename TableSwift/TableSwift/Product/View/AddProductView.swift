//
//  AddProductView.swift
//  TableSwift
//
//  Created by Sivakumar R on 26/02/25.
//

import Foundation
import SwiftUI

struct AddProductView: View {
    @ObservedObject var productService: ProductService
    @Environment(\.dismiss) var dismiss

    @State private var name = ""
    @State private var price = ""
    @State private var description = ""
    @State private var imageUrl = ""

    var body: some View {
        NavigationView {
            Form {
                TextField("Product Name", text: $name)
                TextField("Price", text: $price)
                    .keyboardType(.decimalPad)
                TextField("Description", text: $description)
                TextField("Image URL", text: $imageUrl)
                
                Button("Add Product") {
                    guard let priceValue = Double(price), !name.isEmpty, !description.isEmpty else {
                        print("Error: Invalid input")
                        return
                    }

                    productService.addProduct(name: name, price: priceValue, description: description, imageUrl: imageUrl) { error in
                        if let error = error {
                            print("Error adding product: \(error.localizedDescription)")
                        } else {
                            print("✅ Product added successfully!")
                            dismiss()
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
            .navigationTitle("Add Product")
        }
    }
}
