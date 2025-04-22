#!/run/current-system/sw/bin/nu

sleep 1sec;

nohup bash -c '1password --silent' &;

nohup bash -c 'vesktop' &;