//
//  UserModel.swift
//  Demo
//
//  Created by lanet on 07/02/18.
//  Copyright © 2018 lanet. All rights reserved.
//
import UIKit

class UserInfo {
    
    //MARK:- Properties
    
    var name : String
    var rating : Int
    var photo : UIImage?
    
    //MARK:- Intialization
    
    init?(name : String, rating : Int, photo : UIImage?) {
        
        //initialization fails if the name is empty or rating was nagative
        guard !name.isEmpty else {
            return nil
        }
        
        guard (rating >= 0) && (rating <= 5) else {
            return nil
        }
        
        //Intializer stored properties
        self.name = name
        self.photo = photo
        self.rating = rating
    }
}
