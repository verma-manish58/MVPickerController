//
//  PickerViewController.m
//  
//
//  Created by Manish Verma on 29/03/13.
//  Copyright (c) 2013 Manish Verma. All rights reserved.
//

#import "MVPickerController.h"

static MVPickerController *sharedInstance;


#define screenWidth     [[UIScreen mainScreen] bounds].size.width
#define screenHeight    [[UIScreen mainScreen] bounds].size.height

#define IPHONE          (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IPAD            (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

#define HIDDEN_Y_OFFSET     IPHONE?700:1200
#define SCREEN_WIDTH        screenWidth
#define SCREEN_HEIGHT       screenHeight
#define PICKER_HEIGHT       260 //216 + 44 (tool bar height)
#define ANIMATION_DURATION  0.5





@interface MVPickerController ()

@end

@implementation MVPickerController

@synthesize arrPickerItems;
@synthesize target;
@synthesize tag;

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hidePicker) name:UIKeyboardWillShowNotification object:nil];
    
    //uncomment the code below to show picker in popover view
    //    [self setContentSizeForViewInPopover:CGSizeMake(300, 216)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- Shared Picker View
+ (MVPickerController *)sharedInstance
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedInstance = [[MVPickerController alloc] initWithNibName:@"MVPickerController" bundle:nil];
    });
    return sharedInstance;
}

#pragma mark- Show Picker
- (void)showSharedPickerViewWithItems:(NSArray*)pickerItems delegate:(id)delegate tag:(NSUInteger)pickerTag onView:(id)view
{
    //not being used here as we are showing picker on top of tab view rather than showing it on a view controller
    UIViewController *superViewController = (UIViewController*)view;
    
   [superViewController.view endEditing:YES];
    
    self.arrPickerItems =   [NSArray arrayWithArray:pickerItems];
    self.target         =   delegate;
    
    self.target   =   delegate;
    
    if ([self.strDeviceOrientation compare:@"portrait" options:NSCaseInsensitiveSearch] == NSOrderedSame)
    {
        [self.view setFrame:CGRectMake(0, HIDDEN_Y_OFFSET, SCREEN_WIDTH, PICKER_HEIGHT)];
        [self.toolBar setFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
        
    }
    else
    {
        [self.view setFrame:CGRectMake(0, SCREEN_HEIGHT - PICKER_HEIGHT, SCREEN_WIDTH, PICKER_HEIGHT)];
        [self.toolBar setFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
        
        NSLog(@"View Frame: %@", NSStringFromCGRect(self.view.frame));
    }
    
    
    [UIView animateWithDuration:ANIMATION_DURATION animations:^{
        
        
        if ([self.strDeviceOrientation compare:@"portrait" options:NSCaseInsensitiveSearch] == NSOrderedSame)
        {
//            [self.view setFrame:CGRectMake(0, SCREEN_HEIGHT - PICKER_HEIGHT, SCREEN_WIDTH, PICKER_HEIGHT)];
            [self.view setFrame:CGRectMake(0, (IPAD ?superViewController.view.frame.size.height : SCREEN_HEIGHT) - PICKER_HEIGHT, IPAD ? superViewController.view.frame.size.width : SCREEN_WIDTH, PICKER_HEIGHT)];
            [self.toolBar setFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
        }
        else
        {
            [self.view setFrame:CGRectMake(0, (IPAD ? superViewController.view.frame.size.height : SCREEN_HEIGHT) - PICKER_HEIGHT, IPAD ? superViewController.view.frame.size.width : SCREEN_WIDTH, PICKER_HEIGHT)];
            [self.toolBar setFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
        }
        
         self.isPickerVisible = YES;
        
//        NSLog(@"SCREEN_HEIGHT: %f", SCREEN_HEIGHT);
//        NSLog(@"SCREEN_WIDTH: %f", SCREEN_WIDTH);
        

        [superViewController.view addSubview:self.view];
        NSLog(@"Picker Frame:-============ %@", NSStringFromCGRect(self.view.frame));
        
    } completion:^(BOOL finished) {
        
    }];
    
    [self.picker setTag:pickerTag];
    [self.picker reloadAllComponents];
}

#pragma mark- Filling Picker
- (void)fillPickerWithItems:(NSArray*)items
{
    self.arrPickerItems     =   [NSArray arrayWithArray:items];
    
    [self.picker reloadAllComponents];
}

#pragma mark- IBAction Method
- (IBAction)btnDoneTapped:(id)sender {
    
    if (self.target && [self.target respondsToSelector:@selector(selectedItem:forTag:)])
        [self.target selectedItem:[self.picker.delegate pickerView:self.picker titleForRow:[self.picker selectedRowInComponent:0] forComponent:0] forTag:self.picker.tag];
    
    [self hidePicker];
}

- (IBAction)btnCancelTapped:(id)sender {
    
    /*
     if (self.target && [self.target respondsToSelector:@selector(hidePicker)])
     {
     [self.target hidePicker];
     }
     */
    
    [self hidePicker];
    
}

#pragma mark- Hide Picker
- (void)hidePicker
{
    [UIView animateWithDuration:ANIMATION_DURATION animations:^{
        
        [self.view setFrame:CGRectMake(0, HIDDEN_Y_OFFSET, SCREEN_WIDTH, PICKER_HEIGHT)];
        
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
        
        
    }];
    
     self.isPickerVisible = NO;
}


#pragma mark- UIPickerViewDataSource Methods
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.arrPickerItems count];
}

//uncomment the code below to use custom rows in pickerview
/*
 - (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
 {
 UILabel *label = [[UILabel alloc] init];
 [label setFrame:CGRectMake(pickerView.center.x, pickerView.center.y, pickerView.frame.size.width, 30)];
 [label setTextAlignment:NSTextAlignmentCenter];
 label.text = [NSString stringWithFormat:@"%@",[self.arrPickerItems objectAtIndex:row]];
 label.textColor = [UIColor whiteColor];
 return label;
 }
 */

#pragma mark- UIPickerViewDelegate Methods
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [NSString stringWithFormat:@"%@",[self.arrPickerItems objectAtIndex:row]];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    //    if (self.target && [self.target respondsToSelector:@selector(selectedItem:)])
    //    {
    //        [self.target selectedItem:[pickerView.delegate pickerView:pickerView titleForRow:row forComponent:component]];
    //    }
}
@end
