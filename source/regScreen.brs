' ********************************************************************
' **  hockeystreams.com app 
' **  September 2011
' **  developers: brockoli
' **  artists: dmathieu
' ********************************************************************

' ********************************************************************
' Perform the registration flow
'
' Returns:
'	0 - We're registered. Proceed
'	1 - We're not registered. The user cancelled the process
'	2 - We're not registered. There was an error
' ********************************************************************

Function doRegistration() As Integer

	m.UrlBase = "https://www5.hockeystreams.com"
	m.UrlLogin = "/verify/login"
	
	username = ShowKeyboardScreen("Enter your username")
	if username <> ""
	  ' only prompt the user for a a password if they entered a username
	  password = ShowKeyboardScreen("Enter your password", true)
	end if
	
	if username <> "" and password <> ""
	  ' the user entered both a username and a password
	  ' store them in the registry for logging in during future sessions
	  sec = CreateObject("roRegistrySection", "hockeystreams")
	  sec.Write("username", username)
	  sec.Write("password", password)
	  sec.Flush()
	  
	' login
	xfer = CreateObject("roURLTransfer")
	' setup the transfer for SSL
	xfer.SetCertificatesFile("common:/certs/ca-bundle.crt")
	xfer.InitClientCertificates()
	xfer.SetURL(m.UrlBase + m.UrlLogin + "?username=" + xfer.Escape(username) + "&password=" + xfer.Escape(password))
	xfer.
	
End Function

Function ShowKeyboardScreen(prompt = "", secure = false)
  result = ""

  ' create a roKeyboardScreen and assign a message port to it
  port = CreateObject("roMessagePort")
  screen = CreateObject("roKeyboardScreen")
  screen.SetMessagePort(port)

  ' display a short string telling the user what they need to enter
  screen.SetDisplayText(prompt)

  ' add some buttons
  screen.AddButton(1, "Okay")
  screen.AddButton(2, "Cancel")

  ' if secure is true, the typed text will be obscured on the screen
  ' this is useful when the user is entering a password
  screen.SetSecureText(secure)

  ' display our keyboard screen
  screen.Show()

  while true
    ' wait for an event from the screen
    msg = wait(0, port)

    if type(msg) = "roKeyboardScreenEvent" then
      if msg.isScreenClosed() then
        exit while
      else if msg.isButtonPressed()
        if msg.GetIndex() = 1
          ' the user pressed the Okay button
          ' close the screen and return the text they entered
          result = screen.GetText()
          exit while
        else if msg.GetIndex() = 2
          ' the user pressed the Cancel button
          ' close the screen and return an empty string
          result = ""
          exit while
        end if
      end if
    end if
  end while

  screen.Close()
  return result
end function