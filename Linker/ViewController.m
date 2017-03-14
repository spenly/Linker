//
//  ViewController.m
//  Linker
//
//  Created by spenly.jia on 2017/3/12.
//  Copyright © 2017年 spenly.jia. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *urlTextField;

@property (weak, nonatomic) IBOutlet UITextView *logTextView;
@property (strong, nonatomic) HTTPSession* httpSession;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.httpSession = [[HTTPSession alloc] init];
    __block ViewController* tmp = self;
    [self.httpSession setHttpGetCallBack:^(NSString *data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            tmp.logTextView.text =
            [NSString stringWithFormat:@"%@\n%@",tmp.logTextView.text, data];
//            if([data hasPrefix:REDIRECT]){
//                NSString * url = [data substringFromIndex:[REDIRECT length]+1 ];
//                NSLog(@"%@",url);
//                [tmp getResponse:url];
//            }
        });
    }];
    self.urlTextField.delegate = self;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)myClick:(id)sender {
    [self getResponse:[self getURL]];
}

- (NSString*) getURL{
    NSString *url = self.urlTextField.text;
    url = ( url.length==0 || ![url hasPrefix:@"http"])? @"": url;
    return url;
}

- (void)getResponse:(NSString*) url{
    if(url.length>0){
        [self.httpSession httpGet:url];
//        self.logTextView.text = [NSString stringWithFormat:@"start: %@", url];
        self.logTextView.text = @"start ...";
    }
    else{
        self.logTextView.text = @"invalid or empty url.";
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([textField isEqual:self.urlTextField]){
        NSString * url = [self getURL];
        [self getResponse:url];
    }
    return NO;
}


@end
