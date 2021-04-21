//
//  bubbleGame.swift
//  AlgoBubbleGame
//
//  Created by Mario Fernandes on 19/04/2021.
//

import Foundation
import Combine


class bubbleGame: ObservableObject {
    
        
    
    //    -----------Unlock SeaHorse -------------//
    
    @Published var assetState:Bool = true
    
    
    var assetBubbleState:Bool{
        
        
        Bool(self.assetState)
        
    }
    
    
    func add(assetStateChange:Bool){
        
        
        self.assetState = assetStateChange
        
        
        print("BubbleClass \( assetState)")
        
        
        
        
        return
    }
    
    
    //    -----------Unlock SeaHorse Info-------------//
    
    @Published var UnlockHorseAsset:String = "Try to catch 15 Bubbles and win the Asset."
    
    var horseStringValue:String{
        String(UnlockHorseAsset)
    }
    
    
    func add(horseValue:String = ""){
        UnlockHorseAsset = horseValue
        
        print("UnlockHorseAsset \( UnlockHorseAsset)")
        return
    }
    
    
    //    -----------Asset ID -------------//
    
    @Published var assetIndexName:Int64?=0
    

    
    var assetIDValue:String{
        String(assetIndexName ?? 0)
        
    }
    
    
    func add(assetID:Int64?=0){
        assetIndexName = assetID
        print(assetIndexName as Any)
        return
    }
    
    
    
    
    
    
}


