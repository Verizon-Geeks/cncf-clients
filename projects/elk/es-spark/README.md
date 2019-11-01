Integration of Spark engine with Elasticsearch

Spark provides fast iterative/functional-like capabilities over large data sets, typically by caching data in memory. 

Apache spark installation
Download apache spark from "http://apachemirror.wuchna.com/spark/spark-2.4.4/spark-2.4.4.tgz"
tar -xvf spark-2.4.4.tgz


Download elasticsearch spark plugin "elasticsearch-spark-20_2.11-7.3.0.jar" from "https://jar-download.com/download-handling.php"


Get into assembly directory 
$ cd spark-2.4.4/assembly/

Build the project
$ mvn clean install

Open interactive spark shell by passing elasticsearch-spark plugin and starting coding in scala
$ ./spark-2.4.4/bin --jars elasticsearch-spark-20_2.11-7.3.0.jar

Code snippet to save and read contents in elasticsearch through spark

import org.apache.spark.SparkContext
import org.elasticsearch.spark.rdd.EsSpark                        
case class Trip(departure: String, arrival: String)               
val upcomingTrip = Trip("OTP", "SFO")
val lastWeekTrip = Trip("MUC", "OTP")
val rdd = sc.makeRDD(Seq(upcomingTrip, lastWeekTrip))             
#Saves contents in elasticsearch inside index named spark
EsSpark.saveToEs(rdd, "spark/docs") 


import org.apache.spark.SparkContext
import org.apache.spark.SparkContext._
import org.elasticsearch.spark._
import org.apache.spark.SparkConf
#Reads contents from ES in form of RDD
val RDD = sc.esRDD("spark/docs")
RDD.collect().foreach(println)


Run spark jobs using following command and launch spark UI to view current job status.

./spark-submit -v --master spark://IP:PORT --jars /home/chidaso/es-spark/elasticsearch-spark-20_2.11-7.3.0.jar Sample.py




