//
//  SCDGUtils.m
//  deigo
//
//  Created by SC on 16/5/11.
//  Copyright © 2016年 SC. All rights reserved.
//

#import "SCDGUtils.h"

#import <sys/utsname.h>

@implementation SCDGUtils

+ (NSError*) makeError:(NSString *)localizedDescription {
    NSMutableDictionary* details = [NSMutableDictionary dictionary];
    [details setValue:localizedDescription forKey:NSLocalizedDescriptionKey];
    // populate the error object with the details
    return [NSError errorWithDomain:@"world" code:200 userInfo:details];
}

+ (void) alert:(NSString *)msg {
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:msg message:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"确认", nil) otherButtonTitles:nil];
    [alter show];
}

+ (UIAlertView*) alertView :(NSString*)msg {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:msg message:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"确认", nil) otherButtonTitles:nil];
    return alert;
}

+ (void) alert:(NSString *)msg delegate:(id)delegate {
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:msg message:nil delegate:delegate cancelButtonTitle:NSLocalizedString(@"确认", nil) otherButtonTitles:nil];
    [alter show];
}

+ (BOOL) isNilOrNSNull:(id)object {
    return object == nil || [object isKindOfClass:[NSNull class]];
}

+ (BOOL) isNonnull:(id)object{
    return object != nil && object != NULL && object != [NSNull null];
}

+ (BOOL) isValidStr:(NSString *)str{
    return [self isNonnull:str] && ([str isKindOfClass:[NSString class]] || [str isKindOfClass:[NSMutableString class]]) && str.length > 0;
}

+ (BOOL) isValidData:(NSData *)data{
    return [self isNonnull:data] && ([data isKindOfClass:[NSData class]] || [data isKindOfClass:[NSMutableData class]]) && data.length > 0;
}

+ (BOOL) isValidArray:(NSArray *)array{
    return [self isNonnull:array] && ([array isKindOfClass:[NSArray class]] || [array isKindOfClass:[NSMutableArray class]]) && array.count > 0;
}

+ (BOOL) isValidDictionary:(NSDictionary *)dict{
    return [self isNonnull:dict] && ([dict isKindOfClass:[NSDictionary class]] || [dict isKindOfClass:[NSMutableDictionary class]]) && dict.count > 0;
}

+ (UIViewController *)topViewController{
    return [self topViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
}

+ (UIViewController *)topViewController:(UIViewController *)rootViewController
{
    if (rootViewController.presentedViewController == nil) {
        return rootViewController;
    }
    
    if ([rootViewController.presentedViewController isMemberOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = (UINavigationController *)rootViewController.presentedViewController;
        UIViewController *lastViewController = [[navigationController viewControllers] lastObject];
        return [self topViewController:lastViewController];
    }
    
    UIViewController *presentedViewController = (UIViewController *)rootViewController.presentedViewController;
    return [self topViewController:presentedViewController];
}

+ (UIWindow*) getDefaultWindow {
    return [[[UIApplication sharedApplication] windows] objectAtIndex:0];
}

+ (NSString*)pathInDocuments:(NSString *)subpath {
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    return [documentsPath stringByAppendingPathComponent:subpath];
}

+ (NSString*) pathInCaches: (NSString*)subpath {
    NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    return [cachesPath stringByAppendingPathComponent:subpath];
}

+ (NSError*) dontBackup:(NSString*)path {
    NSError* error = nil;
    NSURL * fileURL;
    fileURL = [ NSURL fileURLWithPath: path];
    [ fileURL setResourceValue: [ NSNumber numberWithBool: YES ] forKey: NSURLIsExcludedFromBackupKey error: &error ];
    if (error) {
        NSLog(@"Error in dontBackup %@, e = %@", path, error);
    }
    return error;
}

+ (NSString*)resourcePathInBundle:(NSString*)subpath {
    return [[NSBundle mainBundle] pathForResource:[subpath stringByDeletingPathExtension] ofType:subpath.pathExtension];
}

+ (NSString*)fileURLAbsoluteString:(NSString*)subpath {
    return [NSURL fileURLWithPath:[SCDGUtils resourcePathInBundle:subpath]].absoluteString;
}

+ (NSDate*) getFileLastModifiedTime:(NSString*)path {
    NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil];
    NSDate *date = [attributes fileModificationDate];
    return date;
}

+ (BOOL) deployResourceFromBundleToCachesIfNeeded: (NSString*)subpath {
    NSFileManager * defaultManage = [NSFileManager defaultManager];
    NSError* error = nil;
    NSString* bundlePath = [SCDGUtils resourcePathInBundle:subpath];
    NSString* cachesPath = [SCDGUtils pathInCaches:subpath];
    if ([defaultManage fileExistsAtPath:cachesPath] && [[SCDGUtils getFileLastModifiedTime:cachesPath] isEqualToDate:[SCDGUtils getFileLastModifiedTime:bundlePath]]) {
        return YES;
    }
    [defaultManage removeItemAtPath:cachesPath error:nil];
    [defaultManage copyItemAtPath:bundlePath toPath:cachesPath error:&error];
    assert(!error);
    return error == nil;
}

+ (NSString*) getCurrentVersionShort {
    NSDictionary *localDic =[[NSBundle mainBundle] infoDictionary];
    NSString *localVersion =[localDic objectForKey:@"CFBundleShortVersionString"];
    return localVersion;
}

+ (NSString*) getCurrentVersionFull {
    NSDictionary *localDic =[[NSBundle mainBundle] infoDictionary];
    NSString *localVersion =[localDic objectForKey:@"CFBundleVersion"];
    return localVersion;
}

+ (NSString*) getCurrentAppLanguage {
    return [[[NSBundle mainBundle] preferredLocalizations] objectAtIndex:0];
}

NSString* const LOGINED_KEY = @"logined";

+ (BOOL) isLogined {
    NSUserDefaults * userDefaultes = [NSUserDefaults standardUserDefaults];
    return [userDefaultes boolForKey:LOGINED_KEY];
}

+ (void) setLogined: (BOOL)logined {
    NSUserDefaults * userDefaultes = [NSUserDefaults standardUserDefaults];
    [userDefaultes setBool:logined forKey:LOGINED_KEY];
    [userDefaultes synchronize];
    if (!logined) {
        
    }
}

+ (NSString *)deviceType{
    
    struct utsname systemInfo;
    uname(&systemInfo);
    return [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
}

+ (NSString *)systemVersion{
    
    return [UIDevice currentDevice].systemVersion;
    
}

+ (void) setupUserAgent {
    // Add scApp-xxx to default UserAgent
    NSString* appID = [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleExecutableKey];
    appID = [appID lowercaseString];
    NSString* userAgent = [NSString stringWithFormat:@"Mozilla/5.0 (iPhone; U; CPU iPhone OS 3_1_2 like Mac OS X; en-us) AppleWebKit/528.18 (KtHTML, like Gecko) Mobile/7D11 deigo-ios/%@ lang/%@ devId/idfv_%@ UMSCashierPlugin/2.4.5 devType/%@ systemVersion/%@",
                           [SCDGUtils getCurrentVersionShort], [[SCDGUtils getCurrentAppLanguage] substringToIndex:2], [[UIDevice currentDevice].identifierForVendor UUIDString], [SCDGUtils deviceType], [SCDGUtils systemVersion]];
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:userAgent, @"UserAgent", nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:dictionary];
}

+ (NSTimer *) asyncRunDelayed:(NSTimeInterval)delay block: (void (^)())block {
#ifdef SC_TP_BLOCKSKIT
    return [NSTimer bk_scheduledTimerWithTimeInterval:delay block:^(NSTimer* timer) {
        block();
    }repeats:NO];
#else
    return nil;
#endif
}

+ (void) dontBackupGeneratedFiles {
    [SCDGUtils dontBackup:[SCDGUtils pathInDocuments:@"baiduplist"]];
    [SCDGUtils dontBackup:[SCDGUtils pathInDocuments:@"cfg"]];
    [SCDGUtils dontBackup:[SCDGUtils pathInDocuments:@".UMSocialData.plist"]];
}

+ (int) compareVersion:(NSString*)version1 withVersion:(NSString*)version2 {
    return [version1 compare:version2 options:NSNumericSearch];
}

+ (NSString*) groupText:(NSString*)text seperator:(NSString*)seperator groupLength:(int)groupLength {
    NSMutableString* s = [NSMutableString new];
    BOOL first = YES;
    text = [text stringByReplacingOccurrencesOfString:seperator withString:@""];
    for (int i = 0; i < text.length; i++) {
        if (!first && i % groupLength == 0) {
            [s appendString:seperator];
        }
        [s appendFormat:@"%c", [text characterAtIndex:i]];
        if (first) {
            first = NO;
        }
    }
    return s;
}
+ (void) showLoginView {
    
}

+ (NSString *)formatStr:(NSString *)str replacement:(NSString *)replacement range:(NSRange)range{
    if (str.length < range.location+range.length) {
        return str;
    }
    NSMutableString *tempStr = [NSMutableString stringWithString:str];
    NSString * replaceStr = @"";
    
    for (NSUInteger i = range.location; i < range.location+range.length; i++) {
        replaceStr = [replaceStr stringByAppendingString:replacement];
    }
    [tempStr replaceCharactersInRange:range withString:replaceStr];
    return [NSString stringWithString:tempStr];
}

+ (NSString *)formatBankCardNum:(NSString *)bankNum replacement:(NSString *)replacement {
    NSString * str = [bankNum stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString * replaceStr = @"";
    if (str.length < 4) {
        return bankNum;
    }
    for (int i = 0; i < str.length - 4; i++) {
        replaceStr = [replaceStr stringByAppendingString:replacement];
    }
    return [NSString stringWithFormat:@"%@%@", replaceStr, [str substringWithRange:NSMakeRange(str.length - 4, 4)]];
}

+ (NSString *)getLoginToken{
    return [[NSUserDefaults standardUserDefaults]stringForKey:SCDG_SERVER_USER_TOKEN];
}

+ (void)setLoginToken:(NSString *)token{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:[SCDGUtils isNilOrNSNull:token] ? @"":token forKey:SCDG_SERVER_USER_TOKEN];
    [userDefaults synchronize];
}

+ (NSString *)encodeURLParameter:(NSString *)str {
    if ([self isNilOrNSNull:str] || (![str isKindOfClass:[NSString class]] && ![str isKindOfClass:[NSMutableString class]])){
        return @"";
    }
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                 (CFStringRef) str,
                                                                                 NULL,
                                                                                 (CFStringRef) @"!*'();:@&=+$,/?%#[]",
                                                                                 kCFStringEncodingUTF8));
    
}

+ (NSString *)keyChainStringForKey:(NSString *)key{
    NSString *str = nil;
#ifdef SC_TP_UICKEYCHAINSTORE
    str = [UICKeyChainStore stringForKey:key];
#endif
    return [self isValidStr:str] ? str : @"";
}

+ (void)setKeyChainString:(NSString *)string forKey:(NSString *)key{
#ifdef SC_TP_UICKEYCHAINSTORE
    [self isValidStr:key] && [self isValidStr:string] ? [UICKeyChainStore setString:string forKey:key] : NO;
#endif
}

+ (NSData *)keyChainDataForKey:(NSString *)key{
    
    NSData *data = nil;
#ifdef SC_TP_UICKEYCHAINSTORE
    data = [UICKeyChainStore dataForKey:key];
#endif
    return [self isValidData:data] ? data : [NSData data];
}

+ (void)setKeyChainData:(NSData *)data forKey:(NSString *)key{
#ifdef SC_TP_UICKEYCHAINSTORE
    [self isValidData:data] && [self isValidStr:key] ? [UICKeyChainStore setData:data forKey:key] : NO;
#endif
}

+ (NSArray *)keyChainArrayForKey:(NSString *)key{
    NSArray * array = [NSKeyedUnarchiver unarchiveObjectWithData:[self keyChainDataForKey:key]];
    return [self isValidArray:array] ? array : [[NSArray alloc]init];
}

+ (void)setKeyChainArray:(NSArray *)array forKey:(NSString *)key{
    [self isValidArray:array] && [self isValidStr:key] ? [self setKeyChainData:[NSKeyedArchiver archivedDataWithRootObject:array] forKey:key] : NO;
}

+ (void)addObjectToKeyChainArrayByKey:(NSString*)key objects:(id)firstObj, ... NS_REQUIRES_NIL_TERMINATION{
    va_list params;
    va_start(params,firstObj);
    id arg;
    if ([SCDGUtils isNonnull:firstObj]) {
        NSMutableArray *array = [[NSMutableArray alloc]initWithArray:[self keyChainArrayForKey:key]];
        
        if ([array indexOfObject:firstObj] == NSNotFound){
            [array addObject:firstObj];
        }
        
        while( (arg = va_arg(params,id)) )
        {
            if ([self isNonnull:arg] && [array indexOfObject:arg] == NSNotFound){
                [array addObject:arg];
            }
        }
        
        va_end(params);
        [SCDGUtils setKeyChainArray:array forKey:key];
    }
}

+ (NSDictionary *)keyChainDictionaryForKey:(NSString *)key{
    NSDictionary * dict = [NSKeyedUnarchiver unarchiveObjectWithData:[self keyChainDataForKey:key]];
    return [self isValidDictionary:dict] ? dict : [[NSDictionary alloc]init];
}

+ (void)setKeyChainDictionary:(NSDictionary *)dict forKey:(NSString *)key{
    [self isValidDictionary:dict] && [self isValidStr:key] ? [self setKeyChainData:[NSKeyedArchiver archivedDataWithRootObject:dict] forKey:key] : NO;
}

+ (void)removeKeyChainItemForKey:(NSString *)key{
#ifdef SC_TP_UICKEYCHAINSTORE
    [self isValidStr:key] ? [UICKeyChainStore removeItemForKey:key] : NO;
#endif
}

+ (void)removeKeyChainAllItems{
#ifdef SC_TP_UICKEYCHAINSTORE
    [UICKeyChainStore removeAllItems];
#endif
}

+ (UIFont *)fontWithSize:(CGFloat)size{
    return [UIFont fontWithName:@"Arial" size:size];
}

+ (UIFont *)boldFontWithSize:(CGFloat)size{
    return [UIFont boldSystemFontOfSize:size];
}

+ (CGSize)sizeForString:(NSString *)string font:(UIFont *)font constrainedToSize:(CGSize)constrainedSize lineBreakMode:(NSLineBreakMode)lineBreakMode {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = lineBreakMode;
    NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle};
    CGRect boundingRect = [string boundingRectWithSize:constrainedSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
    return CGSizeMake(ceilf(boundingRect.size.width), ceilf(boundingRect.size.height));
}

+ (NSString *)getUUID{
    
    NSString *uuidStr = [self keyChainStringForKey:@"SCDGUUID"];
    
    if (![SCDGUtils isValidStr:uuidStr]) {
        
        uuidStr = [NSUUID UUID].UUIDString;
        
        [self setKeyChainString:uuidStr forKey:@"SCDGUUID"];
        
    }
    
    return uuidStr;
}


+ (int)getRandomNumber:(int)from to:(int)to{
    
    return (int)(from + (arc4random() % (to - from + 1)));
    
}

+ (NSString*)getRandomStr:(int)length{
    
    NSString *formStr = [NSString stringWithFormat:@"%%0%dd", length];
    
    return [NSString stringWithFormat:formStr, (int)(arc4random()%(length*10))];
    
}

+ (NSString*)getNonce{
    
    static int noncePrefix = 0;
    
    static int totalLength = 8;
    
    NSString *nonceStrPrefix = [NSString stringWithFormat:@"%x", noncePrefix++];
    
    NSString *nonceSuffix = [self getRandomStr: totalLength - (int)(nonceStrPrefix.length)];
    
    return [nonceStrPrefix stringByAppendingString:nonceSuffix];
    
}

@end
