#import <GoogleMobileAds/GADRewardedAd.h>
#import <GoogleMobileAds/GADExtras.h>
#import "app_delegate.h"
#import "view_controller.h"
#include "object.h"

@class Rewarded;


@interface Rewarded: NSObject <GADRewardedAdDelegate> {
    GADRewardedAd *rewarded;
    bool initialized;
    int instanceId;
    NSString *adUnitId;
    ViewController *rootController;
}
@property (nonatomic, strong) Rewarded * rewarded;


- (instancetype)init: (int) instance_id;
- (void)load_rewarded: (NSString*) ad_unit_id;
- (void)show_rewarded;

@end
