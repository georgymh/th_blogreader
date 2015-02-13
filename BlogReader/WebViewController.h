//
//  WebViewController.h
//  BlogReader
//
//  Created by Georgy Marrero on 1/6/15.
//  Copyright (c) 2015 Georgy Marrero. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) NSURL *blogPostURL;

@end