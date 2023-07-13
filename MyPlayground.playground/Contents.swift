import Foundation

let rawData =
"""
"""

enum ProductColor: String, Codable, CaseIterable {
    case black = "블랙"
    case beige = "베이지"
    case navy = "네이비"
    case blue = "블루"
    case ivory = "아이보리"
    case pink = "핑크"
}

struct Trunk {
    let size: TrunkSize
    let color: ProductColor
}

enum TrunkSize: String, Codable, CaseIterable {
    case L, M
}

struct Shirts {
    let size: ShirtsSize
    let color: ProductColor
}

enum ShirtsSize: String, Codable, CaseIterable {
    case MD, H
}

var trunkList = [Trunk]()
var shirtsList = [Shirts]()
var errorOrder = [String]()

let orders = rawData.components(separatedBy: "\n")
orders.forEach { order in
    if order.contains("셋업") {
        let orderColors = order.colorGenerator
        trunkList += orderColors.map { color in Trunk(size: order.trunkSizeGenerator, color: color)}
        shirtsList += orderColors.map { color in Shirts(size: order.shirtsSizeGenerator, color: color)}
    } else if order.contains("트렁크") {
        if order.contains("노브라티") {
            errorOrder += [order]
        } else {
            trunkList += order.colorGenerator.map { color in Trunk(size: order.trunkSizeGenerator, color: color)}
        }
    } else if order.contains("노브라티") {
        if order.contains("트렁크") {
            errorOrder += [order]
        } else {
            shirtsList += order.colorGenerator.map { color in Shirts(size: order.shirtsSizeGenerator, color: color)}
        }
    }
}

for size in TrunkSize.allCases {
    for color in ProductColor.allCases {
        let productCount = trunkList.filter { $0.color == color && $0.size == size}.count
        if productCount > 0 {
            print("트렁크 | \(size.rawValue) | \(color.rawValue) | 개수\(productCount)")
        }
    }
}

for size in ShirtsSize.allCases {
    for color in ProductColor.allCases {
        let productCount = shirtsList.filter { $0.color == color && $0.size == size}.count
        if productCount > 0 {
            print("티셔츠 | \(size.rawValue) | \(color.rawValue) | 개수\(productCount)")
        }
    }
}

for error in errorOrder {
    print("======== 처리 안된 주문 ========")
    print(error)
}

extension String {
    var colorGenerator: [ProductColor] {
        var searchWord = self
        let allColor = ProductColor.allCases
        var colors = [ProductColor]()
        
        for color in allColor {
            let colorCount = searchWord.components(separatedBy: color.rawValue).dropLast(1)
            colors += colorCount.compactMap { _ in color }
        }
        
        return colors
    }
    
    var trunkSizeGenerator: TrunkSize {
        if contains("트렁크 사이즈-M") || contains("팬티 M") || contains("트렁크사이즈-M") {
            return .M
        } else {
            return .L
        }
    }
    
    var shirtsSizeGenerator: ShirtsSize {
        if contains("노브라티 사이즈-MD") || contains("티 MD") || contains("노브라티사이즈-MD") {
            return .MD
        } else {
            return .H
        }
    }
}
