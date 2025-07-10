# xs2-station-renewdhcp
Bash script for reconnecting (bullet2 or TL-WA5210G ubi) with station mode to AP after power outage or reboot.<br/>
*added some feature, synamic IP firewall drop rule.
tested on Openwrt 19.07 

<h2><strong>Requirement </strong></h2><br/>
sshpass (to enter ssh password automatically when running )

<pre>
<code>sshpass <br/>
openssh-client </br>
bash
</code>
</pre>

<h2><strong>Running</strong></h2> <br/>
ex: place auto.sh at /opt/<br/>
make it executable 
<pre><code>
chmod +x auto.sh
</code></pre>
change credential inside auto.sh with your username and password<br/>
<pre><code>
vi /opt/auto.sh<br/>
</code>
</pre>
run auto.sh <br/>
<pre>
<code>/opt/auto.sh
</code>
</pre>

<h2><strong>Make it run at startup </strong> </h2><br/>
place in local startup
<pre><code>
sleep 20 && /opt/auto.sh
</pre></code>

<h2><g-emoji class="g-emoji" alias="scroll" fallback-src="https://github.githubassets.com/images/icons/emoji/unicode/1f4dc.png"><img class="emoji" alt="scroll" src="https://github.githubassets.com/images/icons/emoji/unicode/2757.png" width="20" height="20"></g-emoji> Troubleshooting </h2>
- no matching key exchange method found. Their offer: diffie-hellman <br/>
add host pattern at /etc/ssh/ssh_config
<pre><code> <br/>
Host * <br>
KexAlgorithms=diffie-hellman-group1-sha1<br/>
HostKeyAlgorithms ssh-rsa <br/>
PubkeyAcceptedKeyTypes ssh-rsa 
Ciphers=aes256-cbc
</pre></code>
<a href="https://askubuntu.com/questions/836048/ssh-returns-no-matching-host-key-type-found-their-offer-ssh-dss">SSH returns: no matching host key type found. Their offer: ssh-dss<a> <br/>
<a href="https://stackoverflow.com/questions/13928116/write-a-shell-script-to-ssh-to-a-remote-machine-and-execute-commands">write a shell script to ssh to a remote machine and execute commands </a> <br/>
<a href="https://www.perfect-privacy.com/en/manuals/router_openwrt_ssh">SSH tunnel on a Router running OpenWRT</a>
