
#import "CheckConnect.h"
#import "AppDelegate.h"

@implementation CheckConnect

+ (BOOL)connectedToNetworkWithoutAlert {
	
	// Create zero addy
	struct sockaddr_in zeroAddress;
	bzero(&zeroAddress, sizeof(zeroAddress));
	zeroAddress.sin_len = sizeof(zeroAddress);
	zeroAddress.sin_family = AF_INET;
	
	// Recover reachability flags
	SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
	SCNetworkReachabilityFlags flags;
	
	BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
	CFRelease(defaultRouteReachability);
	
	if (!didRetrieveFlags)
	{
		return NO;
	}
	
	BOOL isReachable = flags & kSCNetworkFlagsReachable;
	BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
	if (isReachable && !needsConnection)  {
		return YES;
	}
	else {		
		return NO;
	}	
}

+ (BOOL) connectedToNetwork
{
	// Create zero addy
	struct sockaddr_in zeroAddress;
	bzero(&zeroAddress, sizeof(zeroAddress));
	zeroAddress.sin_len = sizeof(zeroAddress);
	zeroAddress.sin_family = AF_INET;
	
	// Recover reachability flags
	SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
	SCNetworkReachabilityFlags flags;
	
	BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
	CFRelease(defaultRouteReachability);
	
	if (!didRetrieveFlags)
	{
		return NO;
	}
	
	BOOL isReachable = flags & kSCNetworkFlagsReachable;
	BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
	if (isReachable && !needsConnection)  {
		return YES;
	}
	else {
		
		[SEUtils showAlert:NO_CONNECTION_ALERT];
		return NO;
		
	}
}

//call like:
+ (void) start 
{
	if (![self connectedToNetwork]) {
		UIAlertView *alert = [[UIAlertView alloc] 
							  initWithTitle:@"Network Error" 
							  message:@"Du musst mit dem Internet verbunden sein um dieses Feature zu nutzen!" 
							  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
	} 
}

@end
