# MTGratuityPicker

## Overview

A custom UIActionSheet for adding tip/gratuity. Contains a UIPickerView, and accessories to handle tip/gratuity in dollar amounts as well as percentage amounts. Once a tip/gratuity is selected the Delegate is called returning the tip/gratuity amount, total, and percentage.

![Screenshot](https://raw.github.com/mteece/MTGratuityPicker/master/MTGratuityPicker/MTGratuityPicker/Images/mtgratuitypicker-1.png)


## Installation

### CocoaPods
* `pod 'MTGratuityPicker', '~> 0.0.2`
* Import the headers: `import <MTTipViewController.h>` `#import <MTTipViewControllerDelegate.h>`

### Manually

* Copy the `MTGratuityPicker/Classes` directory to your project.
* Import the headers: `#import "MTTipViewController.h"` `#import "MTTipViewControllerDelegate.h"`

## Example Code

Include the headers:

	#import "MTTipViewController.h" 
	#import "MTTipViewControllerDelegate.h"

Implement the delegate:

	@interface MTGratuityPickerExampleViewController : UIViewController <MTTipViewControllerDelegate>
	{

	}

Create an instance of the MTGratuityPicker: 

	NSDecimalNumber *total = [NSDecimalNumber decimalNumberWithString:@"25.50"];
	MTTipViewController  *tipController = [[MTTipViewController alloc] initWithSubtotalAndSelectedPercentage:total selectedPercentage:[NSDecimalNumber one]];
	
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

Show the MTGratuityPicker in the view:

	[tipController showInParentView];

Implement the delegate method `didSelectTipAmount`:

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

See the **Example** folder for a full example with a UIViewController.

You can also override the title, and button text. The UIPickerView uses the **NSLocaleCurrencySymbol** for the currency.

	[tipController setTitle:<#(NSString *)#>];
	[tipController setAddTipPrompt:<#(NSString *)#>];
    [tipController setCancelTipPrompt:<#(NSString *)#>];

### Creators

[Matthew Teece](http://github.com/mteece)
[@doctorteece](https://twitter.com/doctorteece)


## License

MTGratuityPicker is available under the MIT license. See the LICENSE file for more info.
