//
//  SettingTextCell.h
//  PhotoTools
//
//  Created by yiluhao on 13-5-18.
//  Copyright (c) 2013年 yiluhao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SettingTextCell;

@protocol SettingTextCellDelegate <NSObject>

@optional

//Called to the delegate whenever return is hit when a user is typing into the rightTextField of an SDTextFieldCell
- (BOOL)textFieldCell:(SettingTextCell *)inCell shouldReturnForIndexPath:(NSIndexPath*)inIndexPath withValue:(NSString *)inValue;

//Called to the delegate whenever the text in the textField is changed
- (void)textFieldCell:(SettingTextCell *)inCell updateTextLabelAtIndexPath:(NSIndexPath *)inIndexPath string:(NSString *)inValue;

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField;
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField;
- (void)textFieldDidBeginEditing:(UITextField *)textField;
- (void)textFieldDidEndEditing:(UITextField *)textField;

@end

/**
 SDTextFieldCell
 
 Provides a UITextField inside a UITableViewCell, accessable through the native `textField` property.
 
 The UITextField instance is aligned to the right side of the cell, but UITextField text is aligned to the left.
 
 This class has no SelectionStyle by design, this would interfere with user input.
 
 The designated initializer for this class is initWithStyle:reuseIdentifier:
 */

@interface SettingTextCell : UITableViewCell <UITextFieldDelegate>

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, weak) id <SettingTextCellDelegate> delegate;
@property (nonatomic, strong) NSIndexPath *indexPath;
@end



