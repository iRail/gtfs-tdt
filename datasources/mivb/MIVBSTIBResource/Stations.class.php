<?php
/**
 * This is a class which will return all available Haltes from MIVB/STIB
 * 
 * @package packages/Haltes
 * @copyright (C) 2012 by iRail vzw/asbl
 * @license AGPLv3
 * @author Maarten Cautreels <maarten@flatturtle.com>
 */

include_once('MIVBSTIBStationDao.php');
 
class MIVBSTIBStations{

    public function __construct() {
        // Initialize possible params
        $this->longitude = null;
        $this->latitude = null;
        $this->name = null;
        $this->id = null;
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

    /**
     * Set parameters to be used in the read function, you can manipulate or validate your REST parameters here
     */
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
        $stationDao = new MIVBSTIBStationDao();
        if($this->id != null) {
            return $stationDao->getStationById($this->id);
        } else if($this->longitude != null && $this->latitude != null) {
            return $stationDao->getClosestStations($this->longitude, $this->latitude);
        } else if ($this->name != null) {
            return $stationDao->getStationsByName($this->name, $this->offset, $this->rowcount);
        }
    
        return $stationDao->getAllStations($this->offset, $this->rowcount);
    }

    public static function getDoc(){
        return "This resource contains haltes from MIVB/STIB.";
    }
}