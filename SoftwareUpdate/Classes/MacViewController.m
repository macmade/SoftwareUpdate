/*******************************************************************************
 * Copyright (c) 2011, Jean-David Gadina <macmade@eosgarden.com>
 * All rights reserved
 ******************************************************************************/
 
/* $Id$ */

/*!
 * @file        MacViewController.m
 * @copyright   eosgarden 2011 - Jean-David Gadina <macmade@eosgarden.com>
 * @abstract    ...
 */

#import "MacViewController.h"
#import "UpdateFeed.h"

@implementation MacViewController

- ( id )initWithCoder: ( NSCoder * )coder
{
    if( ( self = [ super initWithCoder: coder ] ) )
    {
        feedURL = @"http://feeds.feedburner.com/macupdate";
    }
    
    return self;
}

- ( void )dealloc
{
    [ super dealloc ];
}

@end
