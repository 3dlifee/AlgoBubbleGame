//
//  ContentView.swift
//  AlgoBubbleGame
//
//  Created by Mario Fernandes on 17/04/2021.
//

import SwiftUI
import SpriteKit
import Combine
import swift_algorand_sdk


enum goSheet: Identifiable {
    case bonus, assetSeaHorse
    
    var id: Int {
        hashValue
    }
}


struct ContentView: View {
   
    @State var activeGoSheet: goSheet?
//
    @ObservedObject var AssetModel:bubbleGame
    @ObservedObject var gameScene: GameScene
    @ObservedObject var assetSate = bubbleGame()
    
    @State var defaults:UserDefaults = UserDefaults.standard
    @State var transactionIsShowing = false
    @State private var accountIsShowing = false
    
    let bonusSuccedImage = "timerBuyConfirm"
    let bonusFailImage = "timerBuyFail"
    
    @State private var assetRewardState = false
    let transactionSuccedImage = "seahorseTransfer"
    let transactionFailImage = "seahorseTransferFail"
    @State var istransaction = false
    
//   -------PureStake API Token--------------//
    
    var ALGOD_API_ADDR="https://testnet-algorand.api.purestake.io/ps2"
    var ALGOD_API_TOKEN="Gs---------------------------5"
    var ALGOD_API_PORT=""

    //   ------- Asset Values--------------//
    
    @State var assetIndex1:Int64?=nil
    @State var assetTotal:Int64 = 10000
    @State var assetDecimals:Int64 = 0
    @State var  assetUnitName = "HR"
    @State var  assetName = "Hero"
    @State var  url = "https://www.3dlifestudio.com"
    @State var defaultFrozen = false
   
    //   ------- SKScene --------------//
    
    var scene: SKScene {
        let scene = GameScene(horseAsset: $assetSate.assetState)
        scene.size = CGSize(width: 400, height: 800)
        scene.scaleMode = .aspectFit
        scene.anchorPoint =  CGPoint(x: 0.5, y: 0.5)
        return scene
    }
    
    var body: some View {
        
        ZStack(alignment: .center) {
            
            SpriteView(scene: scene)
                
                .ignoresSafeArea()
            
            
            VStack(alignment: .leading){
                
                HStack(){
                    
                    Button(action: {
     
                        accountIsShowing = true
    
                    }) {
                        Image(systemName:"plus.circle.fill")
                            .font(.system(size: 50.0))
                            .foregroundColor((Color("seta")))
                       
                    }
                    .padding(.trailing)
 
                    .sheet(isPresented: $accountIsShowing, onDismiss: {}, content: {
                        AlgoBubbleGame.accounts(accountIsShowing: $accountIsShowing)

                      })
                    
                    Button(action: {
                        
                        self.createAssetClicked()
                        
                    }) {
                        Image("create")
                        
                    }
                    .padding(.trailing)
                    
                    Button(action: {
                        
                        self.changeAsaManager()
                        
                    }) {
                        Image("manager")
                        
                    }
                    .padding(.trailing)
                    
                    Button(action: {
                      
                        self.optInToAsa()
                        
                    }) {
                        Image("optin")
                        
                    }
                    .padding(.trailing)
                    
                }
                //
                .padding(.top, 30.0)
                HStack(){
                    Button(action: {
                        
                        activeGoSheet = .bonus
                        //
                        requestBonus()
                        //
                        
                    }) {
                        Image("bonus")
                        
                    }
                    
                    Text("ID: \(AssetModel.assetIDValue)")
                        .fontWeight(.heavy)
                        .padding(.vertical, 10.0)
                        .font(.custom("AvenirNext-Medium", size: 22))
                        .foregroundColor(Color.black)
                    
                    
                }

                
                Button(action: {
                    
                    activeGoSheet = .assetSeaHorse
                    self.transferAsa()
                    
                    
                }) {
                    Image("seahorse")
                    
                }
                .opacity(Bool(self.assetSate.assetState) ? 0.5 : 1)
                //                .opacity(0.5)
                .disabled(Bool(self.assetSate.assetState))
                //                .disabled(buttonDisabled)
                
            }
            
            .offset(y:-300)
            
            .sheet(isPresented:  $assetRewardState) {
                
                if self.activeGoSheet == .assetSeaHorse {
                    VStack(){
                        if istransaction == true {
                            
                            
                            Image(transactionSuccedImage)
                            Text(String("Score: \(self.assetSate.UnlockHorseAsset)"))
                            
                            Button("Dismiss",
                                   action: {  self.assetRewardState.toggle() })
                            
                        } else  if istransaction == false {
                            
                            
                            Image(transactionFailImage)
                            Text(String("Score: \(self.assetSate.UnlockHorseAsset)"))
                            
                            Button("Dismiss",
                                   action: {  self.assetRewardState.toggle() })
                            
                        }
                    }
                }
                
                else if self.activeGoSheet == .bonus {
                    
                    VStack(){
                        if transactionIsShowing == true {
                            
                            
                            Image(bonusSuccedImage)
                            Text(String("Score: \(self.assetSate.UnlockHorseAsset)"))
                            
                            Button("Dismiss",
                                   action: {  self.assetRewardState.toggle() })
                            
                        } else  if transactionIsShowing == false {
                            
                            
                            Image(bonusFailImage)
                            Text(String("Score: \(self.assetSate.UnlockHorseAsset)"))
                            
                            Button("Dismiss",
                                   action: {  self.assetRewardState.toggle() })
                            
                        }
                    }
                }
                
            }
            
            
            Text("Try to catch 15 Bubbles and win the Asset.")
                .fontWeight(.bold)
                .font(.custom("AvenirNext-Medium", size: 18))
                .foregroundColor(Color.black)
                .offset(y:-150)
        }

       
    }
    
    
  
    
    //    algorand sdk
    func createAssetClicked() {
        
        let algodClient=AlgodClient(host: ALGOD_API_ADDR, port: ALGOD_API_PORT, token: ALGOD_API_TOKEN)
        algodClient.set(key: "X-API-KeY")
        
        
        do {
          
            let account1 = try Account(defaults.string(forKey: "mnemonic1") ?? "")
            
            let senderAddress1 = account1.getAddress()
            
            algodClient.transactionParams().execute(){ paramResponse in
                if(!(paramResponse.isSuccessful)){
                    print(paramResponse.errorDescription!);
                    print("OK")
                    return;
                    
                }
                
          
           
                let tx = Transaction.assetCreateTransactionBuilder()
                    .setSender(senderAddress1)
                    .setAssetTotal(assetTotal: assetTotal)
                    .setAssetDecimals(assetDecimals: assetDecimals)
                    .assetUnitName(assetUnitName: assetUnitName)
                    .assetName(assetName: assetName)
                    .url(url: url)
                    .manager(manager: defaults.string(forKey: "receiveAddress") ?? "")
                    .reserve(reserve: defaults.string(forKey: "receiveAddress") ?? "")
                    .freeze(freeze:  defaults.string(forKey: "receiveAddress") ?? "")
                    .defaultFrozen(defaultFrozen:defaultFrozen)
                    .clawback(clawback:  defaults.string(forKey: "receiveAddress") ?? "")
                    .suggestedParams(params: paramResponse.data!).build()
                
                
        let signedTransaction=account1.signTransaction(tx: tx)
        let encodedTrans:[Int8]=CustomEncoder.encodeToMsgPack(signedTransaction)
        _=Data(CustomEncoder.convertToUInt8Array(input: encodedTrans))
        
        algodClient.rawTransaction().rawtxn(rawtaxn: encodedTrans).execute(){
            response in
            if(response.isSuccessful){
                
                print(signedTransaction)
                print(encodedTrans)
                //
                
                print(response.data!.txId)
                print("Pass")
                self.waitForTransaction(txId:response.data!.txId)
                
            }else{
                print(response.errorDescription!)
                print("Failed")
            }
        }
        
        
       }
       } catch {
        //handle error
        print(error)
       }
        print("algo buy!")
   }
    
//-----
   func waitForTransaction(txId:String) {
       
       let algodClient=AlgodClient(host: ALGOD_API_ADDR, port: ALGOD_API_PORT, token: ALGOD_API_TOKEN)
           algodClient.set(key: "X-API-KeY")
       
       
       var confirmedRound: Int64?=0
       var assetIndex:Int64?=0
       algodClient.pendingTransactionInformation(txId:txId).execute(){
           pendingTransactionResponse in
               if(pendingTransactionResponse.isSuccessful){
                   confirmedRound=pendingTransactionResponse.data!.confirmedRound
                   assetIndex=pendingTransactionResponse.data!.assetIndex
                   print(assetIndex as Any)
                   print("pendingTransactionResponse")
                   AssetModel.add(assetID: assetIndex)
                   assetIndex1 = assetIndex
                   if(confirmedRound != nil && confirmedRound! > 0){

                       print("confirmedRound")

                       
                   }else{
                       self.waitForTransaction(txId: txId)

                       print("fwait")
                   }
               }else{
                   print(pendingTransactionResponse.errorDescription!)
                  
                   confirmedRound=12000;
               }
   }
}
   
   
   
   
//    --------
   
   
   func  changeAsaManager(){
       
       let algodClient=AlgodClient(host: ALGOD_API_ADDR, port: ALGOD_API_PORT, token: ALGOD_API_TOKEN)
           algodClient.set(key: "X-API-KeY")
       
      
       do {
      
       let account1 = try Account( defaults.string(forKey: "mnemonic1") ?? "")
       
       let senderAddress1 = account1.getAddress()
 
       algodClient.transactionParams().execute(){ paramResponse in
           if(!(paramResponse.isSuccessful)){
               print(paramResponse.errorDescription!);
               print("passou")
               return;
               
           }
               
           let tx = Transaction.assetConfigureTransactionBuilder()
               .reserve(reserve: defaults.string(forKey: "receiveAddress") ?? "")
               .freeze(freeze:  defaults.string(forKey: "receiveAddress") ?? "")
               .clawback(clawback:  defaults.string(forKey: "receiveAddress") ?? "")
               .assetIndex(assetIndex: Int64(AssetModel.assetIDValue)!)
               .setSender(senderAddress1)
               .manager(manager: defaults.string(forKey: "receiveAddress") ?? "")
               .suggestedParams(params: paramResponse.data!)
                     .build();
      
           
           let signedTransaction=account1.signTransaction(tx: tx)
         
         
           let encodedTrans:[Int8]=CustomEncoder.encodeToMsgPack(signedTransaction)
           _=Data(CustomEncoder.convertToUInt8Array(input: encodedTrans))
           algodClient.rawTransaction().rawtxn(rawtaxn: encodedTrans).execute(){
              response in
               if(response.isSuccessful){
//                    functionToCall(response.data!.txId)
                   print("manager sim")
               }else{
//                    functionToCall(response.errorDescription)
                   print("manager nao")
               }
   
           }
           
       
       }
       } catch {
           //handle error
           print(error)
       }
       print("algo buy!")
   }
    
    
    //    ----optInToAsa----
    func optInToAsa(){
        
        
        let algodClient=AlgodClient(host: ALGOD_API_ADDR, port: ALGOD_API_PORT, token: ALGOD_API_TOKEN)
        algodClient.set(key: "X-API-KeY")
        
        do {
            
            
            let account3 = try Account( defaults.string(forKey: "mnemonic3") ?? "")
      
            let senderAddress3 = account3.getAddress()
            
            algodClient.transactionParams().execute(){paramResponse in
                if(!(paramResponse.isSuccessful)){
                    print(paramResponse.errorDescription!);
                    print("Success")
                    return;
                }
                
                
                let tx = Transaction.assetAcceptTransactionBuilder()
                    
                    .setSender(senderAddress3)
                    
                    //                    .acceptingAccount(acceptingAccount:senderAddress3)
                    .assetIndex(assetIndex: Int64(AssetModel.assetIDValue))
                    .suggestedParams(params: paramResponse.data!)
                    .build();
                
                
                
                
                //                    var txMessagePack:[Int8]=CustomEncoder.encodeToMsgPack(tx)
                let signedTrans=account3.signTransaction(tx: tx)
                let encodedTx:[Int8]=CustomEncoder.encodeToMsgPack(signedTrans)
                algodClient.rawTransaction().rawtxn(rawtaxn: encodedTx).execute(){
                    response in
                    if(response.isSuccessful){
                        
                        print("optInToAsa yes")
                        //                            functionToCall(response.data!.txId)
                    }else{
                        
                        print("optInToAsa off")
                        //                            functionToCall(response.errorDescription!)
                    }
                    
                    
                }
                //
                
                
            }//paramresponse
            
        } catch {
            //handle error
            print(error)
        }
        print("algo buy!")
        
        
    }
    
    //    ----
    
    //    ----
    func transferAsa(){
        
        
        let algodClient=AlgodClient(host: ALGOD_API_ADDR, port: ALGOD_API_PORT, token: ALGOD_API_TOKEN)
        algodClient.set(key: "X-API-KeY")
        
        
        do {
            
            let account1 = try Account( defaults.string(forKey: "mnemonic1") ?? "")
            
            let senderAddress1 = account1.getAddress()
          
            let account3 = try Account( defaults.string(forKey: "mnemonic3") ?? "")
           
            let senderAddress3 = account3.getAddress()
            
            
            
            
            algodClient.transactionParams().execute(){paramResponse in
                if(!(paramResponse.isSuccessful)){
                    print(paramResponse.errorDescription!);
                    print("passou")
                    return;
                }
                
                let tx =  Transaction.assetTransferTransactionBuilder()
                    
                    .setSender(senderAddress1)
                    .assetReceiver(assetReceiver:senderAddress3)
                    .assetAmount(assetAmount: 1)
                    .assetIndex(assetIndex: Int64(AssetModel.assetIDValue)!)
                    
                    .suggestedParams(params:paramResponse.data!).build();
                
                print(AssetModel.assetIDValue)
                //
                let signedTrans=account1.signTransaction(tx: tx)
                
                let encodedTx:[Int8]=CustomEncoder.encodeToMsgPack(signedTrans)
                algodClient.rawTransaction().rawtxn(rawtaxn: encodedTx).execute(){
                    response in
                    if(response.isSuccessful){
                        print("Transaction ok!")
                        istransaction = true
                        
                        if istransaction == true {
                            DispatchQueue.main.async {
                                
                                let result = "Transaction Ok!"
                                assetSate.add(horseValue:String(result))
                                
                                
                                self.assetRewardState = true
                                
                            }
                        }
                        
                        //                            functionToCall(response.data!.txId)
                    }else  {
                        //                            functionToCall(response.errorDescription!)
                        print("Transaction no!")
                        //
                        //
                        istransaction = false
                        
                        if istransaction == false {
                            DispatchQueue.main.async {
                                
                                let result = "Transaction Fail!"
                                assetSate.add(horseValue:String(result))
                                
                                
                                self.assetRewardState = true
                                
                            }
                        }
                        
                        
                        
                    }
                    
                }
                
                
                
            }//paramresponse
            
        } catch {
            //handle error
            print(error)
        }
        print("algo buy!")
        
    }
    
   
   
    //    ----transaction --------
    
    func  requestBonus(){
        
        let algodClient=AlgodClient(host: ALGOD_API_ADDR, port: ALGOD_API_PORT, token: ALGOD_API_TOKEN)
        algodClient.set(key: "X-API-KeY")
        
        do {
        
            let account = try Account( defaults.string(forKey: "mnemonic1") ?? "")
            
            let senderAddress = account.getAddress()
            let receiverAddress = try! Address(defaults.string(forKey: "receiveAddress") ?? "")
            
            
            algodClient.transactionParams().execute(){ paramResponse in
                if(!(paramResponse.isSuccessful)){
                    print(paramResponse.errorDescription!);
                    print("passou")
                    return;
                }
                
                
                let tx =  try? Transaction.paymentTransactionBuilder().setSender(senderAddress)
                    .amount(1000000)
                    .receiver(receiverAddress)
                    .note("Swift Algo sdk is cool".bytes)
                    .suggestedParams(params: paramResponse.data!)
                    .build()
                
                
                let signedTransaction=account.signTransaction(tx: tx!)
                
                let encodedTrans:[Int8]=CustomEncoder.encodeToMsgPack(signedTransaction)
                
                algodClient.rawTransaction().rawtxn(rawtaxn: encodedTrans).execute(){
                    response in
                    if(response.isSuccessful){
                        print(response.data!.txId)
                        print("OK!")
                        
                        
                        
                        transactionIsShowing = true
                        
                        if transactionIsShowing == true {
                            DispatchQueue.main.async {
                                
                                let result = "Transaction Ok!"
                                assetSate.add(horseValue:String(result))
                                
                                gameScene.addTimeBonus()
                                self.assetRewardState = true
                                
                            }
                        }
                        
                        //
                    }else{
                        print(response.errorDescription!)
                        print("Failed")
                        
                        transactionIsShowing = false
                        
                        if transactionIsShowing == false {
                            DispatchQueue.main.async {
                                
                                let result = "Transaction fail!"
                                assetSate.add(horseValue:String(result))
                                
                                
                                self.assetRewardState = true
                                
                            }
                        }
                        
                        
                        
                        
                    }
                    
                }
            }
            
        } catch {
            //handle error
            print(error)
        }
        print("algo buy!")
    }
    
    
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(AssetModel: bubbleGame(), gameScene: GameScene(horseAsset: .constant(true)))
    }
}
