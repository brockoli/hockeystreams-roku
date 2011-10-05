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
				'prepare the screen for display and get ready to begin
				loginScreen=preShowKeyboardScreen("Setup", "Username") 'file: loginScreens.brs
				if loginScreen=invalid then
					print "unexpected error in preShowKeyboardScreen"
					return
				end if
				'set to go, time to get started
				username = showKeyboardScreen(loginScreen, "Enter the username for your HockeyStreams.com account:") 'file: loginScreens.brs
				print username
				if username <> ""
				  ' only prompt for password if a username was entered
				  loginScreen = preShowKeyboardScreen("Setup", "Password") 'file: loginScreens.brs
				  if loginScreen = invalid then
					print "unexpected error in preShowKeyboardScreen"
					return
				  end if
				  password = showKeyboardScreen(loginScreen, "Enter the password for your HockeyStreams.com account:", true)
				  print "username = " + username + " password = " + password
				  
				  ' *** Testing authentication
				  urlPort=CreateObject("roMessagePort")

				  xfer = CreateObject("roURLTransfer")
				  xfer.SetPort(urlPort)
				  xfer.SetCertificatesFile("common:/certs/ca-bundle.crt")
				  xfer.AddHeader("X-Roku-Reserved-Dev-Id", "")
				  xfer.InitClientCertificates()
				  xfer.SetUrl("https://www5.hockeystreams.com/verify/login")
				  xfer.AsyncPostFromString("username=" + username + "&password=" + password)
				  cookies = CreateObject("roArray", 3, true)
				  while true
				    msg = wait(0, xfer.GetPort())
					
					if type(msg) = "roUrlEvent" then
					  headers = msg.GetResponseHeadersArray()
					  for each header in headers
					    print header
						if header.DoesExist("Set-Cookie")
						  cookies.Push(header.Lookup("Set-Cookie").Tokenize(";")[0])
						end if
					  next
                      exit while					  
					end if
				  end while
				    videoclip = CreateObject("roAssociativeArray")
					videoclip.StreamBitrates = [0]
					videoclip.StreamUrls = ["http://69.175.126.132/PREMIUM_HSTV_14.m3u8"]
					videoclip.StreamQualities = ["HD"]
					videoclip.StreamFormat = "hls"
					videoclip.Title = "Hockeystreams.com live"
					showVideoScreen(videoclip, cookies)
	  
				end if

			  else if msg.GetIndex() = 2
			    'Stub to run preview stream
				print "showWelcomeScreen: Preview"
			  else if msg.GetIndex() = 3
			    'Stub to exit channel
				print "showWelcomeScreen: Cancel"
				screen.Close()
			  end if
            else if msg.isScreenClosed() then
			  exit while
            end if
        end If
    end while

End Function
