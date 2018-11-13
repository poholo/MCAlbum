//
// Created by majiancheng on 2017/9/2.
// Copyright (c) 2017 mjc inc. All rights reserved.
//

#import "AlbumRoute.h"


#import "AlbumDetailController.h"
#import "AlbumCategroriesController.h"
#import "AlbumActionDto.h"
#import "MMRoutable.h"

NSString *const kRouteAlbumAction = @"kRouteAlbumAction";
NSString *const kRouteAlbumModel = @"kRouteAlbumModel";
NSString *const kRouteAlbumSelectCallBack = @"kRouteAlbumSelectCallBack";

@implementation AlbumRoute {

}

+ (void)load {
    [AlbumRoute registerAlbum];
}

+ (void)registerAlbum {
    MMRoutable *routable = [MMRoutable sharedRouter];
    [routable map:[AlbumDetailController identifier] toController:[AlbumDetailController class]];
    [routable map:[AlbumCategroriesController identifier] toController:[AlbumCategroriesController class]];
}

+ (void)presentAlbumList:(AlbumActionDto *)albumActionDto {
    NSMutableDictionary *mmDict = [NSMutableDictionary dictionary];
    mmDict[kRouteAlbumAction] = albumActionDto;
    AlbumCategroriesController *albumCategroriesController = [[AlbumCategroriesController alloc] initWithRouterParams:mmDict];
    [[[MMRoutable sharedRouter].navigationController topViewController] presentViewController:albumCategroriesController animated:YES completion:nil];
}

+ (void)presentAlbumDetail:(AlbumActionDto *)albumActionDto album:(MMAlbumModel *)albumModel {
    NSMutableDictionary *mmDict = [NSMutableDictionary dictionary];
    mmDict[kRouteAlbumModel] = albumModel;
    mmDict[kRouteAlbumAction] = albumActionDto;
    AlbumDetailController *albumDetailController = [[AlbumDetailController alloc] initWithRouterParams:mmDict];
    [[[MMRoutable sharedRouter].navigationController topViewController] presentViewController:albumDetailController animated:YES completion:nil];
}

+ (void)pushAlbumList:(AlbumActionDto *)albumActionDto {
    NSMutableDictionary *mmDict = [NSMutableDictionary dictionary];
    mmDict[kRouteAlbumAction] = albumActionDto;
    [[MMRoutable sharedRouter] open:[AlbumCategroriesController identifier] animated:YES extraParams:mmDict];
}

+ (void)pushAlbumDetail:(AlbumActionDto *)albumActionDto album:(MMAlbumModel *)albumModel selectedCallBack:(void (^)(NSMutableArray<MCAssetDto *> *))selectCallBack {
    NSMutableDictionary *mmDict = [NSMutableDictionary dictionary];
    mmDict[kRouteAlbumModel] = albumModel;
    mmDict[kRouteAlbumAction] = albumActionDto;
    mmDict[kRouteAlbumSelectCallBack] = selectCallBack;
    [[MMRoutable sharedRouter] open:[AlbumDetailController identifier] animated:YES extraParams:mmDict];
}

@end
