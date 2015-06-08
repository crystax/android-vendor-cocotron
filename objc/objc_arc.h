#import <objc/runtime.h>
#import <stdbool.h>

#if __ANDROID__
#import <objc/objc-arc.h>
#endif

OBJC_EXPORT id objc_retain(id value);
OBJC_EXPORT void objc_release(id value);

// Private to CF/Foundation/objc
OBJC_EXPORT void object_incrementExternalRefCount(id value);
OBJC_EXPORT bool object_decrementExternalRefCount(id value);
OBJC_EXPORT unsigned long object_externalRefCount(id value);

struct objc_autoreleasepool;
OBJC_EXPORT void objc_autoreleasePoolAdd(struct objc_autoreleasepool *pool, id object);
