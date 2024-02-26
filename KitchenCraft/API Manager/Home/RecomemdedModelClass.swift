// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let menuModel = try? JSONDecoder().decode(MenuModel.self, from: jsonData)

import Foundation

// MARK: - MenuModel
class RecomemdedModelClass: Codable {
    let meals: [Meal]

    init(meals: [Meal]) {
        self.meals = meals
    }
}

// MARK: - Meal
class Meal: Codable {
    let strMeal: String
    let strMealThumb: String
    let idMeal: String

    init(strMeal: String, strMealThumb: String, idMeal: String) {
        self.strMeal = strMeal
        self.strMealThumb = strMealThumb
        self.idMeal = idMeal
    }
}
