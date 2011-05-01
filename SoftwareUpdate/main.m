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

int main( int argc, char * argv[] )
{
    NSAutoreleasePool * ap;
    int                 status;
    
    ap     = [ [ NSAutoreleasePool alloc ] init ];
    status = UIApplicationMain( argc, argv, nil, nil );
    
    [ ap release ];
    
    return status;
}
