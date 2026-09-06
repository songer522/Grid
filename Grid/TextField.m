//
//  TextField.m
//  Switch
//
//  Created by Yang Song on 5/13/12.
//  Copyright (c) 2012 Xecudev, LLC. All rights reserved.
//



#import "TextField.h"


@interface TextField()

-(id)initWithFrame:(CGRect)frame AddToView:(bool)addToView;

@end

@implementation TextField

@synthesize characterLimit = _characterLimit;
@synthesize customKeyView = _customKeyView;

+(id)textFieldWithFrame:(CGRect)frame
{
    return [[self alloc] initWithFrame:frame AddToView:YES];
}

+(id)textFieldWithFrame:(CGRect)frame AddToView:(bool)addToView
{
    return [[self alloc] initWithFrame:frame AddToView:addToView];
}

-(void)addWordToEnd:(NSString*)word
{
    _textView.text = [NSString stringWithFormat:@"%@%@ ",_textView.text,word];
    
    //keep them from being able to add it beyond the character limit
    if (_textView.text.length > _characterLimit) {
        _textView.text = [_textView.text substringToIndex:(_characterLimit - 1)];
    }
}

-(id)initWithFrame:(CGRect)frame AddToView:(bool)addToView
{
    if((self = [super init])) {
        _characterLimit = 200;
        _textView = [[UITextView alloc] initWithFrame:frame];
        _textView.textColor = [UIColor blackColor];
        [_textView setBackgroundColor:[UIColor clearColor]];
        //[_textView setBackgroundColor:[UIColor redColor]];
        [_textView setFont:[UIFont fontWithName:@"Arial" size:20]];
        [_textView setText:@""];
        [_textView setDelegate:self];
        
        _textView.scrollEnabled = NO;
        
        _textView.clipsToBounds = YES;
        
               
        if (addToView) {
            [[[[CCDirector sharedDirector] view] window] addSubview:_textView];            
        }
        
    }
    
    return self;
}

-(void)clearText
{
    _textView.text = @"";
}

-(UITextView*)getTextView
{
    return _textView;
}

-(void)setPositionBasedOnPosition:(CGPoint)position withOffset:(CGPoint)offset
{
    CGPoint newPosition = [[CCDirector sharedDirector] convertToUI:position];
    CGRect newFrame = CGRectMake(newPosition.x + offset.x, newPosition.y + offset.y, _textView.frame.size.width, _textView.frame.size.height);
    [_textView setFrame:newFrame];
}


-(void)specifyStartKeyboardInput
{
    [_textView becomeFirstResponder];
}

-(void)moveCursorToEndOfText
{
    NSUInteger length = _textView.text.length;
    _textView.selectedRange = NSMakeRange(0, length); 
    _textView.selectedRange = NSMakeRange(length, 0);
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    //end editing
    [textField resignFirstResponder];
    return YES;
}

-(NSString*)endInputAndGetText
{
    [_textView resignFirstResponder];
    [self textViewDidEndEditing:_textView];
    return _contents;
}

-(void)setEnabled:(bool)enabled
{
    _textView.userInteractionEnabled = false;
}

-(void)setText:(NSString*)text
{
    _textView.text = [NSString stringWithString:text];
    [self moveCursorToEndOfText];
}

-(void)setDelegate:(id)delegate
{
    //_delegate = delegate;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    bool returnVal = YES;
    
    if(range.length > text.length){
        returnVal = YES;
    }
    else if ([[textView text] length] + text.length > _characterLimit)
    {
        returnVal = NO;
    }
    
    return returnVal;
}



-(void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView==_textView) {
        [_textView endEditing:YES];
        _contents = [NSString stringWithString:_textView.text];
    }
}

-(void)dealloc
{
    [_textView removeFromSuperview];
    //[_contents release];
   // _delegate = nil;
    [super dealloc];
}


@end