//
//  SubscriptionView.swift
//  UserFreshyZo
//
//  Created by Varsha Sahu on 30/03/26.
//
// MARK: - SubscriptionView.swift
// All business logic has been moved to SubscriptionViewModel.
// This file contains ONLY layout and UI binding.


// on subscribe button click this screen will appear

import SwiftUI

struct SubscriptionView: View {
    
    // Store the concrete product passed in
    var product: ProductFromApi
    var mediaUrls : [ProductAsset]
    // If not used, you can remove this EnvironmentObject.
    // Keeping it here in case other UI parts later need it.
    @EnvironmentObject var productViewModel: ProductViewModel
    @EnvironmentObject var cartVM : CartViewModel
    // ── ViewModel ─────────────────────────────────────────────────────
    @StateObject private var vm = SubscriptionViewModel()
    
    // ── Local UI-only state ───────────────────────────────────────────
    @State private var showDatePicker = false
    @Environment(\.dismiss) private var dismiss
    
    let quantity = 2
    private let isPad = UIDevice.current.userInterfaceIdiom == .pad
    

    init(product: ProductFromApi, mediaUrls : [ProductAsset],quantity: Int = 2) {
            // Assign properties first
            self.product = product
//            self.quantity = quantity
        self.mediaUrls = mediaUrls
            
            // Parse prices safely (handles strings like "104.00")
            let base = Int(Double(product.productPrice ?? "0") ?? 0)
            let mrp = Int(Double(product.dairyMrp ?? "0") ?? 0)
            
            // 3. Initialize StateObject using the local 'quantity' parameter
            // DO NOT use self.quantity here; use the 'quantity' from the init arguments
            self._vm = StateObject(wrappedValue: {
                let viewModel = SubscriptionViewModel()
                viewModel.setup(
                    basePrice: base,
                    mrpPrice: mrp,
                    initialQty: quantity // <--- Uses the passed value directly
                )
                return viewModel
            }())
            
            print("Initializing subscription for \(product.productName ?? "") with qty: \(quantity)")
        }

    // MARK: - Init

    
    // MARK: - Body

    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(spacing: 0) {
                navBar
                scrollContent
            }
            subscribeButton

            // ── Success Popup ─────────────────────────────────────────
            if vm.isSuccess {
                SubscriptionSuccessPopup {
                    dismiss()
                }
                .transition(.opacity.combined(with: .scale(scale: 0.95)))
                .zIndex(1)
            }
        }
        .animation(.spring(response: 0.35, dampingFraction: 0.8), value: vm.isSuccess)
        .navigationBarHidden(true)
        .sheet(isPresented: $showDatePicker) {
            DatePickerSheet(
                selectedDate: Binding(
                    get: { vm.state.startDate },
                    set: { vm.updateStartDate($0) }
                ),
                minimumDate: SubscriptionUiState.defaultStartDate()
            )
            .presentationDetents([.medium])
            .presentationDragIndicator(.visible)
        }
    }
    
    // MARK: - Nav Bar
    
    private var navBar: some View {
        HStack {
            Button(action: { dismiss() }) {
                Image(systemName: "arrow.left")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.black)
                    .frame(width: 38, height: 38)
                    .background(Color(UIColor.systemGroupedBackground))
                    .clipShape(Circle())
            }
            Spacer()
            Text("Subscription")
                .font(.system(size: isPad ? 20 : 17, weight: .bold))
            Spacer()
            Color.clear.frame(width: 38, height: 38)
        }
        .padding(.horizontal, isPad ? 24 : 16)
        .padding(.vertical, 12)
        .background(Color.white)
        .shadow(color: .black.opacity(0.06), radius: 4, y: 2)
    }
    
    // MARK: - Scroll Content
    
    private var scrollContent: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                
                // ── Product header ────────────────────────────────────
                productHeader
                    .horizontalPadding(isPad: isPad)
                    .padding(.top, 16)
                
                // ── Frequency selector ────────────────────────────────
                FrequencySelectorCard(
                    selectedFrequency: vm.state.selectedFrequency,
                    onSelect: { vm.selectFrequency($0) }
                )
                .horizontalPadding(isPad: isPad)
                .padding(.top, 14)
                
                // ── Alt Days Options (conditional) ────────────────────
                if vm.state.selectedFrequency == .altDays {
                    AltDayOptionsCard(
                        selected: vm.state.altDayOption,
                        onSelect: { vm.selectAltDayOption($0) }
                    )
                    .horizontalPadding(isPad: isPad)
                    .padding(.top, 14)
                    .transition(.move(edge: .top).combined(with: .opacity))
                }
                
                // ── Quantity Card OR Weekly Days Card ─────────────────
                if vm.state.selectedFrequency == .weekly {
                    WeeklyDaysCard(
                        days: vm.state.weeklyDayStates,
                        pricePerUnit: Double(vm.state.basePrice),
                        onToggle:   { vm.toggleDay(id: $0) },
                        onIncrease: { vm.increaseDayQty(id: $0) },
                        onDecrease: { vm.decreaseDayQty(id: $0) }
                    )
                    .horizontalPadding(isPad: isPad)
                    .padding(.top, 14)
                    .transition(.move(edge: .top).combined(with: .opacity))
                } else {
                    SimpleQuantityCard(
                        qty: vm.state.simpleQty,
                        summaryLine: vm.state.summaryLine,
                        onIncrease: {
                            
                            vm.increaseSimpleQty()
                            cartVM.addItem(
                                id: product.id,
                                name: product.cleanName,
                                price: Double(product.productPrice) ?? 0.0,
                                mrp: Double(product.dairyMrp) ?? 0.0,
                                image: product.dairyProductImage ?? "",
                                variant: String(vm.state.simpleQty + 1)
                            )
                            
                        },
                        onDecrease: { vm.decreaseSimpleQty()
                            cartVM.removeItem(id : product.id)
                            
                        }
                    )
                    .horizontalPadding(isPad: isPad)
                    .padding(.top, 14)
                }
                
                // ── Start Date Card ───────────────────────────────────
                StartDateCard(
                    formattedDate: vm.state.startDateFormatted,
                    deliveryBeginsText: vm.state.deliveryBeginsText,
                    onTap: { showDatePicker = true }
                )
                .horizontalPadding(isPad: isPad)
                .padding(.top, 14)
                
                // ── Price Summary Card ────────────────────────────────
                PriceSummaryCard(state: vm.state)
                    .horizontalPadding(isPad: isPad)
                    .padding(.top, 14)
                
                // ── Offer Banner ──────────────────────────────────────
                OfferBanner()
                    .horizontalPadding(isPad: isPad)
                    .padding(.top, 14)
                
                Spacer().frame(height: 110)
            }
            .animation(.easeInOut(duration: 0.22), value: vm.state.selectedFrequency)
        }
        .background(Color(UIColor.systemGroupedBackground))
    }
    
    // MARK: - Product Header
    
    private var productHeader: some View {
        HStack(alignment: .center, spacing: 14) {
            VStack(alignment: .leading, spacing: 4) {
                Text("FRESHYZO · FRESH DAILY")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(Color("AppGreenColor"))
                    .tracking(1.1)
                
                Text(product.cleanName)
                    .font(.system(size: isPad ? 20 : 17, weight: .bold))
                
                HStack(spacing: 8) {
                    Text("₹\(product.productPrice)")
                        .font(.system(size: isPad ? 18 : 16, weight: .bold))
                    Text("₹\(product.dairyMrp)")
                        .font(.system(size: 13))
                        .foregroundColor(.gray)
                        .strikethrough()
                    if let price = Double(product.productPrice),
                       let mrp   = Double(product.dairyMrp), mrp > 0 {
                        let pct = Int(((mrp - price) / mrp) * 100)
                        Text("\(pct)% OFF")
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundColor(.orange)
                    }
                }
            }
            
            Spacer()
            
            AsyncImage(url: URL(string: mediaUrls[0].asset)) { img in
                img.resizable().scaledToFit().clipped()
            } placeholder: {
                Color(UIColor.systemGroupedBackground).overlay(ProgressView())
            }
            .frame(width: isPad ? 100 : 80, height: isPad ? 100 : 80)
            .background(Color(UIColor.systemGroupedBackground))
            .cornerRadius(12)
        }
        .padding(14)
        .background(RoundedRectangle(cornerRadius: 16).fill(Color.white))
        .shadow(color: .black.opacity(0.05), radius: 4, y: 2)
    }
    
    // MARK: - Subscribe Button
    
    private var subscribeButton: some View {
        VStack(spacing: 0) {
            Divider()
            Button(action: handleSubscribe) {
                Group {
                    if vm.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    } else {
                        Text("Subscribe Now")
                            .font(.system(size: isPad ? 18 : 16, weight: .semibold))
                            .foregroundColor(.white)
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: isPad ? 56 : 50)
                .background(Color("AppGreenColor").opacity(vm.isLoading ? 0.7 : 1))
                .cornerRadius(14)
                .padding(.horizontal, isPad ? 24 : 16)
                .padding(.vertical, 14)
            }
            .disabled(vm.isLoading)
            .background(Color.white)
        }
        // Error alert only — success is now handled by popup
        .alert("Something went wrong", isPresented: .init(
            get: { vm.errorMessage != nil },
            set: { if !$0 { vm.errorMessage = nil } }
        )) {
            Button("OK") { vm.errorMessage = nil }
        } message: {
            Text(vm.errorMessage ?? "")
        }
    }
    
    // MARK: - Actions
    
    private func handleSubscribe() {
        vm.confirmSubscription(
            productId:   product.id,
            productName: product.cleanName
        )
    }
}

// MARK: - View Modifier Helper

private extension View {
    func horizontalPadding(isPad: Bool) -> some View {
        self.padding(.horizontal, isPad ? 24 : 16)
    }
}

