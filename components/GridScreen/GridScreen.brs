sub Init()
    m.rowList = m.top.findNode("rowList")

    m.titleLabel = m.top.findNode("titleLabel")
    m.descriptionLabel = m.top.findNode("descriptionLabel")

    m.top.observeField("visible", "OnVisibleChange")

    m.rowList.observeField("rowItemFocused", "OnItemFocused")
    m.rowList.observeField("content", "OnContentSet")
end sub

sub OnVisibleChange()
    FocusRowList()
end sub

sub OnContentSet()
    FocusRowList()
end sub

sub FocusRowList()
    if m.top.visible = true AND m.rowList.content <> Invalid
        m.rowList.setFocus(true)
    end if
end sub

sub OnItemFocused()
    content = m.rowList.content

    if content = Invalid
        return
    end if

    focusedIndex = m.rowList.rowItemFocused

    if focusedIndex = Invalid OR focusedIndex.count() < 2
        return
    end if

    row = content.getChild(focusedIndex[0])

    if row = Invalid
        return
    end if

    item = row.getChild(focusedIndex[1])

    if item = Invalid
        return
    end if

    m.titleLabel.text = item.title
    m.descriptionLabel.text = item.description

    if item.length <> invalid and item.length > 0
        m.titleLabel.text += " | time:" + GetTime(item.length)
    end if
end sub
