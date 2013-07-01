//
//  MTGratuityPickerExampleViewController.m
//  MTGratuityPicker
//
//  Created by Matthew Teece on 7/1/13.
//  Copyright (c) 2013 Matthew Teece. All rights reserved.
//

#import "MTGratuityPickerExampleViewController.h"

@interface MTGratuityPickerExampleViewController ()

@end

@implementation MTGratuityPickerExampleViewController

@synthesize tipController, btnTip, lblSubTotalAmount, lblTotalAmount,lblSubTotal, lblTotal, lblTip, lblTipAmount;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [btnTip addTarget:self action:@selector(btnTipTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [btnTip setTitle:@"Tip" forState:UIControlStateNormal];
    
    NSDecimalNumber *total = [NSDecimalNumber decimalNumberWithString:@"25.50"];
    [lblTotal setText:@"Total:"];
    [lblSubTotal setText:@"Subtotal:"];
    [lblTip setText:@"Tip:"];
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
    [lblSubTotalAmount setText:[numberFormatter stringFromNumber:total]];
    [lblTotalAmount setText:[numberFormatter stringFromNumber:total]];
    [lblTipAmount setText:[numberFormatter stringFromNumber:[NSDecimalNumber zero]]];
    
    tipController = [[MTTipViewController alloc] initWithSubtotalAndSelectedPercentage:total selectedPercentage:[NSDecimalNumber one]];
    
    CGRect frame = CGRectMake(tipController.view.frame.origin.x,
                              self.view.frame.size.height,
                              tipController.view.frame.size.width,
                              tipController.view.frame.size.height);
    
    tipController.view.frame = frame;
    [tipController setDelegate:self];
    [self addChildViewController:tipController];
    [tipController viewWillAppear:YES];
    [self.view addSubview:tipController.view];
    [tipController viewDidAppear:YES];
    [tipController didMoveToParentViewController:self];
}

- (void)viewDidUnload {
    [self setBtnTip:nil];
    [self setLblTotalAmount:nil];
    [self setLblSubTotalAmount:nil];
    [self setLblSubTotal:nil];
    [self setLblTotal:nil];
    [self setLblTip:nil];
    [self setLblTipAmount:nil];
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark MTGratuityPickerExampleViewController Class Methods

- (void) btnTipTouchUpInside:(id) sender
{
    [tipController showInParentView];
}

#pragma mark -
#pragma mark MTTipViewControllerDelegate Methods

- (void)didSelectTipAmount:(NSDecimalNumber *)tipAmount forTotalAmount:(NSDecimalNumber *)totalAmount atPercent:(int) percent
{
    NSLog(@"Delegate Selected %@ for %@", tipAmount, totalAmount);
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
    [lblTotalAmount setText:[numberFormatter stringFromNumber:totalAmount]];
    [lblTipAmount setText:[numberFormatter stringFromNumber:tipAmount]];
}
@end
