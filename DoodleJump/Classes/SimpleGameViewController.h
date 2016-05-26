//
//  SimpleGameViewController.h
//  SimpleGame
//
//  Created by Daniel Baird on 3/7/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SimpleGameViewController : UIViewController <UIAccelerometerDelegate> {
	// Image View for the game mode
	UIImageView *bg;
	UIImageView *bg2;
	UIImageView *ball;
	UIImageView *platform1;
	UIImageView *platform2;
	UIImageView *platform3;
	UIImageView *platform4;
	UIImageView *platform5;
	
	UILabel *lblScore;
	UILabel *lblMenu;
	UILabel *lblRestart;
	
	UIButton *btnPlay;
	UIButton *btnHowToPlay;
	UIButton *btnSettings;
	UIButton *btnBack;
	UIButton *btnHighscore;
	
	UISegmentedControl *scTouchTilt;
	
	NSInteger gameState;
	NSInteger previousState;
	NSInteger touchState;
	NSInteger score;
	NSInteger highscore;
	NSInteger controlType;
	
	CGPoint ballVelocity;
	CGPoint gravity;
	
	CGPoint platform1Veloctiy;
	CGPoint platform2Veloctiy;
	CGPoint platform3Veloctiy;
	CGPoint platform4Veloctiy;
	CGPoint platform5Veloctiy;

}

@property (nonatomic, retain) IBOutlet UIImageView *bg;
@property (nonatomic, retain) IBOutlet UIImageView *bg2;
@property (nonatomic, retain) IBOutlet UIImageView *ball;
@property (nonatomic, retain) IBOutlet UIImageView *platform1;
@property (nonatomic, retain) IBOutlet UIImageView *platform2;
@property (nonatomic, retain) IBOutlet UIImageView *platform3;
@property (nonatomic, retain) IBOutlet UIImageView *platform4;
@property (nonatomic, retain) IBOutlet UIImageView *platform5;

@property (nonatomic, retain) IBOutlet UILabel *lblScore;
@property (nonatomic, retain) IBOutlet UILabel *lblMenu;
@property (nonatomic, retain) IBOutlet UILabel *lblRestart;

@property (nonatomic, retain) IBOutlet UIButton *btnPlay;
@property (nonatomic, retain) IBOutlet UIButton *btnHowToPlay;
@property (nonatomic, retain) IBOutlet UIButton *btnSettings;
@property (nonatomic, retain) IBOutlet UIButton *btnBack;
@property (nonatomic, retain) IBOutlet UIButton *btnHighscore;

@property (nonatomic, retain) IBOutlet UISegmentedControl *scTouchTilt;

@property (nonatomic) NSInteger gameState;
@property (nonatomic) NSInteger previousState;
@property (nonatomic) NSInteger touchState;
@property (nonatomic) NSInteger score;
@property (nonatomic) NSInteger highscore;
@property (nonatomic) NSInteger controlType;
	

@property (nonatomic) CGPoint ballVelocity;
@property (nonatomic) CGPoint gravity;

@property (nonatomic) CGPoint platform1Veloctiy;
@property (nonatomic) CGPoint platform2Veloctiy;
@property (nonatomic) CGPoint platform3Veloctiy;
@property (nonatomic) CGPoint platform4Veloctiy;
@property (nonatomic) CGPoint platform5Veloctiy;

- (void)gameStatePlayNormal;

- (IBAction)buttonClickedPlay;
- (IBAction)buttonClickedHowToPlay;
- (IBAction)buttonClickedSettings;
- (IBAction)buttonClickedBack;
- (IBAction)buttonClickedHighscore;
- (IBAction)show;

- (IBAction)valueChanged;


-(IBAction)alertMe;


@end

