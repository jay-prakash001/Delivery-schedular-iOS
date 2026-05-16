//
//  InvoiceView.swift
//  UserFreshyZo
//
//  Created by Rahul Verma on 16/05/26.
//

import SwiftUI
import PDFKit

// MARK: - Invoice Item Model

struct InvoiceItem: Identifiable {
    let id = UUID()
    let productName: String
    let quantity: Int
    let price: Double
    
    var total: Double {
        Double(quantity) * price
    }
}

// MARK: - Main Invoice Screen

struct InvoiceView: View {
    
    // MARK: Input
    
    let startDate: String
    let endDate: String
    
    // MARK: State
    
    @State private var pdfURL: URL?
    @State private var showPreviewSheet = false
    
    // MARK: Dummy Data
    
    let invoiceNumber = "INV-2026-001"
    let invoiceDate = "16 May 2026"
    
    let customerName = "Rahul Verma"
    let customerPhone = "+91 9876543210"
    let address = "Bhopal, Madhya Pradesh"
    
    let items: [InvoiceItem] = [
        InvoiceItem(productName: "Fresh Cow Milk", quantity: 30, price: 89),
        InvoiceItem(productName: "Paneer", quantity: 2, price: 250),
        InvoiceItem(productName: "Curd", quantity: 5, price: 60)
    ]
    
    // MARK: Calculations
    
    var subtotal: Double {
        items.reduce(0) { $0 + $1.total }
    }
    
    var tax: Double {
        subtotal * 0.05
    }
    
    var grandTotal: Double {
        subtotal + tax
    }
    
    // MARK: Body
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            // MARK: Zoomable Invoice
            
            ZoomableInvoiceContainer {
                invoicePaperView
            }
            
            // MARK: Bottom Buttons
            
            HStack(spacing: 14) {
                
                Button {
                    printInvoice()
                } label: {
                    
                    HStack(spacing: 10) {
                        Image(systemName: "printer.fill")
                        Text("Print")
                    }
                    .font(.headline)
                    .foregroundColor(Color.appGreen)
                    .frame(maxWidth: .infinity)
                    .frame(height: 54)
                    .overlay {
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.appGreen, lineWidth: 1.5)
                    }
                }
                
                Button {
                    shareInvoicePDF()
                } label: {
                    
                    HStack(spacing: 10) {
                        Image(systemName: "arrow.down.doc.fill")
                        Text("Download")
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 54)
                    .background(Color.appGreen)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                }
            }
            .padding()
            .background(.white)
        }
        .navigationTitle("Invoice")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - A4 Invoice Paper

extension InvoiceView {
    
    private var invoicePaperView: some View {
        
        VStack(alignment: .leading, spacing: 20) {
            
            // MARK: Header
            
            HStack(alignment: .top) {
                
                Image("freshyzo_logo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 40)
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 6) {
                    
                    Text("Freshyzo Foods Pvt Ltd")
                        .font(.title2.bold())
                    
                    Text("CIN: \(invoiceNumber)")
                        .font(.subheadline)
                    
                    Text("Date: \(invoiceDate)")
                        .font(.subheadline)
                }
            }
            
            Divider()
            
            // MARK: Statement
            
            VStack(alignment: .leading, spacing: 6) {
                
                Text("STATEMENT PERIOD")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Text("\(startDate) — \(endDate)")
                    .font(.headline)
            }
            
            Divider()
            
            // MARK: Customer
            
            VStack(alignment: .leading, spacing: 8) {
                
                Text("Customer Details")
                    .font(.headline)
                
                Text(customerName)
                Text(customerPhone)
                Text(address)
            }
            
            Divider()
            
            // MARK: Table
            
            VStack(spacing: 0) {
                
                HStack {
                    
                    Text("Product")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text("Qty")
                        .frame(width: 50)
                    
                    Text("Price")
                        .frame(width: 70)
                    
                    Text("Total")
                        .frame(width: 80)
                }
                .font(.headline)
                .padding()
                .background(Color.appGreen.opacity(0.12))
                
                Divider()
                
                ForEach(items) { item in
                    
                    HStack {
                        
                        Text(item.productName)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Text("\(item.quantity)")
                            .frame(width: 50)
                        
                        Text("₹\(Int(item.price))")
                            .frame(width: 70)
                        
                        Text("₹\(Int(item.total))")
                            .frame(width: 80)
                    }
                    .padding()
                    
                    Divider()
                }
            }
            .overlay {
                RoundedRectangle(cornerRadius: 14)
                    .stroke(Color.gray.opacity(0.2))
            }
            .clipShape(RoundedRectangle(cornerRadius: 14))
            
            // MARK: Total
            
            VStack(spacing: 14) {
                
                HStack {
                    Text("Subtotal")
                    Spacer()
                    Text("₹\(Int(subtotal))")
                }
                
                HStack {
                    Text("GST (5%)")
                    Spacer()
                    Text("₹\(Int(tax))")
                }
                
                Divider()
                
                HStack {
                    
                    Text("Grand Total")
                        .font(.headline)
                    
                    Spacer()
                    
                    Text("₹\(Int(grandTotal))")
                        .font(.headline)
                        .foregroundColor(Color.appGreen)
                }
            }
            .padding()
            .background(Color.gray.opacity(0.06))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            
            // MARK: Footer
            
            VStack(alignment: .leading, spacing: 8) {
                
                Text("Terms & Notes")
                    .font(.headline)
                
                Text("• Thank you for choosing FreshyZo.")
                Text("• This is a computer generated invoice.")
                Text("• For support contact customer care.")
            }
            .font(.subheadline)
            .foregroundColor(.gray)
            
            Spacer(minLength: 0)
        }
        .padding(24)
        .frame(width: 595, height: 842, alignment: .top)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 4)
    }
}

// MARK: - Zoomable Container
struct ZoomableInvoiceContainer<Content: View>: UIViewRepresentable {
    
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    // MARK: Coordinator
    
    func makeCoordinator() -> Coordinator {
        Coordinator(
            hosting: UIHostingController(rootView: content)
        )
    }
    
    // MARK: UIView
    
    func makeUIView(context: Context) -> UIScrollView {
        
        let scrollView = UIScrollView()
        
        // MARK: Scroll Settings
        
        scrollView.delegate = context.coordinator
        
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        
        scrollView.bouncesZoom = true
        scrollView.decelerationRate = .fast
        
        scrollView.backgroundColor = UIColor.systemGroupedBackground
        
        // MARK: Hosted SwiftUI View
        
        let hostedView = context.coordinator.hosting.view!
        
        hostedView.translatesAutoresizingMaskIntoConstraints = true
        hostedView.backgroundColor = .clear
        
        // MARK: ORIGINAL A4 SIZE
        
        let a4Width: CGFloat = 595
        let a4Height: CGFloat = 842
        
        hostedView.frame = CGRect(
            x: 0,
            y: 0,
            width: a4Width,
            height: a4Height
        )
        
        scrollView.addSubview(hostedView)
        
        // MARK: Content Size
        
        scrollView.contentSize = CGSize(
            width: a4Width,
            height: a4Height
        )
        
        // MARK: Initial Fit Scale
        
        let screenWidth = UIScreen.main.bounds.width
        
        let horizontalPadding: CGFloat = 24
        
        let availableWidth = screenWidth - horizontalPadding
        
        // PERFECT FIT TO SCREEN WIDTH
        let fitScale = availableWidth / a4Width
        
        scrollView.minimumZoomScale = fitScale
        scrollView.maximumZoomScale = 5
        
        // INITIAL ZOOMED OUT STATE
        scrollView.zoomScale = fitScale
        
        // MARK: Center Initially
        
        DispatchQueue.main.async {
            context.coordinator.centerContent(scrollView)
        }
        
        return scrollView
    }
    
    func updateUIView(_ uiView: UIScrollView, context: Context) {
    }
    
    // MARK: Coordinator
    
    class Coordinator: NSObject, UIScrollViewDelegate {
        
        let hosting: UIHostingController<Content>
        
        init(hosting: UIHostingController<Content>) {
            self.hosting = hosting
        }
        
        // MARK: Zoom Target
        
        func viewForZooming(in scrollView: UIScrollView) -> UIView? {
            hosting.view
        }
        
        // MARK: Keep Centered
        
        func scrollViewDidZoom(_ scrollView: UIScrollView) {
            centerContent(scrollView)
        }
        
        func centerContent(_ scrollView: UIScrollView) {
            
            guard let view = hosting.view else { return }
            
            let offsetX = max(
                (scrollView.bounds.width - scrollView.contentSize.width) * 0.5,
                0
            )
            
            let offsetY = max(
                (scrollView.bounds.height - scrollView.contentSize.height) * 0.5,
                0
            )
            
            view.center = CGPoint(
                x: scrollView.contentSize.width / 2 + offsetX,
                y: scrollView.contentSize.height / 2 + offsetY
            )
        }
    }
}

// MARK: - PDF Generation

extension InvoiceView {
    
    @MainActor
    private func generatePDFURL() -> URL? {
        
        let tempDirectory = FileManager.default.temporaryDirectory
        
        let pdfURL = tempDirectory.appendingPathComponent("\(invoiceNumber).pdf")
        
        let renderer = ImageRenderer(content: invoicePaperView)
        
        renderer.render { size, context in
            
            var box = CGRect(
                origin: .zero,
                size: CGSize(width: 595, height: 842)
            )
            
            guard let pdfContext = CGContext(
                pdfURL as CFURL,
                mediaBox: &box,
                nil
            ) else {
                return
            }
            
            pdfContext.beginPDFPage(nil)
            context(pdfContext)
            pdfContext.endPDFPage()
            pdfContext.closePDF()
        }
        
        return pdfURL
    }
    
    private func printInvoice() {
        
        Task {
            
            guard let url = await generatePDFURL() else { return }
            
            let printInfo = UIPrintInfo(dictionary: nil)
            
            printInfo.jobName = "Invoice \(invoiceNumber)"
            printInfo.outputType = .general
            
            let controller = UIPrintInteractionController.shared
            
            controller.printInfo = printInfo
            controller.printingItem = url
            
            await MainActor.run {
                controller.present(animated: true)
            }
        }
    }
    
    private func shareInvoicePDF() {
        
        Task {
            
            guard let pdfURL = await generatePDFURL() else { return }
            
            await MainActor.run {
                
                guard
                    let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                    let rootVC = scene.windows.first?.rootViewController
                else {
                    return
                }
                
                let activityVC = UIActivityViewController(
                    activityItems: [pdfURL],
                    applicationActivities: nil
                )
                
                rootVC.present(activityVC, animated: true)
            }
        }
    }
}

// MARK: - Preview

#Preview {
    
    NavigationStack {
        
        InvoiceView(
            startDate: "01 May 2026",
            endDate: "15 May 2026"
        )
    }
}
