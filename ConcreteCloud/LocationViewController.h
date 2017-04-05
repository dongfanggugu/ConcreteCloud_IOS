//
//  LocationViewController.h
//  elevatorMan
//
//  Created by 长浩 张 on 16/7/5.
//
//

#ifndef LocationViewController_h
#define LocationViewController_h

#import "ComViewController.h"

@protocol LocationControllerDelegate <NSObject>

- (void)onChooseAddressLat:(CGFloat)lat lng:(CGFloat)lng;

@end

@interface LocationViewController : ComViewController

@property (strong, nonatomic) NSString *address;

@property (strong, nonatomic) NSString *city;

@property (weak, nonatomic) id<LocationControllerDelegate> delegate;


@end


#endif /* LocationViewController_h */
