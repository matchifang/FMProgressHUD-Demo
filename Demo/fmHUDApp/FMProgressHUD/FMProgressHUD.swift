//
//  FMProgressHUD.swift
//  fmHUDApp
//
//  Created by Matchima Ditthawibun on 11/5/21.
//

import Foundation


// TODO: move HUD when keyboard shows
// TODO: Should things in the background be disabled?
//  - user can set enable/disable
//  - disable during progress and normal loading
//  - enable during showImage (info, success, error)
// TODO: show hudView inside a backgroundView that is the size of the whole screen
// TODO: Progress disappears just before showing completion
// TODO: auto-dismiss view for error and success
// TODO: accessibility
// TODO: bug: progress is not aligned when changing ring radius

// the background dimming/staying clear when HUD is shown
enum FMProgressHUDMaskType {
    case clear
    case black
    case custom
}

enum FMProgressHUDAnimationType {
    case flat   // indefinite animated ring
    case native // iOS native UIActivityIndicatorView
}

enum FMProgressHUDStyle {
    case light
    case dark
    case custom
}

class FMProgressHUD: UIView {
    
    // MARK: Config Vars
    
    static var animationType = FMProgressHUDAnimationType.flat
    static var hudViewCustomBlurEffect: UIBlurEffect?
    static var hudBackgroundColor = UIColor.white {
        didSet {
            FMProgressHUD.sharedView.hudView.backgroundColor = FMProgressHUD.sharedView.backgroundColorForStyle
        }
    }
    static var maskType = FMProgressHUDMaskType.clear {
        didSet {
            
        }
    }
    static var fadeInAnimationDuration: TimeInterval = 0.15
    static var fadeOutAnimationDuration: TimeInterval = 0.15
    static var imageViewWidth: CGFloat = 28
    static var disableTouch = true {
        didSet {
            FMProgressHUD.sharedView.backgroundView.disableTouch = disableTouch
        }
    }
    
    static var cornerRadius: CGFloat = 14 {
        didSet {
            FMProgressHUD.sharedView.hudView.layer.cornerRadius = cornerRadius
        }
    }
    
    static var ringThickness: CGFloat = 2 {
        didSet {
            FMProgressHUD.sharedView.flatSpinner.strokeThickness = ringThickness
        }
    }
    
    static var ringRadius: CGFloat = 18 {
        didSet {
            FMProgressHUD.sharedView.flatSpinner.radius = ringRadius
            FMProgressHUD.sharedView.ringView.radius = ringRadius
            FMProgressHUD.sharedView.backgroundRingView.radius = ringRadius
        }
    }
    
    
    static var labelFontSize: CGFloat = 15 {
        didSet {
            FMProgressHUD.sharedView.statusLabel.font = UIFont.systemFont(ofSize: labelFontSize)
        }
    }
    
    static var style = FMProgressHUDStyle.light {
        didSet {
            if style != .custom {
                let blurEffectStyle = style == .dark ? UIBlurEffect.Style.dark : UIBlurEffect.Style.light
                let blurEffect = UIBlurEffect(style: blurEffectStyle)
                FMProgressHUD.sharedView.hudView.effect = blurEffect
                FMProgressHUD.sharedView.hudView.backgroundColor = FMProgressHUD.sharedView.backgroundColorForStyle.withAlphaComponent(0.6)
                FMProgressHUD.sharedView.nativeSpinner.color = FMProgressHUD.sharedView.foregroundColorForStyle
                FMProgressHUD.sharedView.flatSpinner.strokeColor = FMProgressHUD.sharedView.foregroundColorForStyle
                FMProgressHUD.sharedView.statusLabel.textColor = FMProgressHUD.sharedView.foregroundColorForStyle
                FMProgressHUD.sharedView.imageView?.tintColor = FMProgressHUD.sharedView.foregroundColorForStyle
            } else {
                FMProgressHUD.sharedView.hudView.effect = hudViewCustomBlurEffect
                FMProgressHUD.sharedView.hudView.backgroundColor = FMProgressHUD.sharedView.backgroundColorForStyle
            }
        }
    }
    
    static var hudForegroundColor = UIColor.black {
        didSet {
            FMProgressHUD.sharedView.nativeSpinner.color = FMProgressHUD.sharedView.foregroundColorForStyle
            FMProgressHUD.sharedView.flatSpinner.strokeColor = FMProgressHUD.sharedView.foregroundColorForStyle
            FMProgressHUD.sharedView.statusLabel.textColor = FMProgressHUD.sharedView.foregroundColorForStyle
            FMProgressHUD.sharedView.imageView?.tintColor = FMProgressHUD.sharedView.foregroundColorForStyle
        }
    }
    
    
    // MARK: constants
    
    final let VERTICAL_SPACING: CGFloat = 12
    final let HORIZONTAL_SPACING: CGFloat = 12
    
    // MARK: Lazy Vars
    
    private lazy var nativeSpinner: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.startAnimating()
        indicator.color = FMProgressHUD.hudForegroundColor
        indicator.translatesAutoresizingMaskIntoConstraints = false
        
        return indicator
    }()
    
    private lazy var flatSpinner: FMIndefiniteAnimatedView = {
        let flatSpinner = FMIndefiniteAnimatedView()
        flatSpinner.strokeColor = FMProgressHUD.hudForegroundColor
        flatSpinner.strokeThickness = FMProgressHUD.ringThickness
        flatSpinner.radius = FMProgressHUD.ringRadius
        flatSpinner.translatesAutoresizingMaskIntoConstraints = false
        
        return flatSpinner
    }()
    
    private lazy var statusLabel: UILabel = {
        let statusLabel = UILabel()
        statusLabel.font = UIFont.systemFont(ofSize: FMProgressHUD.labelFontSize)
        statusLabel.adjustsFontSizeToFitWidth = true
        statusLabel.textAlignment = .center
        statusLabel.baselineAdjustment = .alignCenters
        statusLabel.numberOfLines = 0
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return statusLabel
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private lazy var ringView: FMProgressAnimatedView = {
        let ringView = FMProgressAnimatedView()
        ringView.strokeColor = foregroundColorForStyle
        ringView.strokeThickness = FMProgressHUD.ringThickness
        ringView.radius = FMProgressHUD.ringRadius
        ringView.translatesAutoresizingMaskIntoConstraints = false
                
        return ringView
    }()
    
    private lazy var backgroundRingView: FMProgressAnimatedView = {
        let backgroundRingView = FMProgressAnimatedView()
        backgroundRingView.strokeEnd = 1
        backgroundRingView.strokeColor = foregroundColorForStyle.withAlphaComponent(0.1)
        backgroundRingView.strokeThickness = FMProgressHUD.ringThickness
        backgroundRingView.radius = FMProgressHUD.ringRadius
        backgroundRingView.translatesAutoresizingMaskIntoConstraints = false
        backgroundRingView.addSubview(ringView)
                
        return backgroundRingView
    }()
    
    private lazy var hudView: UIVisualEffectView = {
        
        let blurEffectStyle = FMProgressHUD.style == .dark ? UIBlurEffect.Style.dark : UIBlurEffect.Style.light
        let blurEffect = UIBlurEffect(style: blurEffectStyle)
        let hudView = UIVisualEffectView(effect: blurEffect)
        hudView.layer.masksToBounds = true
        hudView.backgroundColor = UIColor.white.withAlphaComponent(0.6)
        hudView.translatesAutoresizingMaskIntoConstraints = false
        hudView.layer.cornerRadius = FMProgressHUD.cornerRadius
        hudView.backgroundColor = .systemGreen
        hudView.alpha = 0
        
        hudView.contentView.addSubview(stackView)
        let inset = FMProgressHUD.cornerRadius / 2
        hudView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: inset,
                                                                   leading: inset,
                                                                   bottom: inset,
                                                                   trailing: inset)
        let margins = hudView.layoutMarginsGuide
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: HORIZONTAL_SPACING),
            stackView.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: -HORIZONTAL_SPACING),
            stackView.topAnchor.constraint(equalTo: margins.topAnchor, constant: VERTICAL_SPACING),
            stackView.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: -VERTICAL_SPACING),
        ])
        
        return hudView
    }()
    
    class TouchBlockingView: UIView {
        var disableTouch = false
        
        override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
            disableTouch
        }
    }
    
    private lazy var backgroundView: TouchBlockingView = {
        let backgroundView = TouchBlockingView()
        backgroundView.disableTouch = FMProgressHUD.disableTouch
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.addSubview(hudView)
        NSLayoutConstraint.activate([
            hudView.centerYAnchor.constraint(equalTo: backgroundView.layoutMarginsGuide.centerYAnchor),
            hudView.centerXAnchor.constraint(equalTo: backgroundView.layoutMarginsGuide.centerXAnchor),
        ])
//        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(backgroundViewTapped))
//        backgroundView.addGestureRecognizer(tapGestureRecognizer)
        
        return backgroundView
    }()
    
    // MARK: Computed Vars
    
    private var backgroundColorForStyle: UIColor {
        switch FMProgressHUD.style {
        case .light:
            return .white
        case .dark:
            return .black
        default:
            return FMProgressHUD.hudBackgroundColor
        }
    }
    
    private var foregroundColorForStyle: UIColor {
        switch FMProgressHUD.style  {
        case .light:
            return .black
        case .dark:
            return .white
        default:
            return FMProgressHUD.hudForegroundColor
        }
    }
    
    private var imageView: UIImageView?
    
    private var spinner: UIView {
        FMProgressHUD.animationType == .flat ? flatSpinner : nativeSpinner
    }
    
    private var frontWindow: UIWindow? {
        let frontToBackWindows = UIApplication.shared.windows.reversed()
        for window in frontToBackWindows {
            let windowOnMainScreen = window.screen == UIScreen.main
            let windowIsVisible = !window.isHidden && window.alpha > 0
            let windowLevelSupported = window.windowLevel >= .normal && window.windowLevel <= UIWindow.Level.normal
            let windowIsKeyWindow = window.isKeyWindow
            if windowOnMainScreen && windowIsVisible && windowLevelSupported && windowIsKeyWindow {
                return window
            }
        }
        return nil
    }
    
    private var fadeOutTimer: Timer?
    
    // MARK: Static vars
    
    static var sharedView = FMProgressHUD()
    
    // MARK: Static methods
    
    static func show() {
        FMProgressHUD.sharedView.show()
    }
    
    static func show(status: String) {
        FMProgressHUD.sharedView.show(status: status)
    }
    
    static func show(progress: CGFloat, status: String) {
        FMProgressHUD.sharedView.show(progress: progress, status: status)
    }
    
    static func showInfo(status: String) {
        guard let image = UIImage(systemName: "info.circle") else { return }
        FMProgressHUD.sharedView.showImage(image:image , status: status)
    }
    
    static func showSuccess(status: String) {
        guard let image = UIImage(systemName: "checkmark") else { return }
        FMProgressHUD.sharedView.showImage(image: image, status: status)
    }
    
    static func showError(status: String) {
        guard let image = UIImage(systemName: "xmark") else { return }
        FMProgressHUD.sharedView.showImage(image: image, status: status)
    }
    
    static func dismiss() {
        FMProgressHUD.sharedView.dismiss()
    }
    
    // MARK: Instance methods
    
    func observeKeyboard() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
//            NSLayoutConstraint.activate([
//                backgroundView.bottomAnchor.constraint(equalTo: frontWindow!.bottomAnchor, constant: keyboardFrame.height)
//            ])

            
            layoutIfNeeded()
            backgrounBottomConstraint?.constant = -keyboardFrame.height
            UIView.animate(withDuration: 1.0) { [weak self] in
                self?.backgroundView.layoutIfNeeded()
            }
            
            
//            let keyboardRectangle = keyboardFrame as
//            let keyboardHeight = keyboardRectangle.height
//            self.keyboardBottom.constant = keyboardHeight - self.bottomLayoutGuide.length
//            DispatchQueue.main.asyncAfter(deadline: .now()+0.1, execute: {
//                let bottomOffset = CGPoint(x: 0, y: self.scrlView.contentSize.height - self.scrlView.bounds.size.height)
//                self.scrlView.setContentOffset(bottomOffset, animated: true)
//            })
        }
    }
    
    var backgrounBottomConstraint: NSLayoutConstraint?
    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    @objc func backgroundViewTapped() {
//        dismiss()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let dict = [UIResponder.keyboardFrameEndUserInfoKey: CGRect(x: 0, y: 0, width: 300, height: 500) as NSValue]
            
            NotificationCenter.default.post(name: UIResponder.keyboardWillShowNotification, object: nil, userInfo: dict)
        }
    }
    
    private func addHudView(duration: TimeInterval?) {
        guard let frontWindow = frontWindow else { return }

        frontWindow.addSubview(backgroundView)
        backgrounBottomConstraint = backgroundView.bottomAnchor.constraint(equalTo: frontWindow.bottomAnchor)
        NSLayoutConstraint.activate([
            backgroundView.leadingAnchor.constraint(equalTo: frontWindow.leadingAnchor),
            backgroundView.topAnchor.constraint(equalTo: frontWindow.topAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: frontWindow.trailingAnchor),
            backgrounBottomConstraint!,
        ])

        if hudView.alpha == 0 {
            hudView.alpha = 0
            for view in hudView.contentView.subviews {
                view.alpha = 0
            }
            
            hudView.transform = hudView.transform.scaledBy(x: 1.3, y: 1.3)
            let animationsBlock = { [weak self] in
                guard let self = self else { return }
                self.hudView.transform = CGAffineTransform.identity
                self.fadeInEffects()
            }
            let completionBlock = { [weak self] (_: Bool) in
                guard let self = self else { return }
                if let duration = duration {
                    self.fadeOutTimer = Timer(timeInterval: duration, target: self, selector: #selector(self.dismiss), userInfo: nil, repeats: false)
                    RunLoop.main.add(self.fadeOutTimer!, forMode: .common)
                }
            }
//            let animationDuration = self.ringView.strokeEnd >= 0 ? 0 : FMProgressHUD.fadeInAnimationDuration
            UIView.animate(withDuration: FMProgressHUD.fadeInAnimationDuration,
                           delay: 0,
                           options: [.allowUserInteraction, .curveEaseIn, .beginFromCurrentState],
                           animations: animationsBlock,
                           completion: completionBlock)
        }
    }
    
    private func fadeInEffects() {
        hudView.alpha = 1
        for view in hudView.contentView.subviews {
            view.alpha = 1
        }
    }
    
    private func fadeOutEffects() {
        hudView.alpha = 0
        for view in hudView.contentView.subviews {
            view.alpha = 0
        }
    }
    
    let maximumDismissTimeInterval = CGFloat.greatestFiniteMagnitude
    func getDisplayDuration(for status: String) -> TimeInterval {
        TimeInterval(min(CGFloat(status.count) * 0.6 + 0.5, maximumDismissTimeInterval))
    }
    
    private func show(status: String? = nil) {
        observeKeyboard()
        show(progress: -1, status: status)
    }
    
    private func showImage(image: UIImage, status: String) {
        for view in self.stackView.arrangedSubviews {
            view.removeFromSuperview()
        }
        
        let duration = getDisplayDuration(for: status)
        fadeOutTimer = nil
        
        for view in stackView.arrangedSubviews {
            view.removeFromSuperview()
        }
        let imageView = UIImageView(image: image)
        imageView.tintColor = foregroundColorForStyle
        self.imageView = imageView
        
        statusLabel.text = status
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(statusLabel)
        
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
            imageView.heightAnchor.constraint(equalToConstant: FMProgressHUD.imageViewWidth)
        ])
        
        addHudView(duration: duration)
    }
    
    private func show(progress: CGFloat = -1, status: String? = nil) {
        for view in self.stackView.arrangedSubviews {
            view.removeFromSuperview()
        }
        
        if progress >= 0 {
            stackView.addArrangedSubview(backgroundRingView)
            ringView.strokeEnd = progress
        } else {
            stackView.addArrangedSubview(spinner)
        }
        
        if let status = status {
            statusLabel.text = status
            stackView.addArrangedSubview(statusLabel)
        }
        
        addHudView(duration: nil)
    }
    
    @objc func dismiss() {
        if backgroundView.superview != nil {
            let animationsBlock = { [weak self] in
                guard let self = self else { return }
                self.hudView.transform.scaledBy(x: 1 / 1.3, y: 1 / 1.3)
                self.fadeOutEffects()
            }
            let completionBlock = { [weak self] (_: Bool) in
                guard let self = self else { return }
                self.backgroundView.removeFromSuperview()
                for view in self.stackView.arrangedSubviews {
                    view.removeFromSuperview()
                }
                self.ringView.strokeEnd = -1
            }
            UIView.animate(withDuration: FMProgressHUD.fadeOutAnimationDuration,
                           delay: 0,
                           options: [.allowUserInteraction, .curveEaseIn, .beginFromCurrentState],
                           animations: animationsBlock,
                           completion: completionBlock)
        }
    }
    
}
