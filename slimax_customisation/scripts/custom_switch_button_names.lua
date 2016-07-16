-- SLIMax Mgr Lua Script v1.0.0
-- PART OF SLIMAX Manager pkg
-- Copyright (c)2012-2016 by Zappadoc - All Rights Reserved.
-- last change by Zappadoc - 2016-02-29

-- NOTES:
-- these default switch and button names are displayed on your device panel when you change
-- the position of the control (switch or encoder) and when the "display_left_panel_function_state" 
-- and "display_right_panel_function_state" are set to true.
-- see SLIMax Manager Pro > Advanced Options > DISPLAY section

-- Switch Names 
-- replace here the default switch name by your custom name
mCustomSwitchNamesTable = { 
    SW1="SELC", 
    SW2="DISP",
    SW3="MULT",
    SW4="S4",
    SW5="S5",
    SW6="S6",
    SW7="S7",
    SW8="S8",
    SW9="S9",
    SW10="S10",
    SW11="S11",
    SW12="S12"
}

-- Button Names
-- replace here the default button name by your custom name
mCustomButtonNamesTable = { 
    BTN1="STRT", 
    BTN2="WET ",
    BTN3="BP  ",
    BTN4="LDWN",
    BTN5="LLEF",
    BTN6="LUP ",
    BTN7="LRHI",
    BTN8="PUMP",
    BTN9="PIT ",
    BTN10="KERS",
    BTN11="DIF+",
    BTN12="DIF-",
    BTN13="NEUT", 
    BTN14="LMTR",
    BTN15="MIX-",
    BTN16="MIX=",
    BTN17="GRDN",
    BTN18="GRUP",
    BTN19="GRP+",
    BTN20="GRP-",
    BTN21="BST-",
    BTN22="BST+",
    BTN23="CHG=",
    BTN24="CHG-",
    BTN25="DRS ",
    BTN26="+10 ",
    BTN27="-1  ",
    BTN28="RUP ",
    BTN29="RLEF",
    BTN30="RRHI",
    BTN31="RDWN",
    BTN32="B32"
}
