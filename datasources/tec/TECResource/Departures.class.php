<?php
/**
 * This is a class which will return the information with the latest departures from a certain station
 *
 * @copyright (C) 2015 by iRail vzw/asbl
 * @license AGPLv3
 * @author Brecht Van de Vyvere <brecht@iRail.be>
 */
include_once('TECStopTimesDao.php');
 
class TECDepartures{

    public function __construct() {
        $this->offset = 0;
        $this->rowcount = 1024;
    }

    /**
     * The set of REST parameters that this resource requires.
     * Note that
     *      required parameters are passed as part of the URI, not as a query string parameter.
     *      you have access to all of the standard Laravel 4 classes and components (e.g. Request,...)
     *
     */
    public static function getParameters(){
        return array(
            'stationidentifier' => array(
                'required' => true,
                'description' => 'Station Name or ID that can be found in the Stations resource'
                ),
            'year' => array(
                'required' => true,
                'description' => 'Year'
                ),
            'month' => array(
                'required' => true,
                'description' => 'Month'
                ),
            'day' => array(
                'required' => true,
                'description' => 'Day'
                ),
            'hour' => array(
                'required' => true,
                'description' => 'Hour'
                ),
            'minute' => array(
                'required' => true,
                'description' => 'Minute'
                ),
            'offset' => array(
                'required' => false,
                'description' => 'Offset'
                ),
            'rowcount' => array(
                'required' => false,
                'description' => 'Rowcount'
                )
            );
    }

    public function setParameter($key,$val){
        if ($key == "stationidentifier"){
            $this->stationidentifier = $val;
        } else if ($key == "year"){
            $this->year = $val;
        } else if ($key == "month"){
            $this->month = $val;
        } else if ($key == "day") {
            $this->day = $val;
        } else if ($key == "hour") {
            $this->hour = $val;
        } else if ($key == "minute") {
            $this->minute = $val;
        } else if ($key == "offset") {
            $this->offset = $val;
        } else if ($key == "rowcount") {
            $this->rowcount = $val;
        }
    }

    /**
     * For semantic resources only (optional)
     */
    public function getNamespaces(){
        return array();
    }
    
    /**
     * Return an array with your data
     */
    public function getData(){
        $stopTimesDao = new StopTimesDao();

		if(substr($this->stationidentifier, 0, 3) == "tec") {
			return $stopTimesDao->getDeparturesByID($this->stationidentifier, $this->year, $this->month, $this->day, $this->hour, $this->minute, $this->offset, $this->rowcount);
		} else {
			return $stopTimesDao->getDeparturesByName($this->stationidentifier, $this->year, $this->month, $this->day, $this->hour, $this->minute, $this->offset, $this->rowcount);
		}
    }

    public static function getDoc(){
        return "This resource contains the Departures for a certain Station for a certain date and time from TEC.";
    }
}

?>