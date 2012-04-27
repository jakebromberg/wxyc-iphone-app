/*
     File: KeychainItemWrapper.h
 Abstract: 
 Objective-C wrapper for accessing a single keychain item.
 
*/

#import <UIKit/UIKit.h>

/*
    The KeychainItemWrapper class is an abstraction layer for the iPhone Keychain communication. It is merely a 
    simple wrapper to provide a distinct barrier between all the idiosyncracies involved with the Keychain
    CF/NS container objects.
*/
@interface KeychainItemWrapper : NSObject
{
    NSMutableDictionary *keychainItemData;		// The actual keychain item data backing store.
    NSMutableDictionary *genericPasswordQuery;	// A placeholder for the generic keychain item query used to locate the item.
}

@property (nonatomic, retain) NSMutableDictionary *keychainItemData;
@property (nonatomic, retain) NSMutableDictionary *genericPasswordQuery;

// Designated initializer.
- (id)initWithIdentifier: (NSString *)identifier accessGroup:(NSString *) accessGroup;
- (void)setObject:(id)inObject forKey:(id)key;
- (id)objectForKey:(id)key;

// Initializes and resets the default generic keychain item data.
- (void)resetKeychainItem;

@end