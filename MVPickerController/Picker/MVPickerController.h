//
//  PickerViewController.h
//  
//
//  Created by Manish Verma on 29/03/13.
//  Copyright (c) 2013 Manish Verma. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MVPickerControllerDelegate <NSObject>

- (void)selectedItem:(NSString*)item forTag:(NSUInteger)itemForTag;


@end

#define APPDELEGATE         ((AppDelegate*)[UIApplication sharedApplication].delegate)

@interface MVPickerController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>

@property (assign, nonatomic) BOOL isPickerVisible;

@property (assign, nonatomic) NSUInteger tag;

@property (assign, nonatomic) id <MVPickerControllerDelegate>target;

@property (retain, nonatomic) NSArray *arrPickerItems;

@property (retain, nonatomic) IBOutlet UIPickerView *picker;

@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;

@property (strong, nonatomic) NSString *strDeviceOrientation;

- (void)fillPickerWithItems:(NSArray*)items;

- (IBAction)btnDoneTapped:(id)sender;
- (IBAction)btnCancelTapped:(id)sender;

- (void)hidePicker;

+ (MVPickerController *)sharedInstance;
- (void)showSharedPickerViewWithItems:(NSArray*)pickerItems delegate:(id)delegate tag:(NSUInteger)pickerTag onView:(id)view;

@end
