//
//  HCMUniversities.m
//  MAPIOS
//
//  Created by Apple on 1/24/16.
//  Copyright © 2016 AMOSC. All rights reserved.
//

#import "HCMUniversities.h"

@interface HCMUniversities () <MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapVIew;
@property (nonatomic, strong) CLGeocoder*geoCoder;

@end

@implementation HCMUniversities

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.mapVIew.delegate = self;
    [self initView];
    [self universityAnnotation];
}
- (void) initView{
    self.mapVIew.mapType = MKMapTypeHybrid;
    CLLocationCoordinate2D centerPoint = CLLocationCoordinate2DMake(10.823099, 106.629664);
    
    MKMapCamera*camera = [MKMapCamera cameraLookingAtCenterCoordinate:centerPoint fromDistance:100000 pitch:0 heading:0];
    self.mapVIew.camera = camera;

    
}
- (void) universityAnnotation{
    // get file
    NSString*filepath = [[NSBundle mainBundle]pathForResource:@"hcmlist" ofType:@"plist"];
    NSArray*raw = [[NSArray alloc]initWithContentsOfFile:filepath];
    
    // First step: make annotation
    for (NSDictionary*item in raw){
        MKPointAnnotation *annotation = [MKPointAnnotation new];
        
        annotation.title = item[@"name"];
        annotation.subtitle = item[@"adress"];
        
        // second step : coordinate
        self.geoCoder = [CLGeocoder new];
        [self.geoCoder geocodeAddressString:item[@"adress"] completionHandler:^(NSArray*placeMarks, NSError*error){
            CLPlacemark*placeMark = placeMarks.firstObject;
            annotation.coordinate = placeMark.location.coordinate;
        }];
        
        [self.mapVIew addAnnotation:annotation];
        
    }
}
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    
    MKAnnotationView*annotationView = (MKAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"AnnotationViewCell"];
    
    if (annotationView == nil){
        annotationView = [[MKAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"AnnotationViewCell"];
        annotationView.image = [UIImage imageNamed:@"universityicon.png"];
        annotationView.canShowCallout = YES;
    }else{
        annotationView.annotation = annotation;
    }
    return  annotationView;
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
