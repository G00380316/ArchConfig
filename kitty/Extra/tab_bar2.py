"""draw kitty tab"""
# pyright: reportMissingImports=false
# pylint: disable=E0401,C0116,C0103,W0603,R0913

from kitty.boss import get_boss
from kitty.fast_data_types import Screen, get_options
from kitty.tab_bar import (
    DrawData,
    ExtraData,
    TabBarData,
    as_rgb,
    draw_title,
)
from kitty.utils import color_as_int

opts = get_options()

# colors
MAGENTA_1 = as_rgb(color_as_int(opts.color5))
BLUE_1 = as_rgb(color_as_int(opts.color4))
YELLOW_1 = as_rgb(color_as_int(opts.color3))
WHITE_2 = as_rgb(color_as_int(opts.color15))

TABBAR_BG = as_rgb(color_as_int(opts.tab_bar_background or opts.color0))

ACTIVE_BG = as_rgb(color_as_int(opts.active_tab_background or opts.color8))
ACTIVE_FG = as_rgb(color_as_int(opts.active_tab_foreground or opts.color4))
INACTIVE_BG = as_rgb(color_as_int(
    opts.inactive_tab_background or opts.color12))
INACTIVE_FG = as_rgb(color_as_int(opts.inactive_tab_foreground or opts.color7))

ACTIVE_WINDOW_BG = as_rgb(color_as_int(opts.color6))


def draw_tab(
    draw_data: DrawData,
    screen: Screen,
    tab: TabBarData,
    before: int,
    max_title_length: int,
    index: int,
    is_last: bool,
    extra_data: ExtraData,
) -> int:

    _draw_tab_status(
        draw_data, screen, tab, before, max_title_length, index, is_last, extra_data
    )

    if is_last:
        _draw_window_status(screen)

    return screen.cursor.x


SEPARATOR_SYMBOL, SOFT_SEPARATOR_SYMBOL = ("", "")


def _draw_window_status(screen: Screen) -> int:

    tm = get_boss().active_tab_manager
    cells = []

    if tm is not None:
        windows = tm.active_tab.windows.all_windows
        if windows is not None:
            for i, window in enumerate(windows):
                is_active = window.id == tm.active_window.id
                # is_first = i == 0
                is_last = i == len(windows) - 1
                # is_prev_active = windows[i -
                # 1].id == tm.active_window.id if not is_first else False

                sup = to_sup(str(i + 1))

                window_fg = YELLOW_1 if is_active else WHITE_2
                window_bg = INACTIVE_BG

                if is_last:
                    sep = SEPARATOR_SYMBOL
                    sep_bg = TABBAR_BG
                    sep_fg = INACTIVE_BG
                else:
                    sep = SOFT_SEPARATOR_SYMBOL
                    sep_bg = INACTIVE_BG
                    sep_fg = WHITE_2

                cells.insert(
                    i*2, (sep_fg, sep_bg, sep))
                cells.insert(
                    i*2, (window_fg, window_bg, f"  {sup} {window.title}  "))

    # calculate leading spaces to separate tabs from right status
    right_status_length = 0
    for _, _, cell in cells:
        right_status_length += len(cell)

    # draw right status
    for fg, bg, cell in cells:
        screen.cursor.fg = fg
        screen.cursor.bg = bg
        screen.draw(cell)
    screen.cursor.fg = 0
    screen.cursor.bg = 0

    # update cursor position
    screen.cursor.x = max(
        screen.cursor.x, screen.columns - right_status_length)
    return screen.cursor.x


def _draw_tab_status(
    draw_data: DrawData,
    screen: Screen,
    tab: TabBarData,
    before: int,
    max_title_length: int,
    index: int,
    is_last: bool,
    extra_data: ExtraData,
) -> int:
    # if screen.cursor.x >= screen.columns - right_status_length:
    #     return screen.cursor.x

    # tab_bg = screen.cursor.bg
    # tab_fg = screen.cursor.fg
    # default_bg = as_rgb(int(draw_data.default_bg))

    # draw tab title
    if tab.is_active:
        screen.cursor.fg = WHITE_2
        screen.cursor.bg = INACTIVE_BG
        draw_title(draw_data, screen, tab, index)
        screen.draw(" ")

    end = screen.cursor.x
    return end


def to_sup(s):
    sups = {u'0': u'\u2070',
            u'1': u'\xb9',
            u'2': u'\xb2',
            u'3': u'\xb3',
            u'4': u'\u2074',
            u'5': u'\u2075',
            u'6': u'\u2076',
            u'7': u'\u2077',
            u'8': u'\u2078',
            u'9': u'\u2079'}

    return ''.join(sups.get(char, char) for char in s)
