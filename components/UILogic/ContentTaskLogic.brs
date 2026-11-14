sub RunContentTask()
    m.contentTask = CreateObject("roSGNode", "MainLoaderTask")
    m.contentTask.ObserveField("content", "OnMainContentLoaded")
    m.contentTask.ObserveField("error", "OnMainContentError")
    m.loadingIndicator.visible = true
    m.contentTask.control = "run"
end sub

sub OnMainContentLoaded()
    content = m.contentTask.content

    if content = Invalid OR content.getChildCount() = 0
        OnMainContentError()
        return
    end if

    m.loadingIndicator.visible = false

    if m.errorLabel <> Invalid
        m.errorLabel.visible = false
    end if

    m.GridScreen.content = content
end sub

sub OnMainContentError()
    m.loadingIndicator.visible = false

    if m.errorLabel <> Invalid
        m.errorLabel.text = "Failed to load content. Check your connection and restart the app."
        m.errorLabel.visible = true
    end if
end sub
