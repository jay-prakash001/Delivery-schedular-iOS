import SwiftUI


struct CalendarDataDialogItemView: View {
    var item: CalendarItem
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            // 1. The Main Card Container
            HStack(alignment: .top, spacing: 12) {
                // Image
                AsyncImage(url: URL(string: item.image)) { phase in
                    if let image = phase.image {
                        image.resizable().aspectRatio(contentMode: .fill)
                    } else {
                        Color.gray.opacity(0.1)
                    }
                }
                .frame(width: 50, height: 50)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                
                // Content
                VStack(alignment: .leading, spacing: 4) {
                    Text(item.productName)
                        .font(.system(size: 12, weight: .semibold))
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                        // This padding prevents the text from going UNDER the tag
                        .padding(.trailing, 60)
                    
                    Text("Qty: \(item.qty)")
                        .font(.system(size: 8))
                        .foregroundStyle(.secondary)
                }
                Spacer()
            }
            .padding(12) // Inner padding for content
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 3)

            // 2. The Type Tag (Aligned to topTrailing of the ZStack)
            Text(item.type)
                .font(.system(size: 8, weight: .bold))
                .foregroundStyle(.white)
                .padding(.horizontal, 8)
                .padding(.vertical, 2)
                .background(Color.appGreen)
                // Use custom corners so it flushes with the top-right of the card
                .clipShape(UnevenRoundedRectangle(topLeadingRadius: 0, bottomLeadingRadius: 6, bottomTrailingRadius: 0, topTrailingRadius: 12))
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
    }
}

struct CalendarDataDialogItemView1: View {
    var item: CalendarItem
    
    var body: some View {
        ZStack(alignment : .topTrailing){
            HStack(alignment: .top, spacing: 12) { // Align to top
                // 1. Image
                AsyncImage(url: URL(string: item.image)) { phase in
                    if let image = phase.image {
                        image.resizable().aspectRatio(contentMode: .fill)
                    } else {
                        Color.gray.opacity(0.1)
                    }
                }
                .frame(width: 50, height: 50)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                
                // 2. Content Area
                VStack(alignment: .leading, spacing: 4) {
                    HStack(alignment: .top) {
                        // This text now expands
                        Text(item.productName)
                            .font(.system(size: 14, weight: .semibold))
                            .lineLimit(2)
                            .fixedSize(horizontal: false, vertical: true) // Allows wrapping
                        
                        Spacer() // Pushes the tag to the right
                        
                    }
                    
                    Text("Qty: \(item.qty)")
                        .font(.system(size: 12))
                        .foregroundStyle(.secondary)
                }
            }
            
            
            HStack(alignment: .top){
                
                // 3. Type Tag (Top Right)
                Text(item.type)
                    .font(.system(size: 10, weight: .bold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.appGreen)
                    .cornerRadius(6)
            }
            
            
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading) // Ensure card takes full width
        .background(Color.white)
        .cornerRadius(12)
        // Bottom-only elevation shadow
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 3)
        .padding(.horizontal, 16)
        .padding(.vertical, 4)
    }
}
struct CalendarDataDialogItemView0: View {
    var item: CalendarItem
    
    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            // Smaller, thinner image container
            
            HStack{
                AsyncImage(url: URL(string: item.image)) { phase in
                    if let image = phase.image {
                        image.resizable().aspectRatio(contentMode: .fill)
                    } else {
                        Color.gray.opacity(0.1)
                    }
                }
                .frame(width: 40, height: 40) // Reduced from 60
                .clipShape(RoundedRectangle(cornerRadius: 6))
                
                VStack(alignment: .leading, spacing: 0) {
                    Text(item.productName)
                        .font(.system(size: 14, weight: .semibold)) // Smaller font
                    Text("Qty: \(item.qty)")
                        .font(.system(size: 12))
                        .foregroundStyle(.secondary)
                }
            }
            
            
            Spacer()
            
            VStack{
                Text(item.type)
                    .font(.system(size: 10, weight: .bold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.appGreen)
                    .cornerRadius(6)

            }
        }
        .padding(.horizontal, 4)
        .padding(.vertical, 8) // Thinner vertical padding
        .background(Color(.white)) // Light gray instead of white for inner items
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 6)    }
}



#Preview {
    CalendarDataDialogItemView(item : dummyCalendarData.items[0])
}
