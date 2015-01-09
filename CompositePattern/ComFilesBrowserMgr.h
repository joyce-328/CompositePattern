//
//  ComFilesBrowserMgr.h
//  CompositePattern
//
//  Created by Eveian on 2014/12/27.
//
//

#import <Foundation/Foundation.h>
#import "FileComposite.h"

@interface ComFilesBrowserMgr : NSObject

+ (instancetype)getInstance ;

-(void) setupResource;

-(FileComposite*) loadFilesListAtDir:(NSString*)dir;

-(NSString*) getBaseURLString;
@end
