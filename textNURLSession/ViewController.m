//
//  ViewController.m
//  textNURLSession
//
//  Created by Dmitriy Tarelkin on 25/5/18.
//  Copyright © 2018 Dmitriy Tarelkin. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib
    UIButton* downloadFileButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.view.frame) + 60,
                                                                              CGRectGetMidY(self.view.frame) - 15,
                                                                              CGRectGetMaxX(self.view.frame) - 120, 30)];
    [downloadFileButton setTitle:@"Download" forState:UIControlStateNormal];
    [downloadFileButton setBackgroundColor:[UIColor redColor]];
    [downloadFileButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [downloadFileButton.layer setCornerRadius:12];
    [downloadFileButton addTarget:self action:@selector(handleDownloadImageAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:downloadFileButton];
}


- (void)handleDownloadImageAction:(UIButton*)button {
    
    //animate button
    [self changeButton:button forState:UIControlStateHighlighted animated:YES];
    [self changeButton:button forState:UIControlStateNormal animated:YES];
    
    //download image using downloader
    [self downloadImageWithURL:[NSURL URLWithString:@"https://static.alphacoders.com/alpha_system_360.png"]
                withCompletion:^(UIImage * image) {
                    [self presentImageDetailsScreenWithImage:image];
                }];
  
    /********** using URLSessionDataTask **********
    
    [self downloadUsingSessionWithURL:[NSURL URLWithString:@"https://static.alphacoders.com/alpha_system_360.png"]];
    
    */
}


- (void)downloadUsingSessionWithURL:(NSURL*)url {
    NSURLSessionDataTask* downloadTask =
    [[NSURLSession sharedSession] dataTaskWithURL:url
                                completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        //background thread
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIImage *newImage = [UIImage imageWithData:data];
            
            //main thread
            dispatch_async(dispatch_get_main_queue(), ^{
                [self presentImageDetailsScreenWithImage:newImage];
            });
        });
    }];
    [downloadTask resume];
}

-(void)downloadImageWithURL:(NSURL*)url withCompletion:(void(^_Nullable)(UIImage*))completion {
    
        //background thread
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSData* imageData = [NSData dataWithContentsOfURL:url];
            UIImage *newImage = [UIImage imageWithData:imageData];
            
            //main thread
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(newImage);
            });
        });
}


- (void)changeButton:(UIButton*)button forState:(UIControlState)state animated:(BOOL)isAnimated {
    
    if (isAnimated) {
        [UIView animateWithDuration:1 animations:^{
            
            if (state == UIControlStateNormal) {
                button.backgroundColor = UIColor.redColor;
                
            } else {
                button.backgroundColor = UIColor.greenColor;
            }
        }];
    }
}



- (void)presentImageDetailsScreenWithImage:(UIImage*)image {
    
    //new image
    UIImageView *imgView = [[UIImageView alloc] initWithImage:image];
    CGFloat constraint = 30;
    imgView.frame = CGRectMake(CGRectGetMinX(self.view.frame) + constraint, CGRectGetMinY(self.view.frame) + constraint,
                               CGRectGetMaxX(self.view.frame) - 2 * constraint, CGRectGetMaxX(self.view.frame) - 2 * constraint) ;
    imgView.contentMode = UIViewContentModeCenter;
    imgView.layer.contentsGravity = kCAGravityResizeAspect;
    
    //create second view controller with new image
    UIViewController * vc2 = [[UIViewController alloc] init];
    vc2.view.backgroundColor = [UIColor colorWithRed: 31/255.f green: 31/255.f blue: 31/255.f alpha:1];
    [vc2.view addSubview:imgView];
    
    //present second view controller
    [self presentViewController:vc2 animated:YES completion:^{
        NSLog(@"second vc has been presented");
    }];
}



@end
