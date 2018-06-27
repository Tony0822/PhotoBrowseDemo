

#import "AdImageButtonView.h"

@implementation AdImageButtonView

-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.animationAngle = 10;
        
        self.animationView = [[UIView alloc] init];
        self.animationView.frame = self.bounds;
        self.animationView.backgroundColor = [UIColor clearColor];
        self.animationView.alpha = 0.7;
        self.animationView.clipsToBounds = NO;
        [self addSubview:self.animationView];
    
        self.rad = CGRectGetWidth(self.animationView.frame) / 2;
        
        self.leftShapeLayer = [CAShapeLayer layer];
        self.leftShapeLayer.frame = self.animationView.bounds;
        self.leftShapeLayer.fillColor = [UIColor clearColor].CGColor;
        self.leftShapeLayer.strokeColor = [UIColor redColor].CGColor;
        self.leftShapeLayer.lineWidth = 6.0;
        [self.animationView.layer addSublayer:self.leftShapeLayer];
        
        self.rightShapeLayer = [CAShapeLayer layer];
        self.rightShapeLayer.frame = self.animationView.bounds;
        self.rightShapeLayer.fillColor = [UIColor clearColor].CGColor;
        self.rightShapeLayer.strokeColor = [UIColor redColor].CGColor;
        self.rightShapeLayer.lineWidth = 6.0;
        [self.animationView.layer addSublayer:self.rightShapeLayer];
        
        self.skipButton = [[UIButton alloc] init];
        self.skipButton.frame = self.bounds;
        self.skipButton.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
        self.skipButton.layer.cornerRadius = self.rad;
        self.skipButton.layer.masksToBounds = YES;
        self.skipButton.titleLabel.font = [UIFont systemFontOfSize:11];
        [self.skipButton setTitle:@"跳过" forState:UIControlStateNormal];
        [self addSubview:self.skipButton];
        
        [self updateProgress];
        [self startAnimation];
    }
    return self;
}


-(void)updateProgress
{
    if (self.progress > 100) {
        return;
    }
    
    CGFloat angle = M_PI * (self.progress / 100 );
    CGFloat perMin = self.delayTime / 50;
    UIBezierPath *left = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.rad, self.rad) radius:self.rad startAngle:0 endAngle:angle clockwise:YES];
    self.leftShapeLayer.path = left.CGPath;
    
    UIBezierPath * right = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.rad, self.rad) radius:self.rad startAngle:M_PI endAngle:angle + M_PI clockwise:YES];
    self.rightShapeLayer.path = right.CGPath;
    
    self.progress += 2;
    
   __weak typeof(self)  weakself = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(perMin * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakself updateProgress];
    });
    
}

-(void)startAnimation
{
    if (self.progress > 100) {
        return;
    }
    
    CGAffineTransform  endAngle = CGAffineTransformMakeRotation(self.animationAngle * (M_PI / 180.0));
    __weak typeof(self)  weakself = self;
    [UIView animateWithDuration:0.1 animations:^{
        weakself.animationView.transform = endAngle;
    } completion:^(BOOL finished) {
        weakself.animationAngle += 10;
        [weakself startAnimation];
    }];
}

@end
