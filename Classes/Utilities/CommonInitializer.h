//
//  CommonInitializer.h
//  WXYCapp
//
//  Created by Jake Bromberg on 11/16/13.
//  Copyright (c) 2013 WXYC. All rights reserved.
//

#ifndef WXYCapp_CommonInitializer_h
#define WXYCapp_CommonInitializer_h

#define COMMON_INIT(superInit) \
^id (__typeof(self) __self) { \
if (!(__self = superInit)) return nil; \
[__self commonInit]; \
return __self; \
}(self)


#endif
