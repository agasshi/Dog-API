//
//  Breed.swift
//  Breed
//
//  Created by Stéphanie Sabine on 03/07/2022.
//

import Foundation

struct Breed: Codable
{
    let name: String
    let breeds: [Breed]
}
