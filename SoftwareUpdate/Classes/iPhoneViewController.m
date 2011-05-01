/*******************************************************************************
 * Copyright (c) 2011, Jean-David Gadina <macmade@eosgarden.com>
 * All rights reserved
 ******************************************************************************/
 
/* $Id$ */

/*!
 * @file        iPhoneViewController.m
 * @copyright   eosgarden 2011 - Jean-David Gadina <macmade@eosgarden.com>
 * @abstract    ...
 */

#import "iPhoneViewController.h"
#import "UpdateFeed.h"

@implementation iPhoneViewController

- ( id )initWithCoder: ( NSCoder * )coder
{
    if( ( self = [ super initWithCoder: coder ] ) )
    {
        feedURL = @"http://feeds.feedburner.com/macupdate-iphone";
    }
    
    return self;
}

- ( void )dealloc
{
    [ super dealloc ];
}

@end
