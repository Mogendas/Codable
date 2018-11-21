import UIKit

let json = """
[
{
"first_name": "Paul",
"last_name": "Hudson"
},
{
"alternativeFirstName": "Andrew",
"last_name": "Carnegie"
}
]
"""

let data = Data(json.utf8)


class User: Codable {
    var firstName: String?
    var lastname: String?

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        lastname = try container.decode(String.self, forKey: .lastname)

        if let name = try container.decodeIfPresent(String.self, forKey: .firstName) {
            firstName = name
        } else {
            firstName = try container.decode(String.self, forKey: .alternativeFirstName)
        }
    }

    init (firstName: String?, lastName: String?) {
        self.firstName = firstName
        self.lastname = lastName
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(firstName, forKey: .firstName)
        try container.encode(lastname, forKey: .lastname)
    }

    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastname = "last_name"
        case alternativeFirstName
    }
}

// Decode
var users = [User]()
do {
    users = try JSONDecoder().decode([User].self, from: data)
} catch let error {
    print("Error: \(error.localizedDescription)")
}

for user in users {
    print("Name: \(user.firstName ?? "") \(user.lastname ?? "")")
}

// Encode
let user1 = User(firstName: "Bo", lastName: "Ek")
let user2 = User(firstName: "Erik", lastName: "Bus")

let encodeUsers = [user1, user2]

var usersData = try? JSONEncoder().encode(encodeUsers)

let dataUsers = try? JSONDecoder().decode([User].self, from: usersData!)

for user in dataUsers! {
    print("Name: \(user.firstName ?? "") \(user.lastname ?? "")")
}

let jsonString = String(bytes: usersData!, encoding: .utf8)
