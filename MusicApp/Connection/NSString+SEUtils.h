//
//  NSString+SEUtils.h
//  SEDefaults
//
//  Created by Developer on 11/21/13.
//  Copyright (c) 2013 SE. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (SEUtils)

#pragma mark Currency
- (NSString *)currencyFormatted;
- (NSString *)clearCurrencyFormat;

#pragma mark Email
- (BOOL)isValidEmail;

@end
