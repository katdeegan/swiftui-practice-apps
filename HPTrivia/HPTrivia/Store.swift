//
//  Store.swift
//  HPTrivia
//
//  Created by Katherine Deegan on 3/18/24.
//

import Foundation
import StoreKit

// Codable = Encodable + Decodable
enum BookStatus: Codable {
    case active
    case inactive
    case locked
}

@MainActor
class Store: ObservableObject {
    // Observable Object so views can keep an eye on changes
    @Published var books: [BookStatus] = [.active, .active, .inactive, .locked, .locked, .locked, .locked]
    
    // store what products (books) have been purchased
    @Published var products: [Product] = []
    
    // keep track of what user has purchased
    @Published var purchasedIDs = Set<String>()
    
    // based on Product IDs in store config file
    private var productIDs = ["hp4", "hp5", "hp6", "hp7"]
    
    private var updates: Task<Void, Never>? = nil
    
    private let savePath = FileManager.documentsDirectory.appending(path: "SavedBookStatuses")
    
    init() {
        // when new store is initialized
        updates = watchForUpdates()
    }
    
    func loadProducts() async {
        do {
            products = try await Product.products(for: productIDs)
        } catch {
            print("Couldn't fetch products: \(error)")
        }
    }
    
    func purchase(_ product: Product) async {
        do {
            let result = try await product.purchase()
            
            switch result {
            case .success(let verificationResult):
                // purchase was succesful, but we have to verify receipt (make sure purchase was legit)
                switch verificationResult {
                case .unverified(let signedType, let verificationError):
                    print("Error on \(signedType): \(verificationError)")
                case .verified(let signedType):
                    purchasedIDs.insert(signedType.productID)
                    
                }
                
            case .userCancelled:
                // user cancelled, or parent disapproved child's purchase
                break
                
            case .pending:
                // waiting for approval (from user or parent)
                break
                
            @unknown default:
                // unknown cases that may exist in future
                break
            }
            
        } catch {
            print("Couldn't purchase product: \(error)")
        }
    }
    
    func saveStatus() {
        do {
            let data = try JSONEncoder().encode(books)
            try data.write(to: savePath)
        } catch {
            print("Unable to save data.")
        }
    }
    
    func loadStatus() {
        do {
            let data = try Data(contentsOf: savePath)
            books = try JSONDecoder().decode([BookStatus].self, from: data)
        } catch {
            print("Couldn't load book statuses.")
        }
    }
    
    private func checkPurchased() async {
        // check what user has ever purchased (i.e. even if they delete / re-download app)
        for product in products {
            guard let state = await product.currentEntitlement else { return }
            
            switch state {
            case .unverified(let signedType, let verificationError):
                print("Error on \(signedType): \(verificationError)")
            case .verified(let signedType):
                if signedType.revocationDate == nil {
                    // Apple can revoke purchase
                    purchasedIDs.insert(signedType.productID)
                } else {
                    purchasedIDs.remove(signedType.productID)
                }
            }
        }
    }
    
    private func watchForUpdates() -> Task<Void, Never> {
        // anytime there is a notification from outside of app that something happened (i.e. if user makes a purchase directly in app store), check for purchased products
        Task(priority: .background) {
            for await _ in Transaction.updates {
                await checkPurchased()
            }
        }
    }
}
