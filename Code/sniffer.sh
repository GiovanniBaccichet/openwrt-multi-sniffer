#!/bin/sh

# Check if tcpdump is installed
if ! hash tcpdump 2>/dev/null; then
    echo "tcpdump is not installed. Install it with 'opkg update && opkg install tcpdump'"
    exit 1
fi

# Check if iw is installed
if ! hash iw 2>/dev/null; then
    echo "iw is not installed. Install it with 'opkg update && opkg install iw'"
    exit 1
fi

# MAC vendor database file path
VENDOR_DB="/usr/bin/manuf"

# Function to get vendor from MAC address
get_vendor() {
    local mac=$1
    local oui=${mac:0:8}
    local vendor=$(grep -i $oui $VENDOR_DB | cut -f 3)
    echo $vendor
}

                                                      [ Read 100 lines ]
^X Exit        ^O Write Out   ^W Where Is    M-Q Previous   ^K Cut         ^C Location    M-D Prev Word  ^B Back
^L Refresh     ^R Read File   ^\ Replace     M-W Next       ^U Paste       ^/ Go To Line  M-F Next Word  ^F Forward
  GNU nano 7.2                                                                           /usr/bin/probe-sniffer.sh
    local oui=${mac:0:8}
    local vendor=$(grep -i $oui $VENDOR_DB | cut -f 3)
    echo $vendor
}

# Function to get channel from frequency
get_channel() {
    local freq=$1
    case "$freq" in
        2412) echo 1 ;;
        2417) echo 2 ;;
        2422) echo 3 ;;
        2427) echo 4 ;;
        2432) echo 5 ;;
        2437) echo 6 ;;
        2442) echo 7 ;;
        2447) echo 8 ;;
        2452) echo 9 ;;
        2457) echo 10 ;;
        2462) echo 11 ;;
        2467) echo 12 ;;
        2472) echo 13 ;;
        2484) echo 14 ;;
        5180) echo 36 ;;
        5200) echo 40 ;;
        5220) echo 44 ;;
        5240) echo 48 ;;
        5260) echo 52 ;;
        5280) echo 56 ;;
        5300) echo 60 ;;
        5320) echo 64 ;;
        5500) echo 100 ;;
        5520) echo 104 ;;
        5540) echo 108 ;;
        5560) echo 112 ;;
        5580) echo 116 ;;
        5600) echo 120 ;;
        5620) echo 124 ;;
        5640) echo 128 ;;
        5660) echo 132 ;;
        5680) echo 136 ;;
        5700) echo 140 ;;
        5745) echo 149 ;;
        5765) echo 153 ;;
        5785) echo 157 ;;
        5805) echo 161 ;;
        5825) echo 165 ;;
        *) echo "unknown frequency: $freq" ;;
    esac
}

# This function sniffs probe requests on a given interface and output JSON
sniff_probe_requests() {
    local interface=$1
    echo "Sniffing on $interface..."
    tcpdump -l -i $interface -e -s 256 type mgt subtype probe-req -Z root | while IFS= read -r line; do
        mac=$(echo $line | grep -oE 'SA:([[:xdigit:]]{1,2}:){5}[[:xdigit:]]{1,2}' | cut -d ':' -f 2-)
        rssi=$(echo $line | grep -oE 'signal [[:digit:]-]+' | awk '{print $2}')
        timestamp=$(echo $line | awk '{print $1}')
        freq=$(echo $line | grep -oE '[[:digit:]]* MHz' | grep -oE '[[:digit:]]*')
        channel=$(get_channel $freq)
        vendor=$(get_vendor $mac)
        echo "{ \"mac\": \"$mac\", \"rssi\": \"$rssi\", \"timestamp\": \"$timestamp\", \"vendor\": \"$vendor\", \"channel\": \"$channel\" }" | awk -f /root/probe-sniffer.awk -v intf=$intf > /tmp/pro>
    done
}

# Put all the wireless interfaces into monitor mode
for interface in $(iw dev | grep Interface | cut -f 2 -s -d" "); do
    iw dev $interface set monitor none
    ifconfig $interface up
done

# Sniff probe requests on all the wireless interfaces at the same time
for interface in $(iw dev | grep Interface | cut -f 2 -s -d" "); do
    sniff_probe_requests $interface &
done

# Wait for all child processes to finish
wait


