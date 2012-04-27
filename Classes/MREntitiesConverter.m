//
//  MREntitiesConverter.m
//  WXYCapp
//
//  Created by Jake on 2/28/10.
//  Copyright 2010 WXYC. All rights reserved.
//

#import "MREntitiesConverter.h"


@implementation MREntitiesConverter
@synthesize resultString;
- (id)init
{
    if([super init]) {
        resultString = [[NSMutableString alloc] init];
    }
    return self;
}
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)s {
	[self.resultString appendString:s];
}
- (NSString*)convertEntiesInString:(NSString*)s {
    if(s == nil) {
        NSLog(@"ERROR : Parameter string is nil");
    }
    NSString* xmlStr = [NSString stringWithFormat:@"<d>%@</d>", s];
    NSData *data = [xmlStr dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSXMLParser* xmlParse = [[NSXMLParser alloc] initWithData:data];
    [xmlParse setDelegate:self];
    [xmlParse parse];
    NSString* returnStr = [[NSString alloc] initWithFormat:@"%@",resultString];
    return returnStr;
}
- (void)dealloc {
    [resultString release];
    [super dealloc];
}

@end
