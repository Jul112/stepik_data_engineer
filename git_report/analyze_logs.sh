#!/bin/bash
awk '
	/HTTP/ {
		count_requests++
		count_ips[$1]++
		count_urls[$7]++
		
		method = $6
		gsub(/^"/, "", method)
		count_methods[method]++
	}	
	END {
		max_ip_count = 0
		most_common_url = ""
		for(u in count_urls) {
			if(count_urls[u] > max_ip_count) {
				max_ip_count = count_urls[u]
				most_common_url = u
			}
		}
		
		count_single_ips=0
		for ( ip in count_ips ) {
			if ( count_ips[ip] == 1) {
			count_single_ips++
			}
		}
		count_unique_ips = length(count_ips)

		print "Отчет о логе веб-сервера"
		print "========================"
		print "Общее количество запросов:    " count_requests
		print "Количество уникальных IP-адресов:    " count_unique_ips
		print "IP-адреса, встречающиеся 1 раз:    " count_single_ips 
 
		print "\nКоличество запросов по методам:"
		for ( m in count_methods ) {
			print "    " count_methods[m] " " m
		}

		print "\nСамый популярный URL: ", (most_common_url ? (count_urls[most_common_url] " " most_common_url) : "(none)")
	
	}
' access.log > report.txt

echo "Отчет сохранен в файл report.txt"
