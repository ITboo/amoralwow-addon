
print("Amoraloff спешит на помощь!")
local frame = CreateFrame("Frame")

-- Регистрируем события
frame:RegisterEvent("PLAYER_LOGIN")
frame:RegisterEvent("CALENDAR_UPDATE_EVENT_LIST")

local eventTexts = {
    [479] = {
        text = 'Ярмарка - это не только веселье, но это владение для твоей профы, а также талантики.\nСписок айтемов на кв:\n - Алхимия: "Коктейль с пузырьками"(требуется: 5 Сок луноягоды)\n - Кузнечное дело: "Малышке нужны новые подковы"\n - Наложение чар: "Утилизация хлама"\n - Инженерное дело: "Кстати, о хламе"\n - Травничество: "Целебные травы"\n - Начертание: "Предсказание будущего" (требуется: 5 Тонкий пергамент)\n - Ювелирное дело: "Пусть ярмарка сверкает"\n - Кожевничество: "Изготовление призов" (требуется: 10 Блесна, 5 Грубая нить, 5 Синяя краска)\n - Горное дело: "Повторное использование и переработка"\n - Снятие шкур: "Отскоблить шкуры"\n - Портняжное дело: "Флаги, флаги всюду!" (требуется: 1 Грубая нить, 1 Красная краска, 1 Синяя краска)\n - Археология: "Развлечение для самых маленьких"\n - Кулинария: "Лягушки с хрустящей корочкой" (требуется: 5 Простая мука)\n - Рыбная ловля: "Морской хот-дог"',
        show = true,
        links = "https://www.youtube.com/watch?v=G65TPAPlta8&ab_channel=Amoraloff"
    },
    [181] = {
        text = "По всему Азероту начинается празднование Сада чудес! Юные герои, испытайте свои силы в это волшебное время, когда в каждом укромном местечке можно отыскать яйцо с подарком.Тмог?Скучное...А вот продать петов маунтов,может быть любопытным и прибыльным",
        links = "https://youtu.be/bgF1_cuCKsg?si=3TDQy-Fr_Dyq8-3r",
        show = true
    }
}

-- Флаг для отслеживания обработки календаря
local isProcessed = false

-- Создаём основное окно
local eventWindow = CreateFrame("Frame", "AmoraloffEventWindow", UIParent, "BasicFrameTemplateWithInset")
eventWindow:SetSize(400, 500)
eventWindow:SetPoint("CENTER") -- Размещаем окно по центру экрана
eventWindow:SetMovable(true)
eventWindow:EnableMouse(true)
eventWindow:RegisterForDrag("LeftButton")
eventWindow:SetScript("OnDragStart", eventWindow.StartMoving)
eventWindow:SetScript("OnDragStop", eventWindow.StopMovingOrSizing)
eventWindow:Hide() -- Скрываем окно по умолчанию

-- Заголовок окна
local title = eventWindow:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
title:SetPoint("CENTER", eventWindow.TitleBg, "CENTER", 0, 0)
title:SetText("События на сегодня")

-- Текстовое поле для отображения событий
local eventText = eventWindow:CreateFontString(nil, "OVERLAY", "GameFontNormal")
eventText:SetPoint("TOPLEFT", eventWindow, "TOPLEFT", 10, -30)
eventText:SetJustifyH("LEFT")
eventText:SetJustifyV("TOP")
eventText:SetWidth(380)
eventText:SetHeight(500)

-- Кнопка закрытия
local closeButton = CreateFrame("Button", nil, eventWindow, "GameMenuButtonTemplate")
closeButton:SetSize(100, 30)
closeButton:SetPoint("BOTTOM", eventWindow, "BOTTOM", 0, 10)
closeButton:SetText("Закрыть")
closeButton:SetScript("OnClick", function()
    eventWindow:Hide() -- Скрываем окно при нажатии
end)

-- Функция для обработки событий календаря
local function ProcessCalendarEvents()
    -- Проверяем, был ли календарь уже обработан
    if isProcessed then
        return
    end

    local currentCalendarTime = C_DateAndTime.GetCurrentCalendarTime()
    local day = currentCalendarTime.monthDay
    local month = currentCalendarTime.month

    -- Формируем текст для отображения
    local displayText = 'Ахой, малютка! ' .. string.format("Сегодня %02d.%02d, ", day, month) ..
                            "а это значит, что тебя ждёт безудержный фарм:\n\n"

    local numEvents = C_Calendar.GetNumDayEvents(0, day)
    if numEvents == 0 then
        displayText = displayText .. "Сегодня нет событий."
    else
        for i = 1, numEvents do
            local event = C_Calendar.GetDayEvent(0, day, i)
            if event.eventID and eventTexts[event.eventID] then
                -- Проверяем, нужно ли показывать событие
                if eventTexts[event.eventID].show then
                    displayText = displayText .. string.format("Событие: %s\n", event.title)
                    displayText = displayText .. eventTexts[event.eventID].text .. "\n\n"
                end
            end
        end
    end

    -- Устанавливаем текст в окне
    eventText:SetText(displayText)

    -- Показываем окно
    eventWindow:Show()

    -- Устанавливаем флаг, чтобы предотвратить повторную обработку
    isProcessed = true
end

-- Обработчик событий
frame:SetScript("OnEvent", function(self, event, ...)
    if event == "PLAYER_LOGIN" then
        -- После входа в игру запрашиваем обновление календаря
        C_Calendar.OpenCalendar()
    elseif event == "CALENDAR_UPDATE_EVENT_LIST" then
        -- Когда календарь обновлён, обрабатываем события
        ProcessCalendarEvents()
    end
end)

