//
//  ArrestsPlotterViewController.m
//  ArrestsPlotter
//
//  Created by Nathanial L. McConnell on 3/15/13.
//  Copyright (c) 2013 nmcconnell.com. All rights reserved.
//

#import "ArrestsPlotterViewController.h"
#import "ASIHTTPRequest.h"
#import "MyLocation.h"
#import "MBProgressHUD.h"

#define METERS_PER_MILE 1609.344

@interface ArrestsPlotterViewController ()

@end

@implementation ArrestsPlotterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    CLLocationCoordinate2D zoomLocation;
    // Synaptian location
    // zoomLocation.latitude = 36.321563;
    // zoomLocation.longitude = -82.357173;
    // Baltimore location (for testing json data through Socrata API)
    zoomLocation.latitude = 39.281516;
    zoomLocation.longitude = -76.580806;
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 0.5 * METERS_PER_MILE, 0.5 * METERS_PER_MILE);
    
    [_mapView setRegion:viewRegion animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    MyLocation *location = (MyLocation *)view.annotation;
    
    NSDictionary *launchOptions = @{MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving};
    [location.mapItem openInMapsWithLaunchOptions:launchOptions];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    static NSString *identifier = @"MyLocation";
    if ([annotation isKindOfClass:[MyLocation class]]) {
        MKAnnotationView *annotationView = (MKAnnotationView *)[_mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            annotationView.enabled = YES;
            annotationView.canShowCallout = YES;
            annotationView.image = [UIImage imageNamed:@"arrest.png"];
            annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        } else {
            annotationView.annotation = annotation;
        }
        
        return  annotationView;
    }
    
    return nil;
}

- (void)plotCrimePositions:(NSData *)responseData
{
    for (id<MKAnnotation> annotation in _mapView.annotations) {
        [_mapView removeAnnotation:annotation];
    }
    
    NSDictionary *root = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil];
    NSArray *data = [root objectForKey:@"data"];
    
    for (NSArray *row in data) {
        NSNumber *latitude = [[row objectAtIndex:22]objectAtIndex:1];
        NSNumber *longitude = [[row objectAtIndex:22]objectAtIndex:2];
        NSString *crimeDescription = [row objectAtIndex:18];
        NSString *address = [row objectAtIndex:14];
        
        CLLocationCoordinate2D coordinate;
        coordinate.latitude = latitude.doubleValue;
        coordinate.longitude = longitude.doubleValue;
        MyLocation *annotation = [[MyLocation alloc] initWithName:crimeDescription address:address coordinate:coordinate];
        [_mapView addAnnotation:annotation];
    }
}

- (IBAction)refreshTapped:(id)sender
{
    MKCoordinateRegion mapRegion = [_mapView region];
    CLLocationCoordinate2D centerLocation = mapRegion.center;
    
    NSString *jsonFile = [[NSBundle mainBundle] pathForResource:@"command" ofType:@"json"];
    NSString *formatString = [NSString stringWithContentsOfFile:jsonFile encoding:NSUTF8StringEncoding error:nil];
    NSString *json = [NSString stringWithFormat:formatString, centerLocation.latitude, centerLocation.longitude, 0.5 * METERS_PER_MILE];
    
    NSURL *url = [NSURL URLWithString:(NSString *)@"http://data.baltimorecity.gov/api/views/INLINE/rows.json?method=index"];
    
    ASIHTTPRequest *_request = [ASIHTTPRequest requestWithURL:url];
    __weak ASIHTTPRequest *request = _request;
    
    request.requestMethod = @"POST";
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    [request appendPostData:[json dataUsingEncoding:NSUTF8StringEncoding]];
    [request setDelegate:self];
    [request setCompletionBlock:^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSString *responseString = [request responseString];
        [self plotCrimePositions:request.responseData];
        NSLog(@"Response: %@", responseString);
    }];
    [request setFailedBlock:^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSError *error = [request error];
        NSLog(@"Error: %@", error.localizedDescription);
    }];
    
    [request startAsynchronous];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Loading arrests...";
}
@end
