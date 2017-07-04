//
//  Constants.h
//  Spelunker
//
//  Created by Renaud Holcombe on 6/11/17.
//  Copyright © 2017 Renaud Holcombe. All rights reserved.
//

//#ifndef Constants_h
//#define Constants_h

typedef NS_ENUM(NSInteger, AlertType) {
    Scheduled,
    Polling
} ;

typedef NS_ENUM(NSInteger, SplunkJobStatus)
{
    UNKNOWN = 0,
    QUEUED,
    PARSING,
    RUNNING,
    PAUSED,
    FINALIZING,
    FAILED,
    DONE
};

//#endif /* Constants_h */
