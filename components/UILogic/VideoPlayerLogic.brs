sub ShowVideoScreen(rowContent as Object, selectedItem as Integer, isSeries = false as Boolean)
    videoScreen = CreateObject("roSGNode", "VideoScreen")
    videoScreen.observeField("close", "OnVideoScreenClose")

    videoScreen.isSeries = isSeries
    videoScreen.content = rowContent
    videoScreen.startIndex = selectedItem

    ShowScreen(videoScreen)
end sub

sub OnVideoScreenClose(event as Object)
    videoScreen = event.getRoSGNode()

    if event.getData() <> true
        return
    end if

    CloseScreen(videoScreen)

    screen = GetCurrentScreen()

    if screen = Invalid
        return
    end if

    screen.setFocus(true)

    if videoScreen.isSeries = false AND screen.subType() = "DetailsScreen" AND screen.content <> Invalid AND screen.content.isSameNode(videoScreen.content)
        screen.jumpToItem = videoScreen.lastIndex
    end if
end sub
