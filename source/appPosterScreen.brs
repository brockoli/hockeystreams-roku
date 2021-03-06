'******************************************************
'**  Video Player Example Application -- Poster Screen
'**  November 2009
'**  Copyright (c) 2009 Roku Inc. All Rights Reserved.
'******************************************************

'******************************************************
'** Perform any startup/initialization stuff prior to 
'** initially showing the screen.  
'******************************************************
Function preShowPosterScreen(breadA=invalid, breadB=invalid) As Object

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
Function showPosterScreen(screen As Object) As Integer

    if validateParam(screen, "roPosterScreen", "showPosterScreen") = false return -1

    m.curShow     = 0
    
    shows = getShowsForLive()
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
                if shows[m.curShow].SubCat = 0 then
                    print "preShowTeamPosterScreen"
                    subScreen = preShowTeamPosterScreen("On-Demand by Team", "")
                    if subScreen=invalid then
                        print "unexpected error in preShowTeamHomeScreen"
                        return -1
                    end if
                    showTeamPosterScreen(subScreen)
                end if
                if shows[m.curShow].SubCat = 1 then
                
                end if
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

'**********************************************************
'** When a poster on the home screen is selected, we call
'** this function passing an associative array with the 
'** data for the selected show.  This data should be 
'** sufficient for the show detail (springboard) to display
'**********************************************************
Function displayShowDetailScreen(category as Object, showIndex as Integer) As Integer

    if validateParam(category, "roAssociativeArray", "displayShowDetailScreen") = false return -1

    shows = getShowsForCategoryItem(category, m.curCategory)
    screen = preShowDetailScreen(category.Title, category.kids[m.curCategory].Title)
    showIndex = showDetailScreen(screen, shows, showIndex)

    return showIndex
End Function


'**************************************************************
'** Given an roAssociativeArray representing a category node
'** from the category feed tree, return an roArray containing 
'** the names of all of the sub categories in the list. 
'***************************************************************
Function getCategoryList() As Object

    categories = CreateObject("roArray", 100, true)
    categories.Push("Live Streams")
    categories.Push("On-Demand Streams")
    categories.Push("Settings")
    return categories

End Function

'********************************************************************
'** Return the list of shows corresponding the currently selected
'** category in the filter banner.  As the user highlights a
'** category on the top of the poster screen, the list of posters
'** displayed should be refreshed to corrrespond to the highlighted
'** item.  This function returns the list of shows for that category
'********************************************************************
Function getShowsForLive() As Object

    conn = InitShowFeedConnection()
    showList = conn.LoadShowFeed(conn)
    return showList

End Function

Function getVodCategories() As Object
    
    categories = CreateObject("roArray", 2, true)
    
    o = CreateObject("roAssociativeArray")
    
    o.Title            = "On-Demand by Team"
    o.SubCat           = 0
    o.ShortDescriptionLine1 = o.Title 
    
    categories.Push(o)

    o2 = CreateObject("roAssociativeArray")
    
    o2.Title            = "On-Demand by Date"
    o2.SubCat           = 1
    o2.ShortDescriptionLine1 = o2.Title 
    
    categories.Push(o2)
    
    return categories
    
End Function