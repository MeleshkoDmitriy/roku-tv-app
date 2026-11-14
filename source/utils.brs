function GetTime(length as Integer) as String
    if length <= 0
        return "0:00"
    end if

    hours = Int(length / 3600)
    minutes = Int((length MOD 3600) / 60)
    seconds = length MOD 60

    if hours > 0
        return hours.toStr() + ":" + TwoDigits(minutes) + ":" + TwoDigits(seconds)
    end if

    return minutes.toStr() + ":" + TwoDigits(seconds)
end function

function TwoDigits(value as Integer) as String
    if value < 10
        return "0" + value.toStr()
    end if

    return value.toStr()
end function

function ContentListToSimpleNode(contentList as Object, nodeType = "ContentNode" as String) as object
    result = CreateObject("roSGNode", nodeType)

    if result <> invalid

        for each itemAA in contentList
            item = CreateObject("roSGNode", nodeType)
            item.setFields(itemAA)
            result.appendChild(item)
        end for
    end if

    return result
end function

function CloneChildren(node as Object, startItem = 0 as Integer)
    numOfChildren = node.getChildCount()
    children = node.getChildren(numOfChildren - startItem, startItem)
    childrenClone = []

    for each child in children
        childrenClone.push(child.clone(false))
    end for

    return childrenClone
end function
