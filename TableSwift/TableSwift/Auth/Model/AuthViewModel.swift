//
//  AuthViewModel.swift
//  TableSwift
//
//  Created by JIDTP1408 on 25/02/25.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class AuthViewModel: ObservableObject {
    @Published var user: FirebaseAuth.User?
    @Published var userProfile: UserProfile?
    @Published var errorMessage: String?
    private let db = Firestore.firestore()

    init() {
           Auth.auth().addStateDidChangeListener { [weak self] _, user in
               DispatchQueue.main.async {
                   self?.user = user
                   if let user = user {
                       self?.checkIfUserExists(user: user)
                   } else {
                       self?.userProfile = nil
                   }
               }
           }
       }

       private func checkIfUserExists(user: User) {
           user.reload { error in
               DispatchQueue.main.async {
                   if let error = error {
                       print("User does not exist or session expired: \(error.localizedDescription)")
                       self.logout() // Force logout if user is deleted
                   } else {
                       self.fetchUserProfile()
                   }
               }
           }
       }
    
    func fetchUserProfile() {
          guard let userId = Auth.auth().currentUser?.uid else { return }

          db.collection("users").document(userId).getDocument { document, error in
              if let document = document, document.exists {
                  if let data = document.data() {
                      DispatchQueue.main.async {
                          self.userProfile = UserProfile(
                              id: userId,
                              name: data["name"] as? String ?? "",
                              email: data["email"] as? String ?? "",
                              profileImageUrl: data["profileImageUrl"] as? String ?? ""
                          )
                      }
                  }
              } else {
                  print("User profile not found.")
              }
          }
    }
    func logout() {
         do {
             try Auth.auth().signOut()
             DispatchQueue.main.async {
                 self.user = nil
                 self.userProfile = nil
             }
         } catch {
             print("Error signing out: \(error.localizedDescription)")
         }
     }
    func updateUserProfile(name: String, profileImage: UIImage?, completion: @escaping (Bool) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            completion(false)
            return
        }

        let db = Firestore.firestore()
        var updatedData: [String: Any] = ["name": name]

        // If there's a new profile image, upload it
        if let newImage = profileImage {
            uploadProfileImage(newImage, userId: userId) { imageUrl in
                if let imageUrl = imageUrl {
                    updatedData["profileImageUrl"] = imageUrl
                }
                self.saveUpdatedProfile(userId: userId, data: updatedData, completion: completion)
            }
        } else {
            // Just update the name
            saveUpdatedProfile(userId: userId, data: updatedData, completion: completion)
        }
    }

    private func saveUpdatedProfile(userId: String, data: [String: Any], completion: @escaping (Bool) -> Void) {
        let db = Firestore.firestore()
        db.collection("users").document(userId).updateData(data) { error in
            if let error = error {
                print("Error updating profile: \(error.localizedDescription)")
                completion(false)
            } else {
                print("Profile updated successfully!")
                completion(true)
            }
        }
    }
    
    func signUp(email: String, password: String, name: String, profileImage: UIImage?, completion: @escaping (Bool) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                self.errorMessage = error.localizedDescription
                completion(false)
                return
            }
            
            guard let user = result?.user else {
                completion(false)
                return
            }
            
            self.user = user
            
            // Upload profile image if provided
            if let image = profileImage {
                self.uploadProfileImage(image, userId: user.uid) { imageUrl in
                    self.saveUserProfile(userId: user.uid, name: name, email: email, profileImageUrl: imageUrl)
                    completion(true)
                }
            } else {
                self.saveUserProfile(userId: user.uid, name: name, email: email, profileImageUrl: nil)
                completion(true)
            }
        }
    }
    
    func saveUserProfile(userId: String, name: String, email: String, profileImageUrl: String?) {
        let db = Firestore.firestore()
        
        let userData: [String: Any] = [
            "uid": userId,
            "name": name,
            "email": email,
            "profileImageUrl": profileImageUrl ?? ""
        ]
        
        db.collection("users").document(userId).setData(userData) { error in
            if let error = error {
                print("Error saving user profile: \(error.localizedDescription)")
            }
        }
    }
    
    func uploadProfileImage(_ image: UIImage, userId: String, completion: @escaping (String?) -> Void) {
        let storageRef = Storage.storage().reference().child("profile_images/\(userId).jpg")
        
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            completion(nil)
            return
        }
        
        storageRef.putData(imageData, metadata: nil) { _, error in
            if let error = error {
                print("Error uploading profile image: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            storageRef.downloadURL { url, error in
                if let error = error {
                    print("Error getting download URL: \(error.localizedDescription)")
                    completion(nil)
                    return
                }
                completion(url?.absoluteString)
            }
        }
    }
    
    
    func signup(name: String, email: String, password: String, completion: @escaping (Error?) -> Void) {
            Auth.auth().createUser(withEmail: email, password: password) { result, error in
                if let error = error {
                    completion(error)
                    return
                }

                guard let userId = result?.user.uid else { return }

                let userData = [
                    "name": name,
                    "email": email,
                    "profileImageUrl": "" // Placeholder for now
                ]

                self.db.collection("users").document(userId).setData(userData) { error in
                    DispatchQueue.main.async {
                        if let error = error {
                            completion(error)
                        } else {
                            self.user = result?.user
                            self.fetchUserProfile()
                            completion(nil)
                        }
                    }
                }
            }
    }
    func login(email: String, password: String, completion: @escaping (Error?) -> Void) {
          Auth.auth().signIn(withEmail: email, password: password) { result, error in
              DispatchQueue.main.async {
                  if let error = error {
                      completion(error)
                  } else {
                      self.user = result?.user
                      self.fetchUserProfile()
                      completion(nil)
                  }
              }
          }
      }
    func signUp(email: String, password: String, completion: @escaping (Bool) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                self.errorMessage = error.localizedDescription
                completion(false)
                return
            }
            self.user = result?.user
            completion(true)
        }
    }

    func signIn(email: String, password: String, completion: @escaping (Bool) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                self.errorMessage = error.localizedDescription
                completion(false)
                return
            }
            self.user = result?.user
            completion(true)
        }
    }

    func signOut() {
        do {
            try Auth.auth().signOut()
            self.user = nil
        } catch {
            self.errorMessage = "Failed to sign out"
        }
    }
}
