// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let menuModel = try? JSONDecoder().decode(MenuModel.self, from: jsonData)

import Foundation

// MARK: - MenuModel
class CategoryModelClass: Codable {
    let categories: [Category]

    init(categories: [Category]) {
        self.categories = categories
    }
}

// MARK: - Category
class Category: Codable {
    let idCategory, strCategory: String
    let strCategoryThumb: String
    let strCategoryDescription: String

    init(idCategory: String, strCategory: String, strCategoryThumb: String, strCategoryDescription: String) {
        self.idCategory = idCategory
        self.strCategory = strCategory
        self.strCategoryThumb = strCategoryThumb
        self.strCategoryDescription = strCategoryDescription
    }
}
