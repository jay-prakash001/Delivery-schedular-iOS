import SwiftUI
//
//



struct MilkTrialView: View {
    let banner: Banner
    @State private var selectedProduct: TrialProductDetail? = nil
    @State private var selectedDate: Date?
    @State private var showDatePicker = false
    @State private var tempPickerDate: Date = Date() // Temporary state for the sheet
    
    @EnvironmentObject var homeViewModel: HomeViewModel
    
    var products: [TrialProductDetail] {
        homeViewModel.trialRes?.data.trialProductDetails ?? []
    }
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 16) {
                    TrialBannerImageView(imageURL: banner.image)
                    
                    if let trialDetails = homeViewModel.trialRes?.data {
                        SubscriptionDetailsView(
                            products: products,
                            selectedProduct: $selectedProduct,
                            selectedDate: $selectedDate,
                            onDateTap: {
                                tempPickerDate = selectedDate ?? Date()
                                showDatePicker = true
                            }
                        )
                        
                        if let selected = selectedProduct {
                            PriceTotalView(product: selected)
                        }
                    } else {
                        ProgressView("Loading trial details...").padding()
                    }
                    
                    Spacer(minLength: 100)
                }
                .padding(.horizontal, 16)
            }
        }
        .navigationTitle("Milk Trial")
        .navigationBarTitleDisplayMode(.inline)
        .safeAreaInset(edge: .bottom) {
            StartTrialButton { handleStartTrial() }
        }
        .onAppear { homeViewModel.getTrialDetails() }
        .onChange(of: products) { newList in
            //            if selectedProduct == nil, let first = newList.first {
            //                selectedProduct = first
            //            }
        }
        // --- NATIVE BOTTOM SHEET DIALOG ---
        .sheet(isPresented: $showDatePicker) {
            VStack(spacing: 20) {
                // Just a header with no 'Done' button needed
//                HStack {
//                    Text("Select delivery Start Date")
//                        .font(.headline)
//                    Spacer()
//                }
//                .padding(20)
//
                DatePicker(
                    "",
                    selection: $tempPickerDate,
                    in: Date()...,
                    displayedComponents: .date
                )
                .datePickerStyle(.graphical)
                .tint(Color(hex: "#2E7D32"))
                .padding(.horizontal)
                
                // --- AUTO-CLOSE LOGIC ---
                .onChange(of: tempPickerDate) { newDate in
                    selectedDate = newDate
                    // Small delay makes the "tap" feel more natural before the sheet slides down
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        showDatePicker = false
                    }
                }
                
                Spacer()
            }
            .presentationDetents([.medium, .large])
            .presentationDragIndicator(.visible).background(.white)
        }
    }
    
    private func handleStartTrial() {
        guard let date = selectedDate, let product = selectedProduct else { return }
        print("Starting trial for \(product.productName) on \(date)")
    }
}



struct SubscriptionDetailsView: View {
    let products: [TrialProductDetail]
    @Binding var selectedProduct: TrialProductDetail?
    @Binding var selectedDate: Date?
    var isPad = UIDevice.current.userInterfaceIdiom == .pad
    var onDateTap: () -> Void // Triggered when user taps the date field
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Subscription Details").font(.title3).bold()
                Text("Select product and start date to start your trial")
                    .font(.caption2).foregroundColor(.secondary)
            }
            
            ProductPickerView(products: products, selectedProduct: $selectedProduct)
            
            if let product = selectedProduct{
                TrialProductView(selectedProduct: product, isPad: isPad)
                
            }
            
            
            DatePickerFieldView(selectedDate: $selectedDate, action: onDateTap)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 2)
    }
}


struct TrialProductView : View {
    var selectedProduct: TrialProductDetail
    
    var isPad : Bool
    var body: some View {
        
        
        HStack{
            HStack{
                
                AsyncImage(url: URL(string: selectedProduct.productImage)) { img in
                    img.resizable().clipped()
                } placeholder: {
                    Color(UIColor.systemGroupedBackground).overlay(ProgressView())
                }
                .frame(width: isPad ? 100 : 60, height: isPad ? 100 : 60)
                .background(Color(UIColor.systemGroupedBackground))
                .cornerRadius(12)
                
                VStack{
                    Text(selectedProduct.productName)
                        .font(.system(size: 12))
                        .bold()
                }
                
                Spacer()
                Text("₹ \(selectedProduct.amount)")
                    .font(.title2).foregroundColor(.appGreen)
                    .bold()
            }
            
        }
        //        .padding(2).background(.gray.opacity(0.2)).clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
}
struct DatePickerFieldView: View {
    @Binding var selectedDate: Date?
    var action: () -> Void
    
    private var dateFormatter: DateFormatter {
        let f = DateFormatter(); f.dateStyle = .medium; return f
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Select Date").font(.callout).bold()
            
            Button(action: action) {
                HStack {
                    Text(selectedDate != nil ? dateFormatter.string(from: selectedDate!) : "Select Date")
                        .foregroundColor(selectedDate != nil ? .primary : .secondary).font(.caption)
                    
                    Spacer()
                    Image(systemName: "calendar").foregroundColor(.secondary)
                }
                .padding(16)
                .background(Color(.tertiarySystemBackground))
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                )
            }
        }
    }
}

struct TrialBannerImageView: View {
    let imageURL: String
    
    var body: some View {
        AsyncImage(url: URL(string: imageURL)) { phase in
            switch phase {
            case .success(let image):
                image
                    .resizable()
                    .scaledToFill()
                    .frame(minWidth: 0, maxWidth: .infinity) // 👈 Ensure it takes available width
                    .frame(height: 160)                      // 👈 Set height here
                    .clipped()                               // 👈 Chop off the overflow
            case .empty, .failure:
                Color.gray.opacity(0.2)
                    .frame(height: 160)
            @unknown default:
                EmptyView()
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

//
struct ProductPickerView: View {
    let products: [TrialProductDetail]
    @Binding var selectedProduct: TrialProductDetail?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("Select Product")
                .font(.subheadline)
                .bold()
            
            Menu {
                ForEach(products) { product in
                    Button {
                        // Correctly update the Binding
                        selectedProduct = product
                    } label: {
                        HStack {
                            Text(product.productName)
                            if selectedProduct?.id == product.id {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                }
            } label: {
                HStack {
                    // Show selected name or a placeholder if nil
                    Text(selectedProduct?.productName ?? "Choose a product")
                        .foregroundColor(selectedProduct == nil ? .secondary : .primary).font(.caption)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.down")
                        .foregroundColor(.secondary)
                        .font(.caption)
                }
                .padding(16)
                .background(Color(UIColor.tertiarySystemBackground)) // Optional: add a slight background
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                )
            }
        }
    }
}
//

//
//// MARK: - Subview 3: Price Total Card
struct PriceTotalView: View {
    let product: TrialProductDetail
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Price Details")
                    .font(.title3).bold()
            }
            
            Divider()
            
            PriceRow(label: "Total MRP",      value: "₹\((Int(product.amount )   ?? 0) * 2)")
            PriceRow(label: "Discount", value: "-₹\(product.amount ?? "")", color: Color(hex: "#2E7D32"))
            PriceRow(label: "Delivery Fee",   value: "FREE",                         color: Color(hex: "#2E7D32"))
            
            Divider()
            
            //            PriceRow(label: "Total Payable",  value: "₹\(Int(product.payable))", isBold: true)
            
//            Text("Charges are deducted post-delivery. Please ensure sufficient wallet balance.")
//                .font(.caption)
//                .foregroundColor(.orange)
//                .padding(.top, 4)
            
            
            HStack{
                VStack(alignment: .leading, spacing: 4) {
                    Text("Total Payable")
                        .font(.title3)
                    Text("Inclusive of all taxes")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                
                Spacer()
                Text("₹ \(product.amount ?? "" )")
                    .font(.title3).foregroundColor(.appGreen)
                    .bold()
                
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 2)
//        .padding(.horizontal)
    }
}
//
// MARK: - Subview 4: Start Trial Button
struct StartTrialButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text("Start Trial")
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color(hex: "#2E7D32"))
                .cornerRadius(14)
                .padding()
        }
        .background(Color(.systemBackground))
    }
}

//// MARK: - Helper: Price Row
struct PriceRow: View {
    let label: String
    let value: String
    var color: Color = .primary
    var isBold: Bool = false
    
    var body: some View {
        HStack {
            Text(label)
                .font(isBold ? .subheadline.bold() : .subheadline)
                .foregroundColor(.primary)
            Spacer()
            Text(value)
                .font(isBold ? .subheadline.bold() : .subheadline)
                .foregroundColor(color)
        }
    }
}
//
//// MARK: - Helper: Hex Color
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r, g, b: Double
        switch hex.count {
        case 6:
            r = Double((int >> 16) & 0xFF) / 255
            g = Double((int >> 8)  & 0xFF) / 255
            b = Double(int         & 0xFF) / 255
        default:
            r = 0; g = 0; b = 0
        }
        self.init(red: r, green: g, blue: b)
    }
}
