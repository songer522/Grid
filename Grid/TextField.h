//
//  TextField.h
//  Switch
//
//  Created by Yang Song on 5/13/12.
//  Copyright (c) 2012 Xecudev, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"


@class SwitchTextView;

@interface TextField : NSObject<UITextViewDelegate>
{
    UITextView *_textView;
    NSString *_contents;
    int _characterLimit;
    
   
    
    UIView *_customKeyView;
}

@property (nonatomic,assign) UIView *customKeyView;

@property (nonatomic,assign) int characterLimit;

+(id)textFieldWithFrame:(CGRect)frame;
+(id)textFieldWithFrame:(CGRect)frame AddToView:(bool)addToView;

-(void)addWordToEnd:(NSString*)word; //add word to end of string. for example, used when pressing the keyword buttons to tell the textbox to add the keyword to the string.

-(void)specifyStartKeyboardInput;

-(void)setText:(NSString*)text;

-(NSString*)endInputAndGetText;

-(void)moveCursorToEndOfText;

-(UITextView*)getTextView;

-(void)setEnabled:(bool)enabled;

-(void)setDelegate:(id)delegate;

-(void)clearText;

-(void)setPositionBasedOnPosition:(CGPoint)position withOffset:(CGPoint)offset;

@end
