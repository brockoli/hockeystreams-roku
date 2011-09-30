' ********************************************************************
' **  hockeystreams.com app 
' **  September 2011
' **  developers: brockoli
' **  artists: dmathieu
' ********************************************************************

Function showVideoScreen(episode As Object, headers As Object)

    if type(episode) <> "roAssociativeArray" then
        print "invalid data passed to showVideoScreen"
        return -1
    endif

    port = CreateObject("roMessagePort")
    screen = CreateObject("roVideoScreen")
    screen.SetMessagePort(port)

    screen.Show()
    screen.SetPositionNotificationPeriod(30)
	'screen.AddHeader("X-Roku-Reserved-Dev-Id", "")
	if headers <> invalid
	  for each header in headers
	    print header
	    screen.AddHeader("Cookie", header)
      next
	end if
    screen.SetContent(episode)
    screen.Show()

    'Uncomment his line to dump the contents of the episode to be played
    'PrintAA(episode)

    while true
        msg = wait(0, port)

        if type(msg) = "roVideoScreenEvent" then
            print "showHomeScreen | msg = "; msg.getMessage() " | index = "; msg.GetIndex()
            if msg.isScreenClosed()
                print "Screen closed"
                exit while
            elseif msg.isRequestFailed()
                print "Video request failure: "; msg.GetIndex(); " " msg.GetData() 
            elseif msg.isStatusMessage()
                print "Video status: "; msg.GetIndex(); " " msg.GetData() 
            elseif msg.isButtonPressed()
                print "Button pressed: "; msg.GetIndex(); " " msg.GetData()
            elseif msg.isPlaybackPosition() then
                nowpos = msg.GetIndex()
                'RegWrite(episode.ContentId, nowpos.toStr())
            else
                print "Unexpected event type: "; msg.GetType()
            end if
        else
            print "Unexpected message class: "; type(msg)
        end if
    end while

End Function
