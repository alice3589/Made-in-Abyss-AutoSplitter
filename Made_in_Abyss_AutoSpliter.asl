state("MadeInAbyss-Win64-Shipping")
{
    bool isLoading : 0x47B5494;
    int  menuActive : 0x04656A40, 0x7D8, 0x18, 0x88, 0x10;
    int  MapValue   : 0x048F56F8, 0xC0, 0x8C;
    int  MapID      : 0x048F56F8, 0xC0, 0x248;
}

startup
{
    // グループは使わず、トップレベルに2つのチェックを出す
    settings.Add("use_hello", true,  "Hello Abyss");
    settings.Add("use_dia",   false, "Deep in Abyss");
    settings.SetToolTip("use_hello", "Hello Abyss モードを使う");
    settings.SetToolTip("use_dia",   "Deep in Abyss モードを使う");
}

// どちらか一方になるように自動整列（誤操作で両方ON/OFFになっても直す）
update
{
    bool hello = (bool)settings["use_hello"];
    bool dia   = (bool)settings["use_dia"];

    if (hello && dia)            settings.SetValue("use_hello", false); // DIAを優先
    else if (!hello && !dia)     settings.SetValue("use_hello", true);  // どちらもOFFならHelloに戻す
}

isLoading
{
    return current.isLoading
        || current.menuActive == 1
        || current.MapValue == 6
        || current.MapValue == 3;
}

start
{
    return current.isLoading;
}

/* ====== スプリット（カテゴリ完全分岐） ====== */
split
{
    bool hello = (bool)settings["use_hello"];
    bool dia   = (bool)settings["use_dia"];

    // DIAだけONなら cat=1（DIA）。それ以外（両方OFF/両方ON/HelloのみON）は cat=0（Hello）
    int cat = (dia && !hello) ? 1 : 0;

    if (cat == 0)
    {
        // ---- Hello Abyss ----（既存ロジックそのまま）
        if (old.MapID == 60 && current.MapID == 1)  { return true; }
        if (old.MapID == 1  && current.MapID == 4)  { return true; }
        if (old.MapID == 4  && current.MapID == 2)  { return true; }
        if (old.MapID == 60 && current.MapID == 3)  { return true; }
        if (old.MapID == 3  && current.MapID == 8)  { return true; }
        if (old.MapID == 8  && current.MapID == 7)  { return true; }
        if (old.MapID == 7  && current.MapID == 9)  { return true; }
        if (old.MapID == 9  && current.MapID == 10) { return true; }
        if (old.MapID == 10 && current.MapID == 11) { return true; }
        if (old.MapID == 11 && current.MapID == 12) { return true; }
        if (old.MapID == 12 && current.MapID == 13) { return true; }
        if (old.MapID == 13 && current.MapID == 15) { return true; }
        if (old.MapID == 15 && current.MapID == 16) { return true; }
        if (old.MapID == 15 && current.MapID == 18) { return true; }
        if (old.MapID == 18 && current.MapID == 16) { return true; }
        if (old.MapID == 19 && current.MapID == 80) { return true; }
    }
    else
    {
        // ---- Deep in Abyss ----（必要な分割を追加）
        // 例：
        // if (old.MapID == 200 && current.MapID == 201) { return true; }
        // if (current.MapID == 999 && old.MapID != 999) { return true; } // 入場瞬間で切る
    }

    return false;
}
