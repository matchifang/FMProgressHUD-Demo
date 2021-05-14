//
//  NewHUD.swift
//  fmHUDApp
//
//  Created by Matchima Ditthawibun on 11/5/21.
//

import Foundation


// TODO: What should happen if keyboard shows?
// TODO: Should things in the background be disabled?
// TODO: show hudView inside a containerView that is the size of the whole screen
// TODO: Progress disappears just before showing completion

enum FMProgressHUDAnimationType {
    case flat   // indefinite animated ring
    case native // iOS native UIActivityIndicatorView
}

enum FMProgressHUDStyle {
    case light
    case dark
    case custom
}

class NewHUD: UIView {
    
    // MARK: Config Vars
    
    static var animationType = FMProgressHUDAnimationType.flat
    static var hudBackgroundColor = UIColor.white
    static var hudViewCustomBlurEffect: UIBlurEffect?
    
    static var cornerRadius: CGFloat = 14 {
        didSet {
            NewHUD.sharedView.hudView.layer.cornerRadius = NewHUD.cornerRadius
        }
    }
    
    static var ringThickness: CGFloat = 2 {
        didSet {
            NewHUD.sharedView.flatSpinner.strokeThickness = NewHUD.ringThickness
        }
    }
    
    static var labelFontSize: CGFloat = 15 {
        didSet {
            NewHUD.sharedView.statusLabel.font = UIFont.systemFont(ofSize: labelFontSize)
        }
    }
    
    static var style = FMProgressHUDStyle.light {
        didSet {
            if style != .custom {
                let blurEffectStyle = style == .dark ? UIBlurEffect.Style.dark : UIBlurEffect.Style.light
                let blurEffect = UIBlurEffect(style: blurEffectStyle)
                NewHUD.sharedView.hudView.effect = blurEffect
                NewHUD.sharedView.hudView.backgroundColor = NewHUD.sharedView.backgroundColorForStyle.withAlphaComponent(0.6)
                NewHUD.sharedView.nativeSpinner.color = NewHUD.sharedView.foregroundColorForStyle
                NewHUD.sharedView.flatSpinner.strokeColor = NewHUD.sharedView.foregroundColorForStyle
                NewHUD.sharedView.statusLabel.textColor = NewHUD.sharedView.foregroundColorForStyle
                NewHUD.sharedView.imageView?.tintColor = NewHUD.sharedView.foregroundColorForStyle
            } else {
                NewHUD.sharedView.hudView.effect = hudViewCustomBlurEffect
                NewHUD.sharedView.hudView.backgroundColor = NewHUD.sharedView.backgroundColorForStyle
            }
        }
    }
    
    static var hudForegroundColor = UIColor.black {
        didSet {
            NewHUD.sharedView.nativeSpinner.color = NewHUD.sharedView.foregroundColorForStyle
            NewHUD.sharedView.flatSpinner.strokeColor = NewHUD.sharedView.foregroundColorForStyle
            NewHUD.sharedView.statusLabel.textColor = NewHUD.sharedView.foregroundColorForStyle
            NewHUD.sharedView.imageView?.tintColor = NewHUD.sharedView.foregroundColorForStyle
        }
    }
    
    
    // MARK: constants
    
    final let VERTICAL_SPACING: CGFloat = 12
    final let HORIZONTAL_SPACING: CGFloat = 12
    
    // MARK: Lazy Vars
    
    private lazy var nativeSpinner: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.startAnimating()
        indicator.color = NewHUD.hudForegroundColor
        indicator.translatesAutoresizingMaskIntoConstraints = false
        
        return indicator
    }()
    
    private lazy var flatSpinner: FMIndefiniteAnimatedView = {
        let flatSpinner = FMIndefiniteAnimatedView()
        flatSpinner.strokeColor = NewHUD.hudForegroundColor
        flatSpinner.strokeThickness = NewHUD.ringThickness
        flatSpinner.radius = 18
        flatSpinner.translatesAutoresizingMaskIntoConstraints = false
        
        return flatSpinner
    }()
    
    private lazy var statusLabel: UILabel = {
        let statusLabel = UILabel()
        statusLabel.font = UIFont.systemFont(ofSize: NewHUD.labelFontSize)
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
    
    lazy var ringView: FMProgressAnimatedView = {
        let ringView = FMProgressAnimatedView()
        ringView.strokeColor = foregroundColorForStyle
        ringView.strokeThickness = 2
        ringView.radius = 18
        ringView.translatesAutoresizingMaskIntoConstraints = false
                
        return ringView
    }()
    
    lazy var backgroundRingView: FMProgressAnimatedView = {
        let backgroundRingView = FMProgressAnimatedView()
        backgroundRingView.strokeEnd = 1
        backgroundRingView.strokeColor = foregroundColorForStyle.withAlphaComponent(0.1)
        backgroundRingView.strokeThickness = 2
        backgroundRingView.radius = 18
        backgroundRingView.translatesAutoresizingMaskIntoConstraints = false
        backgroundRingView.addSubview(ringView)
                
        return backgroundRingView
    }()
    
    private lazy var hudView: UIVisualEffectView = {
        
        let blurEffectStyle = NewHUD.style == .dark ? UIBlurEffect.Style.dark : UIBlurEffect.Style.light
        let blurEffect = UIBlurEffect(style: blurEffectStyle)
        let hudView = UIVisualEffectView(effect: blurEffect)
        hudView.layer.masksToBounds = true
        hudView.backgroundColor = UIColor.white.withAlphaComponent(0.6)
        hudView.translatesAutoresizingMaskIntoConstraints = false
        hudView.layer.cornerRadius = NewHUD.cornerRadius
        hudView.backgroundColor = .systemGreen
        
        hudView.contentView.addSubview(stackView)
        let inset = NewHUD.cornerRadius / 2
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
    
    // MARK: Computed Vars
    
    private var backgroundColorForStyle: UIColor {
        switch NewHUD.style {
        case .light:
            return .white
        case .dark:
            return .black
        default:
            return NewHUD.hudBackgroundColor
        }
    }
    
    private var foregroundColorForStyle: UIColor {
        switch NewHUD.style  {
        case .light:
            return .black
        case .dark:
            return .white
        default:
            return NewHUD.hudForegroundColor
        }
    }
    
    private var imageView: UIImageView?
    
    private var spinner: UIView {
        NewHUD.animationType == .flat ? flatSpinner : nativeSpinner
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
    
    private var containerView: UIView {
        let containerView = UIView(frame: UIScreen.main.bounds)
        //        containerView.addSubview(hudView)
        //        NSLayoutConstraint.activate([
        //            hudView.centerYAnchor.constraint(equalTo: containerView.layoutMarginsGuide.centerYAnchor),
        //            hudView.centerXAnchor.constraint(equalTo: containerView.layoutMarginsGuide.centerXAnchor),
        //        ])
        
        
        return containerView
    }
    
    static var sharedView = NewHUD()
    
    static func show() {
        NewHUD.sharedView.show()
    }
    
    static func show(status: String) {
        NewHUD.sharedView.show(status: status)
    }
    
    static func show(progress: CGFloat, status: String) {
        NewHUD.sharedView.show(progress: progress, status: status)
    }
    
    static func showInfo(status: String) {
        guard let image = UIImage(systemName: "info.circle") else { return }
        NewHUD.sharedView.showImage(image:image , status: status)
    }
    
    static func showSuccess(status: String) {
        guard let image = UIImage(systemName: "checkmark") else { return }
        NewHUD.sharedView.showImage(image: image, status: status)
    }
    
    static func showError(status: String) {
        guard let image = UIImage(systemName: "xmark") else { return }
        NewHUD.sharedView.showImage(image: image, status: status)
    }
    
    static func dismiss() {
        NewHUD.sharedView.dismiss()
    }
    
    // MARK: Instance methods
    
    private func addHudView() {
        guard let frontWindow = frontWindow else { return }
        
        frontWindow.addSubview(hudView)
        NSLayoutConstraint.activate([
            hudView.centerXAnchor.constraint(equalTo: frontWindow.centerXAnchor),
            hudView.centerYAnchor.constraint(equalTo: frontWindow.centerYAnchor),
        ])
    }
    
    private func show(status: String? = nil) {
        show(progress: -1, status: status)
    }
    
    private func showImage(image: UIImage, status: String) {
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
            imageView.heightAnchor.constraint(equalToConstant: 28)
        ])
        
        addHudView()
    }
    
    private func show(progress: CGFloat = -1, status: String? = nil) {
        for view in stackView.arrangedSubviews {
            view.removeFromSuperview()
        }
        
        if progress >= 0 {
            stackView.addArrangedSubview(backgroundRingView)
//            stackView.addArrangedSubview(backgroundRingView)
//            CATransaction.begin()
//            CATransaction.setDisableActions(true)
            ringView.strokeEnd = progress
//            CATransaction.commit()
        } else {
            stackView.addArrangedSubview(spinner)
        }
        
        if let status = status {
            statusLabel.text = status
            stackView.addArrangedSubview(statusLabel)
        }
        
        addHudView()
    }
    
    func dismiss() {
        if hudView.superview != nil {
            hudView.removeFromSuperview()
            for view in stackView.arrangedSubviews {
                view.removeFromSuperview()
            }
            ringView.strokeEnd = 0
        }
    }
    
}
