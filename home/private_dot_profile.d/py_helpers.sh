# vim:ft=sh

alias urldecode='python3 -c "import sys, urllib.parse as ul;  print(ul.unquote_plus(sys.argv[1]))"'
alias urlencode='python3 -c "import sys, urllib.parse as ul; print (ul.quote_plus(sys.argv[1]))"'
