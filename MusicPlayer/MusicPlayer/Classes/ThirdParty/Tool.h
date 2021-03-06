//
//  Tool.h
//  LJJMp3Player
//
//  Created by Mac on 15-3-14.
//  Copyright (c) 2015年 LJJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Accelerate/Accelerate.h>
@interface Tool : NSObject
//高斯模糊效果
+(UIImage *)blurryImage:(UIImage *)image withBlurLevel:(CGFloat)blur;
//圆形效果
+(void)ImageHandleWithImageView:(UIImageView*)imageView andImageName:(NSString*)imageName;
@end
