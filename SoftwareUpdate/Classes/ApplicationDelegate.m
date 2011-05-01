/*******************************************************************************
 * Copyright (c) 2011, Jean-David Gadina <macmade@eosgarden.com>
 * All rights reserved
 ******************************************************************************/
 
/* $Id$ */

/*!
 * @file        
 * @copyright   eosgarden 2011 - Jean-David Gadina <macmade@eosgarden.com>
 * @abstract    ...
 */

#import "ApplicationDelegate.h"
#import "NavigationController.h"
#import "MainViewController.h"

@implementation ApplicationDelegate

@synthesize window           = _window;
@synthesize tabBarController = _tabBarController;
@synthesize navigationController;

- ( BOOL )application: ( UIApplication * )application didFinishLaunchingWithOptions: ( NSDictionary * )launchOptions
{
    ( void )application;
    ( void )launchOptions;
    
    self.window.rootViewController = self.tabBarController;
    
    [ self.window makeKeyAndVisible ];
    
    return YES;
}

- ( void )applicationWillResignActive: ( UIApplication * )application
{
    NavigationController * navController;
    MainViewController   * controller;
    
    ( void )application;
    
    navController = ( NavigationController * )self.tabBarController.selectedViewController;
    controller    = ( MainViewController   * )navController.topViewController;
    
    [ controller hideIAd ];
}

- ( void )applicationDidEnterBackground:( UIApplication * )application
{
    ( void )application;
}

- ( void )applicationWillEnterForeground:( UIApplication * )application
{
    ( void )application;
}

- ( void )applicationDidBecomeActive:( UIApplication * )application
{
    ( void )application;
}

- ( void )applicationWillTerminate: ( UIApplication * )application
{
    ( void )application;
}

- ( void )dealloc
{
    [ _window              release ];
    [ _tabBarController    release ];
    [ navigationController release ];
    
    [ super dealloc ];
}

@end
