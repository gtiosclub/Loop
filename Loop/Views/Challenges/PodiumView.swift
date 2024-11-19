//
//  PodiumView.swift
//  Loop
//
//  Created by Jason Wrzesien on 10/29/24.
//

import SwiftUI

struct PodiumView: View {
    var personList: [Person]
    
    var body: some View {
        VStack {
            HStack {
                if (personList.count > 2) {
                    PersonView(person: personList[2])
                        .offset(y:135)
                } else {
                    Spacer()
                        .frame(maxWidth: 110)
                }
                if (personList.count > 0) {
                    PersonView(person: personList[0])
                        .offset(y:70)
                } else {
                    Spacer()
                        .frame(maxWidth: 110)
                }
                if (personList.count > 1) {
                    PersonView(person: personList[1])
                        .offset(y:110)
                } else {
                    Spacer()
                        .frame(maxWidth: 110)
                }

            }
                .frame(maxWidth: 330)
            Image("podium")
                .resizable()
                .scaledToFit()
                .frame(width:330, height: 330)
        }
        }
    }

struct PersonView: View {
    var person: Person
    var body: some View {
        VStack(alignment:.center) {
            if person.profilePicURL.isEmpty || person.profilePicURL == "None" {
                Circle()
                    .foregroundColor(.gray)
                    .frame(width: 65, height: 65)
            } else {
                if let url = URL(string: person.profilePicURL) {
                    AsyncImage(url: url) { image in
                        image.resizable().scaledToFill()
                            .frame(width: 65, height: 65).clipShape(.circle)
                    } placeholder: {
                        Circle()
                            .frame(width: 65, height: 65)
                            .foregroundColor(.gray)
                            .padding()
                            .overlay {
                                ProgressView()
                            }
                    }

                }
            }

                        Text(person.name)
                            .font(.system(size: 16, weight: .light))
                            .padding(.bottom, -1)

                        ZStack {
                            RoundedRectangle(cornerRadius: 7)
                                .fill(Color(red: 232/255, green: 78/255, blue:78/255))
                                .frame(width: 70, height: 25)

                            Text(String(format: "%.1f miles", person.score))
                                .font(.system(size: 12, weight: .light))
                                .foregroundStyle(.white)
                        }
                        .padding(.bottom, -5)
                    }
                .frame(maxWidth:110)
    }
}

#Preview {
    PodiumView(personList: [Person(name:"Max", score: 14.8), Person(name:"Sam", score: 11.4), Person(name:"Jason", score: 7.1), Person(name:"Ryan", score: 4.2), Person(name: "Joe", score: 5.5)])
}
