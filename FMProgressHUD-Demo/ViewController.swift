//
//  ViewController.swift
//  fmHUDApp
//
//  Created by Matchima Ditthawibun on 9/5/21.
//

import UIKit
import FMProgressHUD

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
    
    private lazy var showCustomImageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("show custom image with status", for: .normal)
        let tap = UITapGestureRecognizer(target: self, action: #selector(showCustomImageButtonTapped))
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
    
    lazy var textFieldKeyboardView: UIStackView = {
        let label = UILabel()
        label.text = "Show/Hide Keyboard"
        
        let textField = UITextView()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.text = "Textfield"
        
        let control = UISegmentedControl(items: ["Show", "Hide"])
        control.accessibilityIdentifier = "keyboardSegmentedControl"
        control.translatesAutoresizingMaskIntoConstraints = false
        control.addTarget(self, action: #selector(self.showHideKeyboardControlValueChanged(_:)), for: .valueChanged)
        control.selectedSegmentIndex = 1
        
        let stackView = UIStackView(arrangedSubviews: [label, textField, control])
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 15
        
        return stackView
    }()
    
    lazy var animationTypeView: UIStackView = {
        let label = UILabel()
        label.text = "Animation Type"
        
        let control = UISegmentedControl(items: ["Flat", "Native"])
        control.accessibilityIdentifier = "animationTypeSegmentedControl"
        control.translatesAutoresizingMaskIntoConstraints = false
        control.addTarget(self, action: #selector(self.animationTypeSegmentedControlValueChanged(_:)), for: .valueChanged)
        control.selectedSegmentIndex = 0
        
        let stackView = UIStackView(arrangedSubviews: [label, control])
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 15
        
        return stackView
    }()
    
    lazy var styleView: UIStackView = {
        let label = UILabel()
        label.text = "Style"
        
        let control = UISegmentedControl(items: ["Light", "Dark", "Custom"])
        control.accessibilityIdentifier = "styleSegmentedControl"
        control.translatesAutoresizingMaskIntoConstraints = false
        control.addTarget(self, action: #selector(self.styleSegmentedControlValueChanged(_:)), for: .valueChanged)
        control.selectedSegmentIndex = 0
        
        let stackView = UIStackView(arrangedSubviews: [label, control])
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 15
        
        return stackView
    }()
    
    lazy var maskView: UIStackView = {
        let label = UILabel()
        label.text = "Mask"
        
        let control = UISegmentedControl(items: ["Clear", "Black", "Custom"])
        control.accessibilityIdentifier = "maskSegmentedControl"
        control.translatesAutoresizingMaskIntoConstraints = false
        control.addTarget(self, action: #selector(self.maskTypeSegmentedControlValueChanged(_:)), for: .valueChanged)
        control.selectedSegmentIndex = 0
        
        let stackView = UIStackView(arrangedSubviews: [label, control])
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 15
        
        return stackView
    }()
    
    lazy var ringThicknessView: UIStackView = {
        let label = UILabel()
        label.text = "Ring Thickness: 2"
        
        let slider = UISlider()
        slider.minimumValue = 1
        slider.maximumValue = 10
        slider.value = 2
        slider.accessibilityIdentifier = "ringThicknessSlider"
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.addTarget(self, action: #selector(ringThicknessChanged(_:)), for: .valueChanged)
        
        let stackView = UIStackView(arrangedSubviews: [label, slider])
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 15
        
        return stackView
    }()
    
    lazy var imageWidthView: UIStackView = {
        let label = UILabel()
        label.text = "Image Width: 28"
        
        let slider = UISlider()
        slider.minimumValue = 18
        slider.maximumValue = 38
        slider.value = 28
        slider.accessibilityIdentifier = "imageWidthSlider"
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.addTarget(self, action: #selector(imageWidthChanged(_:)), for: .valueChanged)
        
        let stackView = UIStackView(arrangedSubviews: [label, slider])
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 15
        
        return stackView
    }()
    
    lazy var imageHeightView: UIStackView = {
        let label = UILabel()
        label.text = "Image Height: 28"
        
        let slider = UISlider()
        slider.minimumValue = 18
        slider.maximumValue = 38
        slider.value = 28
        slider.accessibilityIdentifier = "imageHeightSlider"
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.addTarget(self, action: #selector(imageHeightChanged(_:)), for: .valueChanged)
        
        let stackView = UIStackView(arrangedSubviews: [label, slider])
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 15
        
        return stackView
    }()
    
    lazy var allowInteractionView: UIStackView = {
        let allowInteractionSwitch = UISwitch()
        allowInteractionSwitch.accessibilityIdentifier = "allowInteractionSwitch"
        allowInteractionSwitch.isOn = FMProgressHUD.allowUserInteraction
        allowInteractionSwitch.translatesAutoresizingMaskIntoConstraints = false
        allowInteractionSwitch.addTarget(self, action: #selector(allowInteractionSwitchValueChanged(_:)), for: .valueChanged)
        
        let label = UILabel()
        label.text = "Allow user interaction"
        
        let stackView = UIStackView(arrangedSubviews: [label, allowInteractionSwitch])
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 15
        
        return stackView
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 15
        stackView.addArrangedSubview(showNormalButton)
        stackView.addArrangedSubview(showWithStatusButton)
        stackView.addArrangedSubview(showWithProgressButton)
        stackView.addArrangedSubview(showInfoWithStatusButton)
        stackView.addArrangedSubview(showSuccessWithStatusButton)
        stackView.addArrangedSubview(showErrorWithStatusButton)
        stackView.addArrangedSubview(showCustomImageButton)
        stackView.addArrangedSubview(dismissButton)
        stackView.addArrangedSubview(textFieldKeyboardView)
        stackView.addArrangedSubview(animationTypeView)
        stackView.addArrangedSubview(styleView)
        stackView.addArrangedSubview(maskView)
        stackView.addArrangedSubview(ringThicknessView)
        stackView.addArrangedSubview(imageWidthView)
        stackView.addArrangedSubview(imageHeightView)
        stackView.addArrangedSubview(allowInteractionView)
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
    
    // MARK - Configuration
    
    @objc func animationTypeSegmentedControlValueChanged(_ sender: UISegmentedControl) {
        FMProgressHUD.animationType = sender.selectedSegmentIndex == 0 ? .flat : .native
    }
    
    @objc func styleSegmentedControlValueChanged(_ sender: UISegmentedControl) {
        FMProgressHUD.style = sender.selectedSegmentIndex == 0 ? .light : .dark
        switch sender.selectedSegmentIndex {
        case 0: FMProgressHUD.style = .light
        case 1: FMProgressHUD.style = .dark
        case 2:
            FMProgressHUD.style = .custom
            FMProgressHUD.hudViewCustomBlurEffect = UIBlurEffect(style: .systemThickMaterialLight)
//            FMProgressHUD.backgroundColor = UIColor.random.withAlphaComponent(0.4)
            
        
        default: FMProgressHUD.style = .light
        }
    }
    
    @objc func maskTypeSegmentedControlValueChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0: FMProgressHUD.maskType = .clear
        case 1: FMProgressHUD.maskType = .black
        case 2: FMProgressHUD.maskType = .custom
            FMProgressHUD.backgroundLayerColor = UIColor.random.withAlphaComponent(0.4)
        default: FMProgressHUD.maskType = .clear
        }
    }
    
    @objc func ringThicknessChanged(_ sender: UISlider) {
        let roundedValue = sender.value.rounded()
        sender.value = roundedValue
        FMProgressHUD.ringThickness = CGFloat(roundedValue)
        if let label = ringThicknessView.arrangedSubviews.first as? UILabel {
            label.text = "Ring Thickness: \(Int(roundedValue))"
        }
    }
    
    @objc func imageWidthChanged(_ sender: UISlider) {
        let roundedValue = sender.value.rounded()
        sender.value = roundedValue
        FMProgressHUD.imageSize = CGSize(width: CGFloat(roundedValue), height: FMProgressHUD.imageSize.height)
        if let label = imageWidthView.arrangedSubviews.first as? UILabel {
            label.text = "Image Width: \(Int(roundedValue))"
        }
    }
    
    @objc func imageHeightChanged(_ sender: UISlider) {
        let roundedValue = sender.value.rounded()
        sender.value = roundedValue
        FMProgressHUD.imageSize = CGSize(width: FMProgressHUD.imageSize.width, height: CGFloat(roundedValue))
        if let label = imageHeightView.arrangedSubviews.first as? UILabel {
            label.text = "Image Height: \(Int(roundedValue))"
        }
    }
    
    @objc func allowInteractionSwitchValueChanged(_ sender: UISwitch) {
        FMProgressHUD.allowUserInteraction = sender.isOn
    }
    
    @objc func showHideKeyboardControlValueChanged(_ sender: UISegmentedControl) {
        if let textView = textFieldKeyboardView.arrangedSubviews[1] as? UITextView {
            if sender.selectedSegmentIndex == 0 {
                textView.becomeFirstResponder()
            } else {
                textView.resignFirstResponder()
            }
        }
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
            progress += 0.05
        } else {
            FMProgressHUD.dismiss()
            progress = 0
        }
    }
    
    @objc func showInfoWithStatusButtonTapped() {
        FMProgressHUD.showInfo(status: "Info")
    }
    
    @objc func showSuccessWithStatusButtonTapped() {
        FMProgressHUD.showSuccess(status: "Success")
    }
    
    @objc func showErrorWithStatusButtonTapped() {
        FMProgressHUD.showError(status: "Error")
    }
    
    @objc func showCustomImageButtonTapped() {
        let image = UIImage(systemName: "photo")!
        FMProgressHUD.show(image: image, status: "Status")
    }
    
    @objc func dismissButtonTapped() {
        FMProgressHUD.dismiss()
        progress = 0
    }
}
