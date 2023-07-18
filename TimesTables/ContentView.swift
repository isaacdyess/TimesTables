//
//  ContentView.swift
//  TimesTables
//
//  Created by Isaac Dyess on 7/10/23.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedNumber = 0
    @State private var numQuestions = 0
    @State private var questions = [[String: String]]()
    
    @State private var currentQuestion = 0
    @State private var userScore = 0
    @State private var userAnswer = ""
    @State private var userOutput = ""
    
    @State private var isOutput = false
    @State private var testStarted = false
    @State private var gameOver = false
    
    @State private var headerPadding = 1.0
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Text("How high can you multiply?")
                        .italic()
                    
                    Spacer()
                    Picker("Practice Number", selection: $selectedNumber) {
                        ForEach(2..<13) { number in
                            Text("\(number)")
                        }
                    }
                    .disabled(testStarted)
                }
                .foregroundColor(testStarted ? .gray : .black)
                .padding(.top, headerPadding)
                
                HStack {
                    Text("How many questions?")
                        .italic()
                    
                    Spacer()
                    Picker("Number of Questions", selection: $numQuestions) {
                        ForEach(5..<25) { number in
                            Text("\(number)")
                        }
                    }
                    .disabled(testStarted)
                }
                .foregroundColor(testStarted ? .gray : .black)
                .padding(.top, headerPadding)
                
                VStack {
                    if (!testStarted || gameOver) {
                        Text("Test Not in Progress")
                    } else {
                        Spacer()
                        Text(questions[currentQuestion]["question"] ?? "Error Rendering Question")
                            .font(.largeTitle)
                            .foregroundColor(.blue)
                            .bold()
                        
                        TextField("Enter your answer", text: $userAnswer)
                            .multilineTextAlignment(.center)
                            .font(.title)
                        
                        Button("Submit") {
                            checkAnswer(answer: userAnswer)
                            isOutput.toggle()
                        }
                        .alert(userOutput, isPresented: $isOutput) {
                            Button("Continue", action: nextQuestion)
                            Button("Give up", action: newGame)
                        }
                        .scaleEffect(0.8)
                        .italic()
                        
                        Spacer()
                        Spacer()
                        Spacer()
                    }
                }
                .opacity(gameOver ? 0 : 1)
                .opacity(testStarted ? 1 : 0)
                
                VStack {
                    Spacer()
                    
                    Text("GAME OVER")
                        .font(.largeTitle)
                        .foregroundColor(.blue)
                        .bold()
                    Text("Final Score: \(userScore) / \(numQuestions + 5)")
                        .font(.title)
                    
                    Spacer()
                    Spacer()
                    Spacer()
                    
                    Button("New Game") {
                        newGame()
                    }
                    .italic()
                }
                .opacity(gameOver ? 1 : 0)
                
                Spacer()
                Button("Start Game") {
                    gameStart()
                }
                .disabled(testStarted)
                .opacity(testStarted ? 0 : 1)
                
                VStack {
                    Text("Question \(currentQuestion + 1) out of \(numQuestions + 5)")
                    Text("Score: \(userScore)")
                }
                .opacity(gameOver ? 0 : 1)
                .opacity(testStarted ? 1 : 0)
                
            }
            .navigationTitle("TIMES TABLES")
            .padding()
        }
    }
    
    func gameStart() {
        var first: Int
        var second: Int
        
        for _ in 1...(numQuestions + 5) {
            first = Int.random(in: 2...(selectedNumber + 2))
            second = Int.random(in: 2...(selectedNumber + 2))
            questions.append([ "question": "What is \(first) * \(second)?", "answer":  "\(first*second)" ])
        }
        
        testStarted = true
        headerPadding = -20
    }
    
    func checkAnswer(answer: String) {
        if answer == questions[currentQuestion]["answer"] {
            userScore += 1
            userOutput = "CORRECT!!!"
        } else {
            userOutput = "WRONG!!!"
        }
    }
    
    func nextQuestion() {
        if (currentQuestion + 1) == (numQuestions + 5) {
            gameOver = true
        } else {
            currentQuestion += 1
            userAnswer = ""
        }
    }
    
    func newGame() {
        gameOver = false
        currentQuestion = 0
        userScore = 0
        userAnswer = ""
        userOutput = ""
        selectedNumber = 0
        numQuestions = 0
        questions.removeAll()
        headerPadding = 1.0
        testStarted = false
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
