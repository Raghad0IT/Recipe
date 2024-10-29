
import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = FoodViewModel()
    @State private var selectedItem: FoodItem? = nil

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Search Bar
                SearchBar(text: $viewModel.searchText)
                    .padding(.horizontal)
                    .background(Color.black)

                // List of Food Items
                if viewModel.items.isEmpty {
                    placeholderView
                } else {
                    FoodListView(viewModel: viewModel)
                }
            }
            
            .background(Color.black.edgesIgnoringSafeArea(.all))
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline) //
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("Food Recipes") //
                        .foregroundColor(.white)
                        .font(.system(size: 28, weight: .bold)) //
                        .padding(.top, 15) //
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: AddEditFoodView(viewModel: viewModel, itemToEdit: .constant(nil))) {
                        Image(systemName: "plus")
                            .foregroundColor(.orange)
                    }
                }
            }
        }
    }

    private var placeholderView: some View {
        VStack {
            Spacer()
            Image(systemName: "fork.knife.circle")
                .resizable()
                .scaledToFit()
                .frame(width: 280, height: 280)
                .foregroundColor(.orange)

            Text("There's no recipe yet")
                .font(.system(size: 34, weight: .bold))
                .foregroundColor(.white)
                .padding(.top, 10)

            Text("Please add your recipes")
                .font(.system(size: 22))
                .foregroundColor(.gray)
                .padding(.top, 5)

            Spacer()
        }
    }
}

struct FoodListView: View {
    @ObservedObject var viewModel: FoodViewModel

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                ForEach(viewModel.filteredItems) { item in
                    NavigationLink(destination: FoodDetailView(viewModel: viewModel, foodItem: item)) {
                        FoodCardView(foodItem: item)
                    }
                }
            }
            .padding(.top)
        }
    }
}

struct FoodCardView: View {
    var foodItem: FoodItem

    var body: some View {
        ZStack(alignment: .bottom) {
            if let foodImage = foodItem.image {
                Image(uiImage: foodImage)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 250)
                    .clipped()
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 250)
                    .foregroundColor(.gray)
                    .background(Color.black)
            }

            LinearGradient(
                gradient: Gradient(colors: [Color.black.opacity(0.8), Color.black.opacity(0)]),
                startPoint: .bottom,
                endPoint: .top
            )
            .frame(height: 80)
            .ignoresSafeArea(edges: .horizontal)

            VStack(alignment: .leading, spacing: 5) {
                Text(foodItem.title)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.black)

                Text(foodItem.description)
                    .font(.subheadline)
                    .foregroundColor(.black)
                    .lineLimit(2)

                Spacer()

                Text("See All")
                    .font(.subheadline)
                    .foregroundColor(.orange)
            }
            .padding()
        }
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
        .padding(.horizontal)
    }
}

struct SearchBar: View {
    @Binding var text: String

    var body: some View {
        
        HStack {
            TextField("Search", text: $text)
            
                .padding(8)
                .padding(.horizontal, 25)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .padding(.leading, 8)
                        Spacer()
                    }
                )
                .padding(.horizontal)
        }
    }
}

// Preview
#Preview {
    ContentView()
}







