//
//  CustomSlider.swift
//  fmHUDApp
//
//  Created by Matchima Ditthawibun on 13/5/21.
//

// Code taken from: https://gist.github.com/jmcd/2499a901136df6f5c327216b27e4e6d4
class CustomSlider: UISlider {
    
    // indent the tracking so the thumb does not hang outside the view
    private let padding = CGFloat(18)
    
    // the default rect for tracking is indented by a few pixels; keep note of that value here
    private var trackIndent = CGFloat(0)
    
    // how far the thumb is indented from the edge of the control; expose this so things outside the control can use it, e.g. laying out labels
    var thumbIndent: CGFloat { return padding - trackIndent}
    
    // take the default track-rect and pad it left and right, and keep note of the few pixels of base implementation indent in trackIndent
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        let superTrackRect = super.trackRect(forBounds: bounds)
        trackIndent = superTrackRect.origin.x
        return CGRect(
            x: superTrackRect.origin.x + padding,
            y: superTrackRect.origin.y,
            width: superTrackRect.size.width - padding * 2,
            height: superTrackRect.size.height)
    }
    
    // take the default thumb-rect and allow it to overhang the left and right of the track-rect by half of its width
    override func thumbRect(forBounds bounds: CGRect, trackRect rect: CGRect, value: Float) -> CGRect {
        let superThumbRect = super.thumbRect(forBounds: bounds, trackRect: rect, value: value)
        let valueAsDecimalFraction = value == minimumValue ? 0 : (value - minimumValue)/(maximumValue - minimumValue)
        let valueAsDecimalFractionOfMinusOneToOne = (valueAsDecimalFraction * 2 - 1) / 2
        let xOffset = CGFloat(valueAsDecimalFractionOfMinusOneToOne) * superThumbRect.width
        return CGRect(
            x: superThumbRect.origin.x + xOffset,
            y: superThumbRect.origin.y,
            width: superThumbRect.size.width,
            height: superThumbRect.size.height)
    }
}
