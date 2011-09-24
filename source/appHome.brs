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
Function preShowHomeScreen(breadA=invalid, breadB=invalid) As Object
    port=CreateObject("roMessagePort")
    screen = CreateObject("roPosterScreen")
    screen.SetMessagePort(port)
    if breadA<>invalid and breadB<>invalid then
        screen.SetBreadcrumbText(breadA, breadB)
    end if

    screen.SetListStyle("flat-landscape")
    return screen
End Function

'********************************************************************
'** Show the home screen with a few static entries for illustration
'** selecting an item from the screen will initiate registration
'********************************************************************
Function showHomeScreen(screen) As Integer

    if type(screen)<>"roPosterScreen" then
        print "illegal type/value for screen passed to showHomeScreen"
        return -1
    end if

    itemNames = getItemNames()
    screen.SetContentList(itemNames)
    screen.Show()

    while true
        msg = wait(0, screen.GetMessagePort())

        if type(msg) = "roPosterScreenEvent" then
            print "showHomeScreen | msg = " +  msg.GetMessage() + " | index = " + itostr(msg.GetIndex())

            if msg.isListItemSelected() then
                'doRegistration() 'file: regScreen.brs
            else if msg.isScreenClosed() then
                return -1
            end if
        end If
    end while

End Function

'**********************************************************************
'** These are the items on the home screen, they do nothing and are
'** are included so that the home screen has some content to select.
'** Press and item and you should get the registration screen displayed
'***********************************************************************
Function getItemNames() As Object
    items = [ "Live Streams", "On-Demand Streams", "testing" ]
    return items
End Function
