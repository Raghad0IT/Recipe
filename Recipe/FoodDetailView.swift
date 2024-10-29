
import SwiftUI

struct FoodDetailView: View {
    @ObservedObject var viewModel: FoodViewModel
    var foodItem: FoodItem

    @Environment(\.dismiss) private var dismiss
    @State private var showDeleteAlert = false
    @State private var showEditView = false

    var body: some View {
        VStack {
            if let foodImage = foodItem.image {
                Image(uiImage: foodImage)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 435)
                    .foregroundColor(.gray)
            }

            Text(foodItem.title)
                .font(.largeTitle)
                .padding(.top)
                .foregroundColor(.white)

            Text(foodItem.description)
                .padding()
                .foregroundColor(.white)

            Text("Quantity: \(foodItem.quantity) \(foodItem.quantityType)")
                .font(.headline)
                .padding()
                .foregroundColor(.white)

            Spacer()

            HStack {
                Button("Delete") {
                    showDeleteAlert = true
                }
                .foregroundColor(.red)
                .padding()

                Spacer()

                Button("Edit") {
                    showEditView = true
                }
                .padding()
            }
            .padding()
        }
        .background(Color.black) // Set background color to black
        .navigationTitle("Detaiels ")
        .alert(isPresented: $showDeleteAlert) {
            Alert(
                title: Text("Delete a recipe"),
                message: Text("Are you sure you want to delete the recipe?"),
                primaryButton: .destructive(Text("حذف")) {
                    viewModel.deleteItem(foodItem)
                    dismiss()
                },
                secondaryButton: .cancel(Text("Cancel"))
            )
        }
        .sheet(isPresented: $showEditView) {
            AddEditFoodView(viewModel: viewModel, itemToEdit: .constant(foodItem))
        }
    }
}




