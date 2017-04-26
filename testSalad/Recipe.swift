//
//  Recipe.swift
//  testSalad
//
//  Created by naomi-hidaka on 2017/04/26.
//  Copyright © 2017年 naomi-hidaka. All rights reserved.
//

import Foundation

class Recipe: Salada.Object {
    typealias Element = Recipe
    
    dynamic var title: String?
    dynamic var detail: String?
}
