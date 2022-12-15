//
//  BooksResponse.swift
//  BookStore_LuizVasconcellos
//
//  Created by Luiz Vasconcellos on 07/12/22.
//

import Foundation

// MARK: - BooksResponse
struct BooksResponse: Codable {
    let totalItems: Int
    let items: [Item]
}

// MARK: - Item
struct Item: Codable {
    let id: String
    let selfLink: String
    let volumeInfo: VolumeInfo
    let saleInfo: SaleInfo
}

// MARK: - SaleInfo
struct SaleInfo: Codable {
    let buyLink: String?
}

// MARK: - VolumeInfo
struct VolumeInfo: Codable {
    let title: String
    let authors: [String]
    let volumeInfoDescription: String?
    let imageLinks: ImageLinks

    enum CodingKeys: String, CodingKey {
        case title, authors
        case volumeInfoDescription = "description"
        case imageLinks
    }
}

// MARK: - ImageLinks
struct ImageLinks: Codable {
    let smallThumbnail, thumbnail: String
}
