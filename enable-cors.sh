#!/bin/bash

matchCors='cross-origin'
matchFilter='<\/filter>'
matchMapping='<\/filter-mapping>'
insertFilter='   <filter>\n     <filter-name>cross-origin</filter-name>\n     <filter-class>org.eclipse.jetty.servlets.CrossOriginFilter</filter-class>\n   </filter>\n'
insertMapping='   <filter-mapping>\n      <filter-name>cross-origin</filter-name>\n      <url-pattern>/*</url-pattern>\n    </filter-mapping>'
file='web.xml'
fileSave='web_sav.xml'
fileTmp='web_tmp.xml'

if grep -Fq "$matchCors" $file
then
  echo "CORS already enabled, nothing to do"
else
  echo "Enabling CORS..."
  cp $file $fileSave
  awk -v "insertFilter=$insertFilter" '1;/<\/filter>/ && !x {print insertFilter; x=1}' $file > $fileTmp
  awk -v "insertMapping=$insertMapping" '1;/<\/filter-mapping>/ && !x {print insertMapping; x=1}' $fileTmp > $file
  rm $fileTmp
fi
