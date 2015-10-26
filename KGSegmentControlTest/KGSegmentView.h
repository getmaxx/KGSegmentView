//
//  KGSegmentView.h
//  DVSwitcherExample
//
//  Created by Dmitry Volevodz on 08.10.14.
//  Copyright (c) 2014 Dmitry Volevodz. All rights reserved.
//
//  Modified (c) 2015 Igor Vedeneev. All rights stolen. cya

#import <UIKit/UIKit.h>

IB_DESIGNABLE

@interface KGSegmentView : UIControl

@property (strong, nonatomic) IBInspectable UIColor *backgroundColor; // defaults to gray
@property (strong, nonatomic) IBInspectable UIColor *sliderColor; // defaults to white
@property (strong, nonatomic) IBInspectable UIColor *labelTextColorInsideSlider; // defaults to black
@property (strong, nonatomic) IBInspectable UIColor *labelTextColorOutsideSlider; // defaults to white
@property (strong, nonatomic) IBInspectable UIFont *font;
@property (nonatomic)         IBInspectable CGFloat  cornerRadius; // defaults to 12
@property (nonatomic)         IBInspectable CGFloat  sliderOffset; // slider offset from background, top, bottom, left, right

@property (strong, nonatomic, setter = setItems:) NSArray *strings; // labels in segment control

+ (instancetype)switchWithStringsArray:(NSArray *)strings;
- (instancetype)initWithStringsArray:(NSArray *)strings;

- (void)forceSelectedIndex:(NSInteger)index animated:(BOOL)animated; // sets the index, also calls handler block

// This method sets handler block that is getting called after the switcher is done animating the transition

- (void)setPressedHandler:(void (^)(NSUInteger index))handler;


// This method sets handler block that is getting called right before the switcher starts animating the transition

- (void)setWillBePressedHandler:(void (^)(NSUInteger index))handler;


@end