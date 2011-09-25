' ********************************************************************
' **  hockeystreams.com app 
' **  September 2011
' **  developers: brockoli
' **  artists: dmathieu
' ********************************************************************

Function preShowKeyboardScreen(breadA=invalid, breadB=invalid) As Object
  ' create a roKeyboardScreen and assign a message port to it
  port = CreateObject("roMessagePort")
  loginScreen = CreateObject("roKeyboardScreen")
  loginScreen.SetMessagePort(port)
  'if breadA<>invalid and breadB<>invalid then
      'loginScreen.SetBreadcrumbText(breadA, breadB)
  'end if

  return loginScreen

End Function

Function showKeyboardScreen(loginScreen, prompt = "", secure = false) As String
  result = ""

  ' display a short string telling the user what they need to enter
  loginScreen.SetDisplayText(prompt)

  ' add some buttons
  loginScreen.AddButton(1, "continue")
  loginScreen.AddButton(2, "back")

  ' if secure is true, the typed text will be obscured on the screen
  ' this is useful when the user is entering a password
  loginScreen.SetSecureText(secure)

  ' display our keyboard screen
  loginScreen.Show()

  while true
    ' wait for an event from the screen
    msg = wait(0, loginScreen.GetMessagePort())

    if type(msg) = "roKeyboardScreenEvent" then
      if msg.isScreenClosed() then
        exit while
      else if msg.isButtonPressed()
        if msg.GetIndex() = 1
          ' the user pressed the Okay button
          ' close the screen and return the text they entered
          result = loginScreen.GetText()
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

  loginScreen.Close()
  return result
End Function