#import <stdint.h>
#if !__ANDROID__
#import <objc/objc-export.h>
#endif

OBJC_EXPORT int _NSGetExecutablePath(char *buf, uint32_t *bufsize);
