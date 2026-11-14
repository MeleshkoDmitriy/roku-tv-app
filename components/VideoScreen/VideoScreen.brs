sub Init()
    m.top.width = 1280
    m.top.height = 720
    m.top.color = "0x202020ff"

    m.video = m.top.findNode("video")
    m.video.visible = false
    m.video.observeField("state", "OnVideoStateChange")

    m.currentIndex = 0
    m.top.observeField("visible", "OnVisibleChange")
end sub

sub OnVisibleChange()
    if m.top.visible = true
        PlayItem(m.top.startIndex)
    end if
end sub

sub PlayItem(index as Integer)
    content = m.top.content

    if content = invalid OR m.top.close = true
        return
    end if

    items = content.getChildren(-1, 0)

    if index < 0 OR index >= items.count()
        m.top.close = true
        return
    end if

    item = items[index]
    m.currentIndex = index
    m.top.lastIndex = index

    videoContent = CreateObject("roSGNode", "ContentNode")
    videoContent.title = item.title
    videoContent.url = item.url
    videoContent.streamFormat = item.streamFormat
    videoContent.length = item.length

    m.video.content = videoContent
    m.video.visible = true
    m.video.setFocus(true)
    m.video.control = "play"
end sub

sub OnVideoStateChange()
    state = m.video.state

    if state = "finished"
        PlayItem(m.currentIndex + 1)
    else if state = "error"
        m.top.close = true
    end if
end sub

function OnKeyEvent(key as String, press as Boolean) as Boolean
    if press AND key = "back"
        m.video.control = "stop"
        m.top.close = true
        return true
    end if

    return false
end function
