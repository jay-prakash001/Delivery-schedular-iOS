//
//   VacationView.swift
//   UserFreshyZo
//
//   Created by Rahul Verma on 16/05/26.
//

import SwiftUI


struct VacationView: View {
    
    // Properties to save chosen calendar date intervals
    @State private var startDate = Date()
    @State private var endDate = Date()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            // 1. Animated Canvas Header Component (No forced layout rounding)
            VacationAnimationView()
                .frame(height: 200)
            
            // 2. Form Section Header
            Text("Start Vacation")
                .font(.headline)
                .foregroundColor(.primary)
                .padding(.horizontal)
            
            // 3. Date Selection Input Section (1-Tap, No Hidden Capsules)
            HStack(alignment: .center, spacing: 20) {
                            
                // Start Date Input Block
                VStack(alignment: .leading, spacing: 6) {
                    Text("Start Date")
                        .font(.caption2)
                        .bold()
                        .foregroundColor(.gray)
                    
                    CustomDateSelectorByDate(
                        selectedDate: $startDate,
                        dateRange: Date.distantPast...Date.distantFuture
                    )
                    .padding(8).overlay{
                        RoundedRectangle(cornerRadius: 12).stroke(.gray, lineWidth: 1)
                    }
                }
                
                Spacer()
                
                // End Date Input Block
                VStack(alignment: .leading, spacing: 6) {
                    Text("End Date")
                        .font(.caption2)
                        .bold()
                        .foregroundColor(.gray)
                    
                    CustomDateSelectorByDate(
                        selectedDate: $endDate,
                        dateRange: startDate...Date.distantFuture
                    ).padding(8).overlay{
                        RoundedRectangle(cornerRadius: 12).stroke(.gray, lineWidth: 1)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                }
                }
            }
            .padding(.horizontal)
            .onChange(of: startDate) { oldValue, newValue in
                if endDate < newValue {
                    endDate = newValue
                }
            }
            
            // 4. Action Operations Buttons Interface
            HStack(spacing: 16) {
                Button {
                    print("Vacation configured from \(startDate) to \(endDate)")
                } label: {
                    Text("🏖️ Start Vacation")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Color.thirdGreen)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                
                Button {
                    startDate = Date()
                    endDate = Date()
                } label: {
                    Text("Clear Vacation")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Color(.systemGroupedBackground))
                        .foregroundColor(.red)
                        .cornerRadius(8)
                }
            }
            .padding(.horizontal)
            .padding(.top, 8)
            
            Divider()
                .padding(.vertical, 8)
            
            // 5. Historical Record Logging Stack Area
            Text("Previous Vacations")
                .font(.subheadline)
                .bold()
                .foregroundColor(.secondary)
                .padding(.horizontal)
            
            Spacer()
        }
        .padding(.top)
        .navigationTitle("Vacation")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Wobble & Float Custom Modifier
struct WobbleModifier: ViewModifier {
    let baseOffset: CGFloat
    let delay: Double
    @State private var isAnimating = false
    
    func body(content: Content) -> some View {
        content
            .offset(y: isAnimating ? baseOffset : -baseOffset)
            .rotationEffect(.degrees(isAnimating ? 3 : -3))
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                    withAnimation(
                        .easeInOut(duration: Double.random(in: 2.5...3.5))
                        .repeatForever(autoreverses: true)
                    ) {
                        isAnimating = true
                    }
                }
            }
    }
}
// MARK: - FIXED 1-TAP SELECTOR
// MARK: - AUTO-DISMISS SELECTOR
struct CustomDateSelectorByDate: View {
    @Binding var selectedDate: Date
    let dateRange: ClosedRange<Date>
    @State private var showCalendar = false
    
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        return formatter.string(from: selectedDate)
    }
    
    var body: some View {
        Button {
            showCalendar.toggle()
        } label: {
            HStack(spacing: 6) {
                Text(formattedDate)
                    .font(.body)
                    .foregroundColor(.primary)
                
                Image(systemName: "calendar")
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
        }
        .sheet(isPresented: $showCalendar) {
            DatePicker(
                "",
                selection: $selectedDate,
                in: dateRange,
                displayedComponents: .date
            )
            .datePickerStyle(.graphical)
            .padding()
            .presentationDetents([.medium])
            // Detects the tap choice immediately and closes the window automatically
            .onChange(of: selectedDate) { _, _ in
                showCalendar = false
            }
        }
    }
}

extension View {
    func wobble(baseOffset: CGFloat = 3, delay: Double = 0.0) -> some View {
        self.modifier(WobbleModifier(baseOffset: baseOffset, delay: delay))
    }
}

// MARK: - Main View
struct VacationAnimationView: View {
    
    @State private var animateClouds = false
    @State private var swayTrees = false
    
    var body: some View {
        
        GeometryReader { geometry in
            
            VStack(spacing: 0) {
                
                // MARK: - SKY AREA
                ZStack {
                    
                    // SKY GRADIENT
                    LinearGradient(
                        colors: [
                            Color(.skyUp),
                            Color(.skyUp),
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    
                    // SUN
                    HStack {
                        Spacer()
                        Image("ic_sun")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 36, height: 36)
                            .wobble(baseOffset: 1.5, delay: 0.2)
                    }
                    .padding(.trailing, geometry.size.width * 0.12)
                    .offset(y: -25)
                    
                    // CLOUD 1
                    Image("ic_cloud")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 65)
                        .opacity(0.9)
                        .wobble(baseOffset: 3, delay: 0.0)
                        .offset(
                            x: animateClouds ? geometry.size.width + 100 : -100,
                            y: -25)
                        .animation(
                            .linear(duration: 16)
                            .repeatForever(autoreverses: false),
                            value: animateClouds
                        )
                    
                    // CLOUD 2
                    Image("ic_cloud")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 32)
                        .opacity(0.7)
                        .wobble(baseOffset: 2, delay: 0.4)
                        .offset(
                            x: animateClouds ? geometry.size.width + 100 : -100,
                            y: -5
                        )
                        .animation(
                            .linear(duration: 20)
                            .repeatForever(autoreverses: false)
                            .delay(3.5),
                            value: animateClouds
                        )
                    
                    // CLOUD 3
                    Image("ic_cloud")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50)
                        .opacity(0.6)
                        .wobble(baseOffset: 4, delay: 0.7)
                        .offset(
                            x: animateClouds ? geometry.size.width + 100 : -100,
                            y: 15
                        )
                        .animation(
                            .linear(duration: 24)
                            .repeatForever(autoreverses: false)
                            .delay(7.0),
                            value: animateClouds
                        )
                    
                    // CLOUD 4
                    Image("ic_cloud")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 36)
                        .opacity(0.75)
                        .wobble(baseOffset: 2.5, delay: 0.2)
                        .offset(
                            x: animateClouds ? geometry.size.width + 100 : -100,
                            y: -40
                        )
                        .animation(
                            .linear(duration: 18)
                            .repeatForever(autoreverses: false)
                            .delay(11.0),
                            value: animateClouds
                        )
                    
                    // VACATION TEXT
                    Text("Vacation \nMode 🏖️")
                        .font(.system(size: 20, weight: .bold))
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color.white.opacity(0.85))
                        .wobble(baseOffset: 2, delay: 0.1)
                        .offset(y: 10)
                }
                .frame(height: geometry.size.height * 0.72)
                .frame(maxWidth: .infinity)
                .clipped()
                
                // MARK: - SAND AREA (Your Layout Refined)
                HStack(alignment: .center) {
                    
                    Text("🌴")
                        .font(.system(size: 70))
                        .rotationEffect(.degrees(swayTrees ? 6 : -2), anchor: .bottom)
                        .offset(y: -22) // Adjusted down slightly so the leaf tops do not clip
                    
                    Spacer().frame(width: geometry.size.width * 0.18)
                    
                    Text("⛱️ 🏄‍♂️")
                        .font(.system(size: 35))
                        .fixedSize(horizontal: true, vertical: false) // Forces full horizontal layout pass
                        .wobble(baseOffset: 2, delay: 0.4)
                        .offset(y: -5)
                    
                    Spacer().frame(width: geometry.size.width * 0.18)
                    
                    Text("🌴")
                        .font(.system(size: 50))
                        .rotationEffect(.degrees(swayTrees ? -3 : 3), anchor: .bottom)
                        .offset(y: -15) // Adjusted down slightly to remain fully visible
                    
                }
                .padding(.horizontal)
                .frame(height: geometry.size.height * 0.28)
                .frame(maxWidth: .infinity)
                .background(
                    LinearGradient(
                        colors: [
                            Color(red: 245/255, green: 222/255, blue: 179/255),
                            Color(red: 222/255, green: 184/255, blue: 135/255)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
            }
            .ignoresSafeArea()
            .onAppear {
                DispatchQueue.main.async {
                    animateClouds = true
                }
                
                withAnimation(
                    .easeInOut(duration: 4.0)
                    .repeatForever(autoreverses: true)
                ) {
                    swayTrees = true
                }
            }
        }
     
    }
}

// MARK: - Preview
#Preview {
    VacationView()
}

