/*******************************************************************************
 * Copyright (c) 2011, Jean-David Gadina <macmade@eosgarden.com>
 * All rights reserved
 ******************************************************************************/
 
/* $Id$ */

/*!
 * @file        PopularViewController.m
 * @copyright   eosgarden 2011 - Jean-David Gadina <macmade@eosgarden.com>
 * @abstract    ...
 */

#import "PopularViewController.h"
#import "UpdateFeed.h"

@implementation PopularViewController

- ( id )initWithCoder: ( NSCoder * )coder
{
    if( ( self = [ super initWithCoder: coder ] ) )
    {
        feedURL = @"http://feeds.feedburner.com/macupdate-popular";
    }
    
    return self;
}

- ( void )dealloc
{
    [ super dealloc ];
}

@end
