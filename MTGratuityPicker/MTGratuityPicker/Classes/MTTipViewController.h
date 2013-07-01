//
//  MTTipViewController.h
//  MTGratuityPicker
//
//  Created by Matthew Teece on 7/1/13.
//  Copyright (c) 2013 Matthew Teece. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MTTipViewControllerDelegate.h"

typedef enum {
    MTTipViewControllerComponentDollarAmount = 0,
    MTTipViewControllerComponentPercentageAmount = 1,
    MTTipViewControllerComponentOther = 2
} MTTipViewControllerComponent;

@interface MTTipViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate, UIActionSheetDelegate>
{
    id <MTTipViewControllerDelegate> delegate;
    UIActionSheet *actionSheet;
    UIPickerView *dollarAmountPickerView;
    UIPickerView *percentageAmountPickerView;
    NSArray *dollarAmounts;
    NSArray *percentageAmounts;
    NSDecimalNumber *subTotal;
    NSDecimalNumber *tipAmount;
    int selectedIndex;
    UISegmentedControl *sgcAmount;
    NSString *accessoryTitle;
    NSString *addTipPrompt;
    NSString *cancelTipPrompt;
}

@property BOOL tipAdded;
@property (retain, nonatomic) id <MTTipViewControllerDelegate> delegate;
@property (nonatomic, strong) UIActionSheet *actionSheet;
@property (nonatomic, strong) UIPickerView *dollarAmountPickerView;
@property (nonatomic, strong) UIPickerView *percentageAmountPickerView;
@property (nonatomic, strong) NSArray *dollarAmounts;
@property (nonatomic, strong) NSArray *percentageAmounts;
@property (nonatomic, strong) NSDecimalNumber *subTotal;
@property (nonatomic, strong, setter = setTipAmount:) NSDecimalNumber *tipAmount;
@property (nonatomic, assign) int selectedIndex;
@property (nonatomic, strong) NSString *accessoryTitle;
@property (nonatomic, strong) NSString *addTipPrompt;
@property (nonatomic, strong) NSString *cancelTipPrompt;
@property (nonatomic, assign) MTTipViewControllerComponent defaultComponent;

- (id)initWithSubtotal:(NSDecimalNumber *)amount;
- (id)initWithSubtotalAndSelectedPercentage:(NSDecimalNumber *)amount selectedPercentage:(NSDecimalNumber *)percentage;
- (void)showInView;
- (void)showInParentView;
- (void)btnBarCancelClicked:(id)sender;
- (void)btnAddTipClicked:(id) sender;
- (void)btnDollarAmountClicked:(id) btnDollarAmountClicked;
- (void)btnPercentageAmountClicked:(id) btnDollarAmountClicked;
@end

