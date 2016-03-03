//
//  ViewController.m
//  CPLikeDemo
//
//  Created by Cooper on 3/3/16.
//  Copyright © 2016 Cooper. All rights reserved.
//

#import "ViewController.h"
#import "CPLikeAnimator.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *v1;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)like:(id)sender {
    CPLikeAnimator *animator = [CPLikeAnimator new];
    [animator animateOnView:self.view atPoint:self.v1.center];
}

@end
