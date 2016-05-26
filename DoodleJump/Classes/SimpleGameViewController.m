//
//  SimpleGameViewController.m
//  SimpleGame
//

#import "SimpleGameViewController.h"

#define kStateRunning 1
#define kStateGameOver 2
#define kStateMenu 3
#define kStateSettings 4
#define kStateHowToPlay 5

#define kLeftDown 1
#define kRightDown 2
#define kTouchesEnded 3

#define kTouch 1
#define kTilt 2

#define kGravityMultiplier 10

#define kPlatformWidth 45
#define kPlatformHeight 16

#define kMaxBallSpeed 10

#define kJumpPower 9

#define kGravity 0.195

@implementation SimpleGameViewController
@synthesize bg, bg2, ball, platform1, platform2, platform3, platform4, platform5;
@synthesize gameState, previousState, touchState, score, controlType;
@synthesize ballVelocity, gravity;
@synthesize lblScore, lblMenu, lblRestart;
@synthesize btnPlay, btnHowToPlay, btnSettings, btnBack;
@synthesize scTouchTilt, highscore, btnHighscore;
@synthesize platform1Veloctiy, platform2Veloctiy, platform3Veloctiy, platform4Veloctiy, platform5Veloctiy;


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	// Get the path
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
	NSString *documentPath = [paths objectAtIndex:0];
	NSString *path = [documentPath stringByAppendingPathComponent:@"highscore.save"];
	
	// Create a dictionary to hold objects
	NSMutableDictionary* myDict = [[NSMutableDictionary alloc] init];
	
	// Read objects back into dictionary
	myDict = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
	NSString *nssHighscore = [myDict objectForKey:@"Highscore"];
	highscore = [nssHighscore intValue];
	
	gameState = kStateMenu;
	ballVelocity = CGPointMake(0, 0);
	gravity = CGPointMake(0, kGravity);
	controlType = kTouch;
	
	[NSTimer scheduledTimerWithTimeInterval:1.0/60 target:self selector:@selector(gameLoop) userInfo:nil repeats:YES];
}

- (void)gameLoop {
	// Running
	if (gameState == kStateRunning) {
		if (previousState != kStateRunning) {
			score = 0;
			NSString *nssScore = [NSString stringWithFormat:@"%i", score];
			lblScore.text = nssScore;
			
			lblMenu.hidden = 1;
			lblRestart.hidden = 1;

			btnPlay.hidden = 1;
			btnSettings.hidden = 1;
			btnHowToPlay.hidden = 1;
			btnHighscore.hidden = 1;
			
			ball.hidden = 0;
			platform1.hidden = 0;
			platform2.hidden = 0;
			platform3.hidden = 0;
			platform4.hidden = 0;
			platform5.hidden = 0;
			lblScore.hidden = 0;
		}
		
		[self gameStatePlayNormal];
		previousState = kStateRunning;
	}
	// Game Over
	else if (gameState == kStateGameOver) {
		if (previousState == kStateRunning) {
			lblMenu.hidden = 0;
			lblRestart.hidden = 0;
		}
		
		previousState = kStateGameOver;
	}
	// Menu
	else if (gameState == kStateMenu) {
		if (previousState != kStateMenu) {
			btnPlay.hidden = 0;
			btnSettings.hidden = 0;
			btnHowToPlay.hidden = 0;
			btnHighscore.hidden = 0;
			
			ball.hidden = 1;
			platform1.hidden = 1;
			platform2.hidden = 1;
			platform3.hidden = 1;
			platform4.hidden = 1;
			platform5.hidden = 1;
			lblScore.hidden = 1;
			lblMenu.hidden = 1;
			lblRestart.hidden = 1;
			
			btnBack.hidden = 1;
			scTouchTilt.hidden = 1;
		}
		
		previousState = kStateMenu;
	}
	
	else if (gameState == kStateSettings) {
		if (previousState != kStateSettings) {
			btnPlay.hidden = 1;
			btnSettings.hidden = 1;
			btnHowToPlay.hidden = 1;
			btnBack.hidden = 0;
			btnHighscore.hidden = 1;
			scTouchTilt.hidden = 0;
		}
		previousState = kStateSettings;
	}
}

- (void)gameStatePlayNormal {
	ballVelocity.y += gravity.y;
	if (platform1Veloctiy.y > 0) {platform1Veloctiy.y += gravity.y;}
	if (platform2Veloctiy.y > 0) {platform2Veloctiy.y += gravity.y;}
	if (platform3Veloctiy.y > 0) {platform3Veloctiy.y += gravity.y;}
	if (platform4Veloctiy.y > 0) {platform4Veloctiy.y += gravity.y;}
	if (platform5Veloctiy.y > 0) {platform5Veloctiy.y += gravity.y;}
	
	if (controlType == kTouch) {
		// If the player is touching the screen, move the ball
		if (touchState == kLeftDown) {ballVelocity.x -= 0.2;}
		if (touchState == kRightDown) {ballVelocity.x += 0.2;}
	}
	
	if (controlType == kTilt) {
		ballVelocity.x += gravity.x;
	}
	
	// Make sure the ball doesn't move too fast.
	if (ballVelocity.x > kMaxBallSpeed) {ballVelocity.x = kMaxBallSpeed;}
	if (ballVelocity.x < -kMaxBallSpeed) {ballVelocity.x = -kMaxBallSpeed;}
	
	// Make the ball loop to the other side of the screen if it goes off.
	if (ball.center.x > self.view.bounds.size.width) {
		ball.center = CGPointMake(0, ball.center.y);
	}
	if (ball.center.x < 0) {
		ball.center = CGPointMake(self.view.bounds.size.width, ball.center.y);
	}
	
	ball.center = CGPointMake(ball.center.x + ballVelocity.x,ball.center.y + ballVelocity.y);
	platform1.center = CGPointMake(platform1.center.x, platform1.center.y + platform1Veloctiy.y);
	platform2.center = CGPointMake(platform2.center.x, platform2.center.y + platform2Veloctiy.y);
	platform3.center = CGPointMake(platform3.center.x, platform3.center.y + platform3Veloctiy.y);
	platform4.center = CGPointMake(platform4.center.x, platform4.center.y + platform4Veloctiy.y);
	platform5.center = CGPointMake(platform5.center.x, platform5.center.y + platform5Veloctiy.y);
	
	// The ball has fallen, game over.
	if (ball.center.y > self.view.bounds.size.height) {
		gameState = kStateGameOver;
		
		if (score > highscore) {
		    highscore = score;
			NSString *nssHighscore = [NSString stringWithFormat:@"%i", highscore];
			UIAlertView *alert = [[UIAlertView alloc]
								  initWithTitle:@"New Record!" 
								  message:nssHighscore
								  delegate:nil 
								  cancelButtonTitle:@"Ok" 
								  otherButtonTitles:nil]; 
			[alert show];
			[alert release];
			
			// Create the dictionry
			NSMutableDictionary* myDict = [[NSMutableDictionary alloc] init];
			
			// Add objects to dictionary
			[myDict setObject:nssHighscore forKey:@"Highscore"];
			
			
			// Get the path
			NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
			NSString *documentPath = [paths objectAtIndex:0];
			NSString *path = [documentPath stringByAppendingPathComponent:@"highscore.save"];
			
			// Save to file
			[NSKeyedArchiver archiveRootObject:myDict toFile:path];
		}
		ballVelocity.x = 0;
		ballVelocity.y = 0;
		
		// Reset the positions
		ball.center = CGPointMake(152 + 16,326 + 16);
		platform1.center = CGPointMake(129 + (kPlatformWidth/2),414 + (kPlatformHeight/2));
		platform2.center = CGPointMake(34 + (kPlatformWidth/2),316 + (kPlatformHeight/2));
		platform3.center = CGPointMake(192 + (kPlatformWidth/2),261 + (kPlatformHeight/2));
		platform4.center = CGPointMake(146 + (kPlatformWidth/2),179 + (kPlatformHeight/2));
		platform5.center = CGPointMake(8 + (kPlatformWidth/2),81 + (kPlatformHeight/2));
	}
	
	// If the ball has passed the 3/4 mark then move everything
	if (ball.center.y < (self.view.bounds.size.height/4)) {
		float difference = (self.view.bounds.size.height/4) - ball.center.y;
		score += (int)difference;
		NSString *nssScore = [NSString stringWithFormat:@"%i", score];
		lblScore.text = nssScore;
		ball.center = CGPointMake(ball.center.x, ball.center.y + difference);
		platform1.center = CGPointMake(platform1.center.x, platform1.center.y + difference);
		platform2.center = CGPointMake(platform2.center.x, platform2.center.y + difference);
		platform3.center = CGPointMake(platform3.center.x, platform3.center.y + difference);
		platform4.center = CGPointMake(platform4.center.x, platform4.center.y + difference);
		platform5.center = CGPointMake(platform5.center.x, platform5.center.y + difference);
		
		bg.center = CGPointMake(bg.center.x, bg.center.y + (difference/2));
		bg2.center = CGPointMake(bg2.center.x, bg2.center.y + (difference/2));
		
		if (bg.center.y > self.view.bounds.size.height + (bg.bounds.size.height/2)) {
			bg.center = CGPointMake(bg.center.x, bg2.center.y - 460);
		}
		
		if (bg2.center.y > self.view.bounds.size.height + (bg2.bounds.size.height/2)) {
			bg2.center = CGPointMake(bg2.center.x, bg.center.y - 460);
		}
		
		float viewWidth = self.view.bounds.size.width;
		float fViewWidthMinusPlatformWidth = viewWidth - 55.0f;
		int iViewWidthMinusPlatformWidth = (int)fViewWidthMinusPlatformWidth;
		
		// If the platforms move off the screen, then reset them at a random spot at the top
		if (platform1.center.y >= (self.view.bounds.size.height + 8)) {
			float x = random() % iViewWidthMinusPlatformWidth;
			x = x + 22.5f;
			float y = (random() % 20)-8;
			platform1.center = CGPointMake(x,y);
			platform1Veloctiy.y = 0;
		}
		if (platform2.center.y >= (self.view.bounds.size.height + 8)) {
			float x = random() % iViewWidthMinusPlatformWidth;
			x = x + 22.5f;
			float y = (random() % 20)-8;
			platform2.center = CGPointMake(x,y);
			platform2Veloctiy.y = 0;
		}
		if (platform3.center.y >= (self.view.bounds.size.height + 8)) {
			float x = random() % iViewWidthMinusPlatformWidth;
			x = x + 22.5f;
			float y = (random() % 20)-8;
			platform3.center = CGPointMake(x,y);
			platform3Veloctiy.y = 0;
		}
		if (platform4.center.y >= (self.view.bounds.size.height + 8)) {
			float x = random() % iViewWidthMinusPlatformWidth;
			x = x + 22.5f;
			float y = (random() % 20)-8;
			platform4.center = CGPointMake(x,y);
			platform4Veloctiy.y = 0;
		}
		if (platform5.center.y >= (self.view.bounds.size.height + 8)) {
			float x = random() % iViewWidthMinusPlatformWidth;
			x = x + 22.5f;
			float y = (random() % 20)-8;
			platform5.center = CGPointMake(x,y);
			platform5Veloctiy.y = 0;
		}
	}
	
	// Check for a bounce
	if (CGRectIntersectsRect(ball.frame, platform1.frame)) {
		if (ball.center.y + 8 < platform1.center.y) {
			if (ballVelocity.y > 0) {
				ballVelocity.y = -kJumpPower;
				platform1Veloctiy.y = .1;
			}
		}
	}
	if (CGRectIntersectsRect(ball.frame, platform2.frame)) {
		if (ball.center.y + 8 < platform2.center.y) {
			if (ballVelocity.y > 0) {
				ballVelocity.y = -kJumpPower;
				platform2Veloctiy.y = .1;

			}
		}
	}
	if (CGRectIntersectsRect(ball.frame, platform3.frame)) {
		if (ball.center.y + 8 < platform3.center.y) {
			if (ballVelocity.y > 0) {
				ballVelocity.y = -kJumpPower;
				platform3Veloctiy.y = .1;

			}
		}
	}
	if (CGRectIntersectsRect(ball.frame, platform4.frame)) {
		if (ball.center.y + 8 < platform4.center.y) {
			if (ballVelocity.y > 0) {
				ballVelocity.y = -kJumpPower;
				platform4Veloctiy.y = .1;

			}
		}
	}
	if (CGRectIntersectsRect(ball.frame, platform5.frame)) {
		if (ball.center.y + 8 < platform5.center.y) {
			if (ballVelocity.y > 0) {
				ballVelocity.y = -kJumpPower;
				platform5Veloctiy.y = .1;
			}
		}
	}
}

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {
	if (controlType == kTilt) {
		gravity.x = acceleration.x * kGravityMultiplier;
	}
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [[event allTouches] anyObject];
	CGPoint location = [touch locationInView:touch.view];
	
	if (gameState == kStateRunning && controlType == kTouch) {
		if (location.x < (self.view.bounds.size.width/2)) {
			touchState = kLeftDown;
			ballVelocity.x -= 0.2;
		}
		else {
			touchState = kRightDown;
			ballVelocity.x += 0.2;
		}
	}
	
	if (gameState == kStateGameOver) {
		if (location.x < (self.view.bounds.size.width/2)) {
			gameState = kStateMenu;
		}
		else {
			gameState = kStateRunning;
		}
	}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	touchState = kTouchesEnded;
}

- (IBAction)buttonClickedPlay {
	gameState = kStateRunning;
}

- (IBAction)buttonClickedHowToPlay {
	
}

- (IBAction)buttonClickedSettings {
	gameState = kStateSettings;
}

- (IBAction)buttonClickedBack {
	gameState = kStateMenu;
}

- (IBAction)buttonClickedHighscore {
	NSString *nssHighscore = [NSString stringWithFormat:@"%i", highscore];
	UIAlertView *alert = [[UIAlertView alloc]
						  initWithTitle:@"High Score" 
						  message:nssHighscore
						  delegate:nil 
						  cancelButtonTitle:@"Ok" 
						  otherButtonTitles:nil]; 
	[alert show];
	[alert release];
}
- (IBAction)valueChanged {
	if (scTouchTilt.selectedSegmentIndex == 0) {
		controlType = kTilt;
	} else {
		controlType = kTouch;
	}
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	
	self.bg = nil;
	self.bg2 = nil;
	self.ball = nil;
	self.platform1 = nil;
	self.platform2 = nil;
	self.platform3 = nil;
	self.platform4 = nil;
	self.platform5 = nil;
	self.lblScore = nil;
	self.lblMenu = nil;
	self.lblRestart = nil;
	self.btnPlay = nil;
	self.btnHowToPlay = nil;
	self.btnSettings = nil;
	self.btnBack = nil;
	self.scTouchTilt = nil;
	self.btnHighscore = nil;
}


- (void)dealloc {
    [super dealloc];
	
	[bg release];
	[bg2 release];
	[ball release];
	[platform1 release];
	[platform2 release];
	[platform3 release];
	[platform4 release];
	[platform5 release];
	[lblScore release];
	[lblMenu release];
	[lblRestart release];
	[btnPlay release];
	[btnHowToPlay release];
	[btnSettings release];
	[btnBack release];
	[scTouchTilt release];
	[btnHighscore release];
	
}

-(IBAction)alertMe {
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Doodle Jump Template!" message:@"Welcome to Doodle Jump Template. Simply just press the sides of the screen to move the Doodle around. Hit the platforms and get as High as you can. But be careful every bounce you do the platform will then quickly fall away " delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
	[alert show];
	[alert release];
	
}

@end