print("Amoraloff спешит на помощь!")
local frame = CreateFrame("Frame")

frame:RegisterEvent("PLAYER_LOGIN")
local eventTexts = {
    [1395] = {
        text = "Гонка за прибылью. Смотреть это видео <ссылка на видео, сделаем вид, что оно есть>",
        show = true
    },
    [613] = {
        text = "Событие с ID 613: тестовое событие.",
        show = false
    },
    [479] = {
        text = "Видео на канале: https://www.youtube.com/watch?v=G65TPAPlta8&ab_channel=Amoraloff",
        show = true
    },
    [6378907] = {
        text = "Это тестовое событие.",
        show = true
    }
}

frame:SetScript("OnEvent", function(self, event, ...)
    if event == "PLAYER_LOGIN" then
        local currentCalendarTime = C_DateAndTime.GetCurrentCalendarTime()
        local day = currentCalendarTime.monthDay
        local month = currentCalendarTime.month

        print('Ахой, малютка! ' .. string.format("Сегодня %02d.%02d, ", day, month) ..
                  "а это значит, что тебя ждёт безудержный фарм:")

        local numEvents = C_Calendar.GetNumDayEvents(0, day)
        print("Количество событий сегодня:", numEvents)
        if numEvents == 0 then
            print("Сегодня нет событий.")
        else
            for i = 1, numEvents do
                local event = C_Calendar.GetDayEvent(0, day, i)
                if event.eventID and eventTexts[event.eventID] then
                    -- Проверяем, нужно ли показывать событие
                    if eventTexts[event.eventID].show then
                        print(string.format("Событие: %s", event.title))
                        print(eventTexts[event.eventID].text)
                    end
                end
            end
        end
    end
end)
