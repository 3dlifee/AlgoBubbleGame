//
//  accounts.swift
//  AlgoBubbleGame
//
//  Created by Mario Fernandes on 08/05/2021.
//

import SwiftUI

struct accounts: View {
    let defaults:UserDefaults = UserDefaults.standard
  
    @ObservedObject var addMnemonic1 = defaultsModel()
    @ObservedObject var addMnemonic3 = defaultsModel()
    @ObservedObject var addAddress = defaultsModel()

    @State var titleMnemonic1:String = "Mnemonic1"
    @State var titleMnemonic3:String = "Mnemonic3"
    @State var titleAddAddress:String = "Receiver Address"
    
    @State var titleInputTitleMnemonic1:String = ""
    @State var titleInputTitleMnemonic3:String = ""
    @State var titleInputTitleReceiverAddress:String = ""
    
    @State var done:String = ""
    @Binding var accountIsShowing: Bool
    
    struct LabelRecta: ViewModifier {

        func body(content: Content) -> some View {
            return  content
                .frame(height:UIScreen.main.bounds.height/8)
                .frame(width:UIScreen.main.bounds.width/1.1)
                .foregroundColor((Color("rectTab")))
                .cornerRadius(15)
        }
        
    }
    
    struct LabelTitleText: ViewModifier {
        
        func body(content: Content) -> some View {
            return  content
                .foregroundColor(Color("T4"))
                .font(.custom("AvenirNext-Bold", size: 20))
                .multilineTextAlignment(.leading)
                .padding(.leading, 15.0)
        }
        
    }
    
    struct LabelDivider: ViewModifier {
        
        func body(content: Content) -> some View {
            return  content
                .background(Color("T2"))
                .font(.custom("AvenirNext-Regular", size: 14))
                .frame(height: 5.0)
                .padding(.horizontal, 15.0)
        }
        
    }
    
    struct LabelAddText: ViewModifier {
        
        func body(content: Content) -> some View {
            return  content
                .foregroundColor(Color("T2"))
                .font(.custom("AvenirNext-Bold", size: 20))
                .opacity(50.0)
                .multilineTextAlignment(.leading)
                .padding(.leading, 15.0)
        }
        
    }
    
    struct LabelDone: ViewModifier {
        
        func body(content: Content) -> some View {
            return  content
                .foregroundColor(Color("T6"))
                .font(.custom("AvenirNext-Bold", size: 20))
                .multilineTextAlignment(.leading)
                .padding(.leading, 15.0)
        }
        
    }
    var body: some View {
     
        VStack(){
            // ---- Logo ----//
            Image("accountLogo")
                .frame(height: 150.0)
            // ---- mnemonic1 ----//
        ZStack(alignment: .leading) {
                
            Rectangle().modifier(LabelRecta())
                
        VStack(alignment: .leading , spacing: 4) {
                    
            Text(titleMnemonic1).modifier(LabelTitleText())
                    
        HStack(alignment: .center){
                        
            TextField("Add", text: $titleInputTitleMnemonic1).modifier(LabelAddText())
                            .keyboardType(.default)
            Text(done).modifier(LabelDone())
                        
                    }
                    .padding(.trailing)
                    
            Divider().modifier(LabelDivider())
                }
            }
            
        .frame(height:UIScreen.main.bounds.height/8)
        .frame(width:UIScreen.main.bounds.width/1.1)

            
            // ---- mnemonic3 ----//
        ZStack(alignment: .leading) {
             
            Rectangle().modifier(LabelRecta())
                
        VStack(alignment: .leading , spacing: 4) {
                    
            Text(titleMnemonic3).modifier(LabelTitleText())
            
        HStack(alignment: .center){
            
            TextField("Add", text: $titleInputTitleMnemonic3).modifier(LabelAddText())
                            .keyboardType(.default)
            Text(done).modifier(LabelDone())
                        
                    }
                    .padding(.trailing)
                    
            Divider().modifier(LabelDivider())
                   
                }
        }
            
        .frame(height:UIScreen.main.bounds.height/8)
        .frame(width:UIScreen.main.bounds.width/1.1)
            
            // ---- Receiver ----//
        ZStack(alignment: .leading) {
               
            Rectangle().modifier(LabelRecta())
                
        VStack(alignment: .leading , spacing: 4) {
                    
            Text(titleAddAddress).modifier(LabelTitleText())
        HStack(alignment: .center){
            TextField("Add", text: $titleInputTitleReceiverAddress).modifier(LabelAddText())
                            .keyboardType(.default)
            Text(done).modifier(LabelDone())
                        
                    }
                    .padding(.trailing)
                    
            Divider().modifier(LabelDivider())
                  
                }
        }
            
        .frame(height:UIScreen.main.bounds.height/8)
        .frame(width:UIScreen.main.bounds.width/1.1)

            // ---- Save Button ----//
        VStack(alignment: .center , spacing: 4) {

            Text("Press and Save  the values").modifier(LabelTitleText())
            Button(action: {
                self.saveKeys()
            }) {
                Image(systemName:"square.and.arrow.down.fill")
                    .font(.system(size: 60.0))
                    .foregroundColor((Color("seta")))
            }
            
            Button("Dismiss",
                   action: {  self.accountIsShowing.toggle() })
                .padding(.top, 20.0)
                .font(.system(size: 28.0))
         }
        
            Spacer()
    }
    }
   
    
    func saveKeys(){
        
        self.defaults.set(self.titleInputTitleMnemonic1, forKey: "mnemonic1")
        addMnemonic1.mnemonic1 = self.titleInputTitleMnemonic1
        
        
        self.defaults.set(self.titleInputTitleMnemonic3, forKey: "mnemonic3")
        addMnemonic3.mnemonic3 = self.titleInputTitleMnemonic3
        
        self.defaults.set(self.titleInputTitleReceiverAddress, forKey: "receiveAddress")
        addAddress.receiveAddress = self.titleInputTitleReceiverAddress
        
        done = "ADDED"
        
    }
        
        
        
}

struct accounts_Previews: PreviewProvider {
    static private var accountIsShowing = Binding.constant(false)
    static var previews: some View {
        accounts(accountIsShowing: accountIsShowing)
    }
}
