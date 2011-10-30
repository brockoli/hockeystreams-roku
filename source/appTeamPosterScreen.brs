'******************************************************
'**  Video Player Example Application -- Poster Screen
'**  November 2009
'**  Copyright (c) 2009 Roku Inc. All Rights Reserved.
'******************************************************

'******************************************************
'** Perform any startup/initialization stuff prior to 
'** initially showing the screen.  
'******************************************************
Function preShowTeamPosterScreen(breadA=invalid, breadB=invalid) As Object

    if validateParam(breadA, "roString", "preShowPosterScreen", true) = false return -1
    if validateParam(breadB, "roString", "preShowPosterScreen", true) = false return -1

    port=CreateObject("roMessagePort")
    screen = CreateObject("roPosterScreen")
    screen.SetMessagePort(port)
    if breadA<>invalid and breadB<>invalid then
        screen.SetBreadcrumbText(breadA, breadB)
    end if

    screen.SetListStyle("arced-landscape")
    return screen

End Function


'******************************************************
'** Display the home screen and wait for events from 
'** the screen. The screen will show retreiving while
'** we fetch and parse the feeds for the game posters
'******************************************************
Function showTeamPosterScreen(screen As Object) As Integer

    if validateParam(screen, "roPosterScreen", "showPosterScreen") = false return -1

    m.curShow     = 0
    
    teams = getTeams()
    screen.SetContentList(teams)
    screen.Show()

    while true
        msg = wait(0, screen.GetMessagePort())
        if type(msg) = "roPosterScreenEvent" then
            print "showTeamPosterScreen | msg = "; msg.GetMessage() " | index = "; msg.GetIndex()
            if msg.isListItemSelected() then
                m.curShow = msg.GetIndex()
                print "list item selected | current show = "; m.curShow
                if teams[m.curShow].SubCat = 3 then
                    print "preShowTeamGamesScreen"
                    subScreen = preShowTeamGamesScreen("On-Demand by Team", teams[m.curShow].Title)
                    if subScreen=invalid then
                        print "unexpected error in preShowTeamGamesScreen"
                        return -1
                    end if
                    showTeamGamesScreen(subScreen, teams[m.curShow].TeamId)
                end if
                screen.SetFocusedListItem(m.curShow)
                print "list item updated  | new show = "; m.curShow
            else if msg.isScreenClosed() then
                return -1
            end if
        end If
    end while
End Function

Function getTeams() As Object

    conn = InitTeamListConnection()
    teamList = conn.LoadTeamXml(conn)
    return teamList

End Function
