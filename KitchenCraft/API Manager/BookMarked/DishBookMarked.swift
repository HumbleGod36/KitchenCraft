import GRDB


struct DishBookMarked: Codable, FetchableRecord, PersistableRecord {
    var dishID: String
    var Dishname: String
    var DishIMage: String
    var Instruction : String
    
}
