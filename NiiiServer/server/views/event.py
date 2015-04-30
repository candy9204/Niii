from django.shortcuts import render
from django.contrib.auth import authenticate
from django.contrib.auth.models import User
from django.http import JsonResponse
from django.core.files.base import ContentFile
from django.forms.models import model_to_dict
from django.core import serializers

from server.models import Event

# Create your views here.
def viewEvent(request, eventid):
	event = Event.objects.select_related().get(id = eventid)
	res = model_to_dict(event, files = ['name', 'place', 'description', 'time'])
	res['organizor'] = {
		'id': event.organizor.pk,
		'username': event.organizor.username,
		'nickname': event.organizor.profile.nickname
	}
	res['category'] = event.category.name
	res['participants'] = event.participants.count()
	res['favoriters'] = event.favoriters.count()

