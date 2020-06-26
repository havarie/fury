//
//  LoginView.swift
//  Diary
//
//  Created by Joseph Hinkle on 6/4/20.
//  Copyright © 2020 Joseph Hinkle. All rights reserved.
//

import UIKit
import SwiftUI
import CryptoKit
import Resolver
import FirebaseAuth
import FirebaseFirestore

let usersRef = db.collection("users")

struct LoginView: View {
    @Environment (\.colorScheme) private var colorScheme: ColorScheme
    @InjectedObject private var userService: UserService
    
    @State private var showHome = Auth.auth().currentUser != nil
    @State private var showCreditsModal = false
    @State private var isLoading = false
    
    init() {
        // if already logged in, skip the animation
        associateFirebaseUserWithNotificationToken()
        UINavigationBar.setAnimationsEnabled(Auth.auth().currentUser == nil)
    }
    
    func associateFirebaseUserWithNotificationToken() {
        if let user = Auth.auth().currentUser {
            let myUserDoc = usersRef.document(user.uid)
            db.runTransaction({ (transaction, errorPointer) -> Any? in
                let userDocSnapshot: DocumentSnapshot
                do {
                    try userDocSnapshot = transaction.getDocument(myUserDoc)
                } catch let fetchError as NSError {
                    errorPointer?.pointee = fetchError
                    return nil
                }

                let oldData = userDocSnapshot.data()
                var newData = (oldData ?? [:])
                var notList = (newData["notificationTokens"] as? [String] ?? []) + [deviceTokenString]
                notList = Array(Set(notList))
                newData["notificationTokens"] = notList
                transaction.setData(newData, forDocument: myUserDoc)
                return nil
            }) { (object, error) in
                if let error = error {
                    print("Transaction failed: \(error)")
                } else {
                    print("Transaction successfully committed!")
                }
            }
//            usersRef.document(user.uid).setData([
//                "test2": "cool",
//                "notificationTokens": [deviceTokenString]
//            ]) { err in
//                if let err = err {
//                    print("Error writing document: \(err)")
//                } else {
//                    print("Document successfully written!")
//                }
//            }
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                NavigationLink(destination: HomeView(showHome: self.$showHome), isActive: self.$showHome) {
                    EmptyView()
                }
                Color.backgroundColor(colorScheme)
                .edgesIgnoringSafeArea(.all)
                ActivityIndicatorView(isAnimating: self.$isLoading, style: .large)
                VStack {
                    Image("Icon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 120, alignment: .center)
                    Text("Timebox Diary")
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                        .padding([.bottom], 5)
                    ManySubtitlesView(subtitles: [
                        SubtitleView(text: "📦 timebox precious moments"),
                        SubtitleView(text: "🔔 send notifications to yourself"),
                        SubtitleView(text: "🚀 make memories for the future"),
                        SubtitleView(text: "⚡️ create memories quickly"),
//                        SubtitleView(text: "🐦 follow us on twitter for more updates", link: "https://twitter.com/joehink95")
                    ])
                    Spacer()
                    Spacer()
                    SignInWithAppleToFirebase() { response in
                        self.isLoading = response == .loading
                        if response == .success {
                            self.associateFirebaseUserWithNotificationToken()
                            self.userService.refresh()
                            self.showHome = true
                        }
                    }
                    .frame(minWidth: 200, idealWidth: 250, maxWidth: 400, minHeight: 50, idealHeight: 50, maxHeight: 50, alignment: .center).padding(25)
                    Button(action: {
                        self.showCreditsModal.toggle()
                    }) {
                        Image(systemName: "text.justifyleft")
                        Text("Credits")
                    }
                        .foregroundColor(Color.blackOrWhite(self.colorScheme))
                        .scaledToFill()
                        .padding([.leading,.trailing], 25)
                    Spacer()
                }
            }
            .sheet(isPresented: $showCreditsModal) {
                // Credits
                VStack {
                    Text("App by Leander Wiegemann")
                    Text("Developed by Joe Hinkle")
                    HStack {
                        Text("App icon made by ")
                            .font(.headline)
                            .fontWeight(.regular)
                        Button(action: {
                            guard let url = URL(string: "https://www.flaticon.com/authors/freepik") else { return }
                            UIApplication.shared.open(url)
                        }) {
                            Text("www.flaticon.com")
                                .font(.headline)
                                .fontWeight(.regular)
                        }
                    }
                }
            }
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

func calcPos(i: Int, current: Int) -> CGFloat {
    let a = CGFloat(current*50)
    let b = CGFloat(i*50)
    return b - a
}

struct ManySubtitlesView : View {
    @State var currentSubTitle: Int = 0
    var subtitles: [SubtitleView] = []
    let timer = Timer.publish(every: 3.5, on: .current, in: .common).autoconnect()
    
    var body: some View {
        ZStack (alignment: .top) {
            ForEach (0..<subtitles.count) { i in
                self.subtitles[i]
                    .offset(CGSize(width: calcPos(i: i, current: self.currentSubTitle), height: 0))
                    .opacity(Double(1 - abs(self.currentSubTitle - i)))
                    .animation(.spring())
            }
        }.onReceive(timer) { _ in
            self.currentSubTitle = (self.currentSubTitle + 1) % self.subtitles.count
        }
    }
}

struct SubtitleView : View {
    var text: String = "Example"
    var link: String? = nil
    
    var body: some View {
        HStack {
            if link == nil {
                Text(text)
                    .font(.headline)
                    .fontWeight(.regular)
            } else {
                Button(action: {
                    guard let url = URL(string: self.link!) else { return }
                    UIApplication.shared.open(url)
                }) {
                    Text(text)
                        .font(.headline)
                        .fontWeight(.regular)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
