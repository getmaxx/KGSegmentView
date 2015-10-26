//
//  ViewController.m
//  KGSegmentControlTest
//
//  Created by Игорь Веденеев on 26.10.15.
//  Copyright © 2015 Igor Vedeneev. All rights reserved.
//

#import "ViewController.h"
#import "KGSegmentView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
     self.segmentView.font = [UIFont fontWithName:@"Avenir" size:15];
    
    KGSegmentView *testSeg = [[KGSegmentView alloc] initWithStringsArray:@[@"SKA", @"Basdasdasdasdas", @"CSKA"]];
    testSeg.frame = CGRectMake(30, 200, 250, 29);
    testSeg.labelTextColorInsideSlider = [UIColor whiteColor];
    testSeg.labelTextColorOutsideSlider = [UIColor lightGrayColor];
    testSeg.backgroundColor = [UIColor whiteColor];
    testSeg.sliderColor = [UIColor colorWithRed:1.0f green:0.5f blue:0.2f alpha:1.0f];
    testSeg.font = [UIFont fontWithName:@"Helvetica" size:15];
    [testSeg setItems:@[@"NEw", @"zomg"]];
    [self.view addSubview:testSeg];
    
    [testSeg setPressedHandler:^(NSUInteger index) {
        
        NSLog(@"Did press position on first switch at index: %lu", (unsigned long)index);
        switch (index) {
            case 0:
                self.testColorView.backgroundColor = [UIColor grayColor];
                break;
            case 1:
                self.testColorView.backgroundColor = [UIColor redColor];
                break;
            default:
                break;
        }
        
    }];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
