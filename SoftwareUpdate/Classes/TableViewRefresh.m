/*******************************************************************************
 * Copyright (c) 2011, Jean-David Gadina <macmade@eosgarden.com>
 * All rights reserved
 ******************************************************************************/
 
/* $Id$ */

/*!
 * @file        TableViewRefresh.m
 * @copyright   eosgarden 2011 - Jean-David Gadina <macmade@eosgarden.com>
 * @abstract    ...
 */

#import "TableViewRefresh.h"

NSString * TableViewHeaderArrowTypeWhite = @"TableViewRefreshArrowWhite.png";
NSString * TableViewHeaderArrowTypeBlack = @"TableViewRefreshArrowBlack.png";
NSString * TableViewHeaderArrowTypeBlue  = @"TableViewRefreshArrowBlue.png";

@implementation TableViewRefresh

@synthesize lastUpdatedLabel;
@synthesize statusLabel;
@synthesize activityView;
@synthesize delegate;

- ( id )initWithFrame:( CGRect )frame
{
    if( ( self = [ super initWithFrame: frame ] ) )
    {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.backgroundColor  = [ UIColor whiteColor ];
        
        lastUpdatedLabel                  = [ [ UILabel alloc ] initWithFrame: CGRectMake( ( CGFloat )0.0, frame.size.height - ( CGFloat )30, self.frame.size.width, ( CGFloat )20 ) ];
        lastUpdatedLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        lastUpdatedLabel.font             = [ UIFont systemFontOfSize: 10 ];
        lastUpdatedLabel.textColor        = [ UIColor colorWithRed: ( CGFloat )0.5 green: ( CGFloat )0.6 blue: ( CGFloat )0.7 alpha: 1 ];
        lastUpdatedLabel.backgroundColor  = [ UIColor clearColor ];
        lastUpdatedLabel.textAlignment    = UITextAlignmentCenter;
        
        [ self addSubview: lastUpdatedLabel ];
        
        statusLabel                  = [ [ UILabel alloc ] initWithFrame: CGRectMake( ( CGFloat )0.0, frame.size.height - ( CGFloat )45, self.frame.size.width, ( CGFloat )20 ) ];
        statusLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        statusLabel.font             = [ UIFont boldSystemFontOfSize: 12 ];
        statusLabel.textColor        = [ UIColor colorWithRed: ( CGFloat )0.5 green: ( CGFloat )0.6 blue: ( CGFloat )0.7 alpha: 1 ];
        statusLabel.backgroundColor  = [ UIColor clearColor ];
        statusLabel.textAlignment    = UITextAlignmentCenter;
        
        [ self addSubview: statusLabel ];
        
        activityView       =  [ [ UIActivityIndicatorView alloc ] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleGray ];
		activityView.frame = CGRectMake( ( CGFloat )25, frame.size.height - ( CGFloat )38.0, ( CGFloat )20.0, ( CGFloat )20.0 );
		
        [ self addSubview: activityView ];
        
        arrowImage                 = [ [ CALayer layer ] retain ];
        arrowImage.frame           = CGRectMake( ( CGFloat )25, frame.size.height - ( CGFloat )65, ( CGFloat )30, ( CGFloat )55 );
        arrowImage.contentsGravity = kCAGravityResizeAspect;
        arrowImage.contents        = ( id )[ UIImage imageNamed: TableViewHeaderArrowTypeBlue ].CGImage;
        
        #if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
            
            if( [ [ UIScreen mainScreen ] respondsToSelector: @selector( scale ) ] )
            {
                arrowImage.contentsScale = [ [ UIScreen mainScreen ] scale ];
            }
            
        #endif
        
        [ [ self layer ] addSublayer: arrowImage ];
        
		[ self setState: TableViewRefreshStateNormal ];
        
        dateFormat = [ NSDateFormatter new ];
        
        [ dateFormat setAMSymbol:   @"AM" ];
		[ dateFormat setPMSymbol:   @"PM" ];
		[ dateFormat setDateFormat: @"MM/dd/yyyy hh:mm" ];
        
        date = [ [ [ NSUserDefaults standardUserDefaults ] objectForKey: @"TableViewRefreshDate" ] retain ];
        
        if( date == nil )
        {
            date = [ [ NSDate date ] retain ];
            
            [ [ NSUserDefaults standardUserDefaults ] setObject: date forKey: @"TableViewRefreshDate" ];
            [ [ NSUserDefaults standardUserDefaults ] synchronize ];
        }
        
        lastUpdatedLabel.text = [ NSString stringWithFormat: NSLocalizedString( @"Last updated: %@", nil ), [ dateFormat stringFromDate: date ] ];
    }
    
    return self;
}

- ( void )dealloc
{
    [ lastUpdatedLabel release ];
    [ statusLabel      release ];
    [ activityView     release ];
    [ arrowImage       release ];
    [ date             release ];
    [ dateFormat       release ];
    
    [ super dealloc ];
}

- ( void )setArrowType: ( NSString * )type
{
    arrowImage.contents = ( id )[ UIImage imageNamed: type ].CGImage;
}

- ( void )setDateFormat: ( NSDateFormatter * )format
{
    dateFormat            = [ format copy ];
    lastUpdatedLabel.text = [ NSString stringWithFormat: NSLocalizedString( @"Last updated: %@", nil ), [ format stringFromDate: date ] ];
}

- ( void )setState: ( TableViewRefreshState )aState
{
    switch( aState )
    {
		case TableViewRefreshStatePulling:
			
			statusLabel.text = NSLocalizedString( @"Release to refresh...",  nil );
            
			[ CATransaction begin];
			[ CATransaction setAnimationDuration: 0.15 ];
			
            arrowImage.transform = CATransform3DMakeRotation( ( ( CGFloat )M_PI / ( CGFloat )180 ) * ( CGFloat )180, ( CGFloat )0, ( CGFloat )0, ( CGFloat )1 );
			
            [ CATransaction commit ];
			
			break;
            
		case TableViewRefreshStateNormal:
			
			if( state == TableViewRefreshStatePulling )
            {
				[ CATransaction begin ];
				[ CATransaction setAnimationDuration: 0.15 ];
                
				arrowImage.transform = CATransform3DIdentity;
				
                [ CATransaction commit ];
			}
			
			statusLabel.text = NSLocalizedString( @"Pull down to refresh...", nil );
			
            [ activityView stopAnimating];
			[ CATransaction begin];
			[ CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions]; 
            
            arrowImage.hidden    = NO;
			arrowImage.transform = CATransform3DIdentity;
            
            [ CATransaction commit ];
            
			break;
            
		case TableViewRefreshStateLoading:
			
            [ date release ];
            
            date = [ [ NSDate date ] retain ];
            
            [ [ NSUserDefaults standardUserDefaults ] setObject: date forKey: @"TableViewRefreshDate" ];
            [ [ NSUserDefaults standardUserDefaults ] synchronize ];
            
			statusLabel.text = NSLocalizedString( @"Loading...", nil );
			
            [ self setDateFormat: dateFormat ];
            [ activityView startAnimating ];
			[ CATransaction begin ];
			[ CATransaction setValue: ( id )kCFBooleanTrue forKey: kCATransactionDisableActions ]; 
			
            arrowImage.hidden = YES;
			
            [ CATransaction commit ];
			
			break;
            
		default:
            
			break;
	}
    
    state = aState;
}

- ( void )scrollViewDidScroll: ( UIScrollView * )scrollView
{
    BOOL    loading;
    CGFloat offset;
	
    if( state == TableViewRefreshStateLoading )
    {
		offset                  = MAX( scrollView.contentOffset.y * -1, 0 );
		offset                  = MIN( offset, 60 );
		scrollView.contentInset = UIEdgeInsetsMake( offset, ( CGFloat )0, ( CGFloat )0, ( CGFloat )0 );
	}
    else if( scrollView.isDragging )
    {
        loading = NO;
        
		if( delegate != nil && [ delegate respondsToSelector: @selector( tableViewIsLoading: ) ] )
        {
			loading = [ delegate tableViewIsLoading: self ];
		}
		
		if
        (
               state == TableViewRefreshStatePulling
            && scrollView.contentOffset.y > ( CGFloat )-65
            && scrollView.contentOffset.y < ( CGFloat )0
            && loading == NO
        )
        {
			[ self setState:TableViewRefreshStateNormal ];
            
		}
        else if
        (
               state == TableViewRefreshStateNormal
            && scrollView.contentOffset.y < ( CGFloat )-65
            && loading == NO
        )
        {
			[ self setState: TableViewRefreshStatePulling ];
		}
		
		if( scrollView.contentInset.top != 0 )
        {
			scrollView.contentInset = UIEdgeInsetsZero;
		}
	}
}

- ( void )scrollViewDidEndDragging: ( UIScrollView * )scrollView
{
	BOOL loading;
    
	if( [ delegate respondsToSelector: @selector( tableViewIsLoading: ) ] )
    {
		loading = [ delegate tableViewIsLoading: self ];
	}
	
	if( scrollView.contentOffset.y <= ( CGFloat )-65 && loading == NO )
    {
		if( [ delegate respondsToSelector: @selector( tableViewShouldReload: ) ] )
        {
			[ delegate tableViewShouldReload: self ];
		}
		
		[ self setState: TableViewRefreshStateLoading ];
		[ UIView beginAnimations: nil context: NULL ];
		[ UIView setAnimationDuration: 0.2 ];
		
        scrollView.contentInset = UIEdgeInsetsMake( ( CGFloat )60, ( CGFloat )0, ( CGFloat )0, ( CGFloat )0 );
		
        [ UIView commitAnimations ];
		
	}
}

- ( void )scrollViewDidFinishLoading: ( UIScrollView * )scrollView
{
	[ UIView beginAnimations: nil context: NULL ];
	[ UIView setAnimationDuration: 0.3 ];
	[ scrollView setContentInset: UIEdgeInsetsMake( ( CGFloat )0, ( CGFloat )0, ( CGFloat )0, ( CGFloat )0 ) ];
	[ UIView commitAnimations ];
	
	[ self setState: TableViewRefreshStateNormal ];
}

@end
