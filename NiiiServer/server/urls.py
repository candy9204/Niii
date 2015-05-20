from django.conf.urls import include, url
from django.contrib import admin

from django.conf import settings
from django.conf.urls.static import static

from server.views import user, event

urlpatterns = [
	# user
    url(r'^user/login/$', user.login, name = 'login'),
    url(r'^user/register/$', user.register, name = 'register'),
    url(r'^user/(?P<userid>[0-9]+)/profile/$', user.viewProfile, name = 'viewprofile'),
    url(r'^user/(?P<userid>[0-9]+)/profile/update/$', user.updateProfile, name = 'updateprofile'),
    url(r'^user/(?P<userid>[0-9]+)/followings/$', user.viewFollowings, name = 'viewfollowings'),
    url(r'^user/(?P<userid>[0-9]+)/followings/add/$', user.addFollowings, name = 'addfollowings'),
    url(r'^user/(?P<userid>[0-9]+)/followings/remove/$', user.removeFollowings, name = 'removefollowings'),
    url(r'^user/(?P<userid>[0-9]+)/followers/$', user.viewFollowers, name = 'viewfollowers'),
    url(r'^user/(?P<userid>[0-9]+)/participations/$', user.viewParticipations, name = 'viewparticipations'),
    url(r'^user/(?P<userid>[0-9]+)/favorites/$', user.viewFavorites, name = 'viewfavorites'),
    url(r'^user/(?P<userid>[0-9]+)/rate/$', user.rate, name = 'rate'),
    url(r'^user/(?P<userid>[0-9]+)/recommend/$', user.recommend, name = 'recommend'),

    url(r'^event/(?P<eventid>[0-9]+)/$', event.viewEvent, name = 'viewevent'),
    url(r'^event/add/$', event.addEvent, name = 'addevent'),
    url(r'^event/categories/$', event.viewCategories, name = 'viewcategories'),

    url(r'^event/(?P<eventid>[0-9]+)/join/$', event.joinEvent, name = 'joinevent'),
    url(r'^event/(?P<eventid>[0-9]+)/favorite/$', event.favoriteEvent, name = 'favoriteevent'),
    url(r'^event/(?P<eventid>[0-9]+)/unjoin/$', event.unjoinEvent, name = 'unjoinevent'),
    url(r'^event/(?P<eventid>[0-9]+)/unfavorite/$', event.unfavoriteEvent, name = 'unfavoriteevent'),
    url(r'^event/(?P<eventid>[0-9]+)/comments/$', event.viewComments, name = 'viewcomments'),
    url(r'^event/(?P<eventid>[0-9]+)/comments/add/$', event.addComment, name = 'addcomment'),
    url(r'^event/(?P<eventid>[0-9]+)/comments/remove/$', event.removeComment, name = 'removecomment'),
    url(r'^event/(?P<eventid>[0-9]+)/pictures/$', event.viewPictures, name = 'viewpictures'),
    url(r'^event/(?P<eventid>[0-9]+)/pictures/add/$', event.addPicture, name = 'addpicture'),
    url(r'^search/$', event.search, name = 'search'),
    url(r'^category/(?P<categoryid>[0-9]+)/$', event.viewEventsByCat, name = 'vieweventsbycat'),

] + static(settings.MEDIA_URL, document_root = settings.MEDIA_ROOT)
