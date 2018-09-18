
#Getting information on Spotify's Global Top 50 chart

# There isn't a great R wrapper for the Spotify API. 
# But not to worry, it's pretty easy to use - but be prepared for a lot of JSON wrangling!

#load packages:

library(httr)
library(dplyr)


#set up tokens from Spotify App:
             
clientID <- 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'
secret <- 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'

#Authentication using the tokens - This is a request API, which in turn gives you permission or not

response = POST(
  'https://accounts.spotify.com/api/token',
  accept_json(),
  authenticate(clientID, secret),
  body = list(grant_type = 'client_credentials'),
  encode = 'form',
  verbose()
)

# These will be used in future API calls:
mytoken = content(response)$access_token #extracting access token from the previous API Call
HeaderValue = paste0('Bearer ', mytoken) #Authorization is always Bearer + unique token

# query with desired endpoint to make API call - this is a 'playlist' call 
# This URL format can be broken apart and pasted back together in order to batch API calls. It is important to know the format
# of the endpoint you want to use, which determines what information you give and get
# a list of Spotify API endpoints can be found here: https://developer.spotify.com/documentation/web-api/reference/object-model/
query <- paste0("https://api.spotify.com/v1/users/spotifycharts/playlists/37i9dQZEVXbMDoHDwVN2tF/tracks")
r <- GET(url = query, add_headers(Authorization = HeaderValue)) #The actual API call
r2 <- httr::content(r) #extracting the JSON information

# this is where most of the music-related data is. Other parts of 'r2' have to do with rate limiting and success/failure status of the call
items <- r2$items

# from exploring the lists (within lists) of data within "items" we can see there is a lot of information you might want! But you also might not want all of it, 
# and unlisting everything can create an unweidly dataset. The loop below creates an empty dataframe of the size we want to fill. For this example, we'll just
# extract the title of the song (name), the credited artist (artist), the track's unique spotify id (id, which can be used for future API calls), and the 
# song's overall popularity on spotify (popularity, integer 0 - 100).


global50 <- matrix(nrow= 50, ncol= 4)
global50<- as.data.frame(global50)
names(global50)<- c("name", "artist", "id", "popularity")

for (i in 1:50) {
  global50$name[i] <- items[[i]]$track$name
  global50$artist[i] <- items[[i]]$track$artists[[1]]$name
  global50$id[i] <- items[[i]]$track$id
  global50$popularity[i] <- items[[i]]$track$popularity
}

# One can imagine that if you want many more variables (say, all of the available markets since this is chart is not limited to one country), 
# this would not be a very efficient method. If we want all of the information this API call gives us for every track, we might want a different
# method.

# Since each song can have a different number of variables, we need to create an empty list to store a dataframe for each song. Thus, the list should
# be however many songs we have (50)

complete_global50_list <- vector("list", length(items))

# Then, we put each song's infromation into a dataframe, and store it in the list:
for (i in 1:length(items)) {
  t <- unlist(r2$items[[i]], use.names = T)
  complete_global50_list[[i]] <- data.frame(lapply(t, type.convert), stringsAsFactors=FALSE) 
}

# complete_global50_list is a list of dataframes, one for each song, which we now have to combine into one:
# note rbind.fill() appends datasets with different numbers of variables!

complete_global50 <- plyr::rbind.fill(complete_global50_list)

# This gives us a dataset of 50 observations, and 226 variables! The data are in wide-form, which is not usually the most useable format...
