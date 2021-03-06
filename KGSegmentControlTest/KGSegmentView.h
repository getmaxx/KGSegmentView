//
//  KGSegmentView.h
//  DVSwitcherExample
//
//  Created by Dmitry Volevodz on 08.10.14.
//  Copyright (c) 2014 Dmitry Volevodz. All rights reserved.
//
//  Modified (c) 2015 Igor Vedeneev. All rights stolen. cya

#import <UIKit/UIKit.h>

@interface KGSegmentView : UIControl

@property (strong, nonatomic)  UIColor *backgroundColor; // defaults to gray
@property (strong, nonatomic)  UIColor *sliderColor; // defaults to white
@property (strong, nonatomic)  UIColor *labelTextColorInsideSlider; // defaults to black
@property (strong, nonatomic)  UIColor *labelTextColorOutsideSlider; // defaults to white
@property (strong, nonatomic)  UIFont *font;
@property (nonatomic)          CGFloat  cornerRadius; // defaults to 12
@property (nonatomic)          CGFloat  sliderOffset; // slider offset from background, top, bottom, left, right

@property (strong, nonatomic, setter = setItems:) NSArray *strings; // labels in segment control

+ (instancetype)switchWithStringsArray:(NSArray *)strings;
- (instancetype)initWithStringsArray:(NSArray *)strings;

- (void)forceSelectedIndex:(NSInteger)index animated:(BOOL)animated; // sets the index, also calls handler block

// This method sets handler block that is getting called after the switcher is done animating the transition

- (void)setPressedHandler:(void (^)(NSUInteger index))handler;


// This method sets handler block that is getting called right before the switcher starts animating the transition

- (void)setWillBePressedHandler:(void (^)(NSUInteger index))handler;


@end