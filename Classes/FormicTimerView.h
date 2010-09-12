//
//  FormicTimerView.h
//  Formic
//
//  Created by Wolfgang Ante on 02.06.08.
//  Copyright 2008 ARTIS Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FormicGame.h"

@interface FormicTimerView : UIImageView
{
	UIImage		*mProgressImage[GAME_TIMERSTEPS];
	int			mPosition;
}

- (id)init;

- (void)setPosition:(int)position;

@end
