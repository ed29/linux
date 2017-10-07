if which dbus-launch >/dev/null && test -z "$DBUS_SESSION_BUS_ADDRESS"; then
       eval `dbus-launch --sh-syntax --exit-with-session`
fi
xsetroot -solid '#655433' &
synclient TapButton1=1 TapButton2=2 TapButton3=3 HorizTwoFingerScroll=1 VertScrollDelta=-12 HorizScrollDelta=-12 &
ibus-daemon -d -x &
openbox
