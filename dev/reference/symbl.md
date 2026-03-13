# A list of UTF-8 or ASCII symbols.

Similar to the cli package listing of UTF-8/Unicode symbols and their
ASCII fall-backs depending on the environment they are called into. Can
be controlled by the option `options(cli.unicode = T/F)` if set,
otherwise the
[`l10n_info()`](https://rdrr.io/r/base/l10n_info.html)`$UTF-8` local
information is used to detect UTF-8 support.

## Usage

``` r
symbl

show_symbols()
```

## Format

A named list, see `names(symbl)`.

## Details

`show_symbols()` is a convenient print output to list of various
available UTF-8 (or ASCII) symbols to the screen.

## Examples

``` r
# available symbols
show_symbols()
#> tick                 ✓  pointer              ❯  leq                  ≤  
#> cross                ✖  info                 ℹ  times                ×  
#> star                 ★  warning              ⚠  pm                   ±  
#> square               ▇  menu                 ☰  upper_block_1        ▔  
#> square_small         ◻  smiley               ☺  upper_block_4        ▀  
#> square_small_filled  ◼  heart                ♥  lower_block_1        ▁  
#> circle               ◯  arrow_up             ↑  lower_block_2        ▂  
#> circle_filled        ◉  arrow_down           ↓  lower_block_3        ▃  
#> circle_dotted        ◌  arrow_left           ←  lower_block_4        ▄  
#> circle_double        ◎  arrow_right          →  lower_block_5        ▅  
#> circle_circle        ⓞ  radio_on             ◉  lower_block_6        ▆  
#> circle_cross         ⓧ  radio_off            ◯  lower_block_7        ▇  
#> circle_pipe          Ⓘ  checkbox_on          ☒  lower_block_8        █  
#> bullet               •  checkbox_off         ☐  full_block           █  
#> dot                  ․  checkbox_circle_on   ⓧ  mustache             ෴  
#> line                 ─  checkbox_circle_off  Ⓘ  fancy_question_mark ❓  
#> double_line          ═  neq                  ≠    
#> ellipsis             …  geq                  ≥    

# ascii versions
withr::with_options(list(cli.unicode = FALSE, width = 80L), show_symbols())
#> tick                    v  arrow_up                ^  sup_0                   0  
#> cross                   x  arrow_down              v  sup_1                   1  
#> star                    *  arrow_left              <  sup_2                   2  
#> square                [ ]  arrow_right             >  sup_3                   3  
#> square_small          [ ]  radio_on              (*)  sup_4                   4  
#> square_small_filled   [x]  radio_off             ( )  sup_5                   5  
#> circle                ( )  checkbox_on           [x]  sup_6                   6  
#> circle_filled         (*)  checkbox_off          [ ]  sup_7                   7  
#> circle_dotted         ( )  checkbox_circle_on    (x)  sup_8                   8  
#> circle_double         (o)  checkbox_circle_off   ( )  sup_9                   9  
#> circle_circle         (o)  neq                    !=  sup_minus               -  
#> circle_cross          (x)  geq                    >=  sup_plus                +  
#> circle_pipe           (|)  leq                    <=  play                    >  
#> circle_question_mark  (?)  times                   x  stop                    #  
#> bullet                  *  pm                    +/-  record                  o  
#> dot                     .  upper_block_1           ^  figure_dash             -  
#> line                    -  upper_block_4           ^  en_dash                --  
#> double_line             =  lower_block_1           .  em_dash               ---  
#> ellipsis              ...  lower_block_2           _  dquote_left             "  
#> continue                ~  lower_block_3           _  dquote_right            "  
#> pointer                 >  lower_block_4           =  squote_left             '  
#> info                    i  lower_block_5           =  squote_right            '  
#> warning                 !  lower_block_6           *  mustache             /\\/  
#> menu                    =  lower_block_7           #  fancy_question_mark   (?)  
#> smiley                 :)  lower_block_8           #    
#> heart                  <3  full_block              #    
```
