/*
 * 
 * Copyright (c) 2012, Ben Reeves. All rights reserved.
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
 * MA 02110-1301  USA
 */

#import <UIKit/UIKit.h>
#import "Wallet.h"

@interface ReceiveCoinsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate> {
    IBOutlet UITableView * tableView;
    IBOutlet UIImageView * qrCodeImageView;
    IBOutlet UIButton * archiveUnarchiveButton;
    IBOutlet UIView * tableFooterView;
    
    IBOutlet UIView * noaddressesView;
    
    //Label Address
    IBOutlet UIView * labelAddressView;
    IBOutlet UITextField * labelTextField;
    IBOutlet UILabel * labelAddressLabel;
    IBOutlet UIView * requestCoinsView;
    
    IBOutlet UIView * optionsModalView;
    IBOutlet UILabel * optionsTitleLabel;
    IBOutlet UILabel * optionsAddressLabel;
    
    //amount
    IBOutlet UITextField * requestAmountTextField;
    IBOutlet UIButton * btcCodeButton;
    
    //accessory
    IBOutlet UIView * amountKeyoboardAccessoryView;
    IBOutlet UILabel * currencyConversionLabel;
    
    BOOL displayingLocalSymbol;
}

@property(nonatomic, strong) NSArray * activeKeys;
@property(nonatomic, strong) NSArray * archivedKeys;

-(void)reload;

@property(nonatomic, strong) NSString * clickedAddress;

-(IBAction)labelAddressClicked:(id)sender;
-(IBAction)archiveAddressClicked:(id)sender;
-(IBAction)generateNewAddressClicked:(id)sender;
-(IBAction)copyAddressClicked:(id)sender;
-(IBAction)labelSaveClicked:(id)sender;
-(IBAction)shareByTwitter:(id)sender;
-(IBAction)shareByFacebook:(id)sender;
-(IBAction)shareByGooglePlus:(id)sender;
-(IBAction)shareByEmailClicked:(id)sender;
-(IBAction)requestPaymentClicked:(id)sender;
-(IBAction)closeKeyboardClicked:(id)sender;
-(IBAction)btcCodeClicked:(id)sender;

@end
