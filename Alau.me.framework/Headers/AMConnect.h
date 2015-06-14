//
//  AMConnect.h
//  Alau.me SDK, http://alau.me
//
//  Copyright 2012-2014 Lumen Spark. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AMPromotionManifest;

/**
 [Alau.me](http://alau.me) is an iOS App Referral Tracking API. It allows you to create short referral links to your app on the App Store
 and track the resulting app installs.

 You can create short links for a specific ad campaign, or create unique links for each of your users, and track user-to-user referrals.

 Alau.me tracks both how many people opened the link, and how many people went on to download and use the app.

 ## Basic Usage

 To enable referral tracking, add the following code to your application delegate's `application:didFinishLaunchingWithOptions:` method:

 ```
    AMConnect *alaume = [AMConnect sharedInstance];

    // For debugging purposes only
    alaume.isLoggingEnabled = YES;

    // Substitute with your own keys from https://alau.me/manage/campaigns
    [alaume initializeWithAppId:@"zg" apiKey:@"1c0bd310f7a44e99b694c00ab63b85aa"];
 ```

 @note Most of the `AMConnect` properties are relevant only in advanced scenarios e.g. if you offer rewards for user-to-user referrals.
 */
@interface AMConnect : NSObject


#pragma mark - Initialization
/** @name Initialization */


/**
 Returns the singleton AMConnect instance.
 */  
+ (AMConnect *) sharedInstance;


/**
 Returns true if this device is already registered.

 @note Once `AMConnect` is initialized, device registration happens automatically when the app is brought to foreground.
 */  
@property (readonly) BOOL isRegistered;


/**
 Initializes AMConnect library.

 This needs to be called inside application delegate's `application:didFinishLaunchingWithOptions:`

 @exception NSInvalidArgumentException if either appId or apiKey is nil or empty.
  
 @param appId corresponding to your app
 @param apiKey corresponding to your app
 */  
- (void)initializeWithAppId:(NSString *)appId apiKey:(NSString *)apiKey;

- (instancetype) init __attribute__((unavailable("Use [AMConnect sharedInstance].")));


#pragma mark - Getting Referral Status
/** @name Getting Referral Status */


/**
 Returns the number of times the app was brought to foreground. 
 
 This property is incremented automatically and is provided purely for your convenience. Use it however you want in your referral program.
 */
@property (readonly) int launchCount;


/**
 Returns the number of successful referals for this user.
 */
@property (readonly) int referralCount;


/**
 Returns the Alau.me link used for sharing (referring other users).

 @note Initially this property is nil until your device is registered, which happens automatically.
 */  
@property (readonly) NSString* referralLink;


/**
 Get or set the promo code of the referring user (or nil if this install wasn't referred by anyone).
 
 For example, if a user was referred by opening http://alau.me/zg3dg3 this property will return "zg3dg3".

 @note Since referral tracking is primarily IP-based, this property is set automatically once device is successfully registered.
 However, you can set it programatically to indicate that the user was referred by someone. Once set, it propagates automatically to the 
 Alau.me service. If the install is already referred by someone i.e. the `wasReferred` property returns YES, setting `referredBy` property 
 has no effect.
 */
@property (readwrite, retain) NSString* referredBy;


/**
 Returns true if this user was referred by another user.

 @note This property is set automatically once the device is successfully registered.
 */
@property (readonly) BOOL wasReferred;


#pragma mark - Getting Campaign Settings
/** @name Getting Campaign Settings */


/**
 Returns true if the promotion is active and can accept new promoters.
   
 Use this property to determine if you should invite the user to participate in the referral program. This property is refreshed 
 automatically at most once a day.
 */  
@property (readonly) BOOL acceptsNewPromoters;


/**
 Returns the amount the user earns for each successful referral. Use the management console to change it.

 @note This will always be 0 if you are rewarding users with virtual goods e.g. in-app perks or additional game levels.
 */
@property (readonly) double cashPerReferral;


/**
 Returns the currency code (based on the ISO 4217 standard) used in the promotion. Default is USD.
 */
@property (readonly) NSString* currencyCode;


/**
 A Boolean value that determines if the user has already seen your program invitation.
  
 Once you invite the user to participate in the referral program, set this property to YES to make sure you don't display the same 
 invitation more than once (assuming you use invitations).
 */  
@property (readwrite) BOOL didShowPromotionBanner;


/**
 Returns promotion end date (UTC time). Use the management console to change it.
 */
@property (readonly) NSDate* endDate;


/**
 Set this property to YES for apps that are free to download.
 */
@property (assign) BOOL isFreeSKU;


/**
 Returns the number of points the user earns for each successful referral. Use the management console to change it.
 */  
@property (readonly) double pointsPerReferral;


/**
 Returns the minimum number of points required to redeem the rewards. Use the management console to change it.
 */  
@property (readonly) double pointsRequiredToRedeem;


/**
 Returns the remaining campaign balance (in currency specified by the `currencyCode` property).
 */
@property (readonly) double remainingBalance;


#pragma mark - Cancelling Participation
/** @name Cancelling Participation */


/**
 Withdraws the promoter from participation in the referral program.

 @param delegate to call once operation completes
 @param didFinishSelector with the following signature: `(void)didFinishWithError:(NSError *)error`
 
 @exception NSInternalInconsistencyException if `initializeWithAppId:apiKey:` method hasn't been called.
 */
- (void)beginPromoterCancellationWithDelegate:(id)delegate didFinishSelector:(SEL)didFinishSelector;


/**
 Returns true if the promoter explicitly withdrew from participation in the program. In order to withdraw the user from participation, 
 you must have explicitly called `beginPromoterCancellationWithDelegate:didFinishSelector:`
 */
@property (readonly) BOOL participantWithdrew;


#pragma mark - Managing Campaign Manifest File
/** @name Managing Campaign Manifest File */


/**
 Returns the promotion manifest containing various settings that you may use to customize user experience.

 The manifest file is a JSON file with various campaign-specific properties. You can define your own key/value pairs specific to your 
 referral program. The manifest is stored on your server and is refreshed automatically once a day, if you set the `promotionManifestURL`.
 */
@property (readonly) AMPromotionManifest* promotionManifest;


/**
 The URL of the manifest.json file (the manifest file is refreshed automatically at most once a day).
 */
@property (readwrite, retain) NSURL* promotionManifestURL;


/**
 Set this property to YES to use the default manifest file (instead of the one loaded from the server).

 @note The default manifest should be named: "AMManifest.json" and stored in the main bundle.
 Use it for debugging / prototyping so that you don't have to wait a day for the manifest to get refreshed.
 */
@property (assign) BOOL useDefaultPromotionManifest;


#pragma mark - Redeeming Rewards
/** @name Redeeming Rewards */


/**
 Returns the number of points earned by this user.
 */  
@property (readonly) double rewardPoints;


/**
 A Boolean value that determines if the user has referred more users since the last daily status check.
  
 Once you notify the user that they have referred more users, set this property to NO.
 */  
@property (readwrite) BOOL hasReferredMoreUsersSinceLastStatusCheck;


/**
 Updates all reward-related properties.
  
 @param delegate to call once the operation completes
 @param didFinishSelector with the following signature: `(void)didFinishWithError:(NSError *)error`

 @exception NSInternalInconsistencyException if `initializeWithAppId:apiKey:` method hasn't been called.
 */
- (void)beginRewardStatusCheckWithDelegate:(id)delegate didFinishSelector:(SEL)didFinishSelector;


/**
 Redeems user's reward points. Use this method only if you are offering monetary rewards or rebates. 
 
 If you are offering in-app rewards, use the `rewardPoints` property instead to automatically unlock in-app content once the user
 earns the required minimum number of points.
  
 @param email address
 @param delegate to call once the operation completes
 @param didFinishSelector with the following signature: `(void)didFinishWithError:(NSError *)error`
 
 @exception NSInternalInconsistencyException if `initializeWithAppId:apiKey:` method hasn't been called.
 */  
- (void)beginRewardRedemptionWithEmail:(NSString *)email delegate:(id)delegate didFinishSelector:(SEL)didFinishSelector;


#pragma mark - Troubleshooting
/** @name Troubleshooting */


/**
 Set this property to YES to enable `AMConnect` logging to stderr. For debugging only.
 */  
@property (assign) BOOL isLoggingEnabled;


/**
 Resets all the properties for testing purposes.
 */  
- (void)reset;

@end


#pragma mark - Manifest JSON File Wrapper (used only in Advanced scenarios)


/**
 Class containing (optional) campaign manifest i.e. a set of properties used to describe the promotion campaign.
 */  
@interface AMPromotionManifest : NSObject 
{
}


/**
 Returns the value associated with the specified custom key.
 
 @param key for which to retrieve the value for
 */  
- (id)valueForKey:(NSString *)key;


/**
 Initializes the receiver with the specified property dictionary and defaults.
 
 @param dictionary containing key-value pairs
 @param defaults dictionary
 */  
- (id)initWithDictionary:(NSDictionary *)dictionary defaults:(NSDictionary *)defaults;

@end
