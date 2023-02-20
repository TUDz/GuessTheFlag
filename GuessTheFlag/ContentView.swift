//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Isay Lucas on 06/02/23.
//

import SwiftUI

struct Title: ViewModifier {
    func body(content: Content) -> some View {
        
        content
            .font(.largeTitle.bold())
            .foregroundColor(.white)
    }
}

extension Text {
    func titleStyle() -> some View {
        modifier(Title())
    }
}

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()

    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var endGameTitle = ""
    
    @State private var userScore: Int = 0
    @State private var totalQuestions = 0
    @State private var endingGame = false
    
    func flagImage(_ flagId: Int) -> some View {
        Image(countries[flagId])
            .renderingMode(.original)
            .clipShape(Capsule())
            .shadow(radius: 15)
    }

    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3),
            ], center: .top, startRadius: 200, endRadius: 400)
                .ignoresSafeArea()

            VStack {
                Spacer()
                
                Text("Guess the flag")
                    .titleStyle()
                
                VStack(spacing: 15){
                    VStack {
                        Text("Tap the flag of:")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }

                    ForEach(0..<3) { number in
                            Button {
                                flagTapped(number)
                            } label: {
                                flagImage(number)
                            }
                        }
                }.frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
                    .background(.regularMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                Spacer()
                Spacer()
                Text("Your score is \(userScore)")
                    .foregroundColor(.white)
                    .font(.title.bold())
                Spacer()
            }.padding()
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            Text("Score: \(userScore)")
                .foregroundColor(.white)
                .font(.title.bold())
        }.alert(endGameTitle, isPresented: $endingGame){
            Button("Game has ended", action: resetGame)
        } message: {
            Text("Your final score is: \(userScore)")
                .foregroundColor(.white)
                .font(.title.bold())
        }
    }

    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct"
            userScore += 1
        } else {
            scoreTitle = "Wrong! That's the flag of \(countries[number])"
        }
        totalQuestions += 1
        if totalQuestions == 3 {
            endingGame = true
        }else {
            showingScore = true
        }
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
    
    func resetGame() {
        endingGame = false
        userScore = 0
        askQuestion()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
