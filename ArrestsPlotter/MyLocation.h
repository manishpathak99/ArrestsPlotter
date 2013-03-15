//
//  MyLocation.h
//  ArrestsPlotter
//
//  Created by Nathanial L. McConnell on 3/15/13.
//  Copyright (c) 2013 nmcconnell.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MyLocation : NSObject <MKAnnotation>

- (id)initWithName:(NSString *)name address:(NSString *)address coordinate:(CLLocationCoordinate2D)coordinate;
- (MKMapItem *)mapItem;

@end
