//
//  MTTipViewController.m
//  MTGratuityPicker
//
//  Created by Matthew Teece on 7/1/13.
//  Copyright (c) 2013 Matthew Teece. All rights reserved.
//

#import "MTTipViewController.h"

#define kDollarAmountTag 1
#define kPercentageAmountTag 2

@interface MTTipViewController ()

@end

@implementation MTTipViewController

@synthesize delegate;
@synthesize actionSheet;
@synthesize dollarAmountPickerView;
@synthesize percentageAmountPickerView;
@synthesize dollarAmounts;
@synthesize percentageAmounts;
@synthesize subTotal;
@synthesize tipAmount;
@synthesize selectedIndex;
@synthesize tipAdded;
@synthesize accessoryTitle;
@synthesize addTipPrompt;
@synthesize cancelTipPrompt;

- (instancetype) initWithSubtotal:(NSDecimalNumber *)amount
{
    self = [super initWithNibName:@"MTTipViewController" bundle:nil];
    if (self) {
        // Custom initialization
        [self setTipAmount:[NSDecimalNumber zero]];
        [self setSubTotal:amount];
        [self setSelectedIndex:1];
        [self setDefaultComponent:MTTipViewControllerComponentDollarAmount];
    }
    return self;
}

- (instancetype)initWithSubtotalAndSelectedPercentage:(NSDecimalNumber *)amount selectedPercentage:(NSDecimalNumber *)percentage
{
    self = [super initWithNibName:@"MTTipViewController" bundle:nil];
    if (self) {
        // Custom initialization
        [self setTipAmount:[NSDecimalNumber zero]];
        [self setSubTotal:amount];
        [self setSelectedIndex:[percentage intValue] - 1 > 0 ? [percentage intValue] - 1 : 1];
        [self setDefaultComponent:MTTipViewControllerComponentPercentageAmount];
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self setSubTotal:[NSDecimalNumber zero]];
        [self setSelectedIndex:1];
        [self setDefaultComponent:MTTipViewControllerComponentDollarAmount];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor clearColor]];
    
    NSMutableArray *dollarData = [[NSMutableArray alloc] init];
    NSMutableArray *percentageData = [[NSMutableArray alloc] init];
    NSDecimalNumberHandler *plainRounding = [NSDecimalNumberHandler
                                             decimalNumberHandlerWithRoundingMode:NSRoundPlain
                                             scale:2
                                             raiseOnExactness:YES
                                             raiseOnOverflow:YES
                                             raiseOnUnderflow:YES
                                             raiseOnDivideByZero:YES];
    
	for(int i = 0; i < 100; i++) {
        NSDecimalNumber *base = [[NSDecimalNumber alloc] initWithInt:i+1];
        [dollarData insertObject:base atIndex:i];
        NSDecimalNumber *percentage = [base decimalNumberByDividingBy:[[NSDecimalNumber alloc] initWithInt:100]];
        NSDecimalNumber *percentageAmount = [percentage decimalNumberByMultiplyingBy:[self subTotal] withBehavior:plainRounding];
        [percentageData insertObject:percentageAmount atIndex:i];
    }
    
    [self setDollarAmounts:dollarData];
    [self setPercentageAmounts:percentageData];
    
    if ([self accessoryTitle] == nil) {
        [self setAccessoryTitle:@"Tip"];
    }
    
    actionSheet = [[UIActionSheet alloc] initWithTitle:accessoryTitle delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    
    dollarAmountPickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0.0, 44.0, 320.0, 250.0)];
    dollarAmountPickerView.delegate = self;
    dollarAmountPickerView.dataSource = self;
    dollarAmountPickerView.showsSelectionIndicator = YES;
    dollarAmountPickerView.tag = kDollarAmountTag;
    
    percentageAmountPickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0.0, 44.0, 320.0, 250.0)];
    percentageAmountPickerView.delegate = self;
    percentageAmountPickerView.dataSource = self;
    percentageAmountPickerView.showsSelectionIndicator = YES;
    percentageAmountPickerView.tag = kPercentageAmountTag;
    
    UIToolbar *pickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    pickerToolbar.barStyle = UIBarStyleBlackTranslucent;
    [pickerToolbar sizeToFit];
    
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    NSString *symbol = [[NSLocale currentLocale] objectForKey:NSLocaleCurrencySymbol];
    NSArray *itemArray = [NSArray arrayWithObjects: symbol, @"%", nil];
    sgcAmount = [[UISegmentedControl alloc] initWithItems:itemArray];
    sgcAmount.segmentedControlStyle = UISegmentedControlStyleBar;
    sgcAmount.selectedSegmentIndex = 1;
    sgcAmount.momentary = NO;
    [sgcAmount setTintColor:[UIColor lightGrayColor]];
    //[[[sgcAmount subviews] objectAtIndex:0] setTintColor:[UIColor darkGrayColor]];
    //[[[sgcAmount subviews] objectAtIndex:1] setTintColor:[UIColor darkGrayColor]];
    [sgcAmount addTarget:self action:@selector(sgcAmountToggle:) forControlEvents:UIControlEventValueChanged];
    
    UIBarButtonItem *segBarBtn = [[UIBarButtonItem alloc] initWithCustomView:sgcAmount];
    [barItems addObject:segBarBtn];
    
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    [barItems addObject:flexSpace];
    
    if ([self cancelTipPrompt] == nil || [[self cancelTipPrompt] length] <= 0) {
        [self setCancelTipPrompt:@"Cancel"];
    }
    
    UIBarButtonItem *btnBarCancel = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(btnBarCancelClicked:)];
    btnBarCancel.possibleTitles = [NSSet setWithObjects:[self cancelTipPrompt], @"Void", nil];
    btnBarCancel.tintColor = [UIColor grayColor];
    [barItems addObject:btnBarCancel];
    
    if ([self addTipPrompt] == nil || [[self addTipPrompt] length] <= 0) {
        [self setAddTipPrompt:@"Add Tip"];
    }
    
    UIBarButtonItem *btnAddTip = [[UIBarButtonItem alloc] initWithTitle:[self addTipPrompt] style:UIBarButtonItemStyleBordered  target:self action:@selector(btnAddTipClicked:)];
    btnAddTip.style = UIBarButtonItemStyleBordered;
    btnAddTip.tintColor = [UIColor whiteColor];
    btnAddTip.possibleTitles = [NSSet setWithObjects:[self addTipPrompt], @"Add", @"Done", nil];
    [barItems addObject:btnAddTip];
    
    [pickerToolbar setItems:barItems animated:YES];
    
    [actionSheet addSubview:pickerToolbar];
    [actionSheet addSubview:dollarAmountPickerView];
    [actionSheet addSubview:percentageAmountPickerView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self selectInitialPickerAmount];
    [percentageAmountPickerView selectRow:[self selectedIndex] inComponent:0 animated:YES];
    
    NSDecimalNumber *dollarVal = nil;
    NSDecimalNumber *percentageVal = nil;
    
    dollarVal = [dollarAmounts objectAtIndex:[self selectedIndex]];
    percentageVal = [percentageAmounts objectAtIndex:[self selectedIndex]];
    
    switch ([self defaultComponent]) {
        case MTTipViewControllerComponentDollarAmount:
            [percentageAmountPickerView setHidden:YES];
            [dollarAmountPickerView setHidden:NO];
            [self setTipAmount:dollarVal];
            NSLog(@"Selected tip Dollar Amount: %@", dollarVal);
            break;
        case MTTipViewControllerComponentPercentageAmount:
            [percentageAmountPickerView setHidden:NO];
            [dollarAmountPickerView setHidden:YES];
            [self setTipAmount:percentageVal];
            NSLog(@"Selected tip Percent Amount: %@", percentageVal);
            break;
        default:
            [percentageAmountPickerView setHidden:YES];
            [dollarAmountPickerView setHidden:NO];
            [self setTipAmount:dollarVal];
            break;
    }
}

- (void)selectInitialPickerAmount {
    int prevIdx = 0;
    NSDecimalNumber *dollarAmtToMatch = [percentageAmounts objectAtIndex:selectedIndex];
    
    int idxToSelect = 0;
	for(int i = 0; i < [dollarAmounts count]; i++) {
        NSDecimalNumber *dollars = dollarAmounts[i];
        NSComparisonResult result = [dollars  compare:dollarAmtToMatch];
        
        if (result == NSOrderedSame) { //a == b DONE!
            idxToSelect = i;
            break;
        }
        else if (result == NSOrderedAscending) { //a < b possible but continue
            idxToSelect = prevIdx;
            continue;
        }
        else if (i+1 < [dollarAmounts count]) { //a > b; is a < c?
            NSDecimalNumber *nextValue = [dollarAmounts objectAtIndex:i+1 ];
            NSComparisonResult nextResult = [dollars compare: nextValue];
            if (nextResult == NSOrderedSame) {
                idxToSelect = i+1;
                break;
            }
            else if (nextResult == NSOrderedAscending) {
                idxToSelect = i;
                break;
            }
        }
        
        prevIdx = i;
    }
    
    [dollarAmountPickerView selectRow:idxToSelect inComponent:0 animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark UIPickerView Delegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (pickerView.tag)
    {
        case kDollarAmountTag:
            return dollarAmounts.count;
            break;
        case kPercentageAmountTag:
            return percentageAmounts.count;
            break;
        default:
            return 0;
            break;
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 30.0f;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch (pickerView.tag)
    {
        case kDollarAmountTag:
            return [dollarAmounts objectAtIndex:row];
            break;
        case kPercentageAmountTag:
            return [percentageAmounts objectAtIndex:row];
            break;
        default:
            return @"";
            break;
            
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 30)];
    label.textAlignment = UITextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
    
    NSString *itemStringValue = nil;
    NSNumber *itemNumber = nil;
    
    if (pickerView.tag == kDollarAmountTag) {
        NSString *numberAsString = [numberFormatter stringFromNumber:[dollarAmounts objectAtIndex:row]];
        label.text = [NSString stringWithFormat:@"%@", numberAsString];
        return label;
    } else if (pickerView.tag == kPercentageAmountTag) {
        float floatValue = [[percentageAmounts objectAtIndex:row] floatValue];
        itemNumber = [NSNumber numberWithFloat:floatValue];
        itemStringValue = [numberFormatter stringFromNumber:itemNumber];
        label.text = [NSString stringWithFormat:@"%ld%% - %@", ((long)row + 1), itemStringValue];
        return label;
    } else {
        return label;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSLog(@"Row Index Selected: %d", row);
    if (pickerView.tag == kDollarAmountTag) {
        NSDecimalNumber *dollarVal = nil;
        dollarVal = [dollarAmounts objectAtIndex:row];
        NSLog(@"Selected tip Dollar Amount: %@", dollarVal);
        [self setTipAmount:dollarVal];
        
    } else if(pickerView.tag == kPercentageAmountTag) {
        NSDecimalNumber *percentageVal = nil;
        percentageVal = [percentageAmounts objectAtIndex:row];
        NSLog(@"Selected tip Percent Amount: %@", percentageVal);
        [self setTipAmount:percentageVal];
    } else{
        [self setTipAmount:[NSDecimalNumber zero]];
    }
}

#pragma mark -
#pragma mark Class Methods

- (void)showInView
{
    [actionSheet showInView:self.view];
    [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{[actionSheet setBounds:CGRectMake(0,0,320,477)];} completion:NULL];
}

- (void)showInParentView
{
    [actionSheet showInView:[self parentViewController].view];
    [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{[actionSheet setBounds:CGRectMake(0,0,320,477)];} completion:NULL];
}

- (void)btnBarCancelClicked:(id) sender
{
    [self setTipAmount:[NSDecimalNumber zero]];
    [self setTipAdded:NO];
    NSLog(@"Total Amount: %@", subTotal);
    [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
}

- (void)btnAddTipClicked:(id) sender
{
    BOOL isPct = ([sgcAmount selectedSegmentIndex] == 1) ? YES : NO;
    NSDecimalNumber *amt = (isPct) ? [percentageAmounts objectAtIndex:[percentageAmountPickerView selectedRowInComponent:0]]
    : [dollarAmounts objectAtIndex:[dollarAmountPickerView selectedRowInComponent:0]];
    [self setTipAmount:amt];
    NSDecimalNumber *total = [subTotal decimalNumberByAdding:tipAmount];
    
    NSLog(@"Total Amount: %@", total);
    [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
    
    NSDecimalNumber *hundred = [NSDecimalNumber decimalNumberWithString:@"100"];
    NSDecimalNumberHandler *handler = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain
                                                                                             scale:0
                                                                                  raiseOnExactness:NO
                                                                                   raiseOnOverflow:NO
                                                                                  raiseOnUnderflow:NO
                                                                               raiseOnDivideByZero:NO];
    
    int percent = (isPct) ? [percentageAmountPickerView selectedRowInComponent:0]+1 : [[[tipAmount decimalNumberByDividingBy: subTotal] decimalNumberByMultiplyingBy:hundred withBehavior:handler]  intValue];
    
    // Call the delegate method for all implementations of the protocol.
    [delegate didSelectTipAmount:tipAmount forTotalAmount:total atPercent: percent];
    [self setTipAdded:YES];
    [self resignFirstResponder];
}

- (void)sgcAmountToggle:(id) sender
{
    if([sender selectedSegmentIndex] == 0){
        [self btnDollarAmountClicked:sender];
        //[[[sender subviews] objectAtIndex:0] setTintColor:[UIColor redColor]];
        //[[[sender subviews] objectAtIndex:1] setTintColor:[UIColor blueColor]];
    } else{
        [self btnPercentageAmountClicked:sender];
        //[[[sender subviews] objectAtIndex:0] setTintColor:[UIColor blueColor]];
        //[[[sender subviews] objectAtIndex:1] setTintColor:[UIColor redColor]];
    }
}

- (void)btnDollarAmountClicked:(id) btnDollarAmountClicked
{
    [dollarAmountPickerView setHidden:NO];
    [percentageAmountPickerView setHidden:YES];
}

- (void)btnPercentageAmountClicked:(id) btnDollarAmountClicked
{
    [dollarAmountPickerView setHidden:YES];
    [percentageAmountPickerView setHidden:NO];
}

- (void)setTipAmount:(NSDecimalNumber *) value {
    tipAmount = value;
}

@end

