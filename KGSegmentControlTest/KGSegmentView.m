//
//  KGSegmentView.h
//  DVSwitcherExample
//
//  Created by Dmitry Volevodz on 08.10.14.
//  Copyright (c) 2014 Dmitry Volevodz. All rights reserved.
//
//  Modified (c) 2015 Igor Vedeneev. All rights stolen. cya

#import "KGSegmentView.h"

@interface KGSegmentView ()

@property (strong, nonatomic) NSMutableArray *labels;
@property (strong, nonatomic) NSMutableArray *onTopLabels;


@property (strong, nonatomic) void (^handlerBlock)(NSUInteger index);
@property (strong, nonatomic) void (^willBePressedHandlerBlock)(NSUInteger index);

@property (strong, nonatomic) UIView *backgroundView;
@property (strong, nonatomic) UIView *sliderView;

@property (nonatomic) NSInteger selectedIndex;

@property (strong, nonatomic) UIView *borderView;

@end

static const NSTimeInterval kAnimationDuration = 0.3f;

@implementation KGSegmentView

#pragma mark - Initialization

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [NSException raise:@"DVSwitchInitException" format:@"Init call is prohibited, use initWithStringsArray: method"];
    }
    
    return self;
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder {
    NSLog(@"%s", __FUNCTION__);
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self defaultSettings];
        //[self setup];
    }
    
    return self;
}

 + (instancetype)switchWithStringsArray:(NSArray *)strings
{
    // to do
    return [[KGSegmentView alloc] initWithStringsArray:strings];
}

- (instancetype)initWithStringsArray:(NSArray *)strings
{
    self = [super init];
    
    self.strings = strings;
    [self setup];
    
    return self;
}

- (instancetype) initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        [self defaultSettings];
    }
    
    return self;
}

- (void) defaultSettings {
    
    self.strings = @[@"First", @"Second"];
    
    [self defaultSegmentApperiance];
    [self setup];
}

#pragma mark - Methods for setup settings

- (void) defaultSegmentApperiance {
    
    //segment apperiance
    self.cornerRadius = self.frame.size.height / 2;
    self.layer.cornerRadius = self.cornerRadius;
    self.sliderOffset = 0.0f;
    
    self.backgroundColor = [UIColor whiteColor];
    self.sliderColor = [UIColor redColor];
    self.labelTextColorInsideSlider = [UIColor whiteColor];
    self.labelTextColorOutsideSlider = [UIColor lightGrayColor];

}

- (void) setup {
    
    self.backgroundView = [[UIView alloc] init];
    self.backgroundView.backgroundColor = self.backgroundColor;
    //self.backgroundView.layer.borderWidth = 1.5f;
    //self.backgroundView.layer.borderColor = [UIColor redColor].CGColor;
    self.backgroundView.userInteractionEnabled = YES;
    [self addSubview:self.backgroundView];
    
    self.labels = [[NSMutableArray alloc] init];
    
    for (int k = 0; k < [self.strings count]; k++) {
        
        NSString *string = self.strings[k];
        UILabel *label = [[UILabel alloc] init];
        label.tag = k;
        label.text = string;
        label.font = self.font;
        label.adjustsFontSizeToFitWidth = YES;
        label.adjustsLetterSpacingToFitWidth = YES;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = self.labelTextColorOutsideSlider;
        [self.backgroundView addSubview:label];
        [self.labels addObject:label];
        
        UITapGestureRecognizer *rec = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleRecognizerTap:)];
        [label addGestureRecognizer:rec];
        label.userInteractionEnabled = YES;
    }
    
    self.borderView = [[UIView alloc] init];
    self.borderView.layer.cornerRadius = self.cornerRadius;
    self.borderView.layer.borderWidth = 1.5f;
    self.borderView.layer.borderColor = self.labelTextColorOutsideSlider.CGColor;
    self.borderView.clipsToBounds = YES;
    [self addSubview: self.borderView];
    
    
    self.sliderView = [[UIView alloc] init];
    self.sliderView.backgroundColor = self.sliderColor;
    self.sliderView.clipsToBounds = YES;
    [self addSubview:self.sliderView];
    
    self.onTopLabels = [[NSMutableArray alloc] init];
    
    for (NSString *string in self.strings) {
        
        UILabel *label = [[UILabel alloc] init];
        label.text = string;
        label.font = self.font;
        label.adjustsFontSizeToFitWidth = YES;
        label.adjustsLetterSpacingToFitWidth = YES;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = self.labelTextColorInsideSlider;
        [self.sliderView addSubview:label];
        [self.onTopLabels addObject:label];
    }
    
    UIPanGestureRecognizer *sliderRec = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(sliderMoved:)];
    [self.sliderView addGestureRecognizer:sliderRec];
}

#pragma mark - UIView lifecycle

- (void) didMoveToWindow {
    [super didMoveToWindow];
    
    //NSLog(@"%s %f",__FUNCTION__, self.frame.size.height / 2);
    self.cornerRadius = self.frame.size.height / 2;
    self.layer.cornerRadius = self.cornerRadius;
    [self setup];
}

/*- (void) drawRect:(CGRect)rect {
    
    NSLog(@"%s",__FUNCTION__);
    //[self setup];
    self.cornerRadius = self.frame.size.height / 2;
    self.layer.cornerRadius = self.cornerRadius;
}*/

- (void)layoutSubviews {
    
    self.backgroundView.layer.borderWidth = 1.0f;
    self.backgroundView.layer.borderColor = self.labelTextColorOutsideSlider.CGColor;
    
    self.cornerRadius = self.frame.size.height / 2;
    //NSLog(@"%f", self.cornerRadius);
    NSLog(@"%s", __FUNCTION__);

    self.backgroundView.layer.cornerRadius = self.cornerRadius;
    self.sliderView.layer.cornerRadius = self.cornerRadius;
    
    self.backgroundView.backgroundColor = self.backgroundColor;
    self.sliderView.backgroundColor = self.sliderColor;
    
    self.backgroundView.frame = [self convertRect:self.frame fromView:self.superview];
    
    self.backgroundView.layer.cornerRadius = self.cornerRadius;
    self.sliderView.layer.cornerRadius = self.cornerRadius;
    
    CGFloat sliderWidth = self.frame.size.width / [self.strings count];
    
    self.sliderView.frame = CGRectMake(sliderWidth * self.selectedIndex + self.sliderOffset, self.backgroundView.frame.origin.y + self.sliderOffset, sliderWidth - self.sliderOffset * 2, self.frame.size.height - self.sliderOffset * 2);
    
    for (int i = 0; i < [self.labels count]; i++) {
        
        UILabel *label = self.labels[i];
        label.frame = CGRectMake(i * sliderWidth, 0, sliderWidth, self.frame.size.height);
        label.font = self.font;
        label.textColor = self.labelTextColorOutsideSlider;
    }
    
    for (int j = 0; j < [self.onTopLabels count]; j++) {
        
        UILabel *label = self.onTopLabels[j];
        label.frame = CGRectMake([self.sliderView convertPoint:CGPointMake(j * sliderWidth, 0) fromView:self.backgroundView].x, - self.sliderOffset, sliderWidth, self.frame.size.height);
        label.font = self.font;
        label.textColor = self.labelTextColorInsideSlider;
    }
    
    //[self setup];
}


#pragma mark - Action Handlers

- (void)setPressedHandler:(void (^)(NSUInteger))handler {
    
    self.handlerBlock = handler;
}

- (void)setWillBePressedHandler:(void (^)(NSUInteger))handler {
    
    self.willBePressedHandlerBlock = handler;
}

#pragma mark - Animations

- (void)forceSelectedIndex:(NSInteger)index animated:(BOOL)animated {
    
    if (index > [self.strings count]) {
        return;
    }
    
    self.selectedIndex = index;
    
    if (animated) {
        
        [self animateChangeToIndex:index];
        
    } else {
        
        [self changeToIndexWithoutAnimation:index];
    }
}


- (void)animateChangeToIndex:(NSUInteger)selectedIndex
{
    
    if (self.willBePressedHandlerBlock) {
        self.willBePressedHandlerBlock(selectedIndex);
    }
    
    [UIView animateWithDuration:kAnimationDuration delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        CGFloat sliderWidth = self.frame.size.width / [self.strings count];
        
        CGRect oldFrame = self.sliderView.frame;
        CGRect newFrame = CGRectMake(sliderWidth * self.selectedIndex + self.sliderOffset, self.backgroundView.frame.origin.y + self.sliderOffset, sliderWidth - self.sliderOffset * 2, self.frame.size.height - self.sliderOffset * 2);
        
        CGRect offRect = CGRectMake(newFrame.origin.x - oldFrame.origin.x, newFrame.origin.y - oldFrame.origin.y, 0, 0);
        
        self.sliderView.frame = newFrame;
        
        for (UILabel *label in self.onTopLabels) {
            
            label.frame = CGRectMake(label.frame.origin.x - offRect.origin.x, label.frame.origin.y - offRect.origin.y, label.frame.size.width, label.frame.size.height);
        }
        
    } completion:^(BOOL finished) {
        
        if (self.handlerBlock) {
            self.handlerBlock(selectedIndex);
        }
    }];
}

- (void)changeToIndexWithoutAnimation:(NSUInteger)selectedIndex {
    
    if (self.willBePressedHandlerBlock) {
        self.willBePressedHandlerBlock(selectedIndex);
    }
    
    CGFloat sliderWidth = self.frame.size.width / [self.strings count];
    
    CGRect oldFrame = self.sliderView.frame;
    CGRect newFrame = CGRectMake(sliderWidth * self.selectedIndex + self.sliderOffset, self.backgroundView.frame.origin.y + self.sliderOffset, sliderWidth - self.sliderOffset * 2, self.frame.size.height - self.sliderOffset * 2);
    
    CGRect offRect = CGRectMake(newFrame.origin.x - oldFrame.origin.x, newFrame.origin.y - oldFrame.origin.y, 0, 0);
    
    self.sliderView.frame = newFrame;
    
    for (UILabel *label in self.onTopLabels) {
        
        label.frame = CGRectMake(label.frame.origin.x - offRect.origin.x, label.frame.origin.y - offRect.origin.y, label.frame.size.width, label.frame.size.height);
    }
    
    if (self.handlerBlock) {
        self.handlerBlock(selectedIndex);
    }
}

- (void)handleRecognizerTap:(UITapGestureRecognizer *)rec {
    self.selectedIndex = rec.view.tag;
    [self animateChangeToIndex:self.selectedIndex];
}

- (void)sliderMoved:(UIPanGestureRecognizer *)rec {
    
   if (rec.state == UIGestureRecognizerStateChanged) {
        
        CGRect oldFrame = self.sliderView.frame;
        
        CGFloat minPos = 0 + self.sliderOffset;
        CGFloat maxPos = self.frame.size.width - self.sliderOffset - self.sliderView.frame.size.width;
        
        CGPoint center = rec.view.center;
        CGPoint translation = [rec translationInView:rec.view];
        
        center = CGPointMake(center.x + translation.x, center.y);
        rec.view.center = center;
        [rec setTranslation:CGPointZero inView:rec.view];
        
        if (self.sliderView.frame.origin.x < minPos) {
            
            self.sliderView.frame = CGRectMake(minPos, self.sliderView.frame.origin.y, self.sliderView.frame.size.width, self.sliderView.frame.size.height);
            
        } else if (self.sliderView.frame.origin.x > maxPos) {
            
            self.sliderView.frame = CGRectMake(maxPos, self.sliderView.frame.origin.y, self.sliderView.frame.size.width, self.sliderView.frame.size.height);
        }

        CGRect newFrame = self.sliderView.frame;
        CGRect offRect = CGRectMake(newFrame.origin.x - oldFrame.origin.x, newFrame.origin.y - oldFrame.origin.y, 0, 0);
        
        for (UILabel *label in self.onTopLabels) {
            
            label.frame = CGRectMake(label.frame.origin.x - offRect.origin.x, label.frame.origin.y - offRect.origin.y, label.frame.size.width, label.frame.size.height);
        }
        
    } else if (rec.state == UIGestureRecognizerStateEnded || rec.state == UIGestureRecognizerStateCancelled || rec.state == UIGestureRecognizerStateFailed) {

        NSMutableArray *distances = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < [self.strings count]; i++) {
            
            CGFloat possibleX = i * self.sliderView.frame.size.width;
            CGFloat distance = possibleX - self.sliderView.frame.origin.x;
            [distances addObject:@(fabs(distance))];
        }
        
        NSNumber *num = [distances valueForKeyPath:@"@min.doubleValue"];
        NSInteger index = [distances indexOfObject:num];
        
        if (self.willBePressedHandlerBlock) {
            self.willBePressedHandlerBlock(index);
        }
        
        CGFloat sliderWidth = self.frame.size.width / [self.strings count];
        CGFloat desiredX = sliderWidth * index + self.sliderOffset;

        if (self.sliderView.frame.origin.x != desiredX) {
            
            CGRect evenOlderFrame = self.sliderView.frame;
            
            CGFloat distance = desiredX - self.sliderView.frame.origin.x;
            CGFloat time = fabs(distance / 300);
            
            [UIView animateWithDuration:time animations:^{
               
                self.sliderView.frame = CGRectMake(desiredX, self.sliderView.frame.origin.y, self.sliderView.frame.size.width, self.sliderView.frame.size.height);
                
                CGRect newFrame = self.sliderView.frame;
                
                CGRect offRect = CGRectMake(newFrame.origin.x - evenOlderFrame.origin.x, newFrame.origin.y - evenOlderFrame.origin.y, 0, 0);
                
                for (UILabel *label in self.onTopLabels) {
                    
                    label.frame = CGRectMake(label.frame.origin.x - offRect.origin.x, label.frame.origin.y - offRect.origin.y, label.frame.size.width, label.frame.size.height);
                }
            } completion:^(BOOL finished) {
               
                self.selectedIndex = index;
                
                if (self.handlerBlock) {
                    self.handlerBlock(index);
                }
                
            }];
            
        } else {
            
                self.selectedIndex = index;
                if (self.handlerBlock) {
                    self.handlerBlock(self.selectedIndex);
                }
        }
    }
}

@end

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com 
