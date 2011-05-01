/*******************************************************************************
 * Copyright (c) 2011, Jean-David Gadina <macmade@eosgarden.com>
 * All rights reserved
 ******************************************************************************/
 
/* $Id$ */

/*!
 * @header      HostReachabilityTest.h
 * @copyright   eosgarden 2011 - Jean-David Gadina <macmade@eosgarden.com>
 * @abstract    ...
 */

#import <SystemConfiguration/SystemConfiguration.h>

@interface HostReachabilityTest: NSObject
{
@protected
    
    BOOL                     hasFlags;
    BOOL                     validFlags;
    SCNetworkReachabilityRef target;
    SCNetworkConnectionFlags flags;
    NSString               * hostname;
    NSUInteger               timeout;
    
@private
    
    id r1;
    id r2;
}

@property( readonly ) SCNetworkReachabilityRef target;
@property( readonly ) SCNetworkConnectionFlags flags;
@property( readonly ) NSString * hostname;
@property( assign, readwrite ) NSUInteger timeout;

+ ( id )testWithHost: ( NSString * )host;
- ( id )initWithHost: ( NSString * )host;
- ( BOOL )isReachable;

@end
