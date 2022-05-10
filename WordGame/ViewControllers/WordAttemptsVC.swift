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
    @IBOutlet weak var translatedWordLabel: UILabel!

    @IBOutlet weak var englishWordLabel: UILabel!
    @IBOutlet weak var correctButton: UIButton!
    @IBOutlet weak var wrongButton: UIButton!

    /// viewModel object associated with this WordAttemptsVC class
    var wordAttemptsVM: WordAttemptsVM
    /// The timer object to keep track of the time duration for each attempt
    var attemptsTimer: Timer?
    /// Time duration in seconds allowed to make an attempt
    let timerDuration: Double
    /// storyboard identifier
    static let identifier = "WordAttemptsVC"

    // MARK: Initializations
    /// creates an instance of WordAttemptsVC class with given data
    static func createWordAttemptsVC(wordAttemptsVM: WordAttemptsVM, timerDuration: Double) -> WordAttemptsVC {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let wordAttemptsVC = storyboard.instantiateViewController(identifier: WordAttemptsVC.identifier) { aCoder in
            WordAttemptsVC.init(wordAttemptsVM: wordAttemptsVM, timerDuration: timerDuration, coder: aCoder)
        }
        return wordAttemptsVC
    }

    init? (wordAttemptsVM: WordAttemptsVM, timerDuration: Double, coder: NSCoder) {
        self.wordAttemptsVM = wordAttemptsVM
        self.timerDuration = timerDuration
        super.init(coder: coder)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

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

        self.translatedWordLabel.frame = .init(x: 0, y: 0, width: self.view.frame.width, height: 100)
        self.translatedWordLabel.center = .init(x: self.view.center.x, y: 50)
        translatedWordLabel.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.5)
    }

    /// Initialize view model object
    func setupViewModel() {
        // Setting up closures
        self.wordAttemptsVM.onGameEnd = self.endGame
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
        self.translatedWordLabel.layer.removeAllAnimations()
        // Starting at the top
        self.translatedWordLabel.center = .init(x: self.view.center.x, y: 50)
        // Animating to the bottom
        UIView.animate(withDuration: self.timerDuration, delay: 0, options: .curveLinear) {
            self.translatedWordLabel.center = .init(x: self.view.center.x, y: self.view.frame.height-150)
        }

        self.translatedWordLabel.text = word.translatedWord
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
    func endGame() {
        self.showAlertForRestart()
    }

    // MARK: Navigations
    /// Shows the Game End dialog with options to `Restart` or `Quit`
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
