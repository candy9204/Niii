from django.shortcuts import render
from django.contrib.auth import authenticate
from django.contrib.auth.models import User
from django.http import JsonResponse
from django.core.files.base import ContentFile
from django.forms.models import model_to_dict
from django.core import serializers

import dateutil.parser

from server.models import Event, Category

# Create your views here.
def viewEvent(request, eventid):
	event = Event.objects.select_related().get(id = eventid)
	res = model_to_dict(event, files = ['name', 'place', 'description'])
	res['organizor'] = {
		'id': event.organizor.pk,
		'username': event.organizor.username,
		'nickname': event.organizor.profile.nickname
		'rating': Rating.objects.filter(ratee = event.organizor).aggregate(Avg('score'))['score__avg']
	}
	res['time'] = res['time'].isoformat()
	res['category'] = event.category.name
	res['participants'] = event.participants.count()
	res['favoriters'] = event.favoriters.count()
	return JsonResponse(res)

def addEvent(request):
	try:
		name = request.POST['name']
		organizor_id = request.POST['organizor']
		place = request.POST['place']
		description = request.POST['description']
		time = request.POST['time']
	except:
		res = {'success': False, 'message': 'Invalid Request'}
		return JsonResponse(res)
	try:
		organizor = User.objects.get(id = organizor_id)
	except:
		res = {'success': False, 'message': 'Invalid organizor_id'}
		return JsonResponse(res)
	try:
		time = dateutil.parser.parse(time)
	except:
		res = {'success': False, 'message': 'Invalid time'}
		return JsonResponse(res)
	event = Event(name = name, organizor = organizor, place = place, description = description, time = time)
	try:
		category_id = request.POST['category']
		category = Category.objects.get(id = category_id)
		event.category = category
	except:
		pass
	return JsonResponse({'success': True})

def viewCategories(request):
	categories = Category.objects.all().values('id', 'name')
	return JsonResponse({'categories': list(categories)})

def joinEvent(request, eventid):
	# GET for joining
	event = Event.objects.get(id = eventid)
	try:
		user_id = request.GET['user_id']
	except:
		res = {'success': False, 'message': 'Invalid Request'}
		return JsonResponse(res)
	user = User.objects.get(id = userid)
	try:
		user = User.objects.get(id = user_id)
		event.participants.add(user)
	except:
		res = {'success': False, 'message': 'Invalid user_id'}
		return JsonResponse(res)
	return JsonResponse({'success': True})

def favoriteEvent(request, eventid):
	# GET for favoriting
	event = Event.objects.get(id = eventid)
	try:
		user_id = request.GET['user_id']
	except:
		res = {'success': False, 'message': 'Invalid Request'}
		return JsonResponse(res)
	user = User.objects.get(id = userid)
	try:
		user = User.objects.get(id = user_id)
		event.favoriters.add(user)
	except:
		res = {'success': False, 'message': 'Invalid user_id'}
		return JsonResponse(res)
	return JsonResponse({'success': True})

def unjoinEvent(request, eventid):
	# GET for joining
	event = Event.objects.get(id = eventid)
	try:
		user_id = request.GET['user_id']
	except:
		res = {'success': False, 'message': 'Invalid Request'}
		return JsonResponse(res)
	user = User.objects.get(id = userid)
	try:
		user = User.objects.get(id = user_id)
		event.participants.remove(user)
	except:
		res = {'success': False, 'message': 'Invalid user_id'}
		return JsonResponse(res)
	return JsonResponse({'success': True})

def unfavoriteEvent(request, eventid):
	# GET for favoriting
	event = Event.objects.get(id = eventid)
	try:
		user_id = request.GET['user_id']
	except:
		res = {'success': False, 'message': 'Invalid Request'}
		return JsonResponse(res)
	user = User.objects.get(id = userid)
	try:
		user = User.objects.get(id = user_id)
		event.favoriters.remove(user)
	except:
		res = {'success': False, 'message': 'Invalid user_id'}
		return JsonResponse(res)
	return JsonResponse({'success': True})
