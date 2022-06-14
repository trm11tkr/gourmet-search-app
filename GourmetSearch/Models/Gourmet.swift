import Foundation


struct Gourmet: Decodable {
    let results: Shops
}

struct Shops: Decodable {
    let resultsReturned: String
    let shop: Array<Shop>
    private enum CodingKeys: String, CodingKey {
        case resultsReturned = "results_returned"
        case shop
    }
}

struct Shop:Decodable {
    let name: String
    let access: String
    let address: String
    let open: String
    let logoImage: String
    let photo: Photo
    let genre: Genre
    private enum CodingKeys: String, CodingKey {
        case name
        case access
        case address
        case open
        case logoImage = "logo_image"
        case photo
        case genre
    }
}

struct Genre: Decodable {
    let name: String
    let `catch`: String
}

struct Photo: Decodable {
    let mobile: MobileImage
}

struct MobileImage: Decodable {
    let mobileImage: String
    private enum CodingKeys: String, CodingKey {
        case mobileImage = "l"
    }
}
