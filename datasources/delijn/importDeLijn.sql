SET character_set_database=utf8;
-- DROP SCHEMA
DROP database if exists `irail-datadelijn`;

-- RECREATE SCHEMA
CREATE database `irail-datadelijn` CHARACTER SET utf8 COLLATE utf8_general_ci;

-- Recreate Table Structure
use 'irail-datadelijn';

CREATE TABLE `dlgtfs_agency` (
  `agency_id` INT(11) NOT NULL,
  `agency_name` varchar(20) NOT NULL,
  `agency_url` varchar(255) NOT NULL,
  `agency_timezone` varchar(55) NOT NULL,
  `agency_lang` varchar(20) NOT NULL,
  `agency_phone` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `dlgtfs_calendar_dates` (
  `service_id` INT(11) NOT NULL,
  `date` DATE NOT NULL,
  `exception_type` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `dlgtfs_routes` (
  `route_id` INT(11) NOT NULL,
  `agency_id` INT(11) NOT NULL,
  `route_short_name` varchar(10) NOT NULL,
  `route_long_name` varchar(100) NOT NULL,
  `route_desc` varchar(255) NOT NULL,
  `route_type` int(11) NOT NULL,
  `route_url` varchar(255) NOT NULL,
  `route_color` varchar(6) NOT NULL,
  `route_text_color` varchar(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `dlgtfs_stop_times` (
  `trip_id` INT(11) NOT NULL,
  `arrival_time` VARCHAR(9),
  `departure_time` VARCHAR(9),
  `arrival_time_t` TIME,
  `departure_time_t` TIME,
  `stop_id` INT(11) NOT NULL,
  `stop_sequence` int(11) NOT NULL,
  `stop_headsign` int(11),
  `pickup_type` int(11) NOT NULL,
  `drop_off_type` int(11) NOT NULL,
  `shape_dist_traveled` varchar(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `dlgtfs_stops` (
  `stop_id` INT(11) NOT NULL,
  `stop_code` varchar(10) NOT NULL,
  `stop_name` varchar(255) NOT NULL,
  `stop_desc` varchar(10) NOT NULL,
  `stop_lat` varchar(25) NOT NULL,
  `stop_lon` varchar(25) NOT NULL,
  `zone_id` INT(11),
  `stop_url` varchar(20) NOT NULL,
  `location_type` varchar(10) NOT NULL,
  `parent_station` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `dlgtfs_trips` (
  `route_id` INT(11) NOT NULL ,
  `service_id` INT(11) NOT NULL ,
  `trip_id` INT(11) NOT NULL ,
  `trip_headsign` VARCHAR(150) NULL ,
  `trip_short_name` VARCHAR(45) NULL ,
  `direction_id` varchar(30) NULL ,
  `block_id` INT(11) NULL ,
  `shape_id` INT(11) NULL ,
  PRIMARY KEY (`trip_id`) 
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Primary Keys

ALTER TABLE `dlgtfs_agency` 
  ADD PRIMARY KEY (`agency_id`);

ALTER TABLE `dlgtfs_routes` 
  ADD PRIMARY KEY (`route_id`); 

ALTER TABLE `dlgtfs_stops` 
  ADD PRIMARY KEY (`stop_id`);
  
-- Indexes
  
ALTER TABLE `dlgtfs_routes` 
  ADD INDEX `IND_ROUTE_AGENCY_ID` (`agency_id` ASC);

ALTER TABLE `dlgtfs_stop_times` 
  ADD INDEX `IND_STOP_TIMES_STOP_ID` (`stop_id` ASC);
  
ALTER TABLE `dlgtfs_stops`  
  ADD INDEX `IND_STOPS_STOP_CODE` (`stop_code` ASC);
  
ALTER TABLE `dlgtfs_calendar_dates` 
  ADD INDEX `IND_CALENDAR_DATES_SERVICE_ID` (`service_id` ASC) ;
  
ALTER TABLE `dlgtfs_stop_times` 
  ADD INDEX `IND_STOP_TIMES_DEPARTURE_TIME_T` (`departure_time_t` ASC) ;

ALTER TABLE `dlgtfs_stops` 
  ADD INDEX `DL_STOPS_STOP_NAME_IND` (`stop_name` ASC) ;

-- Indexes for Foreign Keys
  
ALTER TABLE `dlgtfs_trips`
  ADD INDEX `FK_TRIPS_ROUTES` (`route_id` ASC) ;

ALTER TABLE `dlgtfs_trips`
  ADD INDEX `FK_TRIPS_CALENDAR` (`service_id` ASC);
  
ALTER TABLE `dlgtfs_stop_times` 
  ADD INDEX `FK_STOP_TIMES_TRIPS` (`trip_id` ASC);
  
ALTER TABLE `dlgtfs_routes`
  ADD INDEX `FK_ROUTES_AGENCIES` (`agency_id` ASC);
  
ALTER TABLE `dlgtfs_stop_times`
  ADD INDEX `FK_STOP_TIMES_STOPS` (`stop_id` ASC);
  
-- Foreign Keys

ALTER TABLE `dlgtfs_trips`
  ADD CONSTRAINT FK_TRIPS_ROUTES
  FOREIGN KEY (route_id )
  REFERENCES `dlgtfs_routes` (`route_id`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;
  
ALTER TABLE `dlgtfs_trips` 
  ADD CONSTRAINT `FK_TRIPS_CALENDAR`
  FOREIGN KEY (`service_id` )
  REFERENCES `dlgtfs_calendar_dates` (`service_id` )
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;

ALTER TABLE `dlgtfs_stop_times` 
  ADD CONSTRAINT `FK_STOP_TIMES_TRIPS`
  FOREIGN KEY (`trip_id` )
  REFERENCES `dlgtfs_trips` (`trip_id` )
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;

ALTER TABLE `dlgtfs_routes` 
  ADD CONSTRAINT `FK_ROUTES_AGENCIES`
  FOREIGN KEY (`agency_id` )
  REFERENCES `dlgtfs_agency` (`agency_id` )
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;

ALTER TABLE `dlgtfs_stop_times` 
  ADD CONSTRAINT `FK_STOP_TIMES_STOPS`
  FOREIGN KEY (`stop_id` )
  REFERENCES `dlgtfs_stops` (`stop_id` )
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;

-- AGENCY (delijn.dlgtfs_agency)
LOAD DATA LOCAL INFILE '/tmp/delijn-gtfs/agency.txt' INTO TABLE `dlgtfs_agency` CHARACTER SET utf8 FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\r\n' IGNORE 1 LINES (agency_id, agency_name, agency_url, agency_timezone, agency_lang, agency_phone);

-- ROUTES (delijn.dlgtfs_routes);
LOAD DATA LOCAL INFILE '/tmp/delijn-gtfs/routes.txt' INTO TABLE `dlgtfs_routes` CHARACTER SET utf8 FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\r\n' IGNORE 1 LINES (route_id, agency_id, route_short_name, route_long_name, route_desc, route_type, route_url, route_color, route_text_color);

-- CALENDAR_DATES (delijn.dlgtfs_calendar_dates)
LOAD DATA LOCAL INFILE '/tmp/delijn-gtfs/calendar_dates.txt' INTO TABLE `dlgtfs_calendar_dates` CHARACTER SET utf8 FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\r\n' IGNORE 1 LINES (service_id, @date, exception_type)
SET date = STR_TO_DATE(@date, '%Y%m%d');

-- TRIPS (delijn.dlgtfs_trips)
LOAD DATA LOCAL INFILE '/tmp/delijn-gtfs/trips.txt' INTO TABLE `dlgtfs_trips` CHARACTER SET utf8 FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\r\n' IGNORE 1 LINES (route_id, service_id, trip_id, trip_headsign, trip_short_name, direction_id, @block_id, @shape_id)
SET block_id = 0+@block_id, 
	shape_id = 0+@shape_id;

-- STOPS (delijn.dlgtfs_stops)
LOAD DATA LOCAL INFILE '/tmp/delijn-gtfs/stops.txt' INTO TABLE `dlgtfs_stops` CHARACTER SET utf8 FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\r\n' IGNORE 1 LINES (stop_id, stop_code, stop_name, stop_desc, stop_lat, stop_lon, @zone_id, stop_url, location_type, parent_station)
SET zone_id = 0+@zone_id;

-- STOP_TIMES (dlgtf_stop_times)
LOAD DATA LOCAL INFILE '/tmp/delijn-gtfs/stop_times.txt' INTO TABLE `dlgtfs_stop_times` CHARACTER SET utf8 FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\r\n' IGNORE 1 LINES (trip_id,@arrival_time,@departure_time,stop_id,stop_sequence,@stop_headsign,pickup_type,drop_off_type,shape_dist_traveled)
SET stop_headsign = 0+@stop_headsign,
	arrival_time = @arrival_time,
	departure_time = @departure_time,
	arrival_time_t = IF (0+SUBSTR(@arrival_time, 1,2) < 23, 
    STR_TO_DATE(@arrival_time, '%T'), 
    STR_TO_DATE(CONCAT(0+SUBSTR(@arrival_time, 1,2)-23, SUBSTR(@arrival_time, 3)), '%T')),
    departure_time_t = IF (0+SUBSTR(@departure_time, 1,2) < 23, 
    STR_TO_DATE(@departure_time, '%T'), 
    STR_TO_DATE(CONCAT(0+SUBSTR(@departure_time, 1,2)-23, SUBSTR(@departure_time, 3)), '%T'));
