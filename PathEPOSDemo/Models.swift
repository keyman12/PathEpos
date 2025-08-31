import Foundation

struct InventoryItem: Identifiable, Codable {
    let id = UUID()
    let name: String
    let description: String
    let price: Double
    let imageName: String
    let category: String
}

struct CartItem: Identifiable {
    let id = UUID()
    let item: InventoryItem
    var quantity: Int
    var totalPrice: Double {
        return item.price * Double(quantity)
    }
}

struct Transaction: Identifiable {
    let id = UUID()
    let items: [CartItem]
    let totalAmount: Double
    let paymentMethod: PaymentMethod
    let timestamp: Date
    let cashReceived: Double?
    let changeGiven: Double?
}

enum PaymentMethod: String, CaseIterable {
    case cash = "Cash"
    case card = "Card"
}

// Sample inventory data
extension InventoryItem {
    static let sampleItems = [
        InventoryItem(name: "Coffee", description: "Fresh brewed coffee", price: 3.50, imageName: "cup.and.saucer.fill", category: "Beverages"),
        InventoryItem(name: "Sandwich", description: "Ham and cheese sandwich", price: 8.99, imageName: "birthday.cake.fill", category: "Food"),
        InventoryItem(name: "Water", description: "Bottled water", price: 2.50, imageName: "drop.fill", category: "Beverages"),
        InventoryItem(name: "Cake", description: "Chocolate cake slice", price: 5.99, imageName: "birthday.cake.fill", category: "Food"),
        InventoryItem(name: "Tea", description: "Hot tea", price: 2.99, imageName: "cup.and.saucer.fill", category: "Beverages"),
        InventoryItem(name: "Cookie", description: "Chocolate chip cookie", price: 1.99, imageName: "birthday.cake.fill", category: "Food")
    ]
}
