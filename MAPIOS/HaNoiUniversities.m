//
//  HaNoiUniversities.m
//  MAPIOS
//
//  Created by Apple on 1/24/16.
//  Copyright © 2016 AMOSC. All rights reserved.
//

#import "HaNoiUniversities.h"
#define Meter_Per_Mile 1609.0;

@interface HaNoiUniversities () <MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property CLGeocoder* geoCoder;

@end

@implementation HaNoiUniversities

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    
    self.mapView.delegate = self;
    self.mapView.mapType = MKMapTypeHybrid;
    self.geoCoder = [CLGeocoder new];
    
    [self firstView];
    [self unniversityAnnotations];
    
    
}
- (void) firstView{
    CLLocationCoordinate2D centerPoint = CLLocationCoordinate2DMake(21.027764, 105.834160);
        MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(centerPoint, 10000, 10000);
    [self.mapView setRegion:viewRegion];
    
                                                            
    
}
- (void) unniversityAnnotations{
    // add each annotation to map view
    //zero step : get file
    NSString*filename = [[NSBundle mainBundle]pathForResource:@"hanoilist" ofType:@"plist"];
    NSArray*raw = [[NSArray alloc]initWithContentsOfFile:filename];
    
    // first step create annotation : MKPOINTANNOTATION
    for (NSDictionary*item in raw){
        
        MKPointAnnotation*annotation = [MKPointAnnotation new];
        annotation.title = item[@"name"];
        annotation.subtitle = item[@"adress"];
        
        // second step: get coordinate
        self.geoCoder = [CLGeocoder new];
        [self.geoCoder geocodeAddressString:item[@"adress"] completionHandler:^(NSArray*placeMarks, NSError*error){

            if (!error){
                CLPlacemark *placeMark = placeMarks.firstObject;
                annotation.coordinate = placeMark.location.coordinate;

            }
            
            // third step : add annotation
            [self.mapView addAnnotation:annotation];
        }];
        
    }
    
    

    //second step : add to annotation
    
}
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    MKAnnotationView*annotationView = (MKAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"AnnotationViewCell"];
    if (annotationView==nil){
        
        annotationView = [[MKAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"AnnotationViewCell"];
        annotationView.image = [UIImage imageNamed:@"universityicon.png"];
        
        annotationView.canShowCallout = YES;
        
    }else{
        annotationView.annotation = annotation;
    }
   
    return annotationView;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
