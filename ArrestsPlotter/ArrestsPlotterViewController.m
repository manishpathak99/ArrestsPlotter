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
#import "MapFilterUiModel.h"
#import "FilterView.h"
#import "FilterBoxView.h"

#define VIEW_WHITE_FRAME_PADDING 10
#define SPACE_BETWEEN_WHITE_BOX 5

#define METERS_PER_MILE 1609.344
#define FILTER_VIEW_WIDTH 225
#define FILTER_VIEW_HEIGHT 30

@interface ArrestsPlotterViewController ()

@end

@implementation ArrestsPlotterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.mapView setFrame:CGRectMake(0, 0, 600, 600)];
    [self createFilterBoxView];
    
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    CLLocationCoordinate2D zoomLocation;
    // Synaptian location
    // zoomLocation.latitude = 36.321563;
    // zoomLocation.longitude = -82.357173;
    // Baltimore location (for testing json data through Socrata API)
    zoomLocation.latitude = 28.6139;
    zoomLocation.longitude = 77.2090;
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 0.5 * METERS_PER_MILE, 0.5 * METERS_PER_MILE);
    
    [_mapView setRegion:viewRegion animated:YES];
    
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //    [self createFilterView];
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
    
    NSArray *keys = [NSArray arrayWithObjects:@"New Delhi", @"Mumbai", @"Gurgaon", nil];
    //    NSArray *objects = [NSArray arrayWithObjects:CLLocationCoordinate2DMake(28.6139, 77.2090), CLLocationCoordinate2DMake(18.9750, 72.8258), CLLocationCoordinate2DMake(28.4700,  77.0300), nil];
    
    for(NSString *key in keys) {
        //        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(28.6139, 77.2090);
        CLLocationCoordinate2D coordinate;
        coordinate.latitude = 28.6139;
        coordinate.longitude = 77.2090;
        MyLocation *annotation = [[MyLocation alloc] initWithName:@"Description" address:key coordinate:coordinate];
        [_mapView addAnnotation:annotation];
    }
    //    NSDictionary *dict = [NSDictionary dictionaryWiththObjects:objects
    //                                forKeys:keys];
    //    NSDictionary *dict=@{@"New Delhi": CLLocationCoordinate2DMake(28.6139, 77.2090),
    //                         @"Mumbai":CLLocationCoordinate2DMake(18.9750, 72.8258),
    //                         @"Gurgaon":CLLocationCoordinate2DMake(28.4700, 77.0300),
    //                         };
    //    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(23, 23);
    //    coordinate.latitude = 28.6139;
    //    coordinate.longitude = 77.2090;
    //    for (int index = 0; index < 2; index++) {
    //        MyLocation *annotation = [[MyLocation alloc] initWithName:@"Description" address:@"New Delhi" coordinate:coordinate];
    //        [_mapView addAnnotation:annotation];
    //    }
    //
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
    hud.labelText = @"Loading Locations...";
}

/***********************FILTERVIEW CODE*******************************/

-(void) createFilterBoxView {
    
    // Dummy images for filterview
    NSMutableArray *filterArray=[NSMutableArray new];
    NSMutableArray *arrayOfFilterArray=[NSMutableArray new];
    for (int index = 0; index < 6; index++) {
        MapFilterUiModel *uiModel = [[MapFilterUiModel alloc] init];
        uiModel.checkboxSelectedImage =  [UIImage imageNamed:@"checkbox_check.png"];
        uiModel.checkboxUnselectedImage  =  [UIImage imageNamed:@"checkbox_normal.png"];
        uiModel.circleImage = [UIImage imageNamed: @"green-circle.png"];
        switch (index) {
            case 0:
                uiModel.labelText = [NSString stringWithFormat:@"Mega", index];
                [filterArray addObject:uiModel];
                break;
            case 1:
                uiModel.labelText = [NSString stringWithFormat:@"Medium", index];
                [filterArray addObject:uiModel];
                break;
            case 2:
                uiModel.labelText = [NSString stringWithFormat:@"Small", index];
                [filterArray addObject:uiModel];
                [arrayOfFilterArray addObject:filterArray];
                filterArray =[NSMutableArray new];
                break;
            case 3:
                uiModel.labelText = [NSString stringWithFormat:@"Listed", index];
                [filterArray addObject:uiModel];
                break;
            case 4:
                uiModel.labelText = [NSString stringWithFormat:@"Unlisted", index];
                [filterArray addObject:uiModel];
                break;
            case 5:
                uiModel.labelText = [NSString stringWithFormat:@"Others", index];
                [filterArray addObject:uiModel];
                [arrayOfFilterArray addObject:filterArray];
                break;
                
            default:
                break;
        }
    }
    /*Tag ID for the checkBox, will be the same of filterbox Array. if total elements are 6 , tagId would be 0,1,2,3,4,5 */
    int tagId = 0;
    
    /*get filterbox object from NIB to get the width in advance*/
    FilterBoxView *boxView = [[[NSBundle mainBundle] loadNibNamed:@"FilterBoxView" owner:nil options:nil] lastObject];
    int countTotalElements = 0;
    for (NSArray *filterTitles in arrayOfFilterArray) {
        for(MapFilterUiModel *filterModel in filterTitles) {
            countTotalElements = countTotalElements + 1;
        }
        
    }
    float widthInAdvance = countTotalElements * boxView.frame.size.width;
    /*calculate the margin left and right margin on basis of total elements in array*/
    float marginLeftRight = (self.view.frame.size.width - widthInAdvance - SPACE_BETWEEN_WHITE_BOX * arrayOfFilterArray.count - 2 * VIEW_WHITE_FRAME_PADDING)/2 - 20;
    int runningCoordinateX =0 ;// calculate x by Filterbox placed
    for (NSArray *filterTitles in arrayOfFilterArray) {
        float whiteX = marginLeftRight;//white margin left
        optionView = [[UIView alloc] initWithFrame:CGRectMake(runningCoordinateX + whiteX, self.view.bounds.size.height-150, filterTitles.count * boxView.frame.size.width + VIEW_WHITE_FRAME_PADDING * 2, boxView.frame.size.height)];
        optionView.backgroundColor = [UIColor whiteColor];
        [optionView setAlpha:0.8f];
        [self.view addSubview:optionView];
        
        runningCoordinateX = VIEW_WHITE_FRAME_PADDING * 2;// start of FilterBox
        for(MapFilterUiModel *filterModel in filterTitles) {
            FilterBoxView *boxView = [[[NSBundle mainBundle] loadNibNamed:@"FilterBoxView" owner:nil options:nil] lastObject];
            [boxView.uiCheckBox addTarget:self action:@selector(checkBoxStateChanges:) forControlEvents:UIControlEventTouchUpInside];
            boxView.uiCheckBox.tag = tagId++;
            [boxView.circle setImage:filterModel.circleImage];
            [boxView.label setText:filterModel.labelText];
            boxView.backgroundColor = [UIColor clearColor];
            
            CGRect rect = boxView.frame;
            rect.origin.x = runningCoordinateX;
            rect.origin.y = 0;
            boxView.frame = rect;
            runningCoordinateX = rect.origin.x + boxView.frame.size.width;
            [optionView addSubview:boxView];
            whiteX = whiteX + boxView.frame.size.width;
        }
        runningCoordinateX = runningCoordinateX + SPACE_BETWEEN_WHITE_BOX;//for middle space between white box
    }
}

- (void)checkBoxStateChanges:(UIButton*)btn
{
    /*  if (!btn.selected) {
     [btn setBackgroundImage:[UIImage imageNamed:@"checkbox_check"] forState:UIControlStateNormal];
     }
     else{
     [btn setBackgroundImage:[UIImage imageNamed:@"checkbox_normal"] forState:UIControlStateNormal];
     }*/
    btn.selected = !btn.selected;
    if(btn.selected) {
        NSLog([NSString stringWithFormat:@"%@ %ld",@"CHECKBOX Selected", (long)btn.tag]);
        // create filter array from the ServerData array and pass to map for anntation
    }
}
/***********************************END**************************************/

-(void) createFilterView {
    // Dummy images for filterview
    NSMutableArray *filterArray=[NSMutableArray new];
    NSMutableArray *arrayOfFilterArray=[NSMutableArray new];
    for (int index = 0; index < 6; index++) {
        MapFilterUiModel *uiModel = [[MapFilterUiModel alloc] init];
        uiModel.checkboxSelectedImage =  [UIImage imageNamed:@"checkbox_check.png"];
        uiModel.checkboxUnselectedImage  =  [UIImage imageNamed:@"checkbox_normal.png"];
        uiModel.circleImage = [UIImage imageNamed: @"green-circle.png"];
        switch (index) {
            case 0:
                uiModel.labelText = [NSString stringWithFormat:@"Mega", index];
                [filterArray addObject:uiModel];
                break;
            case 1:
                uiModel.labelText = [NSString stringWithFormat:@"Medium", index];
                [filterArray addObject:uiModel];
                break;
            case 2:
                uiModel.labelText = [NSString stringWithFormat:@"Small", index];
                [filterArray addObject:uiModel];
                [arrayOfFilterArray addObject:filterArray];
                filterArray =[NSMutableArray new];
                break;
            case 3:
                uiModel.labelText = [NSString stringWithFormat:@"Listed", index];
                [filterArray addObject:uiModel];
                break;
            case 4:
                uiModel.labelText = [NSString stringWithFormat:@"Unlisted", index];
                [filterArray addObject:uiModel];
                break;
            case 5:
                uiModel.labelText = [NSString stringWithFormat:@"Others", index];
                [filterArray addObject:uiModel];
                [arrayOfFilterArray addObject:filterArray];
                break;
                
            default:
                break;
        }
    }
    
    //    FilterView *filterView = [[FilterView alloc] initCustomWithFrame:_mapView.frame];
    //    [filterView setUserInteractionEnabled:YES];
    //    [filterView setFilters:arrayOfFilterArray];
    //    UIView *uiView = [filterView createFilterViewWithArray:filterArray];
    //    [filterView addSubview:uiView];
    //    [uiView setFrame:uiView.frame];
    
    //    [self.mapView addSubview:filterView];
    
    //    [filterView createFilterView:[filterArray subarrayWithRange:NSMakeRange(0, 3)]];
    //    [_mapView addSubview:filterView ];
    //
    //    filterArray = [filterArray subarrayWithRange:NSMakeRange(3, 3)];
    //
    //    filterView=[[FilterView alloc]initWithFrame:CGRectMake(filterView.frame.size.width+25, screenRect.size.height-80, screenWidth - FILTER_VIEW_WIDTH- 40, FILTER_VIEW_HEIGHT)];
    //    //    [filterView setBackgroundColor:[UIColor clearColor]];
    //    [filterView createFilterView:filterArray];
    //    [_mapView addSubview:filterView];
    
}

-(NSMutableDictionary*) createDataWithDictionary{
    NSMutableDictionary *testDictionary = [[NSMutableDictionary alloc] init];
    // Dummy images for filterview
    NSMutableArray *filterArray=[NSMutableArray new];
    for (int index = 0; index < 3; index++) {
        MapFilterUiModel *uiModel = [[MapFilterUiModel alloc] init];
        uiModel.checkboxSelectedImage =  [UIImage imageNamed:@"checkbox_check.png"];
        uiModel.checkboxUnselectedImage  =  [UIImage imageNamed:@"checkbox_normal.png"];
        uiModel.circleImage = [UIImage imageNamed: @"green-circle.png"];
        switch (index) {
            case 0:
                uiModel.labelText = [NSString stringWithFormat:@"Mega", index];
                break;
            case 1:
                uiModel.labelText = [NSString stringWithFormat:@"Medium", index];
                break;
            case 2:
                uiModel.labelText = [NSString stringWithFormat:@"Small", index];
                break;
                
            default:
                break;
        }
        
        [filterArray addObject:uiModel];
    }
    NSMutableArray *filter=[NSMutableArray new];
    [filter addObject:@"ok"];
    [testDictionary setObject: filter
                       forKey:[NSNumber numberWithInt:0]];
    [testDictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop)
     {
         
         NSLog(@"%@:%@",key,obj);
         //       UIView *view = [ self createFilterViewWithArray:obj];
         //        [viewHolder addSubview:view];
         
     }];
    NSLog(@"Test dictionary: %@", testDictionary);
    
    //    filterArray=[NSMutableArray new];
    //     [filterArray init];
    //    for (int index = 0; index < 3; index++) {
    //        MapFilterUiModel *uiModel = [[MapFilterUiModel alloc] init];
    //        uiModel.checkboxSelectedImage =  [UIImage imageNamed:@"checkbox_check.png"];
    //        uiModel.checkboxUnselectedImage  =  [UIImage imageNamed:@"checkbox_normal.png"];
    //        uiModel.circleImage = [UIImage imageNamed: @"green-circle.png"];
    //        switch (index) {
    //            case 0:
    //                uiModel.labelText = [NSString stringWithFormat:@"Listed", index];
    //                break;
    //            case 1:
    //                uiModel.labelText = [NSString stringWithFormat:@"Unlisted", index];
    //                break;
    //            case 2:
    //                uiModel.labelText = [NSString stringWithFormat:@"Others", index];
    //                break;
    //
    //            default:
    //                break;
    //        }
    //        [filterArray addObject:uiModel];
    //    }
    //    [testDictionary setObject: filterArray
    //                       forKey:[NSNumber numberWithInt:1]];
    NSLog(@"Test dictionary: %@", testDictionary);
    
}


@end
