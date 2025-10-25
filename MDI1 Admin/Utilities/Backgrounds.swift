import SwiftUI

struct Backgrounds {
    // gradient generator: https://angrytools.com/gradient/
    
    static var gradient1 = LinearGradient(
        gradient: Gradient(colors: [
            Color(hex: "#2F4E67"),
            Color(hex: "#3E627C"),
            Color(hex: "#4D7792"),
            Color(hex: "#5D8DA8"),
            Color(hex: "#6DA3BE")
        ]),
        startPoint: .bottom,  // "to top" in CSS becomes .bottom to .top in SwiftUI
        endPoint: .top
    )
    
    
    static var gradient2 = LinearGradient(
        gradient: Gradient(colors: [
            Color(hex: "#716B83"),
            Color(hex: "#8D8DA9"),
            Color(hex: "#A5A5CA"),
        ]),
        startPoint: .bottom,  // "to top" in CSS becomes .bottom to .top in SwiftUI
        endPoint: .top
    )
    
    static var gradient3 = LinearGradient(
        gradient: Gradient(colors: [
            Color(hex: "#716B83"),
            Color(hex: "#2F7E9A"),
            Color(hex: "#3B8D99"),
        ]),
        startPoint: .bottom,  // "to top" in CSS becomes .bottom to .top in SwiftUI
        endPoint: .top
    )
}
