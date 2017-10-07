xsetroot -solid '#655433' &
synclient TapButton1=1 TapButton2=2 TapButton3=3 HorizTwoFingerScroll=1 VertScrollDelta=-12 HorizScrollDelta=-12 &
ibus-daemon -d -x &
dbus-launch --exit-with-session openbox
