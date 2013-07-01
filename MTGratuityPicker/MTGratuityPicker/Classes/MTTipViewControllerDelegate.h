//
//  MTTipViewControllerDelegate.h
//  MTGratuityPicker
//
//  Created by Matthew Teece on 7/1/13.
//  Copyright (c) 2013 Matthew Teece. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MTTipViewControllerDelegate <NSObject>
@required
- (void)didSelectTipAmount:(NSDecimalNumber *)tipAmount forTotalAmount:(NSDecimalNumber *)totalAmount atPercent: (int) percent;
@end
