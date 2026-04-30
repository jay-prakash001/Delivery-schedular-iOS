//
//  FAQItem.swift
//  UserFreshyZo
//
//  Created by Varsha Sahu on 30/03/26.
//

//  ProductDetailModels.swift
//  UserFreshyZo

import Foundation

// MARK: - FAQ Model
struct FAQItem: Identifiable {
    let id = UUID()
    let question: String
    let answer: String
}

// MARK: - FAQ Provider
struct FAQProvider {
    static func faqItems(for category: String) -> [FAQItem] {
        switch category {
        case "Milk":
            return [
                FAQItem(question: "What is A2 Gir Cow milk?",
                        answer: "A2 Gir Cow milk comes from indigenous Gir breed cows and contains only A2 beta-casein protein, which is easier to digest and better for overall health compared to regular A1 milk."),
                FAQItem(question: "How is Freshyzo milk different from packet milk?",
                        answer: "Freshyzo milk is farm-fresh, preservative-free, delivered within 8 hours of milking, and packed in glass bottles. Packet milk is often pasteurized and may sit for days before reaching you."),
                FAQItem(question: "Is A2 cow milk safe for lactose-sensitive people?",
                        answer: "Yes! A2 milk contains A2 beta-casein protein which is much gentler on the digestive system. Many people who experience discomfort with regular milk find A2 milk easier to digest."),
                FAQItem(question: "Why does the milk look slightly yellow?",
                        answer: "The natural yellow tint comes from beta-carotene, a sign of high-quality, grass-fed Gir cow milk. This is completely natural and indicates the milk is rich in nutrients."),
                FAQItem(question: "Is it safe for children and elderly people?",
                        answer: "Absolutely! Our A2 Gir Cow milk is ideal for growing children, expecting mothers, and senior citizens. It's rich in calcium, protein, and easy on digestion."),
                FAQItem(question: "How should I store the milk after delivery?",
                        answer: "Refrigerate immediately after delivery. Consume within 24–48 hours for best taste. Boil before consuming if preferred. Store in the glass bottle with the cap tightly closed."),
                FAQItem(question: "Why is Freshyzo milk priced higher?",
                        answer: "Our milk is sourced directly from Gir cows, delivered fresh within 8 hours, lab-tested daily, and packed in glass bottles — all of which ensure superior quality over mass-market alternatives.")
            ]
        case "Dahi":
            return [
                FAQItem(question: "How is Freshyzo Dahi made?",
                        answer: "Our Dahi is made from fresh A2 Gir Cow milk using traditional culturing methods. No preservatives, no artificial thickeners — just pure, natural curd."),
                FAQItem(question: "Is Freshyzo Dahi set or stirred?",
                        answer: "Freshyzo Dahi is naturally set in the container, giving it a thick, creamy texture just like homemade curd."),
                FAQItem(question: "How long does the Dahi stay fresh?",
                        answer: "Best consumed within 2–3 days of delivery. Always refrigerate and keep the container tightly sealed."),
                FAQItem(question: "Does the Dahi contain any preservatives?",
                        answer: "No. Freshyzo Dahi is 100% preservative-free. It is made fresh and delivered directly to your door."),
                FAQItem(question: "Can children and elderly people have this Dahi?",
                        answer: "Yes, it is ideal for all age groups. The A2 protein makes it gentle on digestion and rich in probiotics for gut health."),
                FAQItem(question: "Why is the Dahi sometimes slightly sour?",
                        answer: "Natural fermentation causes slight variation in sourness based on temperature and time. This is completely normal and a sign of authentic, preservative-free curd.")
            ]
        case "Paneer":
            return [
                FAQItem(question: "Is Freshyzo Paneer made from A2 milk?",
                        answer: "Yes! Our Paneer is made exclusively from fresh A2 Gir Cow milk, making it softer, richer, and easier to digest than regular paneer."),
                FAQItem(question: "Does Freshyzo Paneer contain starch?",
                        answer: "Absolutely not. Unlike many commercial brands that add starch to increase weight, Freshyzo Paneer is 100% pure with no additives."),
                FAQItem(question: "How long does the Paneer stay fresh?",
                        answer: "Refrigerate and consume within 3–4 days. For longer shelf life, store immersed in water and change the water daily."),
                FAQItem(question: "Can I use Freshyzo Paneer for all cooking?",
                        answer: "Yes! It works perfectly for all Indian dishes — paneer butter masala, palak paneer, or grilled tikka. It holds its shape and absorbs flavors beautifully."),
                FAQItem(question: "Why is A2 Paneer better for children?",
                        answer: "A2 Paneer is rich in calcium, protein, and healthy fats without the digestive issues associated with A1 milk products. It is excellent for growing children."),
                FAQItem(question: "Is Freshyzo Paneer good for lactose-sensitive people?",
                        answer: "Many lactose-sensitive individuals find A2-based paneer easier to digest due to the A2 beta-casein protein structure, which behaves differently in the gut.")
            ]
        case "Ghee":
            return [
                FAQItem(question: "What is Bilona Ghee?",
                        answer: "Bilona Ghee is made using the traditional hand-churning method from curd prepared with A2 Gir Cow milk. This ancient process preserves nutrients and gives a rich, aromatic flavor."),
                FAQItem(question: "How is Freshyzo Ghee different from regular ghee?",
                        answer: "Regular ghee is made from cream directly. Freshyzo Ghee uses the Bilona method — curd is churned to butter, then slowly clarified — retaining more nutrients and authentic taste."),
                FAQItem(question: "Does Freshyzo Ghee have any additives?",
                        answer: "No. It is 100% pure A2 Gir Cow Ghee with no artificial flavoring, coloring, or preservatives."),
                FAQItem(question: "What is the shelf life of Freshyzo Ghee?",
                        answer: "When stored in a cool, dry place away from direct sunlight, Freshyzo Ghee stays fresh for up to 12 months. No refrigeration needed."),
                FAQItem(question: "Is Bilona Ghee good for digestion?",
                        answer: "Yes! Bilona Ghee is rich in butyric acid which supports gut health and digestion. It also boosts immunity and improves nutrient absorption."),
                FAQItem(question: "Why is A2 Bilona Ghee more expensive?",
                        answer: "The Bilona method requires significantly more milk and labor than industrial ghee production. The quality, purity, and health benefits justify the premium price.")
            ]
        case "khowa":
            return [
                FAQItem(question: "What is Khowa (Mawa)?",
                        answer: "Khowa, also known as Mawa, is made by slowly simmering whole A2 Gir Cow milk until most of the moisture evaporates, leaving behind a rich, dense milk solid used in sweets."),
                FAQItem(question: "Is Freshyzo Khowa made from A2 milk?",
                        answer: "Yes. Our Khowa is made entirely from fresh A2 Gir Cow milk, giving it a naturally rich taste and superior nutritional profile."),
                FAQItem(question: "How long does Khowa stay fresh?",
                        answer: "Refrigerate and use within 5–7 days. For longer storage, you can freeze it for up to 2–3 months."),
                FAQItem(question: "Does Freshyzo Khowa contain any adulterants?",
                        answer: "Absolutely not. Freshyzo Khowa is 100% pure with no starch, vanaspati, or any other adulterant commonly found in commercial Khowa."),
                FAQItem(question: "What can I make with Freshyzo Khowa?",
                        answer: "You can make gulab jamun, barfi, halwa, peda, and many other traditional Indian sweets. Its rich, creamy texture gives an authentic homemade taste."),
                FAQItem(question: "Why does pure Khowa taste different from market Khowa?",
                        answer: "Pure A2 Khowa has a naturally sweet, slightly grainy texture and rich milky aroma. Market versions are often diluted or adulterated, changing the flavor and texture.")
            ]
        default:
            return [
                FAQItem(question: "Is this Freshyzo product fresh?",
                        answer: "Yes, all Freshyzo products are made fresh daily from A2 Gir Cow milk and delivered directly to your doorstep."),
                FAQItem(question: "Are Freshyzo products preservative-free?",
                        answer: "Absolutely. All our products are 100% natural with no preservatives, additives, or artificial ingredients."),
                FAQItem(question: "How should I store Freshyzo products?",
                        answer: "Refrigerate all products immediately after delivery and consume within the recommended time frame on the packaging."),
                FAQItem(question: "Are Freshyzo products safe for children?",
                        answer: "Yes, all our products are made from pure A2 milk and are safe and nutritious for children, adults, and the elderly.")
            ]
        }
    }
}

// MARK: - Comparison Data
struct ComparisonFeature {
    let name: String
    let freshyzo: Bool?
    let others: Bool?
    let mass: Bool?
    let regular: Bool?
}

struct ComparisonDataProvider {
    static let features: [ComparisonFeature] = [
        ComparisonFeature(name: "A2 Milk Available",   freshyzo: true,  others: nil,   mass: false, regular: false),
        ComparisonFeature(name: "Preservatives Free",  freshyzo: true,  others: nil,   mass: nil,   regular: false),
        ComparisonFeature(name: "Bilona Ghee",         freshyzo: true,  others: false, mass: false, regular: false),
        ComparisonFeature(name: "No Starch in Paneer", freshyzo: true,  others: true,  mass: nil,   regular: false),
        ComparisonFeature(name: "Farm Direct",         freshyzo: true,  others: nil,   mass: nil,   regular: false),
        ComparisonFeature(name: "Delivered < 8 hrs",   freshyzo: true,  others: false, mass: false, regular: false),
        ComparisonFeature(name: "Glass Bottle",        freshyzo: true,  others: false, mass: false, regular: false),
        ComparisonFeature(name: "Lab Tested Daily",    freshyzo: true,  others: nil,   mass: nil,   regular: nil)
    ]
}
