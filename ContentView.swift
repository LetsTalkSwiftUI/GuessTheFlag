import SwiftUI

struct ContentView: View {
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var scoreDescription = ""
    @State private var userScore = 0
    @State private var timesPlayed = 1
    
    @State private var flagAngle = [0.0, 0.0, 0.0]
    @State private var flagOpacity = [1.0, 1.0, 1.0]
    @State private var flagScale: [CGFloat] = [1.0, 1.0, 1.0]
    
    var body: some View {
        ZStack {
            
            LinearGradient(gradient: Gradient(colors: [.blue, .black]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 30) {
                
                VStack {
                    Text("Tap the flag of")
                        .foregroundColor(.white)
                        .padding(.top, 20)
                    Text(countries[correctAnswer])
                        .font(.largeTitle)
                        .fontWeight(.black)
                        .foregroundColor(.white)
                }
                
                ForEach(0 ..< 3) { number in
                    Button(action: {
                        self.flagTapped(number)
                    }) {
                        Image(self.countries[number])
                            .renderingMode(.original)
                            .flagAppearance()
                    }
                        .rotation3DEffect(.degrees(self.flagAngle[number]), axis: (x: 0, y: 1, z: 0))
                        .opacity(self.flagOpacity[number])
                        .scaleEffect(self.flagScale[number])
                }
                
                Spacer()
                
                VStack {
                    Text("Game \(timesPlayed) of 10")
                        .font(.title)
                        .foregroundColor(Color.white)
                        .fontWeight(.bold)
                    Text("Current Score: \(userScore)")
                        .font(.headline)
                        .foregroundColor(Color.white)
                }
                Spacer()
                
            }
            
        }
        .alert(isPresented: $showingScore) {
            Alert(title: Text(scoreTitle), message: Text(scoreDescription), dismissButton: .default(Text("Continue")) {
                self.askQuestion()
            })
        }
    }
    
    func flagTapped(_ number: Int) {
        if timesPlayed < 10 {
            if number == correctAnswer {
                userScore += 10
                scoreTitle = "Correct"
                scoreDescription = "Your score is now \(userScore)"
                correctAnimation()
            } else {
                if userScore == 0 {
                    
                } else {
                    userScore -= 5
                }
                scoreTitle = "Wrong"
                scoreDescription = "That’s the flag of \(countries[number]).\nYour score is now \(userScore)"
                wrongAnimation(number)
            }

            timesPlayed += 1
            
        } else {
            if number == correctAnswer {
                userScore += 10
                timesPlayed = 1
                
            } else {
                if userScore == 0 {
                    
                } else {
                    userScore -= 5
                }
            }
            
            scoreTitle = "Game Over"
            switch userScore {
            case 0...49:
                scoreDescription = "Your final score: \(userScore)\nBetter luck next time!"
            case 50...74:
                scoreDescription = "Your final score: \(userScore)\nNot bad!"
            case 75...99:
                scoreDescription = "Your final score: \(userScore)\nIncredible game!"
            default:
                scoreDescription = "Your final score: \(userScore)\nPerfect Game!"
            }
            
            timesPlayed = 1
            userScore = 0
        }
        
        showingScore.toggle()
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        
        flagAngle = [0.0, 0.0, 0.0]
        flagOpacity = [1.0, 1.0, 1.0]
        flagScale = [1.0, 1.0, 1.0]
    }
    
    func correctAnimation() {
        for flag in 0...2 {
            if flag == correctAnswer {
                withAnimation(.interpolatingSpring(stiffness: 5, damping: 1)) {
                    flagAngle[flag] = 360.0
                }
            } else {
                withAnimation(.easeOut) {
                    flagOpacity[flag] = 0.5
                }
            }
        }
    }
    
    func wrongAnimation(_ number: Int) {
        for flag in 0...2 {
            if flag == number {
                withAnimation(.easeOut) {
                    flagScale[flag] = 0.9
                }
            }
        }
    }
}

struct FlagAppearance: ViewModifier {
    func body(content: Content) -> some View {
        content
            .clipShape(Capsule())
            .overlay(Capsule().stroke(Color.black, lineWidth: 1))
            .shadow(color: .black, radius: 2)
    }
}

extension View {
    func flagAppearance() -> some View {
        self.modifier(FlagAppearance())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
