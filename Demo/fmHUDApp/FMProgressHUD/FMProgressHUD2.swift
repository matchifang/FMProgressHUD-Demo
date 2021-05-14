//
//  FMProgressHUD2.swift
//  fmHUDApp
//
//  Created by Matchima Ditthawibun on 9/5/21.
//

import Foundation





/**
 
 controlView: UIControl
 
 hudView: UIVisualEffectView
 
 statusLabel: UILabel
 
 */
class FMProgressHUD2: UIView {
    
    dynamic var defaultStyle = FMProgressHUDStyle.light
    dynamic var defaultMaskType = FMProgressHUDMaskType.clear
    dynamic var defaultAnimationType = FMProgressHUDAnimationType.flat
    
    var containerView: UIView?  // if nil, we use default window level
    
    dynamic var minimumSize: CGSize = .zero
    dynamic var ringThickness: CGFloat = 2
    dynamic var ringRadius: CGFloat = 18
    dynamic var ringNoTextRadius: CGFloat = 14
    dynamic var font = UIFont.preferredFont(forTextStyle: .subheadline)
    dynamic var hudBackgroundColor = UIColor.white
    dynamic var hudForegroundColor = UIColor.black
    dynamic var foregroundImageColor: UIColor?
    dynamic var backgroundLayerColor = UIColor(white: 0, alpha: 0.4)
    dynamic var imageViewSize = CGSize(width: 28, height: 28)
    dynamic var shouldTintImages = true
    dynamic var infoImage = UIImage(named: "info")
    dynamic var successImage = UIImage(named: "success")
    dynamic var errorImage = UIImage(named: "error")
    
    var graceTimeInterval: TimeInterval = 0
    var minimumDismissTimeInterval: TimeInterval = 5
    var maximumDismissTimeInterval = TimeInterval.greatestFiniteMagnitude
    
    dynamic var offsetFromCenter = UIOffset(horizontal: 0, vertical: 0)
    dynamic var fadeInAnimationDuration: TimeInterval = 0.15
    dynamic var fadeOutAnimationDuration: TimeInterval = 0.15
    
    var maxSuppertedWindowLevel = UIWindow.Level.normal
    var hapticsEnabled = false
    var motionEffectEnabled = true
    
    private var progress: CGFloat = 0
    private var activityCount = 0
    
    // constants
    final let PARALLAX_DEPTH_POINT: CGFloat = 10
    static let UNDEFINED_PROGRESS: CGFloat = -1
    final let DEFAULT_ANIMATION_DURATION: CGFloat = 0.15
    final let VERTICAL_SPACING: CGFloat = 12
    final let HORIZONTAL_SPACING: CGFloat = 12
    final let LABEL_SPACING: CGFloat = 8
    
    var graceTimer: Timer? {
        willSet {
            graceTimer?.invalidate()
        }
    }
    var fadeOutTimer: Timer? {
        willSet {
            fadeOutTimer?.invalidate()
        }
    }
    
    lazy var controlView: UIControl = {
        let control = UIControl()
        control.translatesAutoresizingMaskIntoConstraints = false
        control.backgroundColor = .clear
        control.frame = UIScreen.main.bounds
        
        return control
    }()
    
    lazy var statusLabel: UILabel = {
        let statusLabel = UILabel()
        statusLabel.alpha = 0
        statusLabel.backgroundColor = .clear
        statusLabel.adjustsFontSizeToFitWidth = true
        statusLabel.textAlignment = .center
        statusLabel.baselineAdjustment = .alignCenters
        statusLabel.numberOfLines = 0
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        hudView.contentView.addSubview(statusLabel)
        
        return statusLabel
    }()
    
    lazy var hudView: UIVisualEffectView = {
        let hudView = UIVisualEffectView()
        hudView.translatesAutoresizingMaskIntoConstraints = false
        hudView.layer.masksToBounds = true
        addSubview(hudView)
        
        return hudView
    }()
    
    lazy var backgroundView: UIView = {
        let backgroundView = UIView()
        backgroundView.alpha = 0
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        insertSubview(backgroundView, belowSubview: hudView)
        backgroundView.backgroundColor = .clear
        backgroundView.frame = bounds
        
        return backgroundView
    }()
    
    lazy var indefiniteAnimatedView: UIView = {
        let view: UIView
        if self.defaultAnimationType == .flat {
            // TODO: skip 1088
            view = FMIndefiniteAnimatedView(frame: .zero)
            let indefiniteAnimatedView = view as? FMIndefiniteAnimatedView
            indefiniteAnimatedView?.strokeColor = hudForegroundColor
            indefiniteAnimatedView?.strokeThickness = ringThickness
            indefiniteAnimatedView?.radius = statusLabel.text != nil ? ringRadius : ringNoTextRadius
        } else {
            // TODO: skip 1104
            view = UIActivityIndicatorView(style: .large)
            let activityIndicatorView = view as? UIActivityIndicatorView
            activityIndicatorView?.color = foregroundImageColorForStyle
        }
        
        view.alpha = 0
        view.sizeToFit()
        
        return view
    }()
    
    lazy var ringView: FMProgressAnimatedView = {
        let ringView = FMProgressAnimatedView()
        ringView.translatesAutoresizingMaskIntoConstraints = false
        
        // TODO: styling
        
        return ringView
    }()
    
    lazy var imageView: UIImageView = {
        
        // TODO: remove from subview
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: imageViewSize.width, height: imageViewSize.height))
        imageView.alpha = 0
        imageView.translatesAutoresizingMaskIntoConstraints = false
        hudView.contentView.addSubview(imageView)
        
        return imageView
    }()
    
    lazy var backgroundRingView: FMProgressAnimatedView = {
        let backgroundRingView = FMProgressAnimatedView()
        backgroundRingView.strokeEnd = 1
        backgroundRingView.translatesAutoresizingMaskIntoConstraints = false
        
        // TODO: styling
        
        return backgroundRingView
    }()
    
    lazy var hapticGenerator: UINotificationFeedbackGenerator? = {
        if !hapticsEnabled {
            return nil
        }
        return UINotificationFeedbackGenerator()
    }()
    
    var frontWindow: UIWindow? {
        let frontToBackWindows = UIApplication.shared.windows.reversed()
        for window in frontToBackWindows {
            let windowOnMainScreen = window.screen == UIScreen.main
            let windowIsVisible = !window.isHidden && window.alpha > 0
            let windowLevelSupported = window.windowLevel >= .normal && window.windowLevel <= maxSuppertedWindowLevel
            let windowIsKeyWindow = window.isKeyWindow
            if windowOnMainScreen && windowIsVisible && windowLevelSupported && windowIsKeyWindow {
                return window
            }
        }
        return nil
    }
    
    var backgroundColorForStyle: UIColor {
        switch defaultStyle {
        case .light:
            return .white
        case .dark:
            return .black
        default:
            return hudBackgroundColor
        }
    }
    
    var foregroundColorForStyle: UIColor {
        switch defaultStyle {
        case .light:
            return .black
        case .dark:
            return .white
        default:
            return hudForegroundColor
        }
    }
    
    var foregroundImageColorForStyle: UIColor {
        if let foregroundImageColor = foregroundImageColor {
            return foregroundImageColor
        }
        return foregroundColorForStyle
    }
    
    var hudViewCustomBlurEffect: UIBlurEffect?
    
    // static vs class vars
    // static is alias for 'class final'
    static var sharedView =  FMProgressHUD2(frame: UIScreen.main.bounds)
    
    override init(frame: CGRect) {
        foregroundImageColor = hudForegroundColor
        
        super.init(frame: frame)
        
        accessibilityIdentifier = "FMProgressHUD2"
        isAccessibilityElement = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // TODO: Something in here is wrong!!
    func updateHUDFrame() {
        let imageUsed = imageView.image != nil && !imageView.isHidden
        let progressUsed = imageView.isHidden
        
        var labelRect = CGRect.zero
        var labelHeight: CGFloat = 0
        var labelWidth: CGFloat = 0
        
//        statusLabel.color
        
        if let statusLabelText = statusLabel.text,
           let statusLabelFont = statusLabel.font {
            let constraintSize = CGSize(width: 200, height: 300)
            labelRect = NSString(string: statusLabelText).boundingRect(with: constraintSize,
                                                                       options: .usesFontLeading, // TODO: line 466
                                                                       attributes: [.font: statusLabelFont],
                                                                       context: nil)
            labelHeight = CGFloat(ceilf(Float(labelRect.height)))
            labelWidth = CGFloat(ceilf(Float(labelRect.width)))
        }
        
        var contentWidth: CGFloat = 0
        var contentHeight: CGFloat = 0
        
        if imageUsed || progressUsed {
            contentWidth = imageUsed ? imageView.frame.width : indefiniteAnimatedView.frame.width
            contentHeight = imageUsed ? imageView.frame.height : indefiniteAnimatedView.frame.height
        }
        
        // |-spacing-content-spacing-|
        let hudWidth = HORIZONTAL_SPACING + max(labelWidth, contentWidth) + HORIZONTAL_SPACING
        
        // |-spacing-content-(labelSpacing-label-)spacing-|
        var hudHeight = VERTICAL_SPACING + labelHeight + contentHeight + VERTICAL_SPACING
        
        if statusLabel.text != nil && (imageUsed || progressUsed) {
            hudHeight += LABEL_SPACING
        }
        
        hudView.bounds = CGRect(x: 0, y: 0, width: max(minimumSize.width, CGFloat(hudWidth)), height: max(minimumSize.height, CGFloat(hudHeight)))
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        var centerY = hudView.bounds.midY
        if statusLabel.text != nil {
            let yOffset = max(VERTICAL_SPACING, ((minimumSize.height - contentHeight) - LABEL_SPACING - labelHeight) / 2.0)
            centerY = CGFloat(yOffset) + contentHeight / 2.0
        }
        indefiniteAnimatedView.center = CGPoint(x: hudView.bounds.midX, y: centerY)
        
        if progress != FMProgressHUD2.UNDEFINED_PROGRESS {
            backgroundRingView.center = CGPoint(x: hudView.bounds.width, y: centerY)
            ringView.center = CGPoint(x: hudView.bounds.width, y: centerY)
        }
        imageView.center = CGPoint(x: hudView.bounds.midX, y: centerY)
        
        if imageUsed || progressUsed {
            centerY = (imageUsed ? imageView.frame.maxY : indefiniteAnimatedView.frame.maxY) + CGFloat(Float(LABEL_SPACING)) + labelHeight / 2.0
        } else {
            centerY = hudView.bounds.midY
        }
        statusLabel.frame = labelRect
        statusLabel.center = CGPoint(x: hudView.bounds.midX, y: centerY)
        
        CATransaction.commit()
    }
    
    func updateViewHierarchy() {    // 555
        if controlView.superview == nil {
            if let containerView = containerView {
                containerView.addSubview(controlView)
            } else {
                frontWindow?.addSubview(controlView)
            }
        } else {
            controlView.superview?.bringSubviewToFront(controlView)
        }
        
        if superview == nil {
            controlView.addSubview(self)
        }
    }
    
    func cancelIndefiniteAnimatedViewAnimation() {
        if let activityIndicator = indefiniteAnimatedView as? UIActivityIndicatorView {
            activityIndicator.stopAnimating()
        }
        
        indefiniteAnimatedView.removeFromSuperview()
    }
    
    func cancelRingLayerAnimation() {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        hudView.layer.removeAllAnimations()
        ringView.strokeEnd = 0
        
        CATransaction.commit()
        
        ringView.removeFromSuperview()
        backgroundRingView.removeFromSuperview()
    }
    
    func registerNotifications() {
        
    }
    
    func positionHUD() {
        
    }
    
    @objc func fadeIn(data: Any? = nil) {
        updateHUDFrame()
        positionHUD()
        
        if backgroundView.alpha != 1 {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HUDWillAppear"), object: self, userInfo: nil) // TODO
            hudView.transform = hudView.transform.scaledBy(x: 1.3, y: 1.3)
            
            let animationsBlock = { [weak self] in
                guard let self = self else { return }
                self.hudView.transform = CGAffineTransform.identity
                self.fadeInEffects()
            }
            let completionBlock = { [weak self] (_: Bool) in
                guard let self = self else {
                    return
                    
                }
                if self.backgroundView.alpha == 1 {
                    self.registerNotifications()
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HUDDidAppear"), object: self, userInfo: nil) // TODO
                    if let timer = data as? Timer,
                        let duration = timer.userInfo as? TimeInterval,
                        let fadeOutTimer = self.fadeOutTimer {
                        self.fadeOutTimer = Timer(timeInterval: duration, target: self, selector: #selector(self.dismiss), userInfo: nil, repeats: false)
                        RunLoop.main.add(fadeOutTimer, forMode: .common)
                    }
                }
            }
            
            if fadeInAnimationDuration > 0 {
                UIView.animate(withDuration: fadeInAnimationDuration,
                               delay: 0,
                               options: [.allowUserInteraction, .curveEaseIn, .beginFromCurrentState],
                               animations: animationsBlock,
                               completion: completionBlock)
            } else {
                animationsBlock()
                completionBlock(false)
            }
            
            self.setNeedsDisplay()
        
        } else {
            if let timer = data as? Timer,
                let duration = timer.userInfo as? TimeInterval,
                let fadeOutTimer = self.fadeOutTimer {
                self.fadeOutTimer = Timer(timeInterval: duration, target: self, selector: #selector(self.dismiss), userInfo: nil, repeats: false)
                RunLoop.main.add(fadeOutTimer, forMode: .common)
            }
        }
    }
    
    func fadeInEffects() {
        if defaultStyle != .custom {
            let blurEffectStyle = defaultStyle == .dark ? UIBlurEffect.Style.dark : UIBlurEffect.Style.light
            let blurEffect = UIBlurEffect(style: blurEffectStyle)
            hudView.effect = blurEffect
            hudView.backgroundColor = backgroundColorForStyle.withAlphaComponent(0.6)
        } else {
            hudView.effect = hudViewCustomBlurEffect
            hudView.backgroundColor = backgroundColorForStyle
        }
        
        backgroundView.alpha = 1
        imageView.alpha = 1
        statusLabel.alpha = 1
        indefiniteAnimatedView.alpha = 1
        ringView.alpha = 1
        backgroundRingView.alpha = 1
    }
    
    func fadeOutEffects() {
        if defaultStyle != .custom {
            hudView.effect = nil
        }
        
        hudView.backgroundColor = .clear
        
        backgroundView.alpha = 0
        imageView.alpha = 0
        statusLabel.alpha = 0
        indefiniteAnimatedView.alpha = 0
        ringView.alpha = 0
        backgroundRingView.alpha = 0
    }
    
    @objc func dismiss() {
        dismissWithDelay(delay: 0, completion: nil)
    }
    
    func dismissWithDelay(delay: TimeInterval, completion: (() -> Void)?) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HUDWillDisappear"), object: self, userInfo: nil) // TODO
            self.activityCount = 0
            
            let animationsBlock = { [weak self] in
                guard let self = self else { return }
                self.hudView.transform.scaledBy(x: 1/1.3, y: 1/1.3)
                self.fadeOutEffects()
            }
            let completionBlock = { [weak self] (_: Bool) in
                guard let self = self else { return }
                if self.backgroundView.alpha == 0 {
                    self.controlView.removeFromSuperview()
                    self.backgroundView.removeFromSuperview()
                    self.hudView.removeFromSuperview()
                    self.removeFromSuperview()
                    
                    self.progress = FMProgressHUD2.UNDEFINED_PROGRESS
                    self.cancelRingLayerAnimation()
                    self.cancelIndefiniteAnimatedViewAnimation()
                    
                    NotificationCenter.default.removeObserver(self)
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HUDDidDisappear"), object: self, userInfo: nil) // TODO
                    if let completion = completion {
                        completion()
                    }
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay) {
                self.graceTimer = nil
                if self.fadeOutAnimationDuration > 0 {
                    UIView.animate(withDuration: self.fadeOutAnimationDuration,
                                   delay: 0,
                                   options: [.allowUserInteraction, .curveEaseIn, .beginFromCurrentState],
                                   animations: animationsBlock,
                                   completion: completionBlock)
                }
            }
            
            self.setNeedsDisplay()
        }
    }
    
    // MARK - Show Methods
    
    static func show() {
        showWithStatus()
    }
    
    static func showWithStatus(status: String? = nil) {
        showProgress(progress: UNDEFINED_PROGRESS)
    }
    
    static func showProgress(progress: CGFloat, status: String? = nil) {
        FMProgressHUD2.sharedView.showProgress(progress: progress, status: status)
    }
    
    func showImage(image: UIImage, status: String, duration: TimeInterval) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.fadeOutTimer = nil
            self.graceTimer = nil
            self.updateViewHierarchy()
            self.progress = FMProgressHUD2.UNDEFINED_PROGRESS
            self.cancelRingLayerAnimation()
            self.cancelIndefiniteAnimatedViewAnimation()
            
            if self.shouldTintImages {
                self.imageView.tintColor = self.foregroundImageColorForStyle
            }
            self.imageView.image = image.withRenderingMode(.alwaysTemplate)
            self.imageView.isHidden = false
            
            self.statusLabel.isHidden = status.count == 0
            self.statusLabel.text = status
            
            if self.graceTimeInterval > 0 && self.backgroundView.alpha == 0,
               let graceTimer = self.graceTimer {
                self.graceTimer = Timer(timeInterval: self.graceTimeInterval, target: self, selector: #selector(self.fadeIn(data:)), userInfo: duration, repeats: false)
                RunLoop.main.add(graceTimer, forMode: .common)
            } else {
                self.fadeIn(data: duration)
            }
        }
    }
    
    func showProgress(progress: CGFloat, status: String? = nil) { // 763
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            if self.fadeOutTimer != nil {
                self.activityCount = 0
            }
            
            self.fadeOutTimer = nil
            self.graceTimer = nil
            
            self.updateViewHierarchy()
            
            self.statusLabel.isHidden = status?.isEmpty ?? true
            self.statusLabel.text = status
            self.progress = progress
            
            if progress >= 0 {
                self.cancelIndefiniteAnimatedViewAnimation()
                
                if self.ringView.superview == nil {
                    self.hudView.contentView.addSubview(self.ringView)
                }
                if self.backgroundRingView.superview == nil {
                    self.hudView.contentView.addSubview(self.backgroundRingView)
                }
                
                CATransaction.begin()
                CATransaction.setDisableActions(true)
                self.ringView.strokeEnd = self.progress
                CATransaction.commit()
                
                if progress == 0 {
                    self.activityCount += 1
                }
            } else {
                self.cancelRingLayerAnimation()
                self.hudView.contentView.addSubview(self.indefiniteAnimatedView)
//                self?.subviews[0].subviews[0] == self?.hudView.contentView
                // self?.subviews[0].subviews[0].subviews:
                //  [UILabel, FMIndefiniteAnimatedView]
                if let activityIndicator = self.indefiniteAnimatedView as? UIActivityIndicatorView {
                    activityIndicator.startAnimating()
                }
                
                self.activityCount += 1
            }
            
            if self.graceTimeInterval > 0 && self.backgroundView.alpha == 0,
               let graceTimer = self.graceTimer {
                self.graceTimer = Timer(timeInterval: self.graceTimeInterval, target: self, selector: #selector(self.fadeIn), userInfo: nil, repeats: false)
                RunLoop.main.add(graceTimer, forMode: .common)
            } else {
                self.fadeIn()
            }
            
            self.hapticGenerator?.prepare()
        }
    }
    
}
