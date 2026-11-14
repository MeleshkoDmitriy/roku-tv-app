sub InitScreenStack()
    m.screenStack = []
end sub

sub ShowScreen(node as Object)
    if node = Invalid
        return
    end if

    prev = m.screenStack.peek()

    if prev <> Invalid
        prev.visible = false
    end if

    node.visible = false
    m.top.appendChild(node)
    node.visible = true
    node.setFocus(true)
    m.screenStack.push(node)
end sub

sub CloseScreen(node as Object)
    last = m.screenStack.peek()

    if last = Invalid
        return
    end if

    if node <> Invalid AND NOT last.isSameNode(node)
        return
    end if

    m.screenStack.pop()
    last.visible = false
    m.top.removeChild(last)

    prev = m.screenStack.peek()

    if prev <> Invalid
        prev.visible = true
        prev.setFocus(true)
    end if
end sub

function GetCurrentScreen()
    return m.screenStack.peek()
end function
