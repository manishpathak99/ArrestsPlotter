//
//  ArrestsPlotterViewController.h
//  ArrestsPlotter
//
//  Created by Nathanial L. McConnell on 3/15/13.
//  Copyright (c) 2013 nmcconnell.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface ArrestsPlotterViewController : UIViewController <MKMapViewDelegate>
{
    UIView *optionView;
}

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

- (IBAction)refreshTapped:(id)sender;

@end
