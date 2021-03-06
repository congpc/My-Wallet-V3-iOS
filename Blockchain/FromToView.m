//
//  FromToView.m
//  Blockchain
//
//  Created by kevinwu on 11/14/17.
//  Copyright © 2017 Blockchain Luxembourg S.A. All rights reserved.
//

#import "FromToView.h"
#import "Blockchain-Swift.h"
#import "UIView+ChangeFrameAttribute.h"

@implementation FromToView

- (id)initWithFrame:(CGRect)frame enableToTextField:(BOOL)enableToTextField
{
    if (self == [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        UILabel *fromLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 40, 21)];
        fromLabel.adjustsFontSizeToFitWidth = YES;
        fromLabel.font = [UIFont fontWithName:FONT_MONTSERRAT_REGULAR size:FONT_SIZE_SMALL];
        fromLabel.textColor = COLOR_TEXT_DARK_GRAY;
        fromLabel.text = BC_STRING_FROM;
        fromLabel.center = CGPointMake(fromLabel.center.x, ROW_HEIGHT_FROM_TO_VIEW/2);
        [self addSubview:fromLabel];
        
        CGFloat imageViewWidth = 16;
        
        CGFloat fromPlaceholderLabelOriginX = fromLabel.frame.origin.x + fromLabel.frame.size.width + 13;
        UILabel *fromPlaceholderLabel = [[UILabel alloc] initWithFrame:CGRectMake(fromPlaceholderLabelOriginX, 0, self.frame.size.width - fromPlaceholderLabelOriginX - 8 - imageViewWidth - 8, 30)];
        fromPlaceholderLabel.font = [UIFont fontWithName:FONT_MONTSERRAT_LIGHT size:FONT_SIZE_SMALL];
        fromPlaceholderLabel.textColor = COLOR_TEXT_DARK_GRAY;
        fromPlaceholderLabel.center = CGPointMake(fromPlaceholderLabel.center.x, ROW_HEIGHT_FROM_TO_VIEW/2);
        [self addSubview:fromPlaceholderLabel];
        self.fromLabel = fromPlaceholderLabel;
        
        UIImageView *fromImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width - 8 - imageViewWidth, 0, imageViewWidth, imageViewWidth)];
        fromImageView.contentMode = UIViewContentModeScaleAspectFit;
        fromImageView.center = CGPointMake(fromImageView.center.x, fromPlaceholderLabel.center.y);
        [self addSubview:fromImageView];
        self.fromImageView = fromImageView;
        
        BCLine *lineAboveToField = [self offsetLineWithYPosition:ROW_HEIGHT_FROM_TO_VIEW];
        [self addSubview:lineAboveToField];
        
        UIButton *fromButton = [[UIButton alloc] initWithFrame:CGRectMake(fromPlaceholderLabel.frame.origin.x, 0, self.frame.size.width - fromPlaceholderLabel.frame.origin.x, ROW_HEIGHT_FROM_TO_VIEW)];
        [fromButton addTarget:self action:@selector(fromButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:fromButton];
        
        UILabel *toLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 40, 21)];
        toLabel.font = [UIFont fontWithName:FONT_MONTSERRAT_REGULAR size:FONT_SIZE_SMALL];
        toLabel.textColor = COLOR_TEXT_DARK_GRAY;
        toLabel.text = BC_STRING_TO;
        toLabel.center = CGPointMake(toLabel.center.x, ROW_HEIGHT_FROM_TO_VIEW*1.5);
        [self addSubview:toLabel];
        
        CGFloat toFieldOriginX = toLabel.frame.origin.x + toLabel.frame.size.width + 13;
        
        CGRect toTextFrame = CGRectMake(toFieldOriginX, 0, self.frame.size.width - 8 - toFieldOriginX - imageViewWidth - 8, 30);
        CGFloat toVerticalCenterY;
        
        if (enableToTextField) {
            BCSecureTextField *toField = [[BCSecureTextField alloc] initWithFrame:toTextFrame];
            toField.font = [UIFont fontWithName:FONT_MONTSERRAT_LIGHT size:FONT_SIZE_SMALL];
            toField.placeholder = BC_STRING_ENTER_ETHER_ADDRESS;
            toField.textColor = COLOR_TEXT_DARK_GRAY;
            toField.clearButtonMode = UITextFieldViewModeWhileEditing;
            toField.center = CGPointMake(toField.center.x, ROW_HEIGHT_FROM_TO_VIEW*1.5);
            [self addSubview:toField];
            self.toField = toField;
            toVerticalCenterY = toField.center.y;
        } else {
            UILabel *toPlaceHolderLabel = [[UILabel alloc] initWithFrame:toTextFrame];
            toPlaceHolderLabel.font = [UIFont fontWithName:FONT_MONTSERRAT_LIGHT size:FONT_SIZE_SMALL];
            toPlaceHolderLabel.textColor = COLOR_TEXT_DARK_GRAY;
            toPlaceHolderLabel.center = CGPointMake(toPlaceHolderLabel.center.x, ROW_HEIGHT_FROM_TO_VIEW*1.5);
            [self addSubview:toPlaceHolderLabel];
            self.toLabel = toPlaceHolderLabel;
            toVerticalCenterY = toPlaceHolderLabel.center.y;
            
            UIButton *toButton = [[UIButton alloc] initWithFrame:CGRectMake(toPlaceHolderLabel.frame.origin.x, ROW_HEIGHT_FROM_TO_VIEW + lineAboveToField.frame.size.height, self.frame.size.width - toPlaceHolderLabel.frame.origin.x, self.frame.size.height - ROW_HEIGHT_FROM_TO_VIEW)];
            [toButton addTarget:self action:@selector(toButtonClicked) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:toButton];
        }
        
        UIImageView *toImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width - 8 - imageViewWidth, 0, imageViewWidth, imageViewWidth)];
        toImageView.center = CGPointMake(toImageView.center.x, toVerticalCenterY);
        toImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:toImageView];
        self.toImageView = toImageView;
        
        BCLine *lineBelowToField = [self offsetLineWithYPosition:ROW_HEIGHT_FROM_TO_VIEW*2];
        [self addSubview:lineBelowToField];
    }
    return self;
}

- (BCLine *)offsetLineWithYPosition:(CGFloat)yPosition
{
    BCLine *line = [[BCLine alloc] initWithYPosition:yPosition];
    [line changeXPosition:15];
    return line;
}

- (void)fromButtonClicked
{
    [self.delegate fromButtonClicked];
}

- (void)toButtonClicked
{
    [self.delegate toButtonClicked];
}

@end
