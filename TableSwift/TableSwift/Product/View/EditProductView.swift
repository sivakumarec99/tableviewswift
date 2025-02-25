//
//  EditProductView.swift
//  TableSwift
//
//  Created by Sivakumar R on 26/02/25.
//

import SwiftUI

struct EditProductView: View {
    @ObservedObject var productService: ProductService
    @Environment(\.dismiss) var dismiss

    var product: Product

    @State private var name: String
    @State private var price: String
    @State private var description: String
    @State private var imageUrl: String

    init(product: Product, productService: ProductService) {
        self.product = product
        self.productService = productService
        _name = State(initialValue: product.name)
        _price = State(initialValue: "\(product.price)")
        _description = State(initialValue: product.description)
        _imageUrl = State(initialValue: product.imageUrl)
    }

    var body: some View {
        NavigationView {
            Form {
                TextField("Product Name", text: $name)
                TextField("Price", text: $price)
                    .keyboardType(.decimalPad)
                TextField("Description", text: $description)
                TextField("Image URL", text: $imageUrl)
                
                Button("Update Product") {
                    guard let priceValue = Double(price) else { return }
                    let updatedProduct = Product(id: product.id, name: name, price: priceValue, description: description, imageUrl: imageUrl, userId: product.userId)
                    productService.updateProduct(product: updatedProduct) { error in
                        if error == nil {
                            dismiss()
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
            .navigationTitle("Edit Product")
        }
    }
}
