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
    var timerDuration: Double { 5.0 }

    // MARK: Initializations

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupViewModel()
        self.setupViews()
        self.showNextWordWithAnimation()
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

        self.spanishWordLabel.frame = .init(x: 0, y: 0, width: self.view.frame.width, height: 100)
        self.spanishWordLabel.center = .init(x: self.view.center.x, y: 50)
        spanishWordLabel.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.5)
    }

    /// Initialize view model object
    func setupViewModel() {
        let spanishWordsList: [SpanishWord] = Constants.getWordList(fileName: Constants.spanishWordsFileName) ?? []
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
    func showNextWordWithAnimation() {
        guard let word = self.wordAttemptsVM.getNextRandomWord() else { return }
        self.spanishWordLabel.layer.removeAllAnimations()
        // Starting at the top
        self.spanishWordLabel.center = .init(x: self.view.center.x, y: 50)
        // Animating to the bottom
        UIView.animate(withDuration: self.timerDuration, delay: 0, options: .curveLinear) {
            self.spanishWordLabel.center = .init(x: self.view.center.x, y: self.view.frame.height-150)
        }

        self.spanishWordLabel.text = word.translatedWord
        self.englishWordLabel.text = word.englishWord
    }

    // MARK: Timer
    @objc func timerDidEnd() {
        self.wordAttemptsVM.processTimerExpiryAttempt()
        if self.wordAttemptsVM.verifyGameEndingConditions() {
            self.attemptsTimer?.invalidate()
        } else {
            self.showNextWordWithAnimation()
        }
    }

    /// When the timer had to end prematurely and we need to restart the timer
    func restartTimer() {
        self.attemptsTimer?.invalidate()
        self.attemptsTimer = Timer.scheduledTimer(timeInterval: self.timerDuration, target: self, selector: #selector(timerDidEnd), userInfo: nil, repeats: true)
    }

    // MARK: UserInteractions

    @IBAction func correctButtonPressed(_ sender: UIButton) {
        guard let currentWord = self.wordAttemptsVM.currentWord else {
            self.showNextWordWithAnimation()
            return
        }
        self.wordAttemptsVM.processUserAttempt(userAttempt: .correct, givenWord: currentWord)
        if self.wordAttemptsVM.verifyGameEndingConditions() {
            self.attemptsTimer?.invalidate()
        } else {
            self.showNextWordWithAnimation()
            self.restartTimer()
        }
    }

    @IBAction func wrongButtonPressed(_ sender: UIButton) {
        guard let currentWord = self.wordAttemptsVM.currentWord else {
            self.showNextWordWithAnimation()
            return
        }
        self.wordAttemptsVM.processUserAttempt(userAttempt: .wrong, givenWord: currentWord)
        if self.wordAttemptsVM.verifyGameEndingConditions() {
            self.attemptsTimer?.invalidate()
        } else {
            self.showNextWordWithAnimation()
            self.restartTimer()
        }
    }

    // MARK: Game Logic
    /// This is used to quit the app once the game has ended.
    func endGame(quitReason: WordAttemptsVM.EndGameReason) {
        self.showAlertForRestart()
    }

    // MARK: Navigations
    func showAlertForRestart() {
        let alert = UIAlertController(title: "Game End", message: "Do you want to restart ?", preferredStyle: .alert)
        let restartAction = UIAlertAction(title: "Restart", style: .default) { [weak self] _ in
            self?.wordAttemptsVM.updateDataForGameRestart()
            self?.showNextWordWithAnimation()
            self?.restartTimer()
        }
        let quitAction = UIAlertAction(title: "Quit", style: .destructive) { _ in
            exit(1)
        }
        alert.addAction(restartAction)
        alert.addAction(quitAction)
        self.present(alert, animated: true, completion: nil)
    }
}
