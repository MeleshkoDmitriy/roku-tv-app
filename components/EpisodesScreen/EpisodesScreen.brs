function Init()
    m.top.observeField("visible", "OnVisibleChange")

    m.categoryList = m.top.findNode("categoryList")
    m.categoryList.observeField("itemFocused", "OnCategoryItemFocused")

    m.itemList = m.top.findNode("itemList")
    m.itemList.observeField("itemFocused", "OnListItemFocused")
    m.itemList.observeField("itemSelected", "OnListItemSelected")

    m.categoryListGainFocus = false

end function

sub OnListItemFocused(event as Object)
    focusedItem = event.getData()

    if m.itemToSection = Invalid OR focusedItem < 0 OR focusedItem >= m.itemToSection.count()
        return
    end if

    categoryIndex = m.itemToSection[focusedItem]

    if (categoryIndex - 1) = m.categoryList.jumpToItem
        m.categoryList.animateToItem = categoryIndex
    else if NOT m.categoryList.isInFocusChain()
        m.categoryList.jumpToItem = categoryIndex
    end if
end sub

sub InitSections(content as Object)
    m.firstItemInSection = [0]
    m.itemToSection = []
    sections = []
    sectionsCount = 0

    for each section in content.getChildren(- 1, 0)
        itemsPerSection = section.getChildCount()

        for each child in section.getChildren(- 1, 0)
            m.itemToSection.push(sectionsCount)
        end for

        sections.push({ title : section.title })
        m.firstItemInSection.push(m.firstItemInSection.peek() + itemsPerSection) 
        sectionsCount++
    end for

    m.firstItemInSection.pop()
    m.categoryList.content = ContentListToSimpleNode(sections)
end sub

sub OnCategoryItemFocused(event as Object) 
    if m.categoryListGainFocus = true
        m.categoryListGainFocus = false
    else if m.firstItemInSection <> Invalid
        focusedItem = event.getData() 

        if focusedItem >= 0 AND focusedItem < m.firstItemInSection.count()
            m.itemList.jumpToItem = m.firstItemInSection[focusedItem]
        end if
    end if
end sub

sub OnJumpToItem(event as Object) 
    content = m.itemList.content

    if content = Invalid
        return
    end if

    childCount = content.getChildCount()

    if childCount = 0
        return
    end if

    itemIndex = event.getData()

    if itemIndex < 0
        itemIndex = 0
    else if itemIndex >= childCount
        itemIndex = childCount - 1
    end if

    m.itemList.jumpToItem = itemIndex 
end sub

sub OnContentChange()
    content = m.top.content

    if content = Invalid
        return
    end if

    InitSections(content)
    m.itemList.content = GetEpisodesNode(content)
end sub

function GetEpisodesNode(content as Object) as Object
    node = CreateObject("roSGNode", "ContentNode")

    for each season in content.getChildren(- 1, 0)
        for each episode in season.getChildren(- 1, 0)
            node.appendChild(episode.clone(false))
        end for
    end for

    return node
end function

sub onVisibleChange()
    if m.top.visible = true
        m.itemList.setFocus(true)
    end if
end sub

sub OnListItemSelected(event as Object) 
    itemSelected = event.getData() 

    if m.itemToSection = Invalid OR itemSelected < 0 OR itemSelected >= m.itemToSection.count()
        return
    end if

    sectionIndex = m.itemToSection[itemSelected] 
    m.top.selectedItem = [sectionIndex, itemSelected - m.firstItemInSection[sectionIndex]]
end sub

function OnKeyEvent(key as String, press as Boolean) as Boolean
    result = false

    if press
        if key = "left" and m.itemList.HasFocus() 
            m.categoryListGainFocus = true
            m.categoryList.SetFocus(true)
            m.itemList.drawFocusFeedback = false
            result = true
        else if key = "right" and m.categoryList.HasFocus() 
            m.itemList.drawFocusFeedback = true
            m.itemList.SetFocus(true)
            result = true
        end if
    end if
    
    return result
end function
