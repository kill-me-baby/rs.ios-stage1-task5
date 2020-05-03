#import "Converter.h"

// Do not change
NSString *KeyPhoneNumber = @"phoneNumber";
NSString *KeyCountry = @"country";

@implementation PNConverter
- (NSDictionary*)converToPhoneNumberNextString:(NSString*)string; {
    //Delete plus if it's there
    
    NSMutableString* myFormatNumber = [NSMutableString stringWithString:string];
    NSRange firstRange = NSMakeRange(0, 1);
    NSString* firstElement = [myFormatNumber substringWithRange:firstRange];
    
    if ([firstElement isEqualToString:@"+"]) {
        [myFormatNumber deleteCharactersInRange:firstRange];
    }
    
    //Check length
    
    if ([myFormatNumber length] > 12) {
        NSString* newString = [myFormatNumber substringToIndex:12];
        myFormatNumber = [NSMutableString stringWithString:newString];
    }
    
    NSDictionary* lengthNumbersForCountries = @{@"RU":@10, @"KZ":@10, @"MD":@8, @"AM":@8, @"BY":@9, @"UA":@9, @"TJ":@9, @"TM":@8, @"AZ":@9, @"KG":@9, @"UZ":@9 };
    NSDictionary* countryCodes = @{@"7":@"RU", @"77":@"KZ", @"373":@"MD", @"374": @"AM", @"375": @"BY",@"380": @"UA",@"992": @"TJ", @"993": @"TM", @"994": @"AZ", @"996": @"KG", @"998": @"UZ"};
    NSDictionary* numsAreaCode = @{@"RU":@3, @"KZ":@3, @"MD":@2, @"AM":@2, @"BY":@2, @"UA":@2, @"TJ":@2, @"TM":@2, @"AZ":@2, @"KG":@2, @"UZ":@2 };
    
    NSMutableString* areaCode = [NSMutableString string];
    NSString* foundCountryCode = @"";
    NSInteger foundLengthNumber = 0;
    
    //Search country code
    
    for (NSString* countryCode in countryCodes) {
        
        if ([myFormatNumber hasPrefix:@"77"]) {
            foundCountryCode = @"77";
            NSRange range = NSMakeRange(0, 1);
            [myFormatNumber deleteCharactersInRange:range];
            foundLengthNumber = [lengthNumbersForCountries[countryCodes[foundCountryCode]] integerValue];
            break;
        }
        
        if ([myFormatNumber hasPrefix:countryCode]) {
            foundCountryCode = countryCode;
            NSRange range = NSMakeRange(0, [countryCode length]);
            [myFormatNumber deleteCharactersInRange:range];
            foundLengthNumber = [lengthNumbersForCountries[countryCodes[foundCountryCode]] integerValue];
            break;
        } else {
            NSLog(@"Country code not found");
        }
    }
    
    //Check if countryCode not found
    
    if ([foundCountryCode isEqualToString:@""]) {
        
        string = [string substringToIndex:MIN(string.length, 12)];
        string = [NSString stringWithFormat:@"+%@", myFormatNumber];
        
        return @{KeyPhoneNumber: string, KeyCountry: @""};
    }
    
    if ([myFormatNumber length] == 0) {
        
        NSString* result = [NSString stringWithFormat:@"+%@", foundCountryCode];
        
        return @{KeyPhoneNumber: result, KeyCountry: countryCodes[foundCountryCode]};
    }
    
    NSLog(@"myFormatNumber = %@", myFormatNumber);
    NSLog(@"Country: %@, countryCode: %@, lengthNumber: %ld, numsAreaCode = %@", countryCodes[foundCountryCode], foundCountryCode, foundLengthNumber, numsAreaCode[countryCodes[foundCountryCode]]);
    
    if ([myFormatNumber length] <= [numsAreaCode[countryCodes[foundCountryCode]] integerValue]) {
        
        if ([countryCodes[foundCountryCode] isEqualToString:@"KZ"]) {
            
            NSRange range = NSMakeRange(0, 1);
            NSString* result = [NSString stringWithFormat:@"+%@ (%@",[foundCountryCode substringWithRange:range], myFormatNumber];
            
            return @{KeyPhoneNumber: result, KeyCountry: countryCodes[foundCountryCode]};
        }
        
        NSString* result = [NSString stringWithFormat:@"+%@ (%@",foundCountryCode, myFormatNumber];
        
        return @{KeyPhoneNumber: result, KeyCountry: countryCodes[foundCountryCode]};
    } else {
        if ([numsAreaCode[countryCodes[foundCountryCode]] integerValue] <= [myFormatNumber length]) {
            
            NSRange myRange = NSMakeRange(0, [numsAreaCode[countryCodes[foundCountryCode]] integerValue]);
            NSString* subString = [myFormatNumber substringWithRange:myRange];
            [myFormatNumber deleteCharactersInRange:myRange];
            areaCode = [NSMutableString stringWithFormat:@"(%@)", subString];
        }
        
        NSInteger clearLocalNum = foundLengthNumber - [numsAreaCode[countryCodes[foundCountryCode]] integerValue];
        
        if ([myFormatNumber length] > clearLocalNum) {
            
            NSString* subString = [myFormatNumber substringToIndex:clearLocalNum];
            myFormatNumber = [NSMutableString stringWithString:subString];
        }
        
        if (foundLengthNumber == 8) {
            if ([myFormatNumber length] > 3) {
                [myFormatNumber insertString:@"-" atIndex:3];
            } else {
                
                if ([countryCodes[foundCountryCode] isEqualToString:@"KZ"]) {
                    
                    NSRange range = NSMakeRange(0, 1);
                    NSString* result = [NSString stringWithFormat:@"+%@ %@ %@",[foundCountryCode substringWithRange:range], areaCode, myFormatNumber];
                    result = [result substringToIndex: [result length]];
                    
                    return @{KeyPhoneNumber: result, KeyCountry: countryCodes[foundCountryCode]};
                }
                
                NSString* result = [NSString stringWithFormat:@"+%@ %@ %@",foundCountryCode, areaCode, myFormatNumber];
                result = [result substringToIndex: [result length]];
                
                return @{KeyPhoneNumber: result, KeyCountry: countryCodes[foundCountryCode]};
            }
        } else {
            
            if ([myFormatNumber length] > 3) {
                [myFormatNumber insertString:@"-" atIndex:3];
            } else {
                
                if ([countryCodes[foundCountryCode] isEqualToString:@"KZ"]) {
                    
                    NSRange range = NSMakeRange(0, 1);
                    NSString* result = [NSString stringWithFormat:@"+%@ %@ %@",[foundCountryCode substringWithRange:range], areaCode, myFormatNumber];
                    
                    return @{KeyPhoneNumber: result, KeyCountry: countryCodes[foundCountryCode]};
                }
                
                NSString* result = [NSString stringWithFormat:@"+%@ %@ %@",foundCountryCode, areaCode, myFormatNumber];
                return @{KeyPhoneNumber: result, KeyCountry: countryCodes[foundCountryCode]};
            }
            
            if ([myFormatNumber length] > 6) {
                [myFormatNumber insertString:@"-" atIndex:6];
            } else {
                
                if ([countryCodes[foundCountryCode] isEqualToString:@"KZ"]) {
                    
                    NSRange range = NSMakeRange(0, 1);
                    NSString* result = [NSString stringWithFormat:@"+%@ %@ %@",[foundCountryCode substringWithRange:range], areaCode, myFormatNumber];
                    
                    return @{KeyPhoneNumber: result, KeyCountry: countryCodes[foundCountryCode]};
                }
                
                NSString* result = [NSString stringWithFormat:@"+%@ %@ %@",foundCountryCode, areaCode, myFormatNumber];
                
                return @{KeyPhoneNumber: result, KeyCountry: countryCodes[foundCountryCode]};
            }
        }
        
        if ([countryCodes[foundCountryCode] isEqualToString:@"KZ"]) {
            
            NSRange range = NSMakeRange(0, 1);
            NSString* result = [NSString stringWithFormat:@"+%@ %@ %@",[foundCountryCode substringWithRange:range], areaCode, myFormatNumber];
            
            return @{KeyPhoneNumber: result,
                     KeyCountry: countryCodes[foundCountryCode]};
        }
        
        NSString* result = [NSString stringWithFormat:@"+%@ %@ %@",foundCountryCode, areaCode, myFormatNumber];
        
        return @{KeyPhoneNumber: result,
                 KeyCountry: countryCodes[foundCountryCode]};
    }
}
@end
