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
        let control = UISegmentedControl(items: ["Clear", "Black", "Custom"])
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
    
    lazy var ringThicknessLabel: UILabel = {
        let label = UILabel()
        label.text = "Ring Thickness: 2"
        return label
    }()
    
    lazy var ringThicknessView: UIStackView = {
        let slider = UISlider()
        slider.minimumValue = 1
        slider.maximumValue = 10
        slider.value = 2
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.addTarget(self, action: #selector(ringThicknessChanged(_:)), for: .valueChanged)
        
        let stackView = UIStackView(arrangedSubviews: [ringThicknessLabel, slider])
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 15
        
        return stackView
    }()
    
    lazy var ringRadiusLabel: UILabel = {
        let label = UILabel()
        label.text = "Ring Radius: 18"
        return label
    }()
    
    lazy var ringRadiusView: UIStackView = {
        let slider = UISlider()
        slider.minimumValue = 15
        slider.maximumValue = 25
        slider.value = 18
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.addTarget(self, action: #selector(ringRadiusChanged(_:)), for: .valueChanged)
        
        let stackView = UIStackView(arrangedSubviews: [ringRadiusLabel, slider])
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 15
        
        return stackView
    }()
    
    lazy var allowTouchView: UIStackView = {
        let allowTouchSwitch = UISwitch()
        allowTouchSwitch.isOn = false
        allowTouchSwitch.translatesAutoresizingMaskIntoConstraints = false
        allowTouchSwitch.addTarget(self, action: #selector(allowTouchSwitchValueChanged(_:)), for: .valueChanged)
        
        let label = UILabel()
        label.text = "Allow touch through"
        
        let stackView = UIStackView(arrangedSubviews: [label, allowTouchSwitch])
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 15
        
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
        stackView.addArrangedSubview(ringRadiusView)
        stackView.addArrangedSubview(allowTouchView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    var progress: CGFloat = 0
    
    
    // MARK - ViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -15),
        ])
    }
    
    @objc func animationTypeSegmentedControlValueChanged(_ sender: UISegmentedControl) {
        FMProgressHUD.animationType = sender.selectedSegmentIndex == 0 ? .flat : .native
    }
    
    @objc func styleSegmentedControlValueChanged(_ sender: UISegmentedControl) {
        FMProgressHUD.style = sender.selectedSegmentIndex == 0 ? .light : .dark
    }
    
    @objc func maskTypeSegmentedControlValueChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0: FMProgressHUD.maskType = .clear
        case 1: FMProgressHUD.maskType = .black
        case 2: FMProgressHUD.maskType = .custom
        default: FMProgressHUD.maskType = .clear
        }
    }
    
    @objc func ringThicknessChanged(_ sender: UISlider) {
        let roundedValue = sender.value.rounded()
        sender.value = roundedValue
        FMProgressHUD.ringThickness = CGFloat(roundedValue)
        ringThicknessLabel.text = "Ring Thickness: \(Int(roundedValue))"
    }
    
    @objc func ringRadiusChanged(_ sender: UISlider) {
        let roundedValue = sender.value.rounded()
        sender.value = roundedValue
        FMProgressHUD.ringRadius = CGFloat(roundedValue)
        ringRadiusLabel.text = "Ring Radius: \(Int(roundedValue))"
    }
    
    @objc func allowTouchSwitchValueChanged(_ sender: UISwitch) {
        FMProgressHUD.disableTouch = !sender.isOn
    }
    
    // MARK - Show different HUDs
    
    @objc func showNormalButtonTapped() {
        FMProgressHUD.show()
    }
    
    @objc func showWithStatusButtonTapped() {
        FMProgressHUD.show(status: "Status")
    }
    
    @objc func showWithProgressButtonTapped() {
        if progress <= 1 {
            perform(#selector(showWithProgressButtonTapped), with: nil, afterDelay: 0.1)
            FMProgressHUD.show(progress: progress, status: "Progress")
            //            SVProgressHUD.showProgress(Float(progress), status: "Loading with progress")
            self.progress += 0.05
        } else {
            FMProgressHUD.dismiss()
            //            SVProgressHUD.dismiss()
            progress = 0
        }
    }
    
    @objc func showInfoWithStatusButtonTapped() {
        FMProgressHUD.showInfo(status: "Info")
        //        SVProgressHUD.showInfo(withStatus: "Info")
    }
    
    @objc func showSuccessWithStatusButtonTapped() {
        FMProgressHUD.showSuccess(status: "Success")
        //        SVProgressHUD.showSuccess(withStatus: "success")
    }
    
    @objc func showErrorWithStatusButtonTapped() {
        FMProgressHUD.showError(status: "Error")
        //        SVProgressHUD.showError(withStatus: "error")
    }
    
    @objc func dismissButtonTapped() {
        SVProgressHUD.dismiss()
        FMProgressHUD.dismiss()
        progress = 0
    }
    
    @objc func showKeyboardButtonTapped() {
        textField.becomeFirstResponder()
    }
}

