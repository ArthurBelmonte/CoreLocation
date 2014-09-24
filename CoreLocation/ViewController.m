//
//  ViewController.m
//  CoreLocation
//
//  Created by Art on 9/22/14.
//  Copyright (c) 2014 Test. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface ViewController () <CLLocationManagerDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;

- (IBAction)requestAlwaysAuthorization:(id)sender;
- (IBAction)requestWhenInUseAuthorization:(id)sender;
- (IBAction)getLocation:(id)sender;
- (IBAction)startVisitMonitoring:(id)sender;
- (IBAction)openSettings:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.locationManager = [[CLLocationManager alloc] init];
    [self.locationManager setDelegate:self];
}

- (IBAction)requestAlwaysAuthorization:(id)sender
{
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        [self.locationManager requestAlwaysAuthorization];
    }
}

- (IBAction)requestWhenInUseAuthorization:(id)sender
{
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        [self.locationManager requestWhenInUseAuthorization];
    }
}

- (IBAction)getLocation:(id)sender
{
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied ||
        [CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Authorization Request" message:@"To use this feature you need to turn on Location Service." delegate:self cancelButtonTitle:@"Nope" otherButtonTitles:@"Go to Settings", nil];
        [alert show];
    }
    else {
        [self.locationManager startUpdatingLocation];
    }
}

- (IBAction)startVisitMonitoring:(id)sender
{
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied ||
        [CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Authorization Request" message:@"To use this feature you need to turn on Location Service." delegate:self cancelButtonTitle:@"Nope" otherButtonTitles:@"Go to Settings", nil];
        [alert show];
    }
    else {
        [self.locationManager startUpdatingLocation];
    }
}

- (IBAction)openSettings:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
}

# pragma mark - CLLocationManagerDelegate Methods

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *loc = locations.lastObject;
    NSLog(@"Location Object: %@", loc);
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"%@", error.localizedDescription);
}

- (void)locationManager:(CLLocationManager *)manager didVisit:(CLVisit *)visit
{
    NSLog(@"%@", visit);
}

# pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }
}

@end
