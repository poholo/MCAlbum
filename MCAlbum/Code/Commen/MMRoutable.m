//
//  MMRoutable.m
//  MMRoutable
//
//  Created by Clay Allsopp on 4/3/13.
//  Copyright (c) 2013 TurboProp Inc. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "MMRoutable.h"

@implementation MMRoutable

+ (instancetype)sharedRouter {
    static MMRoutable *_sharedRouter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedRouter = [[MMRoutable alloc] init];
#ifdef DEBUG
        _sharedRouter.ignoresExceptions = NO;
#else
        _sharedRouter.ignoresExceptions = YES;
#endif
    });
    return _sharedRouter;
}

//really unnecessary; kept for backward compatibility.
+ (instancetype)newRouter {
    return [[self alloc] init];
}

@end

@interface RouterParams : NSObject

@property(readwrite, nonatomic, strong) UPRouterOptions *routerOptions;
@property(readwrite, nonatomic, strong) NSMutableDictionary *openParams;
@property(readwrite, nonatomic, strong) NSMutableDictionary *extraParams;
@property(readwrite, nonatomic, strong) NSMutableDictionary *controllerParams;

@end

@implementation RouterParams

- (instancetype)initWithRouterOptions:(UPRouterOptions *)routerOptions openParams:(NSMutableDictionary *)openParams extraParams:(NSMutableDictionary *)extraParams {
    [self setRouterOptions:routerOptions];
    [self setExtraParams:extraParams];
    [self setOpenParams:openParams];
    return self;
}

- (NSMutableDictionary *)controllerParams {
    NSMutableDictionary *controllerParams = [NSMutableDictionary new];
    [controllerParams addEntriesFromDictionary:self.routerOptions.defaultParams];
    [controllerParams addEntriesFromDictionary:self.extraParams];
    [controllerParams addEntriesFromDictionary:self.openParams];
    return controllerParams;
}

//fake getter. Not idiomatic Objective-C. Use accessor controllerParams instead
- (NSMutableDictionary *)getControllerParams {
    return [self controllerParams];
}

@end

@interface UPRouterOptions ()

@property(readwrite, nonatomic, strong) Class openClass;
@property(readwrite, nonatomic, copy) RouterOpenCallback callback;
@end

@implementation UPRouterOptions

//Explicit construction
+ (instancetype)routerOptionsWithPresentationStyle:(UIModalPresentationStyle)presentationStyle
                                   transitionStyle:(UIModalTransitionStyle)transitionStyle
                                     defaultParams:(NSMutableDictionary *)defaultParams
                                            isRoot:(BOOL)isRoot
                                           isModal:(BOOL)isModal {
    UPRouterOptions *options = [[UPRouterOptions alloc] init];
    options.presentationStyle = presentationStyle;
    options.transitionStyle = transitionStyle;
    options.defaultParams = defaultParams;
    options.shouldOpenAsRootViewController = isRoot;
    options.modal = isModal;
    return options;
}

//Default construction; like [NSArray array]
+ (instancetype)routerOptions {
    return [self routerOptionsWithPresentationStyle:UIModalPresentationNone
                                    transitionStyle:UIModalTransitionStyleCoverVertical
                                      defaultParams:nil
                                             isRoot:NO
                                            isModal:NO];
}

//Custom class constructors, with heavier Objective-C accent
+ (instancetype)routerOptionsAsModal {
    return [self routerOptionsWithPresentationStyle:UIModalPresentationNone
                                    transitionStyle:UIModalTransitionStyleCoverVertical
                                      defaultParams:nil
                                             isRoot:NO
                                            isModal:YES];
}

+ (instancetype)routerOptionsWithPresentationStyle:(UIModalPresentationStyle)style {
    return [self routerOptionsWithPresentationStyle:style
                                    transitionStyle:UIModalTransitionStyleCoverVertical
                                      defaultParams:nil
                                             isRoot:NO
                                            isModal:NO];
}

+ (instancetype)routerOptionsWithTransitionStyle:(UIModalTransitionStyle)style {
    return [self routerOptionsWithPresentationStyle:UIModalPresentationNone
                                    transitionStyle:style
                                      defaultParams:nil
                                             isRoot:NO
                                            isModal:NO];
}

+ (instancetype)routerOptionsForDefaultParams:(NSMutableDictionary *)defaultParams {
    return [self routerOptionsWithPresentationStyle:UIModalPresentationNone
                                    transitionStyle:UIModalTransitionStyleCoverVertical
                                      defaultParams:defaultParams
                                             isRoot:NO
                                            isModal:NO];
}

+ (instancetype)routerOptionsAsRoot {
    return [self routerOptionsWithPresentationStyle:UIModalPresentationNone
                                    transitionStyle:UIModalTransitionStyleCoverVertical
                                      defaultParams:nil
                                             isRoot:YES
                                            isModal:NO];
}

//Exposed methods previously supported
+ (instancetype)modal {
    return [self routerOptionsAsModal];
}

+ (instancetype)withPresentationStyle:(UIModalPresentationStyle)style {
    return [self routerOptionsWithPresentationStyle:style];
}

+ (instancetype)withTransitionStyle:(UIModalTransitionStyle)style {
    return [self routerOptionsWithTransitionStyle:style];
}

+ (instancetype)forDefaultParams:(NSMutableDictionary *)defaultParams {
    return [self routerOptionsForDefaultParams:defaultParams];
}

+ (instancetype)root {
    return [self routerOptionsAsRoot];
}

//Wrappers around setters (to continue DSL-like syntax)
- (UPRouterOptions *)modal {
    [self setModal:YES];
    return self;
}

- (UPRouterOptions *)withPresentationStyle:(UIModalPresentationStyle)style {
    [self setPresentationStyle:style];
    return self;
}

- (UPRouterOptions *)withTransitionStyle:(UIModalTransitionStyle)style {
    [self setTransitionStyle:style];
    return self;
}

- (UPRouterOptions *)forDefaultParams:(NSMutableDictionary *)defaultParams {
    [self setDefaultParams:defaultParams];
    return self;
}

- (UPRouterOptions *)root {
    [self setShouldOpenAsRootViewController:YES];
    return self;
}
@end

@interface UPRouter ()

// Map of URL format NSString -> RouterOptions
// i.e. "users/:id"
@property(readwrite, nonatomic, strong) NSMutableDictionary *routes;
// Map of final URL NSStrings -> RouterParams
// i.e. "users/16"
@property(readwrite, nonatomic, strong) NSMutableDictionary *cachedRoutes;

@end

#define ROUTE_NOT_FOUND_FORMAT @"No route found for URL %@"
#define INVALID_CONTROLLER_FORMAT @"Your controller class %@ needs to implement either the static method %@ or the instance method %@"

@implementation UPRouter

- (id)init {
    if ((self = [super init])) {
        self.routes = [NSMutableDictionary dictionary];
        self.cachedRoutes = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)map:(NSString *)format toCallback:(RouterOpenCallback)callback {
    [self map:format toCallback:callback withOptions:nil];
}

- (void)map:(NSString *)format toCallback:(RouterOpenCallback)callback withOptions:(UPRouterOptions *)options {
    if (!format) {
        @throw [NSException exceptionWithName:@"RouteNotProvided"
                                       reason:@"Route #format is not initialized"
                                     userInfo:nil];
        return;
    }
    if (!options) {
        options = [UPRouterOptions routerOptions];
    }
    options.callback = callback;
    self.routes[format] = options;
}

- (void)map:(NSString *)format toController:(Class)controllerClass {
    [self map:format toController:controllerClass withOptions:nil];
}

- (void)map:(NSString *)format toController:(Class)controllerClass withOptions:(UPRouterOptions *)options {
    if (!format) {
        @throw [NSException exceptionWithName:@"RouteNotProvided"
                                       reason:@"Route #format is not initialized"
                                     userInfo:nil];
        return;
    }
    if (!options) {
        options = [UPRouterOptions routerOptions];
    }
    options.openClass = controllerClass;
    self.routes[format] = options;
}

- (void)openExternal:(NSString *)url {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

- (void)open:(NSString *)url {
    [self open:url animated:YES];
}

- (void)open:(NSString *)url animated:(BOOL)animated {
    [self open:url animated:animated extraParams:nil];
}

- (void)open:(NSString *)url animated:(BOOL)animated extraParams:(NSMutableDictionary *)extraParams {
    RouterParams *params = [self routerParamsForUrl:url extraParams:extraParams];
    UPRouterOptions *options = params.routerOptions;

    if (options.callback) {
        RouterOpenCallback callback = options.callback;
        callback([params controllerParams]);
        return;
    }

    if (!self.navigationController) {

        if (_ignoresExceptions) {
            return;
        }

        @throw [NSException exceptionWithName:@"NavigationControllerNotProvided"
                                       reason:@"Router#navigationController has not been set to a UINavigationController instance"
                                     userInfo:nil];
    }

    UIViewController *controller = [self controllerForRouterParams:params];

    if (self.navigationController.presentedViewController) {
        [self.navigationController dismissViewControllerAnimated:animated completion:nil];
    }

    if ([options isModal]) {
        if ([controller.class isSubclassOfClass:UINavigationController.class]) {
            [self.navigationController presentViewController:controller
                                                    animated:animated
                                                  completion:nil];
        } else {
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
            navigationController.modalPresentationStyle = controller.modalPresentationStyle;
            navigationController.modalTransitionStyle = controller.modalTransitionStyle;
            [self.navigationController presentViewController:navigationController
                                                    animated:animated
                                                  completion:nil];
        }
    } else if (options.shouldOpenAsRootViewController) {
        [self.navigationController setViewControllers:@[controller] animated:animated];
    } else {
        [self.navigationController pushViewController:controller animated:animated];
    }
}

- (NSMutableDictionary *)paramsOfUrl:(NSString *)url {
    return [[self routerParamsForUrl:url] controllerParams];
}

//Stack operations
- (void)popViewControllerFromRouterAnimated:(BOOL)animated {
    if (self.navigationController.presentedViewController) {
        [self.navigationController dismissViewControllerAnimated:animated completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:animated];
    }
}

- (void)pop {
    [self popViewControllerFromRouterAnimated:YES];
}

- (void)pop:(BOOL)animated {
    [self popViewControllerFromRouterAnimated:animated];
}

- (void)popToRootController {
    if (self.navigationController.presentedViewController) {
        [self.navigationController dismissViewControllerAnimated:NO completion:nil];
    } else {
        [self.navigationController popToRootViewControllerAnimated:NO];
    }
}

///////
- (RouterParams *)routerParamsForUrl:(NSString *)url extraParams:(NSMutableDictionary *)extraParams {
    if (!url) {
        //if we wait, caching this as key would throw an exception
        if (_ignoresExceptions) {
            return nil;
        }
        @throw [NSException exceptionWithName:@"RouteNotFoundException"
                                       reason:[NSString stringWithFormat:ROUTE_NOT_FOUND_FORMAT, url]
                                     userInfo:nil];
    }

    if (self.cachedRoutes[url] && !extraParams) {
        return self.cachedRoutes[url];
    }

    NSArray *givenParts = url.pathComponents;
    NSArray *legacyParts = [url componentsSeparatedByString:@"/"];
    if ([legacyParts count] != [givenParts count]) {
        NSLog(@"MMRoutable Warning - your URL %@ has empty path components - this will throw an error in an upcoming release", url);
        givenParts = legacyParts;
    }

    __block RouterParams *openParams = nil;
    [self.routes enumerateKeysAndObjectsUsingBlock:
            ^(NSString *routerUrl, UPRouterOptions *routerOptions, BOOL *stop) {

                NSArray *routerParts = [routerUrl pathComponents];
                if ([routerParts count] == [givenParts count]) {

                    NSMutableDictionary *givenParams = [self paramsForUrlComponents:givenParts routerUrlComponents:routerParts];
                    if (givenParams) {
                        openParams = [[RouterParams alloc] initWithRouterOptions:routerOptions openParams:givenParams extraParams:extraParams];
                        *stop = YES;
                    }
                }
            }];

    if (!openParams) {
        if (_ignoresExceptions) {
            return nil;
        }
        @throw [NSException exceptionWithName:@"RouteNotFoundException"
                                       reason:[NSString stringWithFormat:ROUTE_NOT_FOUND_FORMAT, url]
                                     userInfo:nil];
    }
    self.cachedRoutes[url] = openParams;
    return openParams;
}

- (RouterParams *)routerParamsForUrl:(NSString *)url {
    return [self routerParamsForUrl:url extraParams:nil];
}

- (NSMutableDictionary *)paramsForUrlComponents:(NSArray *)givenUrlComponents
                            routerUrlComponents:(NSArray *)routerUrlComponents {

    __block NSMutableDictionary *params = [NSMutableDictionary new];
    [routerUrlComponents enumerateObjectsUsingBlock:
            ^(NSString *routerComponent, NSUInteger idx, BOOL *stop) {

                NSString *givenComponent = givenUrlComponents[idx];
                if ([routerComponent hasPrefix:@":"]) {
                    NSString *key = [routerComponent substringFromIndex:1];
                    params[key] = givenComponent;
                } else if (![routerComponent isEqualToString:givenComponent]) {
                    params = nil;
                    *stop = YES;
                }
            }];
    return params;
}

- (UIViewController *)controllerForRouterParams:(RouterParams *)params {
    SEL CONTROLLER_CLASS_SELECTOR = sel_registerName("allocWithRouterParams:");
    SEL CONTROLLER_SELECTOR = sel_registerName("initWithRouterParams:");
    UIViewController *controller = nil;
    Class controllerClass = params.routerOptions.openClass;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    if ([controllerClass respondsToSelector:CONTROLLER_CLASS_SELECTOR]) {
        controller = [controllerClass performSelector:CONTROLLER_CLASS_SELECTOR withObject:[params controllerParams]];
    } else if ([params.routerOptions.openClass instancesRespondToSelector:CONTROLLER_SELECTOR]) {
        controller = [[params.routerOptions.openClass alloc] performSelector:CONTROLLER_SELECTOR withObject:[params controllerParams]];
    }
#pragma clang diagnostic pop
    if (!controller) {
        if (_ignoresExceptions) {
            return controller;
        }
        @throw [NSException exceptionWithName:@"RoutableInitializerNotFound"
                                       reason:[NSString stringWithFormat:INVALID_CONTROLLER_FORMAT, NSStringFromClass(controllerClass), NSStringFromSelector(CONTROLLER_CLASS_SELECTOR), NSStringFromSelector(CONTROLLER_SELECTOR)]
                                     userInfo:nil];
    }

    controller.modalTransitionStyle = params.routerOptions.transitionStyle;
    controller.modalPresentationStyle = params.routerOptions.presentationStyle;
    return controller;
}

@end

