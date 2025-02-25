//
//  ProductListView.swift
//  TableSwift
//
//  Created by Sivakumar R on 26/02/25.
//

import SwiftUI

struct ProductListView: View {
    @StateObject private var productService = ProductService()
    @State private var showAddProductView = false
    @State private var selectedProduct: Product?

    var body: some View {
        NavigationView {
            List {
                ForEach(productService.products) { product in
                    ProductRow(product: product, productService: productService) { selected in
                        selectedProduct = selected
                    }
                }
            }
            .onAppear {
                productService.fetchProducts()
            }
            .navigationTitle("Products")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showAddProductView.toggle() }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showAddProductView) {
                AddProductView(productService: productService)
            }
            .sheet(item: $selectedProduct) { product in
                EditProductView(product: product, productService: productService)
            }
        }
    }
}

struct ProductRow: View {
    let product: Product
    let productService: ProductService
    var onEdit: (Product) -> Void  // Pass selected product to the parent view

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(product.name).font(.headline)
                Text("$\(product.price, specifier: "%.2f")").font(.subheadline)
            }
            Spacer()
            Button(action: {
                onEdit(product)
            }) {
                Image(systemName: "pencil")
                    .foregroundColor(.blue)
            }
            Button(action: {
                productService.deleteProduct(productId: product.id!) { error in
                    if error != nil {
                        print("Error deleting product: \(error!.localizedDescription)")
                    }
                }
            }) {
                Image(systemName: "trash")
                    .foregroundColor(.red)
            }
        }
    }
}
