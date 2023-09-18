# badScripts - Growing compilation of bash and powershell scripts for daily use

### Not 'bad' bad, just not good, you know...
These scripts aren't optimized and some of them need to be re-tuned.

#### What's in here?
If you're anything like me, you have a few computers you use for coding and you have a collection of scripts that make your life so much easier; however, you probably never port them over to your new system, and the script you cobbled together from memory just doesn't run the same as your others.


#### How to run 'em?
I was always told if you can't start the car, you can't drive it... In case you need a refresher I tossed some quick primers below.

To run powershell scripts, same directory, .\scriptNameHere.ps1 (I can break it down better if the request is there)

Bash scripts, same directory, make file executable -- chmod +x filename.sh --, ./filename.sh. If you want it added so you can access it anywhere in the system, ask the google machine... Just kidding, follow below (Mileage may vary depending on distro)

```
### Move the file
sudo mv /path/to/file /usr/local/bin
### Make file executable
sudo chmod +x /usr/local/bin/file
### Love the file
file
```

Feel free to reach out or submit an issue for a specific script that you want added. I will start cleaning up the folders here soon so it's not a jumbled nightmare.

Cheers.

## run at your own risk, if you don't understand what you're running - try it in a VM first...
