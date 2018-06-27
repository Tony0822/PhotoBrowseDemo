

#import <UIKit/UIKit.h>

@interface AdImageButtonView : UIView

@property (nonatomic , strong) UIButton * skipButton;

@property (nonatomic , strong) UIView * animationView;

@property (nonatomic , strong) CAShapeLayer * rightShapeLayer;

@property (nonatomic , strong) CAShapeLayer * leftShapeLayer;

@property (nonatomic , assign) CGFloat progress;

@property (nonatomic , assign) CGFloat rad;

@property (nonatomic , assign) CGFloat animationAngle;

@property (nonatomic , assign) CGFloat delayTime;

@end
