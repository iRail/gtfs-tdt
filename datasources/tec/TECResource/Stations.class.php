<?php
/**
 * This is a class which will return all available Stations from TEC
 * 
 * @copyright (C) 2015 by iRail vzw/asbl
 * @license MIT
 * @author Brecht Van de Vyvere <brecht@iRail.be>
 */

include_once('TECStationDao.php');
 
class TECStations{

    public function __construct() {     
        // Initialize possible params
        $this->longitude = null;
        $this->latitude = null;
        $this->name = null;
        $this->id = null;
        $this->code = null;
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
            'longitude' => array(
                'required' => false,
                'description' => 'Longitude'
                ),
            'latitude' => array(
                'required' => false,
                'description' => 'Latitude'
                ),
            'name' => array(
                'required' => false,
                'description' => 'Name'
                ),
            'id' => array(
                'required' => false,
                'description' => 'Id'
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
        if ($key == "longitude"){
            $this->longitude = $val;
        } else if ($key == "latitude"){
            $this->latitude = $val;
        } else if ($key == "name"){
            $this->name = $val;
        } else if ($key == "offset"){
            $this->offset = $val;
        } else if ($key == "rowcount"){
            $this->rowcount = $val;
        } else if ($key == "id") {
            $this->id = $val;
        } else if ($key == "code") {
            $this->code = $val;
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
        $stationDao = new StationDao();
        
        if($this->id != null) {
            return $stationDao->getStationById($this->id);
        } else if($this->code != null) {
            return $stationDao->getStationByCode($this->code);
        } else if($this->longitude != null && $this->latitude != null) {
            return $stationDao->getClosestStations($this->longitude, $this->latitude);
        } else if ($this->name != null) {
            return $stationDao->getStationsByName($this->name, $this->offset, $this->rowcount);
        }
    
        return $stationDao->getAllStations($this->offset, $this->rowcount);
    }

    public static function getDoc(){
        return "This resource contains stations from TEC.";
    }
}