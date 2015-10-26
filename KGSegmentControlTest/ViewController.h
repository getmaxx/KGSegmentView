//
//  ViewController.h
//  KGSegmentControlTest
//
//  Created by Игорь Веденеев on 26.10.15.
//  Copyright © 2015 Igor Vedeneev. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KGSegmentView;

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet KGSegmentView *segmentView;
@property (weak, nonatomic) IBOutlet UIView *testColorView;

@end

