//
//  User.swift
//  testSalad
//
//  Created by naomi-hidaka on 2017/04/26.
//  Copyright © 2017年 naomi-hidaka. All rights reserved.
//

import Foundation

class User: Salada.Object {
    typealias Element = User

    dynamic var name: String?
    dynamic var recipes: Set<String> = []
}
