//
//  DataViewController.m
//  RFEventDemo
//
//  Created by GZH on 16/4/3.
//  Copyright © 2016年 GZH. All rights reserved.
//

#import "DataViewController.h"

@interface DataViewController ()

@end

@implementation DataViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	self.dataLabel.text = [self.dataObject description];
}

@end
