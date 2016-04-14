//
//  Constants.h
//  Demo Places
//
//  Created by paras.gorasiya on 4/2/15.
//  Copyright (c) 2015 paras.gorasiya. All rights reserved.
//

#ifndef Demo_Places_Constants_h
#define Demo_Places_Constants_h


#define kConst_Google_APIKey                    @"AIzaSyB1KaoKVj1vOd8aygUCmRQnLXQIkpZq6Fw"
#define kBgQueue                                dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

#define kLocationDisabled_AlertTitle        @"Location Services is disabled"
#define kLocationDisabled_AlertMsg          @"Demo Places needs your location to display nearby places.\nPlease turn on Location Services in your device settings."
#define kBtnCancel_Title                    @"Cancel"
#define kBtnSettings_Title                  @"Settings"
#define kBtnDone_Title                      @"Done"
#define kBtnOk_Title                        @"Ok"

#define kUD_Key_isFromDetailScreen          @"isFromDetailScreen"
#define kPermissionDenied_AlerTitle         @"App Permission Denied"
#define kPermissionDenied_AlerMsg           @"To re-enable, please go to Settings and turn on Location Service for this app."
#define kLocationDisabled_AlerTitle         @"Location Services is disabled"
#define kLocationDisabled_AlerMsg           @"Demo Places needs your location to display nearby places.\nPlease turn on Location Services in your device settings."

#define kURL_GooglePlaceSearch              @"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=%f,%f&radius=%@&types=%@&key=%@"
#define kURL_PlaceImageRef                  @"https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=%@&key=%@"
#define kAlertTitle_Sorry                   @"Sorry!"
#define kAlertMsg_NoData                    @"No data available."
#define kAlertMsg_NoResult                  @"No results found."

#define kAPI_Key_results                    @"results"

#define kUD_Key_Userlocation                @"userLocation"



//Favorites View controller
#define kBtnTitle_Favorites                 @"Favorites"
#define kUD_KeyisFromDetailScreen           @"isFromDetailScreen"
#define kUD_KeyisFromFavoriteScreen         @"isFromFavoriteScreen"

#define kAPI_Key_icon                       @"icon"
#define kAPI_Key_name                       @"name"
#define kAPI_Key_rating                     @"rating"
#define kAPI_Key_vicinity                   @"vicinity"
#define kAPI_Key_imageKey                   @"imageKey"
#define kAPI_Key_photos                     @"photos"
#define kAPI_Key_photo_reference            @"photo_reference"
#define kAPI_Key_id                         @"id"
#define kAPI_Key_geometry                   @"geometry"
#define kAPI_Key_location                   @"location"
#define kAPI_Key_lat                        @"lat"
#define kAPI_Key_lng                        @"lng"
#define kAPI_Key_latitude                   @"latitude"
#define kAPI_Key_longitude                  @"longitude"
#define kAlertMsg_NoPlaces                  @"No favorite places found."




#endif
