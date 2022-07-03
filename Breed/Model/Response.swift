//
//  Breed.swift
//  Breed
//
//  Created by Stéphanie Sabine on 01/07/2022.
//

import Foundation

struct ResponseArray: Codable
{
    let message: [String]
    let status: String
}

struct ResponseObject: Codable
{
    let message: [String: [String]]
    let status: String
}
