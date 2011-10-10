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

Function LoadTeamXml() As Object
    teamsArray = newTeamList()
    
    teamsFile = ReadAsciiFile("pkg:/xml/teams.xml")
    xml = CreateObject("roXMLElement")
    if not xml.Parse(teamsFile) then
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
        'item.SDPosterURL = item.Logo
        'item.HDPosterURL = item.Logo
                
        teamCount = teamCount + 1
        teamsArray.Push(item)

    next

End Function
