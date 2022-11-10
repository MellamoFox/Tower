//
//  PlayVC.swift
//  Millioneros
//
//  Created by VT on 06.11.2022.
//

import UIKit

var yourWin = 0
var userResults = true

class PlayVC: UIViewController {
    
    private let setTimer = TimerSetUp()
    private let helpButtons = HelpButtons()
    private let answerButtons = AnswerButtons()
    private let questionLabel = QuestionLabel()
    private var questionBrain = QuestionBrain()
    private let gradientView = GradientView()
    private let resultVC = ResultVC()
    
    
    private lazy var stackView = UIStackView(arrangedSubviews: [answerButtonsArray[0],answerButtonsArray[1]],
                                             axis: .vertical,
                                             spacing: 20)
    private lazy var stackView2 = UIStackView(arrangedSubviews: [answerButtonsArray[2],answerButtonsArray[3]],
                                             axis: .vertical,
                                             spacing: 20)
    private lazy var stackView3 = UIStackView(arrangedSubviews: helpButtonsArray,
                                             axis: .horizontal,
                                             spacing: 20)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupButtonsAction()
        setupHelpButtonsAction()
        setStackViews()
        setConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setAnswerTitles()
        questionLabel.text = ""
        questionLabel.animation(typing: questionBrain.getQuestion().text, duration: 0.05)
        view.addSubview(setTimer)
        setTimerConstraints()
    }
    
    private func setupViews() {
        self.navigationController?.isNavigationBarHidden = true
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(gradientView)
        view.addSubview(stackView)
        view.addSubview(stackView2)
        view.addSubview(stackView3)
        view.addSubview(questionLabel)
    }
    
    private func setupButtonsAction() {
        for i in answerButtonsArray {
            i.addTarget(self, action: #selector(answerButtonTapped), for: .touchUpInside)
        }
    }
    
    private func setupHelpButtonsAction() {
        for i in helpButtonsArray {
            i.addTarget(self, action: #selector(helpButtonTapped), for: .touchUpInside)
        }
    }
    
    private func setAnswerTitles() {
        for i in 0..<4 {
                let answer = questionBrain.getQuestion().answers
                answerButtonsArray[i].setTitle("\(answer[i])", for: .normal)
                answerButtonsArray[i].backgroundColor = .none
                answerButtonsArray[i].setTitleColor(.white, for: .normal)
        }
    }
   
    
    private func setStackViews() {
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView2.alignment = .fill
        stackView2.distribution = .fillEqually
        stackView3.alignment = .fill
        stackView3.distribution = .fillEqually
        setTimer.translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    @objc private func helpButtonTapped(_ sender: UIButton) {
        sender.isEnabled = false
        sender.alpha = 0.5
    }
    
    @objc private func answerButtonTapped(_ sender: UIButton) {
        sender.backgroundColor = .yellow
        sender.setTitleColor(.black, for: .normal)
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(4), execute: { [self] in
            let userAnswer = sender.currentTitle
            let userGotItRight = self.questionBrain.checkAnswer(userAnswer: userAnswer!)
            if userGotItRight {
                yourWin = questionBrain.winArray[questionBrain.questionNumber]
                print(yourWin)
                sender.backgroundColor = .green
                yourWin = questionBrain.winArray[questionBrain.questionNumber]
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(4), execute: {
                    self.navigationController?.pushViewController(self.resultVC, animated: true)
                    self.questionBrain.nextQuestion()
                })
                } else {
                userResults = false
                sender.backgroundColor = .red
                switch yourWin {
                case 32000..<1000000 : yourWin = questionBrain.winArray[9]
                case 1000..<32000 : yourWin = questionBrain.winArray[5]
                default : yourWin = 0
                }
                print(yourWin)
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(4), execute: { [self] in
                    navigationController?.pushViewController(resultVC, animated: true)
                })
            }
        })
    }
    
    private func setTimerConstraints(){
        NSLayoutConstraint.activate([
            setTimer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            setTimer.bottomAnchor.constraint(equalTo: stackView3.topAnchor,constant: -70),
            
        ])
    }
    private func setConstraints(){
        NSLayoutConstraint.activate([
            gradientView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            gradientView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            gradientView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            gradientView.topAnchor.constraint(equalTo: view.topAnchor)
        ])
        NSLayoutConstraint.activate([
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -20),
            stackView.heightAnchor.constraint(equalToConstant: 100),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.centerXAnchor,constant: -10)
        ])
        NSLayoutConstraint.activate([
            stackView2.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -20),
            stackView2.heightAnchor.constraint(equalToConstant: 100),
            stackView2.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,constant: -20),
            stackView2.leadingAnchor.constraint(equalTo: stackView.trailingAnchor,constant: 10)
        ])
        NSLayoutConstraint.activate([
            questionLabel.bottomAnchor.constraint(equalTo: stackView2.topAnchor,constant: -20),
            questionLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant: 20),
            questionLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,constant: -20),
            questionLabel.heightAnchor.constraint(equalToConstant: 80)
        ])
        NSLayoutConstraint.activate([
            stackView3.bottomAnchor.constraint(equalTo: questionLabel.topAnchor, constant: -20),
            stackView3.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant: 20),
            stackView3.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,constant: -20),
            stackView3.heightAnchor.constraint(equalToConstant: 50),

        ])
    }
}
