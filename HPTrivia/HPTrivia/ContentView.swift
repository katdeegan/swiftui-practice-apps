//
//  ContentView.swift
//  HPTrivia
//
//  Created by Katherine Deegan on 3/13/24.
//

import SwiftUI
import AVKit // framework for adding audio

struct ContentView: View {
    @EnvironmentObject private var store: Store
    @EnvironmentObject private var game: Game
    
    @State private var audioPlayer: AVAudioPlayer! // audio player property
    
    @State private var scalePlayButton = false // property that will change value to animate Play button
    @State private var moveBackgroundImage = false
    @State private var animateViewsIn = false // property for transition animation
    @State private var showInstructions = false // toggle + sheet modifier to show InstructionView
    @State private var showSettings = false
    @State private var playGame = false
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Image("hogwarts")
                    .resizable()
                    .frame(width: geo.size.width*3, height: geo.size.height)
                    .padding(.top, 3)
                    .offset(x: moveBackgroundImage ? geo.size.width/1.1 : -geo.size.width/1.1) // animate background image to more back and forth horizontally
                    .onAppear {
                        withAnimation(.linear(duration: 60).repeatForever()) {
                            moveBackgroundImage.toggle()
                        }
                    }
                
                VStack {
                    // need an additional VStack to add animation modifier (cannot add animation modifier to if statement)
                    VStack {
                        // transition view in/out of screen
                        // if animateViewsIn == true, display VStack
                        if animateViewsIn {
                            VStack {
                                // SF images can have text (i.e. font) OR image modifiers (i.e. imageScale)
                                Image(systemName: "bolt.fill")
                                    .font(.largeTitle)
                                    .imageScale(.large)
                                
                                Text("HP")
                                    .font(.custom(Constants.hpFont, size: 70))
                                    .padding(.bottom, -50)
                                
                                Text("Trivia")
                                    .font(
                                        .custom(Constants.hpFont, size: 60))
                            }
                            .padding(.top, 70)
                            .transition(.move(edge: .top))
                        }
                    }
                    .animation(.easeOut(duration: 0.7).delay(2), value: animateViewsIn)
                    Spacer()
                    VStack {
                        if animateViewsIn {
                            VStack {
                                Text("Recent Scores")
                                    .font(.title2)
                                
                                
                                Text("\(game.recentScores[0])")
                                Text("\(game.recentScores[1])")
                                Text("\(game.recentScores[2])")
                            }
                            .font(.title3)
                            .padding(.horizontal)
                            .foregroundColor(.white)
                            .background(.black.opacity(0.7))
                            .cornerRadius(15)
                            .transition(.opacity)
                        }}
                    .animation(.linear(duration: 1).delay(4), value: animateViewsIn)
                    
                    Spacer()
                    
                    HStack {
                        Spacer()
                        
                        VStack {
                            if animateViewsIn {
                                Button {
                                    // show instructions screen
                                    showInstructions.toggle()
                                } label : {
                                    Image(systemName: "info.circle.fill")
                                        .font(.largeTitle)
                                        .foregroundColor(.white)
                                        .shadow(radius: 5)
                                }
                                .transition(.offset(x: -geo.size.width/4))
                            }}
                        .animation(.easeOut(duration: 0.7).delay(2), value: animateViewsIn)
                        
                        Spacer() // uses all the available space in parent view (without the hstack frame modifier, this would be the background image, which is larger than the device screen)
                        
                        // adding animation to play button
                        // animations are triggered by a value changing (i.e. Boolean from true/false)
                        VStack {
                            if animateViewsIn {
                                Button {
                                    // start new game
                                    filterQuestions()
                                    game.startGame()
                                    playGame.toggle()
                                } label: {
                                    Text("Play")
                                        .font(.largeTitle)
                                        .foregroundColor(.white)
                                        .padding(.vertical, 7)
                                        .padding(.horizontal, 50)
                                        .background(store.books.contains(.active) ? .brown : .gray)
                                        .cornerRadius(7)
                                        .shadow(radius: 5)
                                }
                                .scaleEffect(scalePlayButton ? 1.2 : 1) // if scalePlayButton is true, button should scale 1.2x
                                .onAppear {
                                    // as soon as button appears, execute thie code
                                    // specify you want this animation to happen continuously with repeatForever (can also specify number of times you want it to repeat)
                                    withAnimation(.easeInOut(duration: 1.3).repeatForever()) {
                                        scalePlayButton.toggle()
                                    }
                                }
                                .transition(.offset(y: geo.size.height/3))
                                .fullScreenCover(isPresented: $playGame, content: {
                                    GamePlayView()
                                        .environmentObject(game)
                                        .onAppear {
                                            // background audio fades out
                                            audioPlayer.setVolume(0, fadeDuration: 2)
                                        }
                                        .onDisappear {
                                            audioPlayer.setVolume(1, fadeDuration: 3)
                                        }
                                }) // alt to sheet view (sheet view is more temporary)
                                .disabled(store.books.contains(.active) ? false : true) // disables play button if no books are selected
                            }}
                        .animation(.easeOut(duration: 0.7).delay(2), value: animateViewsIn)
                        
                        Spacer()
                        VStack {
                            if animateViewsIn {
                                Button {
                                    // show settings screen
                                    showSettings.toggle()
                                } label: {
                                    Image(systemName: "gearshape.fill")
                                        .font(.largeTitle)
                                        .foregroundColor(.white)
                                        .shadow(radius: 5)
                                    
                                }
                                .transition(.offset(x: geo.size.width/4))
                            }}
                        .animation(.easeOut(duration: 0.7).delay(2), value: animateViewsIn)
                        
                        Spacer()
                    }
                    .frame(width: geo.size.width) // Spacer() can only push view to width of device screen
                    
                    VStack {
                        if animateViewsIn {
                            if store.books.contains(.active) == false {
                                Text("No questions available. Go to settings.⬆️")
                                    .multilineTextAlignment(.center)
                                    .transition(.opacity)
                            }
                        }
                    }
                    .animation(.easeInOut.delay(3), value: animateViewsIn)
                    
                    Spacer()
                }
                
            }
            .frame(width: geo.size.width, height: geo.size.height) // zstack takes up width/height of device screen
            
        }
        .ignoresSafeArea()
        .onAppear {
            // play audio as soon as screen appears
            playAudio()
            
            // transition title view in
            animateViewsIn = true
        }
        .sheet(isPresented: $showInstructions) { InstructionsView() }
        .sheet(isPresented: $showSettings) { SettingsView().environmentObject(store) }
    }
    
    private func playAudio() {
        let sound = Bundle.main.path(forResource: "magic-in-the-air", ofType: "mp3")
        
        audioPlayer = try! AVAudioPlayer(contentsOf: URL(filePath: sound!))
        
        audioPlayer.numberOfLoops = -1 // audio keeps repeating forever
        
        audioPlayer.play()
    }
    
    private func filterQuestions() {
        var books: [Int] = []
        
        for (index, status) in store.books.enumerated() {
            
            if status == .active {
                books.append(index + 1)
            }
            
            game.filterQuestions(to: books)
            game.newQuestion()
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(Store())
        .environmentObject(Game())
}
