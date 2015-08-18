//
//  ViewController.m
//  WMHamburgerButton
//
//  Created by Mark on 15/8/18.
//  Copyright (c) 2015年 yq. All rights reserved.
//

#import "ViewController.h"
#import "WMHamburgerButton.h"
#import "Masonry.h"

@interface ViewController ()
@property (nonatomic, weak) WMHamburgerButton *hamburger;
@property (nonatomic, weak) UIView *maskView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"Hamburger";
    
    // autoLayout
    WMHamburgerButton *hamburger = [[WMHamburgerButton alloc] init];
    hamburger.tintColor = [UIColor colorWithRed:245.0/255. green:61.0/255.0 blue:73.0/255.0 alpha:1.0];
    [self.view addSubview:hamburger];
    [hamburger addTarget:self action:@selector(centerHamburgerPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.hamburger = hamburger;
    [hamburger mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(17, 15));
    }];
    
    // frame
    WMHamburgerButton *rightHamburger = [[WMHamburgerButton alloc] initWithFrame:CGRectMake(0, 0, 17, 15)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightHamburger];
    [rightHamburger addTarget:self action:@selector(rightPressed:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)rightPressed:(WMHamburgerButton *)sender {
    NSLog(@"rrrrrright pressed!! selected: %d",sender.selected);
}

- (void)centerHamburgerPressed:(WMHamburgerButton *)sender {
    UIView *maskView = [[UIView alloc] initWithFrame:self.view.bounds];
    maskView.backgroundColor = [UIColor blackColor];
    maskView.alpha = 0.3;
    self.maskView = maskView;
    [self.view addSubview:maskView];
    [maskView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(maskPressed:)]];
}

- (void)maskPressed:(UITapGestureRecognizer *)recognizer {
    [self.maskView removeFromSuperview];
    self.hamburger.selected = !self.hamburger.selected;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
