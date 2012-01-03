/*******************************************************************************
 * Copyright (c) 2011, Jean-David Gadina <macmade@eosgarden.com>
 * All rights reserved
 ******************************************************************************/
 
/* $Id$ */

/*!
 * @file        HostReachabilityTest.m
 * @copyright   eosgarden 2011 - Jean-David Gadina <macmade@eosgarden.com>
 * @abstract    ...
 */

#import "HostReachabilityTest.h"
#import <unistd.h>

@implementation HostReachabilityTest

@synthesize target;
@synthesize flags;
@synthesize hostname;
@synthesize timeout;

+ ( id )testWithHost: ( NSString * )host
{
    id test = [ [ self alloc ] initWithHost: host ];
    
    return [ test autorelease ];
}

- ( id )initWithHost: ( NSString * )host
{
    if( ( self = [ super init ] ) )
    {
        hostname   = [ host copy ];
        target     = SCNetworkReachabilityCreateWithName( kCFAllocatorDefault, [ hostname UTF8String ] );
        timeout    = 2;
        hasFlags   = NO;
        validFlags = NO;
    }
    
    return self;
}

- ( void )dealloc
{
    if( target != NULL )
    {
        CFRelease( target );
    }
    
    [ hostname release ];
    [ super dealloc ];
}

- ( void )getFlags: ( id )nothing
{
    ( void )nothing;
    
    validFlags = SCNetworkReachabilityGetFlags( target, &flags );
    hasFlags   = YES;
}

- ( void )checkTimeout: ( id )nothing
{
    ( void )nothing;
    
    sleep( timeout );
    
    hasFlags   = YES;
    validFlags = NO;
}

- ( BOOL )isReachable
{
    NSRunLoop * runLoop;
    
    [ NSThread detachNewThreadSelector: @selector( getFlags: )     toTarget: self withObject: nil ];
    [ NSThread detachNewThreadSelector: @selector( checkTimeout: ) toTarget: self withObject: nil ];
    
    runLoop = [ NSRunLoop currentRunLoop ];
    
    while( hasFlags == NO )
    {
        [ runLoop runUntilDate: [ NSDate date ] ];
    }
    
    if( !validFlags )
    {
        return NO;
    }
    
    if( flags & kSCNetworkFlagsReachable && ( !( flags & kSCNetworkFlagsConnectionRequired ) || flags & kSCNetworkFlagsConnectionAutomatic ) )
    {
        return YES;
    }
    
    return NO;
}

@end