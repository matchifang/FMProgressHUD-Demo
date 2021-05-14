//
//  ViewController.swift
//  fmHUDApp
//
//  Created by Matchima Ditthawibun on 9/5/21.
//

import UIKit

class ViewController: UIViewController {
    
    private lazy var showNormalButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("show normal", for: .normal)
        let tap = UITapGestureRecognizer(target: self, action: #selector(showNormalButtonTapped))
        button.addGestureRecognizer(tap)
        
        return button
    }()
    
    private lazy var showWithStatusButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("show with status", for: .normal)
        let tap = UITapGestureRecognizer(target: self, action: #selector(showWithStatusButtonTapped))
        button.addGestureRecognizer(tap)
        
        return button
    }()
    
    private lazy var showWithProgressButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("show with progress", for: .normal)
        let tap = UITapGestureRecognizer(target: self, action: #selector(showWithProgressButtonTapped))
        button.addGestureRecognizer(tap)
        
        return button
    }()
    
    private lazy var showInfoWithStatusButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("show info with status", for: .normal)
        let tap = UITapGestureRecognizer(target: self, action: #selector(showInfoWithStatusButtonTapped))
        button.addGestureRecognizer(tap)
        
        return button
    }()
    
    private lazy var showSuccessWithStatusButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("show success with status", for: .normal)
        let tap = UITapGestureRecognizer(target: self, action: #selector(showSuccessWithStatusButtonTapped))
        button.addGestureRecognizer(tap)
        
        return button
    }()
    
    private lazy var showErrorWithStatusButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("show error with status", for: .normal)
        let tap = UITapGestureRecognizer(target: self, action: #selector(showErrorWithStatusButtonTapped))
        button.addGestureRecognizer(tap)
        
        return button
    }()
    
    private lazy var dismissButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("dismiss", for: .normal)
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissButtonTapped))
        button.addGestureRecognizer(tap)
        
        return button
    }()
    
    lazy var animationTypeSegmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["Flat", "Native"])
        control.translatesAutoresizingMaskIntoConstraints = false
        control.addTarget(self, action: #selector(self.animationTypeSegmentedControlValueChanged(_:)), for: .valueChanged)
        control.selectedSegmentIndex = 0
        return control
    }()
    
    lazy var styleSegmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["Light", "Dark"])
        control.translatesAutoresizingMaskIntoConstraints = false
        control.addTarget(self, action: #selector(self.styleSegmentedControlValueChanged(_:)), for: .valueChanged)
        control.selectedSegmentIndex = 0
        return control
    }()
    
    lazy var maskTypeSegmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["None", "Clear", "Black", "Gradient", "Custom"])
        control.translatesAutoresizingMaskIntoConstraints = false
        control.addTarget(self, action: #selector(self.maskTypeSegmentedControlValueChanged(_:)), for: .valueChanged)
        control.selectedSegmentIndex = 0
        return control
    }()
    
    lazy var showKeyboardButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("show keyboard", for: .normal)
        let tap = UITapGestureRecognizer(target: self, action: #selector(showKeyboardButtonTapped))
        button.addGestureRecognizer(tap)
        return button
    }()
    
    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var ringThicknessView: UIStackView = {
        let slider = UISlider()
        slider.minimumValue = 1
        slider.maximumValue = 10
        slider.value = 2
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.addTarget(self, action: #selector(ringThicknessChanged(_:)), for: .valueChanged)
        
        let label = UILabel()
        label.text = "Ring Thickness"
        
        let stackView = UIStackView(arrangedSubviews: [label, slider])
        stackView.axis = .horizontal
        stackView.distribution = .fill
        
        return stackView
    }()
    
    // https://nshipster.com/uistackview/
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.addArrangedSubview(showNormalButton)
        stackView.addArrangedSubview(showWithStatusButton)
        stackView.addArrangedSubview(showWithProgressButton)
        stackView.addArrangedSubview(showInfoWithStatusButton)
        stackView.addArrangedSubview(showSuccessWithStatusButton)
        stackView.addArrangedSubview(showErrorWithStatusButton)
        stackView.addArrangedSubview(dismissButton)
        stackView.addArrangedSubview(textField)
        stackView.addArrangedSubview(showKeyboardButton)
        stackView.addArrangedSubview(animationTypeSegmentedControl)
        stackView.addArrangedSubview(styleSegmentedControl)
        stackView.addArrangedSubview(maskTypeSegmentedControl)
        stackView.addArrangedSubview(ringThicknessView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    var progress: CGFloat = 0
    
    
    // MARK - ViewController Lifecycle
    
//    override func loadView() {
//        <#code#>
//    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        configureView()
        NewHUD.show()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
//        let sliderConstraints = [
//            ringThicknessSlider.widthAnchor.constraint(equalTo: view.widthAnchor),
//            ringThicknessSlider.centerYAnchor.constraint(equalTo: view.centerYAnchor),
//        ]
//
//        let labelConstraints = labels.enumerated().map { (i, label) -> [NSLayoutConstraint] in
//            let pct = CGFloat(i)/CGFloat(labels.count-1)
//            let centerX = (view.bounds.size.width - 2 * self.ringThicknessSlider.thumbIndent) * pct + self.ringThicknessSlider.thumbIndent
//            return [
//                label.centerXAnchor.constraint(equalTo: ringThicknessSlider.leftAnchor, constant: centerX),
//                label.bottomAnchor.constraint(equalTo: ringThicknessSlider.topAnchor, constant: 0),
//            ]
//        }.flatMap { $0 }
//
//        view.removeConstraints(view.constraints)
//
//        (sliderConstraints + labelConstraints).forEach {
//            view.addConstraint($0)
//            $0.isActive = true
//        }
    }
    
    func configureView() {
        view.addSubview(stackView)
//        for label in labels {
//            view.addSubview(label)
//        }
//        view.addSubview(ringThicknessSlider)
//        view.addSubview(animationTypeSegmentedControl)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//            animationTypeSegmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 300)
        ])
    }
    
    @objc func animationTypeSegmentedControlValueChanged(_ sender: UISegmentedControl) {
        NewHUD.animationType = sender.selectedSegmentIndex == 0 ? .flat : .native
    }
    
    @objc func styleSegmentedControlValueChanged(_ sender: UISegmentedControl) {
        NewHUD.style = sender.selectedSegmentIndex == 0 ? .light : .dark
    }
    
    @objc func maskTypeSegmentedControlValueChanged(_ sender: UISegmentedControl) {
        // TODO
    }
    
    @objc func ringThicknessChanged(_ sender: UISlider) {
        NewHUD.ringThickness = CGFloat(sender.value)
    }
    
    // MARK - Show different HUDs
    
    @objc func showNormalButtonTapped() {
        NewHUD.show()
    }
    
    @objc func showWithStatusButtonTapped() {
        NewHUD.show(status: "Status")
    }
    
    @objc func showWithProgressButtonTapped() {
        if progress <= 1 {
            perform(#selector(showWithProgressButtonTapped), with: nil, afterDelay: 0.1)
            NewHUD.show(progress: progress, status: "Progress")
//            SVProgressHUD.showProgress(Float(progress), status: "Loading with progress")
            self.progress += 0.05
        } else {
            NewHUD.dismiss()
//            SVProgressHUD.dismiss()
            progress = 0
        }
    }
    
    @objc func showInfoWithStatusButtonTapped() {
        NewHUD.showInfo(status: "Info")
//        SVProgressHUD.showInfo(withStatus: "Info")
    }
    
    @objc func showSuccessWithStatusButtonTapped() {
        NewHUD.showSuccess(status: "Success")
//        SVProgressHUD.showSuccess(withStatus: "success")
    }
    
    @objc func showErrorWithStatusButtonTapped() {
        NewHUD.showError(status: "Error")
//        SVProgressHUD.showError(withStatus: "error")
    }
    
    @objc func dismissButtonTapped() {
        SVProgressHUD.dismiss()
        NewHUD.dismiss()
        progress = 0
    }
    
    @objc func showKeyboardButtonTapped() {
        textField.becomeFirstResponder()
    }
}

