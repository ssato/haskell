-- ~/.xmobarrc

Config {
     font = "xft:Sans-10:bold:antialias=true"
    ,bgColor = "black"
    ,fgColor = "grey"
    ,position = TopW L 94
    ,lowerOnStart = False
    ,commands = [
         Run Cpu ["-L","3","-H","50","--normal","green","--high","red"] 10
        --, Run Weather "EGPF" ["-t"," <tempF>F","-L","64","-H","77","--normal","green","--high","red","--low","lightblue"] 36000
        --, Run Network "eth0" ["-L","0","-H","32","--normal","green","--high","red"] 10
        ,Run Memory ["-t","Mem: <usedratio>%"] 10
        ,Run Swap [] 10
        ,Run Date "%a %b %_d %H:%M" "date" 10
        ,Run StdinReader
        ]
    ,sepChar = "%"
    ,alignSep = "}{"
    ,template = "%StdinReader% }{ %cpu% %memory% %swap%  <fc=#ee9a00>%date%</fc> "
    }


-- vim:sw=4 ts=4 et:
