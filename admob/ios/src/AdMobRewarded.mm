#import "AdMobRewarded.h"
#include "reference.h"

@implementation AdMobRewarded

- (void)dealloc {
    [rewarded release];
    [super dealloc];
}

- (void)initialize:(BOOL)is_real: (int)instance_id: (NSString*)test_device_id {
    isReal = is_real;
    initialized = true;
    instanceId = instance_id;
    testDeviceId = test_device_id;
    rootController = [AppDelegate getViewController];
}


- (void) load_rewarded:(NSString*)ad_unit_id {
    NSLog(@"Calling load_rewarded");
    
    if (!initialized) {
        return;
    }
    else{
        NSLog(@"rewarded will load with the id");
        NSLog(ad_unit_id);
    }
    
    if(!isReal) {
        rewarded = [[GADRewardedAd alloc] initWithAdUnitID:@"ca-app-pub-3940256099942544/1712485313"];
        NSLog(@"rewarded with test id created");
    }
    else {
        rewarded = [[GADRewardedAd alloc] initWithAdUnitID:ad_unit_id];
        NSLog(@"rewarded created with the id");
        NSLog(ad_unit_id);
    }

    GADRequest *request = [GADRequest request];
    if (!testDeviceId.length){
        request.testDevices = @[testDeviceId];
        NSLog(@"Using test device with id");
        NSLog(testDeviceId);
    }
    [rewarded loadRequest:request completionHandler:^(GADRequestError * _Nullable error) {
        if (error) {
            NSLog(@"error while creating reward");
        } else {
            NSLog(@"reward successfully loaded");
            Object *obj = ObjectDB::get_instance(instanceId);
            obj->call_deferred("_on_AdMob_rewarded_ad_loaded");
        }
    }];
    
}

- (void) show_rewarded {
    if (!initialized) {
        return;
    }

    if (rewarded.isReady) {
        [rewarded presentFromRootViewController:rootController delegate:self];
    } else {
        NSLog(@"reward ad wasn't ready");
    }
}


/// Tells the delegate that the user earned a reward.
- (void)rewardedAd:(GADRewardedAd *)rewardedAd userDidEarnReward:(GADAdReward *)reward {
  // TODO: Reward the user.
  NSLog(@"rewardedAd:userDidEarnReward:");
  NSString *rewardMessage = [NSString stringWithFormat:@"Reward received with currency %@ , amount %lf",
                                reward.type, [reward.amount doubleValue]];
  NSLog(rewardMessage);
  Object *obj = ObjectDB::get_instance(instanceId);
  obj->call_deferred("_on_AdMob_user_earned_rewarded", [reward.type UTF8String], reward.amount.doubleValue);
}

/// Tells the delegate that the rewarded ad was presented.
- (void)rewardedAdDidPresent:(GADRewardedAd *)rewardedAd {
  NSLog(@"rewardedAdDidPresent:");
  Object *obj = ObjectDB::get_instance(instanceId);
  obj->call_deferred("_on_AdMob_rewarded_ad_closed");
}

/// Tells the delegate that the rewarded ad failed to present.
- (void)rewardedAd:(GADRewardedAd *)rewardedAd didFailToPresentWithError:(NSError *)error {
  NSLog(@"rewardedAd:didFailToPresentWithError");
}

/// Tells the delegate that the rewarded ad was dismissed.
- (void)rewardedAdDidDismiss:(GADRewardedAd *)rewardedAd {
    NSLog(@"rewardedAdDidDismiss:");
}


@end