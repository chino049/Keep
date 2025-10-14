$ipadd = Read-Host -Prompt "Enter an IP address: "

#foreach ($item in 80,135,139,443,445) {
foreach ($item in 1..65535) {
    try {
        $socket = new-object System.Net.Sockets.TCPClient($ipadd, $item);
    } catch {}

    if ($socket -ne $NULL) {
    #    echo $ipadd":"$item "- Closed\n";
    #} else {
        echo $ipadd":"$item "- Open\n";
        $socket = $NULL;
    }
}


