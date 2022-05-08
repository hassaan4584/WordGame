//
//  WordAttemptsVC.swift
//  WordGame
//
//  Created by Hassaan Fayyaz Ahmed on 07/05/2022.
//

import UIKit

class WordAttemptsVC: UIViewController {

    @IBOutlet weak var correctAttemptsCountLabel: UILabel!
    @IBOutlet weak var wrongAttemptsCountLabel: UILabel!
    @IBOutlet weak var spanishWordLabel: UILabel!

    @IBOutlet weak var englishWordLabel: UILabel!
    @IBOutlet weak var correctButton: UIButton!
    @IBOutlet weak var wrongButton: UIButton!

    /// viewModel object associated with this WordAttemptsVC class
    var wordAttemptsVM: WordAttemptsVM!
    /// The timer object to keep track of the time duration for each attempt
    var attemptsTimer: Timer?
    /// Time duration in seconds allowed to make an attempt
    private var timerDuration: Double { 5.0 }
    // MARK: Initializations

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupViewModel()
        self.setupViews()
        self.showNextWord()
        self.restartTimer()
    }

    /// Setting up different views
    private func setupViews() {
        self.correctButton.setTitleColor(UIColor.label.withAlphaComponent(0.5), for: .highlighted)
        self.wrongButton.setTitleColor(UIColor.label.withAlphaComponent(0.5), for: .highlighted)
        self.wrongButton.layer.cornerRadius = 2.0
        self.wrongButton.layer.borderWidth = 3.0
        self.correctButton.layer.cornerRadius = 2.0
        self.correctButton.layer.borderWidth = 3.0
    }

    /// Initialize view model object
    func setupViewModel() {
        let spanishWordsList: [Word] = Constants.getSpanishWords() ?? []
        self.wordAttemptsVM = WordAttemptsVM(spanishWordsList: spanishWordsList, correctAnswerProbability: 0.25)
        // Setting up closures
        self.wordAttemptsVM.endGame = self.endGame(quitReason:)
        self.wordAttemptsVM.onAttemptMade = self.updateAttemps(correctCount:wrongCount:)
    }

    // MARK: UI Updates

    /// Update labels for correct and wrong attempt counts
    func updateAttemps(correctCount: Int, wrongCount: Int) {
        self.correctAttemptsCountLabel.text = "\(correctCount)"
        self.wrongAttemptsCountLabel.text = "\(wrongCount)"
    }

    /// Fetches the next word and displays it on the screen
    func showNextWord() {
        guard let word = self.wordAttemptsVM.getNextRandomWord() else { return }

        self.spanishWordLabel.text = word.translatedWord
        self.englishWordLabel.text = word.englishWord
    }

    // MARK: Timer
    @objc func timerDidEnd() {
        self.wordAttemptsVM.processTimerExpiryAttempt()
        self.showNextWord()
    }

    /// When the timer had to end prematurely and we need to restart the timer
    func restartTimer() {
        self.attemptsTimer?.invalidate()
        self.attemptsTimer = Timer.scheduledTimer(timeInterval: self.timerDuration, target: self, selector: #selector(timerDidEnd), userInfo: nil, repeats: true)
    }

    // MARK: UserInteractions

    @IBAction func correctButtonPressed(_ sender: UIButton) {
        guard let currentWord = self.wordAttemptsVM.currentWord else {
            self.showNextWord()
            return
        }
        self.wordAttemptsVM.processUserAttempt(userAttempt: .correct, givenWord: currentWord)
        self.wordAttemptsVM.verifyGameEndingConditions()
        self.showNextWord()
        self.restartTimer()
    }

    @IBAction func wrongButtonPressed(_ sender: UIButton) {
        guard let currentWord = self.wordAttemptsVM.currentWord else {
            self.showNextWord()
            return
        }
        self.wordAttemptsVM.processUserAttempt(userAttempt: .wrong, givenWord: currentWord)
        self.wordAttemptsVM.verifyGameEndingConditions()
        self.showNextWord()
        self.restartTimer()
    }

    // MARK: Game Logic
    /// This is used to quit the app once the game has ended.
    func endGame(quitReason: WordAttemptsVM.EndGameReason) {
        let exitCode: Int32 = Int32(quitReason.rawValue)
        exit(exitCode)
    }
}
