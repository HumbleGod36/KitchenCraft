// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? JSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - WelcomeElement
struct OnboardingModel: Codable {
    let id: Int
    let foodImage: String
    let foodHeader, foodDisc: String

    enum CodingKeys: String, CodingKey {
        case id
        case foodImage = "food_image"
        case foodHeader = "food_header"
        case foodDisc = "food_Disc"
    }
}

typealias Welcome = [OnboardingModel]
