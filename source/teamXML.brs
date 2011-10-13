Function InitTeamListConnection() As Object

    conn = CreateObject("roAssociativeArray")
    conn.UrlShowFeed  = "http://www5.hockeystreams.com/rss/roku_teams.xml" 

    conn.Timer = CreateObject("roTimespan")

    conn.LoadTeamXml    = LoadTeamXml
    conn.ParseTeamFeed   = parse_team_xml
    conn.InitTeamItem    = init_team_item

    print "created feed connection for " + conn.UrlShowFeed
    return conn

End Function


'******************************************************
'Initialize a new feed object
'******************************************************
Function newTeamList() As Object

    o = CreateObject("roArray", 30, true)
    return o

End Function

Function init_team_item() As Object
    o = CreateObject("roAssociativeArray")

    o.Title            = ""
    o.Logo             = ""
    
    return o
End Function

Function LoadTeamXml(conn As Object) As Object
    
    if validateParam(conn, "roAssociativeArray", "LoadTeamXml") = false return invalid 

    print "url: " + conn.UrlShowFeed 
    http = NewHttp(conn.UrlShowFeed)

    m.Timer.Mark()
    rsp = http.GetToStringWithRetry()
    print "Request Time: " + itostr(m.Timer.TotalMilliseconds())

    teamsArray = newTeamList()

    'teamsFile = ReadAsciiFile("pkg:/xml/teams.xml")
    
    xml = CreateObject("roXMLElement")
    if not xml.Parse(rsp) then
        print "Can't parse xml"
        return teamsArray
    endif

    parse_team_xml(xml, teamsArray)
    return teamsArray
    
End Function

'**************************************************************************
'**************************************************************************
Function parse_team_xml(xml As Object, teamsArray As Object) As Void

    teamCount = 0
    teamList = xml.GetChildElements()

    for each team in teamList

        item = init_team_item()

        'fetch all values from the xml for the current show
        item.Title            = validstr(team@name) 
        item.Logo             = validstr(team@logo)

        'map xml attributes into screen specific variables
        item.ShortDescriptionLine1 = item.Title 
        item.SDPosterURL = item.Logo
        item.HDPosterURL = item.Logo
        print item.SDPosterURL
        print item.HDPosterURL
                
        teamCount = teamCount + 1
        teamsArray.Push(item)

    next

End Function
