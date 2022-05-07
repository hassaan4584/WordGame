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

    // MARK: Initializations

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupViewModel()
        self.setupViews()
        self.showNextWord()
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

    // MARK: UserInteractions

    @IBAction func correctButtonPressed(_ sender: UIButton) {
        guard let currentWord = self.wordAttemptsVM.currentWord else {
            self.showNextWord()
            return
        }
        let attempts = self.wordAttemptsVM.processUserAttempt(userAttempt: .correct, givenWord: currentWord)
        self.updateAttemps(correctCount: attempts.correctCount, wrongCount: attempts.wrongCount)
        self.showNextWord()
    }

    @IBAction func wrongButtonPressed(_ sender: UIButton) {
        guard let currentWord = self.wordAttemptsVM.currentWord else {
            self.showNextWord()
            return
        }
        let attempts = self.wordAttemptsVM.processUserAttempt(userAttempt: .wrong, givenWord: currentWord)
        self.updateAttemps(correctCount: attempts.correctCount, wrongCount: attempts.wrongCount)
        self.showNextWord()
    }
}
