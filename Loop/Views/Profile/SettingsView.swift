//
//  SettingsView.swift
//  Loop
//
//  Created by Ryan O’Meara on 9/19/24.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        ZStack {
            VStack{
                ZStack {
                    HStack {
                        Button(action: {
                            self.presentationMode.wrappedValue.dismiss()
                        }) {
                            Image(systemName: "arrow.left.circle.fill")
                                .font(.system(size: 30))
                                .foregroundColor(.red)
                        }
                        Spacer()
                    }
                }.padding()
                
                VStack {
                    NavigationLink(destination: ChangePasswordView()) {
                        HStack{
                            Image(systemName: "lock.circle.fill").font(.system(size:40)).foregroundColor(.gray)
                            VStack(alignment: .leading) {
                                Text("Change Password").font(.headline).foregroundColor(.black)
                            }
                            Spacer()
                        }.padding().background(Color.white).cornerRadius(10).shadow(radius: 2).padding(.horizontal)
                    }
                }
                
                VStack {
                    NavigationLink(destination: ChangeEmailView()){
                        HStack{
                            Image(systemName: "envelope.circle.fill").font(.system(size:40)).foregroundColor(.gray)
                            VStack(alignment: .leading) {
                                Text("Change Email").font(.headline).foregroundColor(.black)
                            }
                            Spacer()
                        }.padding().background(Color.white).cornerRadius(10).shadow(radius: 2).padding(.horizontal)
                    }
                }
                
                VStack {
                    Button(action: {
                        //enable notifications implementation
                    }) {
                        HStack{
                            Image(systemName: "bell.circle.fill").font(.system(size:40)).foregroundColor(.gray)
                            VStack(alignment: .leading) {
                                Text("Enable Notifications").font(.headline).foregroundColor(.black)
                            }
                            Spacer()
                        }.padding().background(Color.white).cornerRadius(10).shadow(radius: 2).padding(.horizontal);
                    }
                }
                
                VStack {
                    Button(action: {
                        //enable notifications implementation
                    }) {
                        HStack{
                            Image(systemName: "applewatch.and.arrow.forward").font(.system(size:40)).foregroundColor(.gray)
                                .padding(.trailing, 3)
                                .padding(.leading, 3)
                            VStack(alignment: .leading) {
                                Text("Link to Watch").font(.headline).foregroundColor(.black)
                            }
                            Spacer()
                        }.padding().background(Color.white).cornerRadius(10).shadow(radius: 2).padding(.horizontal);
                    }
                }
                
                Spacer()
                
                VStack {
                    Button(action: {
                        //delete profile implementation
                    }) {
                        HStack{
                            Image(systemName: "rectangle.portrait.and.arrow.forward").font(.system(size:40)).foregroundColor(.white)
                                .padding(.trailing, 3)
                                .padding(.leading, 3)
                                .scaleEffect(x: -1, y: 1)
                            VStack(alignment: .leading) {
                                Text("Log Out").font(.headline).foregroundColor(.white)
                            }
                            Spacer()
                        }.padding().background(Color.red).cornerRadius(10).shadow(radius: 2).padding(.horizontal);
                    }
                }.padding(.vertical)
            }
        }.background(Color.gray.opacity(0.1).edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/))
            .navigationBarBackButtonHidden(true)
            .navigationBarTitle("Settings", displayMode: .inline)
    }
}

#Preview {
    SettingsView()
}
