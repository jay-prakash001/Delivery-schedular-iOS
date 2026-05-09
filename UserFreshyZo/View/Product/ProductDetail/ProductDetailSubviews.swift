//
//  ProductDetailSubviews.swift
//  UserFreshyZo
//
//  Created by Varsha Sahu on 30/03/26.
//

import SwiftUI
import LinkPresentation


// MARK: - ShareSheet
struct ShareSheet: UIViewControllerRepresentable {
    let activityItems: [Any]
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
    }
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

func shareProductContent(text: String, link: String, imageUrl: String) {
    print("📢 Share initiated for product: \(text)")
    
    // 1. Validate URLs
    guard let productUrl = URL(string: link) else {
        print("❌ Error: Invalid product link URL: \(link)")
        return
    }
    guard let imageDownloadUrl = URL(string: imageUrl) else {
        print("❌ Error: Invalid image download URL: \(imageUrl)")
        return
    }

    print("⏳ Downloading image from: \(imageUrl)...")
    
    // 2. Download Data
    URLSession.shared.dataTask(with: imageDownloadUrl) { data, response, error in
        // Check for networking errors
        if let error = error {
            print("❌ Network Error during image download: \(error.localizedDescription)")
            return
        }
        
        // Check HTTP Status
        if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
            print("❌ Server Error: Received status code \(httpResponse.statusCode)")
            return
        }

        // 3. Convert data to UIImage
        guard let data = data, let imageToShare = UIImage(data: data) else {
            print("⚠️ Warning: Could not convert data to UIImage. Proceeding with text only.")
            presentShareController(text: text, url: productUrl, image: nil)
            return
        }
        
        print("✅ Image downloaded successfully (\(data.count) bytes)")
        
        DispatchQueue.main.async {
            presentShareController(text: text, url: productUrl, image: imageToShare)
        }
    }.resume()
}

// Separate function for presentation to keep logs clean
private func presentShareController(text: String, url: URL, image: UIImage?) {
    print("🚀 Preparing UIActivityViewController...")
    
    let metadataSource = ProductShareMetadataSource(text: text, url: url, image: image)
    var items: [Any] = [metadataSource]
    
    if let img = image {
        items.append(img)
    }
    
    let activityVC = UIActivityViewController(activityItems: items, applicationActivities: nil)
    
    // Log dismissal/completion
    activityVC.completionWithItemsHandler = { activity, success, items, error in
        if success {
            print("🎉 User successfully shared via: \(activity?.rawValue ?? "unknown app")")
        } else if let error = error {
            print("❌ Share Sheet Error: \(error.localizedDescription)")
        } else {
            print("⏹️ User dismissed the share sheet without sharing.")
        }
    }
    
    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
       let rootVC = windowScene.windows.first?.rootViewController {
        
        if let popover = activityVC.popoverPresentationController {
            print("📱 Configuring iPad popover...")
            popover.sourceView = rootVC.view
            popover.sourceRect = CGRect(x: rootVC.view.bounds.midX, y: rootVC.view.bounds.midY, width: 0, height: 0)
            popover.permittedArrowDirections = []
        }
        
        rootVC.present(activityVC, animated: true) {
            print("📺 Share Sheet presented on screen.")
        }
    } else {
        print("❌ Error: Could not find rootViewController to present the share sheet.")
    }
}

// MARK: - Metadata Helper
class ProductShareMetadataSource: NSObject, UIActivityItemSource {
    let text: String
    let url: URL
    let image: UIImage?

    init(text: String, url: URL, image: UIImage?) {
        self.text = text
        self.url = url
        self.image = image
    }

    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return text
    }

    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        // Return the text and link for messaging apps
        return "\(text)\n\(url.absoluteString)"
    }

    func activityViewControllerLinkMetadata(_ activityViewController: UIActivityViewController) -> LPLinkMetadata? {
        let metadata = LPLinkMetadata()
        metadata.title = text
        metadata.originalURL = url
        metadata.url = url
        if let img = image {
            metadata.iconProvider = NSItemProvider(object: img)
            metadata.imageProvider = NSItemProvider(object: img)
        }
        return metadata
    }
}


// MARK: - Section Header
struct SectionHeader: View {
    let title: String
    var body: some View {
        HStack(spacing: 8) {
            Circle().fill(Color("AppGreenColor")).frame(width: 10, height: 10)
            Text(title).font(.system(size: 16, weight: .semibold))
        }
    }
}

// MARK: - Nutrition Badge
struct NutritionBadge: View {
    let icon: String; let value: String; let label: String
    var body: some View {
        VStack(spacing: 6) {
            Text(icon).font(.system(size: 22))
            Text(value).font(.system(size: 16, weight: .bold)).foregroundColor(Color("AppGreenColor"))
            Text(label).font(.system(size: 11, weight: .medium)).foregroundColor(.gray).tracking(0.5)
        }
        .frame(maxWidth: .infinity).padding(.vertical, 14)
        .background(Color(UIColor.systemGroupedBackground)).cornerRadius(12)
    }
}

// MARK: - Comparison Row
struct ComparisonRow: View {
    let feature: ComparisonFeature
    let isPad: Bool
    var body: some View {
        HStack {
            Text(feature.name)
                .font(.system(size: isPad ? 14 : 12))
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity, alignment: .leading)
            ComparisonCell(value: feature.freshyzo, isPad: isPad).frame(width: isPad ? 80 : 64)
            ComparisonCell(value: feature.others,   isPad: isPad).frame(width: isPad ? 60 : 48)
            ComparisonCell(value: feature.mass,     isPad: isPad).frame(width: isPad ? 60 : 48)
            ComparisonCell(value: feature.regular,  isPad: isPad).frame(width: isPad ? 60 : 48)
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Comparison Cell
struct ComparisonCell: View {
    let value: Bool?; let isPad: Bool
    var body: some View {
        Group {
            if let v = value {
                Image(systemName: v ? "checkmark" : "xmark")
                    .font(.system(size: isPad ? 14 : 12, weight: .bold))
                    .foregroundColor(v ? Color("AppGreenColor") : .red)
            } else {
                Text("~").font(.system(size: isPad ? 16 : 13, weight: .bold)).foregroundColor(.orange)
            }
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Legend Item
struct LegendItem: View {
    let symbol: String; let color: Color; let label: String
    var body: some View {
        HStack(spacing: 4) {
            Text(symbol).font(.system(size: 13, weight: .bold)).foregroundColor(color)
            Text(label).font(.system(size: 12)).foregroundColor(.gray)
        }
    }
}

// MARK: - Review Card
struct ReviewCard: View {
    let isPad: Bool
    
    let feedback : Feedback
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                
                Circle().fill(Color.gray.opacity(0.2)).frame(width: 36, height: 36)
                    .overlay(
                        Text(String(feedback.customerName.first ?? "@").capitalized)
                        
                        .font(.system(size: 16, weight: .semibold)).foregroundColor(.gray))
                VStack(alignment: .leading, spacing: 2) {
                    Text(feedback.customerName.capitalized).font(.system(size: isPad ? 14 : 13, weight: .semibold))
                    HStack(spacing: 3) {
                        Image(systemName: "checkmark.seal.fill")
                            .foregroundColor(Color("AppGreenColor")).font(.system(size: 10))
                        Text("Verified Buyer").font(.system(size: 11)).foregroundColor(Color("AppGreenColor"))
                    }
                }
                Spacer()
                Text("★ \(feedback.productRating)")
                    .font(.system(size: isPad ? 13 : 11, weight: .bold)).foregroundColor(.white)
                    .padding(.horizontal, 10).padding(.vertical, 5)
                    .background(Color("AppGreenColor")).cornerRadius(20)
            }
            Text(feedback.feedback)
                .font(.system(size: isPad ? 14 : 12)).foregroundColor(.secondary).lineSpacing(3)
            Text(feedback.timeStamp).font(.system(size: isPad ? 12 : 10)).foregroundColor(.gray)
//            HStack(spacing: 4) {
//                Text("Helpful?").font(.system(size: isPad ? 12 : 10)).foregroundColor(.gray)
//                Text("👍 12").font(.system(size: isPad ? 12 : 10)).foregroundColor(.gray)
//            }
        }
        .padding(12)
        .frame(width: isPad ? 300 : 230)
        .background(Color(UIColor.systemGroupedBackground)).cornerRadius(14)
    }
}



struct ReviewCardListItem: View {
    let isPad: Bool
    let feedback: Feedback
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // MARK: - Header (Avatar, Name, Rating)
            HStack(alignment: .center, spacing: 12) {
                // Better Avatar
                ZStack {
                    Circle()
                        .fill(LinearGradient(colors: [Color.gray.opacity(0.1), Color.gray.opacity(0.2)], startPoint: .top, endPoint: .bottom))
                        .frame(width: 40, height: 40)
                    
                    Text(String(feedback.customerName.first ?? "@").uppercased())
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.gray)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(feedback.customerName.capitalized)
                        .font(.system(size: isPad ? 16 : 14, weight: .bold))
                        .foregroundColor(.primary)
                    
                    HStack(spacing: 4) {
                        Image(systemName: "checkmark.seal.fill")
                            .foregroundColor(Color("AppGreenColor"))
                            .symbolRenderingMode(.multicolor)
                            .font(.system(size: 12))
                        
                        Text("Verified Buyer")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(Color("AppGreenColor"))
                    }
                }
                
                Spacer()
                
                // Modern Rating Badge
                HStack(spacing: 2) {
                    Image(systemName: "star.fill")
                        .font(.system(size: 10))
                    Text("\(feedback.productRating)")
                        .font(.system(size: isPad ? 14 : 12, weight: .bold))
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .foregroundColor(.white)
                .background(Color("AppGreenColor"))
                .clipShape(Capsule())
            }
            
            // MARK: - Review Text
            Text(feedback.feedback)
                .font(.system(size: isPad ? 15 : 13))
                .foregroundColor(.primary.opacity(0.8))
                .lineSpacing(4)
                .fixedSize(horizontal: false, vertical: true) // Prevents text truncation issues
            
            // MARK: - Footer (Timestamp)
            HStack {
                Spacer() // Pushes timestamp to the right
                Text(feedback.timeStamp)
                    .font(.system(size: isPad ? 12 : 11))
                    .foregroundColor(.secondary.opacity(0.7))
                    .italic()
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(UIColor.secondarySystemGroupedBackground))
                .shadow(color: Color.black.opacity(0.03), radius: 8, x: 0, y: 4)
        )
        .padding(.horizontal, 4) // Subtle breathing room in the list
    }
}
// MARK: - Why Choose Row
struct WhyChooseRow: View {
    let emoji: String; let title: String; let subtitle: String; let badge: String?
    var body: some View {
        HStack(spacing: 14) {
            Text(emoji).font(.system(size: 28))
                .frame(width: 44, height: 44)
                .background(Color(UIColor.systemGroupedBackground)).cornerRadius(10)
            VStack(alignment: .leading, spacing: 2) {
                Text(title).font(.system(size: 15, weight: .semibold))
                Text(subtitle).font(.system(size: 12)).foregroundColor(.gray)
            }
            Spacer()
            if let badge = badge {
                Text(badge)
                    .font(.system(size: 12, weight: .bold)).foregroundColor(Color("AppGreenColor"))
                    .padding(.horizontal, 10).padding(.vertical, 5)
                    .overlay(RoundedRectangle(cornerRadius: 8)
                        .stroke(Color("AppGreenColor"), lineWidth: 1.5))
            }
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Subscription Stepper
struct SubscriptionStepperView: View {
    @Binding var qty: Int
    let isPad: Bool
    
    var body: some View {
        HStack(spacing: 8) {
            Button(action: { if qty > 2 { qty -= 1 } }) {
                Text("-")
                    .font(.system(size: isPad ? 18 : 16, weight: .semibold))
                    .foregroundColor(qty <= 2 ? Color.gray.opacity(0.35) : Color("AppGreenColor"))
                    .frame(width: isPad ? 32 : 28, height: isPad ? 32 : 28)
            }
            .disabled(qty <= 2)
            
            Text("\(qty)")
                .font(.system(size: isPad ? 16 : 15, weight: .bold))
                .frame(minWidth: isPad ? 24 : 20)
                .multilineTextAlignment(.center)
            
            Button(action: { qty += 1 }) {
                Text("+")
                    .font(.system(size: isPad ? 18 : 16, weight: .semibold))
                    .foregroundColor(Color("AppGreenColor"))
                    .frame(width: isPad ? 32 : 28, height: isPad ? 32 : 28)
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(Color("AppGreenColor").opacity(0.12))
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color("AppGreenColor").opacity(0.3), lineWidth: 1)
        )
    }
}
