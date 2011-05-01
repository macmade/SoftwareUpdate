/*******************************************************************************
 * Copyright (c) 2011, Jean-David Gadina <macmade@eosgarden.com>
 * All rights reserved
 ******************************************************************************/
 
/* $Id$ */

/*!
 * @header      
 * @copyright   eosgarden 2011 - Jean-David Gadina <macmade@eosgarden.com>
 * @abstract    ...
 */

@class NavigationController;

@interface ApplicationDelegate: NSObject < UIApplicationDelegate >
{
@protected
    
    NavigationController * navigationController;
    
@private
    
    id r1;
    id r2;
}

@property( nonatomic, retain ) IBOutlet UIWindow             * window;
@property( nonatomic, retain ) IBOutlet UITabBarController   * tabBarController;
@property( nonatomic, retain ) IBOutlet NavigationController * navigationController;

@end
