//
//  MTGratuityPickerExampleViewController.h
//  MTGratuityPicker
//
//  Created by Matthew Teece on 7/1/13.
//  Copyright (c) 2013 Matthew Teece. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MTTipViewController.h"
#import "MTTipViewControllerDelegate.h"

@interface MTGratuityPickerExampleViewController : UIViewController <MTTipViewControllerDelegate>
{
     MTTipViewController *tipController;
}

@property (nonatomic, strong) MTTipViewController *tipController;
@property (weak, nonatomic) IBOutlet UIButton *btnTip;
@property (weak, nonatomic) IBOutlet UILabel *lblTotalAmount;
@property (weak, nonatomic) IBOutlet UILabel *lblSubTotalAmount;
@property (weak, nonatomic) IBOutlet UILabel *lblSubTotal;
@property (weak, nonatomic) IBOutlet UILabel *lblTotal;
@property (weak, nonatomic) IBOutlet UILabel *lblTip;
@property (weak, nonatomic) IBOutlet UILabel *lblTipAmount;

@end
