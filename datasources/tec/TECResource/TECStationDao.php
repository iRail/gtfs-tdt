<?php

/**
 * This is a class which will return all available Stations from TEC
 * 
 * @copyright (C) 2015 by iRail vzw/asbl
 * @license MIT
 * @author Brecht Van de Vyvere <brecht@iRail.be>
 */

include_once('Config.class.php');
 
class StationDao {
	
	public function __construct() {
		require('rb.php');
		R::setup(TECConfig::$DB, TECConfig::$DB_USER, TECConfig::$DB_PASSWORD);
	}

	/**
	  * Query to get all stations ordered alphabetically
	  */
	private $GET_ALL_STATIONS_QUERY = "SELECT stop_id, stop_code, stop_name, stop_lat, stop_lon 
								FROM tecgtfs_stops
								ORDER BY stop_name ASC
								LIMIT :offset , :rowcount;";
								
	/**
	  * Query to get all stations with a certain name
	  * @param string name
	  */
	private $GET_STATIONS_BY_NAME_QUERY = "SELECT stop_id, stop_code, stop_name, stop_lat, stop_lon 
								FROM tecgtfs_stops
								WHERE lower(stop_name) LIKE :name
								ORDER BY stop_name ASC
								LIMIT :offset , :rowcount;";

	/**
	  * Query to get all closest station to a given point (lat/long) ordered by distance
	  * @param string latitude
	  * @param string longitude
	  */
	private $GET_CLOSEST_STATIONS_QUERY = "SELECT stop_id, stop_code, stop_name, stop_lat, stop_lon, 
									( 6371 * acos( cos( radians(:latitude) ) 
												   * cos( radians( stop_lat ) ) 
												   * cos( radians( :longitude ) 
													   - radians(stop_lon) ) 
												   + sin( radians(:latitude) ) 
												   * sin( radians( stop_lat ) ) 
												 )
								   ) AS distance 
								FROM tecgtfs_stops 
								HAVING distance < 250000
								ORDER BY distance
								LIMIT :offset , :rowcount;";
								
	/**
	  * Query to get a station with a given id
	  * @param int id
	  */
	private $GET_STATION_BY_ID = "SELECT stop_id, stop_code, stop_name, stop_lat, stop_lon 
											FROM tecgtfs_stops
											WHERE stop_id = :id;";
											
	/**
	  * Query to get a station with a given station code
	  * @param int code
	  */
	private $GET_STATION_BY_CODE = "SELECT stop_id, stop_code, stop_name, stop_lat, stop_lon 
											FROM tecgtfs_stops
											WHERE stop_code = :code;";

	/**
	  * 
	  * @param int id
	  * @return array The Station with the given id
	  */
	public function getStationById($id) {
		$arguments = array(":id" => intval(urldecode($id)));
		$query = $this->GET_STATION_BY_ID;
		
		$result = R::getAll($query, $arguments);
		return $this->parseStations($result);
	}
	
	/**
	  * 
	  * @param int code
	  * @return array The Station with the given code
	  */
	public function getStationByCode($code) {
		$arguments = array(":code" => intval(urldecode($code)));
		$query = $this->GET_STATION_BY_CODE;
		
		$result = R::getAll($query, $arguments);
		return $this->parseStations($result);
	}
	
	/**
	  *
	  * @param int $offset Number of the first row to return (Optional)
	  * @param int $rowcount Number of rows to return (Optional)
	  * @return array A List of all Stations
	  */
	public function getAllStations($offset=0, $rowcount=1024) {
		$arguments = array(":offset" => intval(urldecode($offset)), ":rowcount" => intval(urldecode($rowcount)));
		$query = $this->GET_ALL_STATIONS_QUERY;

		$result = R::getAll($query, $arguments);		
		return $this->parseStations($result);
	}
	
	/**
	  *
	  * @param string $name Name or part of the name of a station
	  * @param int $offset Number of the first row to return (Optional)
	  * @param int $rowcount Number of rows to return (Optional)
	  * @return array A List of Stations with given name
	  */
	public function getStationsByName($name, $offset=0, $rowcount=1024) {
		$arguments = array(":name" => '%' . urldecode(strtolower( $name )) . '%', ":offset" => intval(urldecode($offset)), ":rowcount" => intval(urldecode($rowcount)));
		$query = $this->GET_STATIONS_BY_NAME_QUERY;

		$result = R::getAll($query, $arguments);
		return $this->parseStations($result);
	}

	/**
	  *
	  * @param string $municipal The longitude (Required)
	  * @param string $latitude The latitude (Required)
	  * @param int $offset Number of the first row to return (Optional)
	  * @param int $rowcount Number of rows to return (Optional)
	  * @return array A List of the closest stations to a given location 
	  */
	public function getClosestStations($longitude, $latitude, $offset=0, $rowcount=1024) {
		$arguments = array(":latitude" => urldecode($latitude), ":longitude" => urldecode($longitude), ":offset" => intval(urldecode($offset)), ":rowcount" => intval(urldecode($rowcount)));
		$query = $this->GET_CLOSEST_STATIONS_QUERY;
		
		$result = R::getAll($query, $arguments);
		return $this->parseStations($result);
	}

	/**
     * Parses the data that comes out of the queries and creates nice objects that could be returned to the user.
     */
    private function parseStations($result) {
    	$stations = array();
		foreach($result as &$row){
			$station = array();
			$station["id"] = $row["stop_id"];
			$station["code"] = $row["stop_code"];

			// remove double quotes from stop_name and stop_lat
			$station["name"] = ltrim($row["stop_name"],'"');
			$station["latitude"] = ltrim(rtrim($row["stop_lat"],'"'));
			$station["longitude"] = $row["stop_lon"];
			
			// Some operations to make a better datastructure to parse
            $s = array();
            $s["station"] = $station;

			$stations[] = $s;
		}

		$sstations = array();
        $sstations["stations"] = $stations;

		return $sstations;
    }
}
