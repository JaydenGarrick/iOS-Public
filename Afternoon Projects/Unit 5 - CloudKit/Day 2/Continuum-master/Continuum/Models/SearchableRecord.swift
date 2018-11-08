//
//  SearchableRecord.swift
//  Continuum
//
//  Created by DevMountain on 9/19/18.
//  Copyright © 2018 trevorAdcock. All rights reserved.
//

import Foundation

protocol SearchableRecord{
    
    func matches(searchTerm: String) -> Bool
    
}
