//
//  FileComposite.h
//  CompositePattern
//
//  Created by Eveian on 2014/12/27.
//
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, EntryType) {
    kEntryTypeGeneric = 0,
    kEntryTypeDirectory,
};

@interface FileComposite : NSObject
@property(strong, nonatomic) NSString* file_name;
@property(strong, nonatomic) NSString* file_size;
@property(strong, nonatomic) NSDate*   modification_date;
@property(assign, nonatomic) EntryType entry_type;
@property(strong, nonatomic) NSString* file_path;

-(FileComposite*) initWithPath:(NSString*)path;

-(void) add:(FileComposite*)c;

-(NSArray*) subItems;
@end

@interface ComFile : FileComposite

@end

@interface ComDirectory : FileComposite

@end
