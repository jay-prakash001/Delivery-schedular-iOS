//
//  OrderHistoryView.swift
//  UserFreshyZo
//
//  Created by Rahul Verma on 18/05/26.
//

import SwiftUI

struct OrderHistoryView: View {
    let categories = [
            (name: "All Orders", color: Color.green),
            (name: "✔️ Placed", color: Color.blue),
            (name: "⏳ Pending", color: Color.yellow),
            (name: "❌ Cancelled", color: Color.red)
        ]
    @State private var selectedFilter: String = "Completed"
    var body: some View {
        
        
        
        ScrollView(showsIndicators: false) {
            // Use a regular VStack here to hold the distinct sections
            VStack(spacing: 0) {
                
                // 1. Top bar container that fills the background up to the safe area
                OrderStatesTopBarView(all: 10, placed: 5, pending: 4, cancelled: 1)
                    .padding(.top, 16) // Padding below the navigation bar
                    .background(Color.appGreen) // Fills everything including the safe area above it
          
                // 2. The scrollable list items container
                LazyVStack(alignment: .leading, spacing: 12) {
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(categories, id: \.name) { category in
                                FilterChip(
                                    title: category.name,
                                    themeColor: category.color,
                                    isSelected: selectedFilter == category.name,
                                    onClick: {
                                        // Update state on click
                                        selectedFilter = category.name
                                        print("Filtered by: \(category.name)")
                                    }
                                )
                            }
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 4) // Breathing room so the elevation boundary isn't clipped
                    }
                    ForEach(testOrders, id: \.id) { order in
                        OrderHistoryItemView(
                            imageName: order.imageUrlString,
                            title: order.title,
                            unitPrice: order.unitPrice,
                            quantity: order.quantity,
                            status: order.status,
                            deliveryDate: order.deliveryDate
                        )
                    }
                }
                //                .padding(.vertical)
                .background(Color(.systemBackground)) // Keeps the list background white/system color
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.appGreen.ignoresSafeArea(edges: .top)) // Forces the green to flood the top safe area
        .navigationTitle("Order History")
        .navigationBarTitleDisplayMode(.inline)
    }
}


struct OrderHistoryItemView: View {
    // 1. Define Parameters
    let imageName: String       // System symbol name or asset name
    let title: String
    let unitPrice: Double
    let quantity: Int
    let status: String          // e.g., "Placed", "Pending", "Cancelled"
    let deliveryDate: String
    
    var body: some View {
        VStack(spacing: 10) { // Slightly tighter spacing for a smaller card footprint
            
            // Top Section: Product Details & Status
            HStack(alignment: .center, spacing: 12) {
                
                // Product Image (Fixed 1:1 Size Boundary)
                AsyncImage(url: URL(string: imageName)) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 64, height: 64)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(6)
                .clipped()
                
                // Product Metadata Stack
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                        .lineLimit(1)
                    
                    Text(String(format: "$%.2f × %d", unitPrice, quantity))
                        .font(.footnote)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                        .frame(height: 2)
                    
                    // Dynamic Status Capsule
                    StatusCapsule(status: status)
                        .scaleEffect(0.9, anchor: .leading)
                }
                
                Spacer() // Pushes content to the left
            }
            .fixedSize(horizontal: false, vertical: true)
            
            Divider()
                .background(Color.gray.opacity(0.15))
            
            // Bottom Section: Delivery Footer
            HStack(spacing: 6) {
                Image(systemName: "calendar")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Text("Delivered by:")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Text(deliveryDate)
                    .font(.caption).bold()
                    .foregroundColor(.appGreen)
                
                Spacer()
            }
        }
        .padding(12) // Inner padding
        
        // --- TRUE MATERIAL ELEVATION (NO DROP SHADOW) ---
        // 1. We use a secondary system background color to lift the card base
        .background(Color(.secondarySystemBackground))
        // 2. We clip it to a rounded rectangle shape
        .cornerRadius(10)
        // 3. We overlay a fine, semi-transparent border that mimics a physical beveled edge
        //    catching the light, separating it cleanly from the primary background layer.
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.primary.opacity(0.06), lineWidth: 1)
        )
        // ------------------------------------------------
        
        .padding(.horizontal) // Safe layout padding away from screen edges
    }
}// 2. Custom Status Capsule Subview
struct StatusCapsule: View {
    let status: String
    
    // Compute colors dynamically based on order state
    var statusColors: (bg: Color, text: Color) {
        switch status.lowercased() {
        case "placed":
            return (Color.green.opacity(0.15), Color.green)
        case "pending":
            return (Color.yellow.opacity(0.15), Color.orange)
        case "cancelled":
            return (Color.red.opacity(0.15), Color.red)
        default:
            return (Color.gray.opacity(0.15), Color.gray)
        }
    }
    
    var body: some View {
        Text(status.capitalized)
            .font(.caption).bold()
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(statusColors.bg)
            .foregroundColor(statusColors.text)
            .cornerRadius(20)
    }
}

struct FilterChip: View {
    // 1. Parameters
    let title: String
    let themeColor: Color       // Accent color used when selected
    let isSelected: Bool        // Controls the active layout state
    let onClick: () -> Void     // Action closure triggered on tap
    
    var body: some View {
        Button(action: onClick) {
            HStack(spacing: 6) {
                // Circular indicator showing the chip's theme color
//                Circle()
//                    .fill(themeColor)
//                    .frame(width: 8, height: 8)
                
                Text(title)
                    .font(.footnote).bold()
                    .fontWeight(isSelected ? .semibold : .regular)
                    .foregroundColor(isSelected ? .white : .gray)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            // Elevation & Background Material Styling
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(isSelected ? .appGreen : Color(.secondarySystemBackground))
            )
            // Premium edge bevel instead of a heavy drop shadow
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSelected ? themeColor.opacity(0.3) : Color.primary.opacity(0.06), lineWidth: 1)
            )
        }
        .buttonStyle(.plain) // Prevents the default iOS blue tint on custom buttons
        .animation(.easeInOut(duration: 0.2), value: isSelected) // Smooth micro-interaction transition
    }
}

struct SampleOrder {
    let id = UUID()
    let imageUrlString: String
    let title: String
    let unitPrice: Double
    let quantity: Int
    let status: String
    let deliveryDate: String
}

let testOrders = [
    SampleOrder(imageUrlString: "https://images.unsplash.com/photo-1597362925123-77861d3fbac7?w=150", title: "Fresh Broccoli Crowns", unitPrice: 1.99, quantity: 2, status: "Placed", deliveryDate: "May 20, 2026"),
    SampleOrder(imageUrlString: "https://images.unsplash.com/photo-1598170845058-32b996a69427?w=150", title: "Organic Carrots Bunch", unitPrice: 2.49, quantity: 3, status: "Placed", deliveryDate: "May 20, 2026"),
    SampleOrder(imageUrlString: "https://images.unsplash.com/photo-1557800636-894a64c1696f?w=150", title: "Sweet Valencia Oranges", unitPrice: 4.99, quantity: 1, status: "Pending", deliveryDate: "May 22, 2026"),
    SampleOrder(imageUrlString: "https://images.unsplash.com/photo-1550258987-190a2d41a8ba?w=150", title: "Ripe Tropical Pineapple", unitPrice: 3.49, quantity: 1, status: "Cancelled", deliveryDate: "Cancelled"),
    SampleOrder(imageUrlString: "https://images.unsplash.com/photo-1601004890684-d8cbf643f5f2?w=150", title: "Fresh Red Strawberries", unitPrice: 2.99, quantity: 4, status: "Placed", deliveryDate: "May 21, 2026"),
    SampleOrder(imageUrlString: "https://images.unsplash.com/photo-1571771894821-ce9b6c11b08e?w=150", title: "Organic Cavendish Bananas", unitPrice: 0.89, quantity: 6, status: "Pending", deliveryDate: "May 23, 2026"),
    SampleOrder(imageUrlString: "https://images.unsplash.com/photo-1560806887-1e4cd0b6cbd6?w=150", title: "Crisp Red Gala Apples", unitPrice: 1.25, quantity: 5, status: "Placed", deliveryDate: "May 21, 2026"),
    SampleOrder(imageUrlString: "https://images.unsplash.com/photo-1587049352846-4a222e784d38?w=150", title: "Fresh Seedless Watermelon", unitPrice: 5.99, quantity: 1, status: "Cancelled", deliveryDate: "Cancelled"),
    SampleOrder(imageUrlString: "https://images.unsplash.com/photo-1595855759920-86582396756a?w=150", title: "Fresh Hass Avocados", unitPrice: 1.50, quantity: 3, status: "Placed", deliveryDate: "May 20, 2026"),
    SampleOrder(imageUrlString: "https://images.unsplash.com/photo-1518977676601-b53f82aba655?w=150", title: "Baking Russet Potatoes", unitPrice: 0.99, quantity: 10, status: "Pending", deliveryDate: "May 24, 2026")
]
// 3. Updated Preview Integration
#Preview {
    VStack(spacing: 16) {
        OrderHistoryItemView(
            imageName: "carrot.fill",
            title: "Fresh Organic Carrots",
            unitPrice: 2.49,
            quantity: 3,
            status: "Placed",
            deliveryDate: "May 20, 2026"
        )
        
        OrderHistoryItemView(
            imageName: "leaf.fill",
            title: "Premium Spinach Bunch",
            unitPrice: 1.99,
            quantity: 1,
            status: "Pending",
            deliveryDate: "May 22, 2026"
        )
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color(.systemBackground))
}

struct OrderStatesTopBarView: View {
    var all: Int
    var placed: Int
    var pending: Int
    var cancelled: Int
    
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            OrderStateItem(title: "All", count: all, color: .white)
            
            // 1. Keep the dividers completely clean of height modifiers
            
            Divider().frame(width: 1)
                .background(Color.white)
            
            OrderStateItem(title: "Placed", count: placed, color: .white)
            
            Divider().frame(width: 1)
                .background(Color.white)
            
            OrderStateItem(title: "Pending", count: pending, color: .yellow)
            
            Divider().frame(width: 1)
                .background(Color.white)
            
            OrderStateItem(title: "Cancelled", count: cancelled, color: .red)
        }
        
        // 2. MOVE .fixedSize HERE (On the Parent HStack)
        // This tells the HStack: "Calculate the height of the Text views first,
        // then stretch the Dividers to match that exact height."
        .fixedSize(horizontal: false, vertical: true)
        
        .background(Color.appGreen)
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.white, lineWidth: 1)
        )
        .padding()
    }
}
// A small helper subview to keep the code clean
struct OrderStateItem: View {
    let title: String
    let count: Int
    var color: Color
    
    var body: some View {
        VStack(spacing: 4) {
            Text("\(count)")
                .font(.headline).bold()
                .foregroundColor(color)
            
            Text(title.uppercased())
                .font(.caption)
                .foregroundColor(.white)
        }
        // This acts exactly like Modifier.weight(1f) in Compose
        .frame(maxWidth: .infinity).padding(.vertical, 12)
    }
}


#Preview {
    
    VStack{
        
        OrderStatesTopBarView(all: 10, placed: 5, pending: 4,cancelled: 1)
        .background(.appGreen)}
    Spacer()
}


//#Preview {
//    OrderHistoryView()
//}
