//
//  BSRaceLampView.m
//  10000ui-swift
//
//  Created by 张亚东 on 15/12/18.
//  Copyright © 2015年 blurryssky. All rights reserved.
//

#import "BSRaceLampView.h"
#import <CoreText/CoreText.h>

static const CGFloat GradientWidth = 25;
static const CGFloat LabelSpacing = 20;
static const CGFloat Velocity = 50;
static const NSTimeInterval StayTimeInterval = 4;
static const CGFloat FontSize = 17;

@interface BSRaceLampView ()

@property (strong, nonatomic) CAGradientLayer *gradientLayer;
@property (strong, nonatomic) UIView *animationView;
@property (strong, nonatomic) UILabel *firstLabel;
@property (strong, nonatomic) UILabel *secondLabel;
@property (strong, nonatomic) CABasicAnimation *positionXAnimation;
@property (strong, nonatomic) CAAnimationGroup *delayPositionXAnimationGroup;

@end

@implementation BSRaceLampView

#pragma mark - Override

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self display];
}

#pragma mark - Private

- (void)setup {
    [self setupVars];
    [self setupView];
    [self setupSubviews];
}

- (void)setupVars {
    _gradientWidth = GradientWidth;
    _labelSpacing = LabelSpacing;
    _velocity = Velocity;
    _stayTimeInterval = StayTimeInterval;
    // setter
    self.font = [UIFont systemFontOfSize:FontSize];
}

- (void)setupView {
    self.clipsToBounds = YES;
    self.layer.mask = self.gradientLayer;
}

- (void)setupSubviews {
    [self addSubview:self.animationView];
    [self.animationView addSubview:self.firstLabel];
    [self.animationView addSubview:self.secondLabel];
}

- (void)display {
    if ((_text == nil || _text.length == 0) &&
        (_attributedText == nil || _attributedText.length == 0)) {
        return;
    }
    
    // prepare
    _gradientLayer.frame = self.bounds;
    _gradientLayer.locations  = @[@(0),
                                  @(_gradientWidth/self.bounds.size.width),
                                  @(1 - _gradientWidth/self.bounds.size.width),
                                  @(1)];
    _animationView.frame = CGRectMake(_gradientWidth, 0, self.bounds.size.width - _gradientWidth * 2, self.bounds.size.height);
    self.positionXAnimation.beginTime = _beginTime;
    [_animationView.layer removeAllAnimations];
    
    //
    CGFloat textWidth = [self getCorrectTextWidth];
    CGFloat firstLabelWidth = 0;
    if (_velocity != 0) {
        firstLabelWidth = textWidth + _labelSpacing;
        
        _firstLabel.textAlignment = NSTextAlignmentLeft;
        _secondLabel.hidden = NO;
        
        NSTimeInterval playDuration = firstLabelWidth/_velocity;
        _positionXAnimation.duration = playDuration;
        _positionXAnimation.toValue = @(-firstLabelWidth + self.bounds.size.width/2);
        self.delayPositionXAnimationGroup.duration = playDuration + _stayTimeInterval;
        [self.animationView.layer addAnimation:_delayPositionXAnimationGroup forKey:@"group"];
        
    } else {
        
        firstLabelWidth = textWidth;
        
        _firstLabel.textAlignment = NSTextAlignmentCenter;
        _secondLabel.hidden = YES;
    }
    _firstLabel.frame = CGRectMake(0, 0, firstLabelWidth, self.bounds.size.height);
    _secondLabel.frame = CGRectOffset(_firstLabel.frame, firstLabelWidth, 0);
}

- (CGFloat)getCorrectTextWidth {
    
    NSAttributedString *aAttributedString = nil;
    if (_attributedText) {
        aAttributedString = _attributedText;
    } else {
        aAttributedString = [[NSAttributedString alloc] initWithString:_text attributes:@{NSFontAttributeName:_font}];
    }
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)aAttributedString);
    CGSize targetSize = CGSizeMake(CGFLOAT_MAX, 0);
    CGSize fitSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, [aAttributedString length]), NULL, targetSize, NULL);
    CFRelease(framesetter);
    
    return fitSize.width;
}

#pragma mark - Getter
- (CAGradientLayer *)gradientLayer {
    if (!_gradientLayer) {
        _gradientLayer = [CAGradientLayer layer];
        _gradientLayer.colors = @[(__bridge id)[UIColor clearColor].CGColor,
                                  (__bridge id)[UIColor blackColor].CGColor,
                                  (__bridge id)[UIColor blackColor].CGColor,
                                  (__bridge id)[UIColor clearColor].CGColor];
        _gradientLayer.startPoint = CGPointMake(0, 0);
        _gradientLayer.endPoint   = CGPointMake(1, 0);
    }
    return _gradientLayer;
}

- (UIView *)animationView {
    if (!_animationView) {
        _animationView = [UIView new];
        _animationView.backgroundColor = [UIColor clearColor];
    }
    return _animationView;
}

- (UILabel *)firstLabel {
    if (!_firstLabel) {
        _firstLabel = [UILabel new];
        _firstLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _firstLabel;
}

- (UILabel *)secondLabel {
    if (!_secondLabel) {
        _secondLabel = [UILabel new];
        _secondLabel.textAlignment = NSTextAlignmentLeft;
        _secondLabel.hidden = YES;
    }
    return _secondLabel;
}

- (CABasicAnimation *)positionXAnimation {
    if (!_positionXAnimation) {
        _positionXAnimation = [CABasicAnimation animationWithKeyPath:@"position.x"];
        _positionXAnimation.fromValue = @(self.bounds.size.width/2);
    }
    return _positionXAnimation;
}

- (CAAnimationGroup *)delayPositionXAnimationGroup {
    if (!_delayPositionXAnimationGroup) {
        _delayPositionXAnimationGroup = [CAAnimationGroup animation];
        _delayPositionXAnimationGroup.animations = @[[CABasicAnimation new],self.positionXAnimation];
        _delayPositionXAnimationGroup.repeatCount = HUGE;
        _delayPositionXAnimationGroup.fillMode = kCAFillModeBackwards;
    }
    return _delayPositionXAnimationGroup;
}

#pragma mark - Setter

- (void)setFont:(UIFont *)font {
    if (_font != font) {
        _font = font;
        
        self.firstLabel.font = font;
        self.secondLabel.font = font;
    }
}

- (void)setTextColor:(UIColor *)textColor {
    if (_textColor != textColor) {
        _textColor = textColor;
        
        _firstLabel.textColor = textColor;
        _secondLabel.textColor = textColor;
    }
}

- (void)setText:(NSString *)text {
    if (_text != text) {
        _text = text;
        
        _firstLabel.text = text;
        _secondLabel.text = text;
        
        [self setNeedsLayout];
        [self layoutIfNeeded];
    }
}

- (void)setAttributedText:(NSAttributedString *)attributedText {
    if (_attributedText != attributedText) {
        _attributedText = attributedText;
        
        _firstLabel.attributedText = attributedText;
        _secondLabel.attributedText = attributedText;
        
        [self setNeedsLayout];
        [self layoutIfNeeded];
    }
}

- (void)setVelocity:(CGFloat)velocity {
    if (_velocity != velocity) {
        _velocity = velocity;
        
        [self setNeedsLayout];
        [self layoutIfNeeded];
    }
}

@end
