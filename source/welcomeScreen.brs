' ********************************************************************
' **  hockeystreams.com app 
' **  September 2011
' **  developers: brockoli
' **  artists: dmathieu
' ********************************************************************

'***************************************************
'** Set up the screen in advance before its shown
'** Do any pre-display setup work here
'***************************************************
Function preShowWelcomeScreen(breadA=invalid, breadB=invalid) As Object
    port=CreateObject("roMessagePort")
    screen = CreateObject("roParagraphScreen")
    screen.SetMessagePort(port)
    if breadA<>invalid and breadB<>invalid then
        screen.SetBreadcrumbText(breadA, breadB)
    end if

    return screen
End Function

'********************************************************************
'** Show the home screen with a few static entries for illustration
'** selecting an item from the screen will initiate registration
'********************************************************************
Function showWelcomeScreen(screen) As Void

    if type(screen)<>"roParagraphScreen" then
        print "illegal type/value for screen passed to showHomeScreen"
		screen.close()
    end if

	screen.SetTitle("")
	screen.AddHeaderText("Welcome to the HockeyStreams.com channel")
	screen.AddParagraph("Enjoy the Pre-Season, Regular Season, and the Playoffs with HockeyStreams.  That's not all, HockeyStreams also broadcasts the Trade Deadline, Free Agency, All-Star Game, Player Awards, World Cup, Olympics, and many more events!")
	screen.AddParagraph("The HockeyStreams.com channel requires a HockeyStreams.com Premium Gold account.  If you do not currently have an account, please visit http://www.hockeystreams.com to sign up.  Memberships are available for a single day, a month, three months and one year.")
	screen.AddParagraph("If you already have HockeyStreams.com account, select Start to continue.")
    screen.AddButton(1, "Start")
	screen.AddButton(2, "Preview Stream")
	screen.AddButton(3, "Cancel")
	screen.Show()

    while true
        msg = wait(0, screen.GetMessagePort())

        if type(msg) = "roParagraphScreenEvent" then

            if msg.isButtonPressed() then
			  if msg.GetIndex() = 1
			    'Stub to run login screen
				print "showWelcomeScreen: Start"
			  else if msg.GetIndex() = 2
			    'Stub to run preview stream
				print "showWelcomeScreen: Preview"
			  else if msg.GetIndex() = 3
			    'Stub to exit channel
				print "showWelcomeScreen: Cancel"
				exit while
			  end if
            else if msg.isScreenClosed() then
			  exit while
            end if
        end If
    end while

End Function
