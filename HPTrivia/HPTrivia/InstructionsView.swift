//
//  InstructionsView.swift
//  HPTrivia
//
//  Created by Katherine Deegan on 3/13/24.
//

import SwiftUI

struct InstructionsView: View {
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        ZStack {
            InfoBackgroundImage()
            
            VStack {
                Image("appiconwithradius")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150)
                    .padding(.top)
                
                ScrollView {
                    Text("How to Play")
                        .font(.largeTitle)
                        .foregroundColor(.black)
                        .padding()
                    
                    VStack(alignment: .leading, content: {
                        Text("Welcome to Harry Potter Trivia! In this game, you will be asked random questions from the HP Books and you must guess the correct answer of you will lose points! 😱")
                            .padding([.horizontal, .bottom])
                        
                        Text("Each question is worth 5 points, but if you guess a wrong answer, you lose 1 point.")
                            .padding([.horizontal, .bottom])
                        
                        Text("If you are struggling to answer a question, you have an options to reveal a hint or to reveal the book that corresponds to the question. But beware! Using either of these options minuses 1 point from your score.")
                            .padding([.horizontal, .bottom])
                        
                        Text("When you select the correct answer, you will be awarded all the points left for that question, and these will be added to your score")
                            .padding([.horizontal, .bottom])
                        
                        Text("Good luck!")
                            .font(.title)
                            .frame(maxWidth: .infinity, alignment: .center)
                    })
                    .foregroundColor(.black)
                    .font(.title3)
                    
                    Button("Done") {
                        dismiss()
                    }
                    .doneButton()
                }
            }
        }
    }
}

#Preview {
    InstructionsView()
}
