
import SwiftUI

class FoodViewModel: ObservableObject {
    @Published var items: [FoodItem] = []
    @Published var searchText: String = ""

    var filteredItems: [FoodItem] {
        if searchText.isEmpty {
            return items
        } else {
            return items.filter { $0.title.contains(searchText) }
        }
    }

    func addItem(_ item: FoodItem) {
        items.append(item)
    }

    func updateItem(item: FoodItem, newTitle: String, newDescription: String, newQuantity: Int, newQuantityType: String, newQuantityItem: String?, newImage: UIImage?) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index].title = newTitle
            items[index].description = newDescription
            items[index].quantity = newQuantity
            items[index].quantityType = newQuantityType
            items[index].newQuantityItem = newQuantityItem
            if let newImage = newImage {
                items[index].image = newImage
            }
        }
    }

    func deleteItem(_ item: FoodItem) {
        items.removeAll { $0.id == item.id }
    }
}







