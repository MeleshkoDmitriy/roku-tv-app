sub Init()
    m.top.functionName = "GetContent"
end sub

sub GetContent()
    response = FetchFeed()

    if response = Invalid
        m.top.error = "network request failed"
        return
    end if

    json = ParseJson(response)

    if type(json) <> "roAssociativeArray"
        m.top.error = "unexpected feed format"
        return
    end if

    contentNode = BuildContentNode(json)

    if contentNode = Invalid OR contentNode.getChildCount() = 0
        m.top.error = "feed contains no content"
        return
    end if

    m.top.content = contentNode
end sub

function FetchFeed() as Dynamic
    xref = CreateObject("roURLTransfer")
    xref.setCertificatesFile("common:/certs/ca-bundle.crt")
    xref.setURL("https://jonathanbduval.com/roku/feeds/roku-developers-feed-v1.json")

    port = CreateObject("roMessagePort")
    xref.setMessagePort(port)

    if NOT xref.AsyncGetToString()
        return Invalid
    end if

    event = wait(15000, port)

    if type(event) <> "roUrlEvent"
        return Invalid
    end if

    if event.getResponseCode() <> 200
        return Invalid
    end if

    return event.getString()
end function

function BuildContentNode(json as Object) as Object
    rootChildren = []

    for each category in json
        value = json.Lookup(category)

        if type(value) = "roArray"
            row = {
                title : category
                children : []
            }

            for each item in value
                itemData = GetItemData(item)

                if itemData <> Invalid
                    itemData.mediaType = category
                    season = GetSeasonData(item.seasons)

                    if season <> Invalid AND season.count() > 0
                        itemData.children = season
                    end if

                    row.children.push(itemData)
                end if
            end for

            rootChildren.push(row)
        end if
    end for

    contentNode = CreateObject("roSGNode", "ContentNode")
    contentNode.update({
        children : rootChildren
    }, true)

    return contentNode
end function

function getItemData(video as Object) as Object
    if video = Invalid OR type(video) <> "roAssociativeArray"
        return Invalid
    end if

    item = {}

    item.description = ""
    if video.longDescription <> Invalid
        item.description = video.longDescription
    else if video.shortDescription <> Invalid
        item.description = video.shortDescription
    end if

    item.title = GetFeedString(video.title)
    item.releaseDate = GetFeedString(video.releaseDate)
    item.id = GetFeedString(video.id)
    item.hdPosterUrl = GetFeedString(video.thumbnail)

    if video.episodeNumber <> Invalid
        item.episodePosition = video.episodeNumber.toStr()
    end if

    if video.content <> Invalid
        if video.content.duration <> Invalid
            item.length = Int(video.content.duration)
        end if

        videos = video.content.videos

        if videos <> Invalid AND videos.count() > 0
            stream = videos[0]

            if stream <> Invalid
                item.url = GetFeedString(stream.url)

                if stream.videoType <> Invalid
                    item.streamFormat = LCase(stream.videoType.toStr())
                end if
            end if
        end if
    end if
    
    return item
end function

function GetSeasonData(seasons as Object) as Object
    seasonsArray = []

    if seasons <> Invalid
        episodeCounter = 0

        for each season in seasons 
            if season.episodes <> Invalid
                episodes = []

                for each episode in season.episodes
                    episodeData = GetItemData(episode)

                    if episodeData <> Invalid
                        episodeData.titleSeason = GetFeedString(season.title)
                        episodeData.numEpisodes = episodeCounter
                        episodeData.mediaType = "episode"
                        episodes.push(episodeData)
                        episodeCounter++
                    end if
                end for

                seasonData = GetItemData(season)

                if seasonData <> Invalid
                    seasonData.children = episodes
                    seasonData.contentType = "section"
                    seasonsArray.push(seasonData)
                end if
            end if
        end for
    end if
    
    return seasonsArray
end function

function GetFeedString(value as Dynamic) as String
    if value = Invalid
        return ""
    end if

    return value.toStr()
end function
