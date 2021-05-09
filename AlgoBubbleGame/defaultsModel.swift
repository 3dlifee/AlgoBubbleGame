//
//  defaultsModel.swift
//  AlgoBubbleGame
//
//  Created by Mario Fernandes on 08/05/2021.
//

import Foundation
class defaultsModel: ObservableObject {
    
    
    @Published var mnemonic1: String = UserDefaults.standard.string(forKey: "mnemonic1") ?? "" {
        
        didSet {
            
            UserDefaults.standard.set(self.mnemonic1, forKey: "mnemonic1")
        }
        
         }
    
    
    @Published var mnemonic3: String = UserDefaults.standard.string(forKey: "mnemonic3") ?? "" {
           
           didSet {
               
               UserDefaults.standard.set(self.mnemonic3, forKey: "mnemonic3")
           }
           
            }

    
    @Published var receiveAddress: String = UserDefaults.standard.string(forKey: "receiveAddress") ?? "" {
           
           didSet {
               
               UserDefaults.standard.set(self.receiveAddress, forKey: "receiveAddress")
           }
           
            }
    
   
    
}


