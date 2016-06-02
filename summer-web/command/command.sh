#!/bin/bash

javac -encoding utf8 -classpath ./ summer/ShareFunc.java
javac -encoding utf8 -classpath ./ summer/Function.java
javac -encoding utf8 -classpath ./ summer/SearchCourse.java
javac -encoding utf8 -classpath ./ summerpt/SearchCourse.java
javac -encoding utf8 -classpath ./ summer/SearchDraw.java
javac -encoding utf8 -classpath ./ summerpt/SearchDraw.java
javac -encoding utf8 -classpath ./ summer/SearchSign.java
javac -encoding utf8 -classpath ./ summerpt/SearchSign.java 
javac -encoding utf8 -classpath ./ summer/PrintDraw.java
javac -encoding utf8 -classpath ./ summer/SearchSign.java
javac -encoding utf8 -classpath ./ summer/ShowCourse.java
javac -encoding utf8 -classpath ./ summerpt/ShowCourse.java
javac -encoding utf8 -classpath ./ summer/Sign.java
javac -encoding utf8 -classpath ./ summerpt/Sign.java
javac -encoding utf8 -classpath ./ summer/GetCategory.java
javac -encoding utf8 -classpath ./ summer/SA_2015.java
javac -encoding utf8 -classpath ./ summer/ShowCourse_toplux.java
javac -encoding utf8 -classpath ./ util/MysqlConnection.java
javac -encoding utf8 -classpath ./ util/ResourceUtil.java
javac -encoding utf8 -classpath ./ summer/GetCategoryOracle.java
javac -encoding utf8 -classpath ./:../lib/ojdbc6.jar:../lib/ucp.jar util/myOracleConnection.java

javac -encoding utf8 -classpath ../lib/ojdbc14.jar:./ summer/Report.java
javac -encoding utf8 -classpath ../lib/ojdbc14.jar:./ summer/ShowCourseOraclePstat.java
javac -encoding utf8 -classpath ../lib/ojdbc14.jar:./ summer/SearchCourseOraclePstat.java
javac -encoding utf8 -classpath ../lib/ojdbc14.jar:./ summerpt/ShowCourseOraclePstat.java


javac -encoding utf8 -classpath ./ summer/SA_2015O.java

# java -cp ./:../lib/mm.mysql-2.0.11-bin.jar TestMySQL
native2ascii -encoding UTF-8 i18n/Trans_cn.txt i18n/Trans_cn.properties



