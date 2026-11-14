function Init()
    m.top.observeField("visible", "OnVisibleChange")
    m.top.observeField("itemFocused", "OnItemFocusedChanged")

    m.buttons = m.top.findNode("buttons")
    m.poster = m.top.findNode("poster")
    m.description = m.top.findNode("descriptionLabel")
    m.title = m.top.findNode("titleLabel")
    m.time = m.top.findNode("timeLabel")
    m.release = m.top.findNode("releaseLabel")
end function

sub OnVisibleChange(event as Object)
    if event.getData() <> true
        return
    end if

    if m.buttons = Invalid OR m.buttons.isInFocusChain()
        return
    end if

    m.buttons.setFocus(true)
end sub

sub SetButtons(buttons)
    result = []

    for each button in buttons
        result.push({
            title : button
        })
    end for

    m.buttons.content = ContentListToSimpleNode(result)
end sub

sub SetDetailsContent(content)
    if content = Invalid
        return
    end if

    m.description.text = content.description
    m.poster.uri = content.hdPosterUrl
    m.title.text = content.title

    releaseDate = content.releaseDate

    if releaseDate <> Invalid AND releaseDate <> ""
        m.release.text = Left(releaseDate, 10)
    else
        m.release.text = ""
    end if

    m.time.text = ""

    if content.length <> Invalid AND content.length > 0
        m.time.text = "Duration: " + GetTime(content.length)
    end if

    if content.mediaType = "series"
        SetButtons(["Play", "See all episode"])
    else 
        SetButtons(["Play"])
    end if
end sub

sub OnJumpToItem()
    content = m.top.content

    if content = Invalid
        return
    end if

    itemIndex = m.top.jumpToItem

    if itemIndex < 0 OR itemIndex >= content.getChildCount()
        return
    end if

    m.top.itemFocused = itemIndex
end sub

sub OnItemFocusedChanged(event as Object)
    content = m.top.content

    if content = Invalid
        return
    end if

    item = content.getChild(event.getData())

    if item = Invalid
        return
    end if

    SetDetailsContent(item)
end sub

function OnKeyEvent(key as String, press as Boolean) as Boolean
    if NOT press
        return false
    end if

    content = m.top.content

    if content = Invalid
        return false
    end if

    currentItem = m.top.itemFocused

    if key = "left" AND currentItem > 0
        m.top.jumpToItem = currentItem - 1
        return true
    end if

    if key = "right" AND currentItem < content.getChildCount() - 1
        m.top.jumpToItem = currentItem + 1
        return true
    end if

    return false
end function
