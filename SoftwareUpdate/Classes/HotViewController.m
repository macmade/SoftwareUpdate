/*******************************************************************************
 * Copyright (c) 2011, Jean-David Gadina <macmade@eosgarden.com>
 * All rights reserved
 ******************************************************************************/
 
/* $Id$ */

/*!
 * @file        HotViewController.m
 * @copyright   eosgarden 2011 - Jean-David Gadina <macmade@eosgarden.com>
 * @abstract    ...
 */

#import "HotViewController.h"
#import "UpdateFeed.h"

@implementation HotViewController

- ( id )initWithCoder: ( NSCoder * )coder
{
    if( ( self = [ super initWithCoder: coder ] ) )
    {
        feedURL = @"http://feeds.feedburner.com/macupdate-hotpicks";
    }
    
    return self;
}

- ( void )dealloc
{
    [ super dealloc ];
}

@end
