import Foundation


struct Gourmet: Decodable {
    let results: Shops
}

struct Shops: Decodable {
    let results_returned: String
    let shop: Array<Shop>
}

struct Shop:Decodable {
    let name: String
    let access: String
    let address: String
    let open: String
    let logo_image: String
    let photo: Photo
    let genre: Genre
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
