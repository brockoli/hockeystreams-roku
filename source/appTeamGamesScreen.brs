'******************************************************
'**  Video Player Example Application -- Poster Screen
'**  November 2009
'**  Copyright (c) 2009 Roku Inc. All Rights Reserved.
'******************************************************

'******************************************************
'** Perform any startup/initialization stuff prior to 
'** initially showing the screen.  
'******************************************************
Function preShowTeamGamesScreen(breadA=invalid, breadB=invalid) As Object

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
Function showTeamGamesScreen(screen As Object, teamid As String) As Integer

    if validateParam(screen, "roPosterScreen", "showTeamGamesScreen") = false return -1

    m.curShow     = 0
    
    shows = getGamesByTeam(teamid)
    screen.SetListNames(getCategoryList())
    screen.SetContentList(shows)
    screen.Show()

    while true
        msg = wait(0, screen.GetMessagePort())
        if type(msg) = "roPosterScreenEvent" then
            print "showPosterScreen | msg = "; msg.GetMessage() " | index = "; msg.GetIndex()
            if msg.isListFocused() then
                m.curShow = 0
                screen.SetFocusedListItem(m.curShow)
                if msg.GetIndex() = 0 then
                  shows = getShowsForLive()
                  screen.SetContentList(shows)
                else if msg.GetIndex() = 1 then
                  shows = getVodCategories()
                  screen.SetContentList(shows)
                else if msg.GetIndex() = 2 then
                  screen.SetContentList(getShowsForLive())
                end if
                print "list focused | current category = "; m.curCategory
            else if msg.isListItemSelected() then
                m.curShow = msg.GetIndex()
                print "list item selected | current show = "; m.curShow
                if shows[m.curShow].SubCat = 2 then
                  ShowVideoScreen(shows[m.curShow])
                end if
                screen.SetFocusedListItem(m.curShow)
                print "list item updated  | new show = "; m.curShow
            else if msg.isScreenClosed() then
                return -1
            end if
        end If
    end while


End Function

'********************************************************************
'** Return the list of shows corresponding the currently selected
'** category in the filter banner.  As the user highlights a
'** category on the top of the poster screen, the list of posters
'** displayed should be refreshed to corrrespond to the highlighted
'** item.  This function returns the list of shows for that category
'********************************************************************
Function getGamesByTeam(teamid As String) As Object

    conn = InitTeamByGameFeedConnection(teamid)
    showList = conn.LoadTeamGamesFeed(conn)
    return showList

End Function