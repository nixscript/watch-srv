# watch-srv

The script for termux (Android only), monitors the specified server. If someone has logged in to the server, the script issues a notification in the phone.

![ScreenShot](./screenshot.png)

1. [Install](#install)
2. [Configuration](#settings)
3. [Resume](#resume)

### Requirements

1. termux, termux-api
2. Permissions **termux** and **termux-api** to access the network and files.
3. Generate *ssh-key* to access the server without a password.

### Installation

1. Install [termux](https://play.google.com/store/apps/details?id=com.termux)
2. Install [termux-api](https://play.google.com/store/apps/details?id=com.termux.api)
3. Enter **termux**, do the following:

    ```
    apt update
    apt upgrade
    apt install termux-api
    ```
    This will install updates, and establish **termux** communication with **termux-api**.
4. Install *git*

    ```
    apt install git
    ```
5. Clone *watch-srv*

    ```
    git clone https://git.tuxnix.ru/nixscript/watch-srv
    ```
Everything is ready for configure.

**Note:** by default, **termux** has only *vi*, so if
you are not friends with it, set the preferred one.
For example, I use **Midnight Commander** ( *mc* ),
which has *mcedit*, but I like micro more.
Both mc and *micro* are available, so I think there are
other editors too.

### Configuration

Есть масса вариантов, оставить скрипт в текущем месте,
переместить в системную директорию, например */usr*, или
сделать наиболее логично. Создать директорию *~/bin* и
скопировать скрипт туда. На примере *~/bin* я и опишу
настройку.

There are many options to leave the script in the current
location, move to the system directory, for example */usr*,
or make the most logical. Create a *~/bin* directory and
copy the script there. I will describe the setup using the
example *~/bin*.

1. Make directory

    ```
    mkdir ~/bin
    ```
2. Copy script

    ```
    cp ./watch-srv/watch-srv.sh ~/bin/watch-srv.sh
    ```
3. Open script with our favorite editor, uncomment the last
line and replace the *login* *server.ru* and *22* with
the required parameters.

    ```
    check "login" "server.ru" 22
    ```
4. Generate ssh-key and upload to server

    ```
    ssh-keygen
    cd .ssh
    rsync ./id_rsa.pub login@server.ru:/home/login/.ssh/termux_key
    ssh login@server.ru cat ~/.ssh/termux_key >>~/.ssh/authorized_keys
    ```
    The last two commands will require a password.
    After, no password is required.
5. Add a task to *cron*. Remember, the default editor is *vi*.
If you want to use another, here is an example:

    ```
    export EDITOR="mcedit"; crontab -e
    # или так
    export EDITOR="micro"; crontab -e
    ```
    The task in *cron* is easy to add. For example, to check every
    minute in the editor, we write the following line:

    ```
        * * * * * ~/bin/watch-srv.sh
    ```

    I decided to do a check every 30 seconds, so I had to use hack:

    ```
        * * * * * ~/bin/watch-srv.sh

        * * * * * (sleep 30; ~/bin/watch-srv.sh)
    ```
    
    Here are two calls to the script, both act in a minute, but the
    first one works, and the other with a delay of 30 seconds.

    Save and exit

6. Run *cron*

    ```
    crond
    ```
Now, if someone logs in on the server, a notification of this type
will appear in the smartphone:

![ScreenShot](./screenshot.png)

As you can see in the screenshot, there are three buttons:
1. **All right** - prevents the permanent notification to appear
until the user logs out on the server. After all users have logged
out, the script runs in standard mode.
2. **Copy** - puts the notification text into the smartphone's
system clipboard.
3. **Get full log** - gets the whole log and saves it to
*Downloads/srv-login.log*

### Resume

Everything is quite simple. If you have any suggestions, suggestions,
ideas, write to [VK@Nixscript](https://vk.com/nixscript)
or to me [FB@grig.russ](https://facebook.com/grigruss)
[Instagramm@grigruss](https://instagramm.com/grig.russ)
[e-mail](mailto:grigruss@ya.ru).
