
import SwiftUI

struct FoodItem: Identifiable {
    var id = UUID()
    var title: String
    var description: String
    var quantity: Int
    var quantityType: String
    var image: UIImage?
    var ingredients: [(String, Measurement, Int)]
    var newQuantityItem: String?
}



