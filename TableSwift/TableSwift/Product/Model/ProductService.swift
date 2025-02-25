//
//  ProductService.swift
//  TableSwift
//
//  Created by Sivakumar R on 26/02/25.
//

import FirebaseFirestore
import FirebaseAuth

class ProductService: ObservableObject {
    private let db = Firestore.firestore()
    private let collectionName = "products"
    
    @Published var products: [Product] = []

    // 🔹 Create Product
    func addProduct(name: String, price: Double, description: String, imageUrl: String, completion: @escaping (Error?) -> Void) {
           guard let userId = Auth.auth().currentUser?.uid else {
               print("Error: No authenticated user")
               completion(NSError(domain: "AuthError", code: 401, userInfo: [NSLocalizedDescriptionKey: "User not logged in"]))
               return
           }

           let productData: [String: Any] = [
               "name": name,
               "price": price,
               "description": description,
               "imageUrl": imageUrl,
               "userId": userId, // Ensure products belong to a user
               "createdAt": FieldValue.serverTimestamp()
           ]

           db.collection("products").addDocument(data: productData) { error in
               if let error = error {
                   print("Firestore Error: \(error.localizedDescription)")
                   completion(error)
               } else {
                   print("✅ Product successfully added!")
                   self.fetchProducts() // Refresh product list
                   completion(nil)
               }
           }
    }

    // 🔹 Fetch All Products
    func fetchProducts() {
            db.collection("products").getDocuments { snapshot, error in
                if let error = error {
                    print("🔥 Firestore Error: \(error.localizedDescription)")
                    return
                }

                guard let documents = snapshot?.documents else {
                    print("⚠️ No products found")
                    return
                }

                var fetchedProducts: [Product] = []

                for doc in documents {
                    do {
                        let product = try doc.data(as: Product.self)
                        fetchedProducts.append(product)
                    } catch {
                        print("⚠️ Error decoding product \(doc.documentID): \(error.localizedDescription)")
                    }
                }

                DispatchQueue.main.async {
                    self.products = fetchedProducts
                    print("✅ Successfully fetched \(self.products.count) products")
                }
            }
        }
    // 🔹 Update Product
    func updateProduct(product: Product, completion: @escaping (Error?) -> Void) {
        do {
            try db.collection(collectionName).document(product.userId).setData(from: product, merge: true)
            completion(nil)
        } catch {
            completion(error)
        }
    }

    // 🔹 Delete Product
    func deleteProduct(productId: String, completion: @escaping (Error?) -> Void) {
        db.collection(collectionName).document(productId).delete { error in
            completion(error)
        }
    }
}
