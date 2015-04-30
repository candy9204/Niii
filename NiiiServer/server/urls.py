from django.conf.urls import include, url
from django.contrib import admin

from django.conf import settings
from django.conf.urls.static import static

from server.views import user, event

urlpatterns = [
	# user
    url(r'^user/login/', user.login, name = 'login'),
    url(r'^user/register/', user.register, name = 'register'),
    url(r'^user/profile/(?P<userid>[0-9]+)/$', user.viewProfile, name = 'viewprofile'),
    url(r'^user/profile/(?P<userid>[0-9]+)/update/$', user.updateProfile, name = 'updateprofile'),
    url(r'^user/following/(?P<userid>[0-9]+)/$', user.viewFollowing, name = 'viewfollowing'),
    url(r'^user/following/(?P<userid>[0-9]+)/add/$', user.addFollowing, name = 'addfollowing'),
    url(r'^user/following/(?P<userid>[0-9]+)/remove/$', user.removeFollowing, name = 'removefollowing'),
    url(r'^user/follower/(?P<userid>[0-9]+)/$', user.viewFollower, name = 'viewfollower'),

    url(r'^event/(?P<eventid>[0-9]+)/$', event.viewEvent, name = 'viewEvent'),

] + static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
