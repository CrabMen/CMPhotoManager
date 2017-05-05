//
//  CMPhotoManager.m
//  CMPhotoManager
//
//  Created by CrabMan on 2017/5/5.
//  Copyright © 2017年 CrabMan. All rights reserved.
//

#import "CMPhotoManager.h"
#import <Photos/Photos.h>
@implementation CMPhotoManager


- (PHAssetCollection *)createdCollection {
    //项目名称
    __block NSString *bundleName = [[NSBundle mainBundle]infoDictionary][(NSString *)kCFBundleNameKey];
    
    //判断相册中是否有已经创建好的自定义相册
    PHFetchResult<PHAssetCollection *> * collections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    
    for (PHAssetCollection *collection in collections) {
        if ([collection.localizedTitle isEqualToString:bundleName]) {
            
            return  collection;
            
        }
    }
    //创建自定义相册
    NSError *error = nil;
    __block NSString *collectionID = @"";
    
    [[PHPhotoLibrary sharedPhotoLibrary]performChangesAndWait:^{
        
        collectionID =  [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:bundleName].placeholderForCreatedAssetCollection.localIdentifier;
        
    } error:&error];
    
    if (error) {
        NSLog(@"相册创建失败!");
    }
    
    
    return  [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[collectionID] options:nil].firstObject;
    
}

- (PHFetchResult<PHAsset *> *)createdAssetsWithImage:(UIImage *)img {
    NSError *error = nil;
    __block NSString *assetID = nil;
    
    [[PHPhotoLibrary sharedPhotoLibrary]performChangesAndWait:^{
        
        assetID = [PHAssetChangeRequest creationRequestForAssetFromImage:img].placeholderForCreatedAsset.localIdentifier;
        
    } error:&error];
    
    if (error) return nil;
    
    
    return [PHAsset fetchAssetsWithLocalIdentifiers:@[assetID] options:nil];
    
}


- (void)saveImage:(UIImage *)img {

    PHAuthorizationStatus oldStatus = [PHPhotoLibrary authorizationStatus];
    
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if (status == PHAuthorizationStatusDenied && oldStatus != PHAuthorizationStatusNotDetermined) {
            NSLog(@"提示用户去设置中开启权限");
            
            NSURL *settingUrl = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            
            [[UIApplication sharedApplication]openURL:settingUrl options:nil completionHandler:^(BOOL success) {
                
            }];
            
            
            
            
        } else if (oldStatus == PHAuthorizationStatusAuthorized) {
            
            [self saveImageIntoAlbum:img];
            
        } else if (oldStatus == PHAuthorizationStatusRestricted) {
            
            NSLog(@"因系统原因无法访问相册");
            
        }
        
        
    }];

}


- (void)saveImageIntoAlbum:(UIImage *)img {


    //保存图片到【相机胶卷 】
    NSError *error = nil;
    
    PHFetchResult<PHAsset *> *createdAssets = [self createdAssetsWithImage:img];
    
    
    //添加图片到自定义相册
    PHAssetCollection *cretatedCollection = self.createdCollection;
    
    if (cretatedCollection == nil) {
        NSLog(@"创建相册失败");
    }
    
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        PHAssetCollectionChangeRequest *request = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:cretatedCollection];
        //插入到第一张
        [request insertAssets:createdAssets atIndexes:[NSIndexSet indexSetWithIndex:0]];
    } error:&error];
    
    if (error) {
        NSLog(@"保存图片失败");
    } else {
        
        NSLog(@"保存图片成功");
    }
    

}


- (void)alertUserToAuthorize {

UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"请去设置中开启访问\"相片\"权限!" message:nil
                                                          preferredStyle:UIAlertControllerStyleAlert];
    
    
    UIAlertAction *cancenlAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];

    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"去开启" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        
        [[UIApplication sharedApplication] openURL:url];
        
    }];
    
    
    [alertVC addAction:cancenlAction];
    [alertVC addAction:okAction];
    
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertVC animated:YES completion:nil];

}


@end
