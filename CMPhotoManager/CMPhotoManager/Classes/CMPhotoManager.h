//
//  CMPhotoManager.h
//  CMPhotoManager
//
//  Created by CrabMan on 2017/5/5.
//  Copyright © 2017年 CrabMan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface CMPhotoManager : NSObject
/**
 保存相片（会创建项目名称的相簿）

 */
- (void)saveImage:(UIImage *)img;

/**
 根据图片名称删除相册中的图片
 @param imgName 图片名称
 */
- (void)deleteImage:(NSString *)imgName;


/**
 删除自定义相册以及图片且无法恢复
 */
- (void)deleteAssetCollection;


@end
