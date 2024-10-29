
import SwiftUI
import PhotosUI

enum Measurement: String, CaseIterable {
    case spoon = "🥄 Spoon"
    case cup = "🥛 Cup "
    
    var title: String {
        self.rawValue
    }
}

struct AddEditFoodView: View {
    @ObservedObject var viewModel: FoodViewModel
    @Binding var itemToEdit: FoodItem?
    @State private var title: String = ""
    @State private var description: String = ""
    @State private var ingredients: [(String, Measurement, Int)] = []
    @State private var showIngredientPopup: Bool = false
    @State private var image: UIImage? = nil
    @State private var showImagePicker: Bool = false

    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Title").foregroundColor(.white)) {
                    TextField("Title", text: $title)
                        .foregroundColor(.white)
                }
                Section(header: Text("Description").foregroundColor(.white)) {
                    TextField("Description", text: $description)
                        .foregroundColor(.white)
                }
                Section(header: Text("Ingrediant").foregroundColor(.white)) {
                    ingredientList
                    addIngredientButton
                }
                Section(header: Text("Image").foregroundColor(.white)) {
                    imageUploadView
                }
            }
            .navigationTitle("New Recipe")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveItem()
                    }
                    .foregroundColor(.orange)
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Back") {
                        dismiss()
                    }
                    .foregroundColor(.orange)
                }
            }
            .background(Color.black)
            .scrollContentBackground(.hidden)
            .overlay(ingredientPopupOverlay)
        }
        .accentColor(.white)
        .onAppear {
            loadItemData()
        }
    }
    
    private var ingredientList: some View {
        ForEach(ingredients, id: \.0) { ingredient in
            HStack {
                Text(ingredient.0)
                    .foregroundColor(.white)
                Spacer()
                Text("\(ingredient.2) \(ingredient.1.title)")
                    .foregroundColor(.white)
            }
        }
    }
    
    private var addIngredientButton: some View {
        HStack {
            Text("Add Ingredient")
                .font(.headline)
                .foregroundColor(.white)
            Spacer()
            Button(action: { showIngredientPopup.toggle() }) {
                Image(systemName: "plus.circle.fill")
                    .foregroundColor(.orange)
                    .font(.title)
            }
        }
    }
    
    private var ingredientPopupOverlay: some View {
        Group {
            if showIngredientPopup {
                IngredientPopup(showPopup: $showIngredientPopup, ingredients: $ingredients)
            }
        }
    }
    
    private var imageUploadView: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 0)
                .fill(Color.gray.opacity(0.7))
                .frame(height: 200)
                .frame(width: 365)
                .overlay(
                    RoundedRectangle(cornerRadius: 0)
                        .stroke(Color.orange, style: StrokeStyle(lineWidth: 2, dash: [5]))
                )
            
            if let selectedImage = image {
                Image(uiImage: selectedImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
            } else {
                Image(systemName: "photo.badge.plus")
                    .font(.system(size: 60, weight: .bold))
                    .foregroundColor(.orange)
            }
            
            Text("Upload Photo")
                .font(.system(size: 24, weight: .bold))
                .padding(.top, 120)
                .foregroundColor(.white)
        }
        .padding(.top, 10)
        .onTapGesture {
            showImagePicker = true
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(image: $image)
        }
    }
    
    private func loadItemData() {
        guard let item = itemToEdit else { return }
        title = item.title
        description = item.description
        ingredients = item.ingredients
        image = item.image
    }
    
    private func saveItem() {
        // Save logic without required checks
        let newQuantity = ingredients.reduce(0) { $0 + $1.2 }
        let newQuantityType = ingredients.isEmpty ? "" : ingredients[0].1.title

        if let item = itemToEdit {
            viewModel.updateItem(
                item: item,
                newTitle: title,
                newDescription: description,
                newQuantity: newQuantity,
                newQuantityType: newQuantityType,
                newQuantityItem: nil,
                newImage: image
            )
        } else {
            let newItem = FoodItem(
                title: title,
                description: description,
                quantity: newQuantity,
                quantityType: newQuantityType,
                image: image,
                ingredients: ingredients
            )
            viewModel.addItem(newItem)
        }
        
        dismiss()
    }
    
    struct ImagePicker: UIViewControllerRepresentable {
        @Binding var image: UIImage?
        
        func makeCoordinator() -> Coordinator {
            Coordinator(self)
        }
        
        func makeUIViewController(context: Context) -> PHPickerViewController {
            var configuration = PHPickerConfiguration(photoLibrary: .shared())
            configuration.selectionLimit = 1
            configuration.filter = .images
            
            let picker = PHPickerViewController(configuration: configuration)
            picker.delegate = context.coordinator
            return picker
        }
        
        func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
        
        class Coordinator: NSObject, PHPickerViewControllerDelegate {
            var parent: ImagePicker
            
            init(_ parent: ImagePicker) {
                self.parent = parent
            }
            
            func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
                picker.dismiss(animated: true)
                guard let result = results.first else { return }
                
                if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
                    result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] (image, error) in
                        if let uiImage = image as? UIImage {
                            DispatchQueue.main.async {
                                self?.parent.image = uiImage
                            }
                        }
                    }
                }
            }
        }
    }
}

struct IngredientPopup: View {
    @Binding var showPopup: Bool
    @Binding var ingredients: [(String, Measurement, Int)]
    
    @State private var ingredientName: String = ""
    @State private var selectedMeasurement: Measurement = .spoon
    @State private var quantity: Int = 1

    var body: some View {
        ZStack {
            Color.black.opacity(0.5).ignoresSafeArea()
            VStack(spacing: 20) {
                Text("Ingrediant")
                    .foregroundColor(.white)
                TextField("Ingredients", text: $ingredientName)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)

                HStack {
                    ForEach(Measurement.allCases, id: \.self) { measurement in
                        MeasurementButton(label: measurement.title, measurement: measurement, selected: $selectedMeasurement)
                    }
                }

                quantitySelector
                actionButtons
            }
            .padding()
            .background(Color.black)
            .cornerRadius(16)
            .padding(.horizontal, 40)
        }
    }

    private var quantitySelector: some View {
        HStack {
            Button { if quantity > 1 { quantity -= 1 } } label: {
                Image(systemName: "minus.rectangle")
                    .font(.title)
                    .foregroundColor(.orange)
            }
            Text("\(quantity)")
                .foregroundColor(.white)
            Button { quantity += 1 } label: {
                Image(systemName: "plus.rectangle")
                    .font(.title)
                    .foregroundColor(.orange)
            }
        }
    }

    private var actionButtons: some View {
        HStack {
            Button("Cancel") { showPopup = false }
                .padding()
                .background(Color.gray)
                .cornerRadius(8)
            Button("Add") {
                let newIngredient = (ingredientName, selectedMeasurement, quantity)
                ingredients.append(newIngredient)
                showPopup = false
            }
            .padding()
            .background(Color.orange)
            .cornerRadius(8)
        }
    }
}

struct MeasurementButton: View {
    var label: String
    var measurement: Measurement
    @Binding var selected: Measurement
    
    var body: some View {
        Button(action: { selected = measurement }) {
            Text(label)
                .padding()
                .background(selected == measurement ? Color.orange : Color.gray)
                .foregroundColor(.white)
                .cornerRadius(8)
        }
    }
}


struct AddEditFoodView_Previews: PreviewProvider {
static var previews: some View {
AddEditFoodView(viewModel: FoodViewModel(), itemToEdit: .constant(nil))
} }


