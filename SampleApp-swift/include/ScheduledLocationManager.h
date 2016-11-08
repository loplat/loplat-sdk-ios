#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>

@protocol ScheduledLocationManagerDelegate <NSObject>

-(void)scheduledLocationManageDidFailWithError:(NSError*)error;
-(void)scheduledLocationManageDidUpdateLocations:(NSArray*)locations;

@end

@interface ScheduledLocationManager : NSObject <CLLocationManagerDelegate>{
    id <ScheduledLocationManagerDelegate> delegate;
}
@property (retain) id delegate;

-(void)getUserLocationWithInterval:(int)interval;

@end


