from django.shortcuts import render
from django.contrib.auth import authenticate
from django.contrib.auth.models import User
from django.http import JsonResponse
from django.core.files.base import ContentFile
from django.forms.models import model_to_dict
from django.core import serializers
#from django.core.exceptions import DoesNotExist
from django.db.models import Avg

import dateutil.parser
import datetime

from server.models import Event, Category, Comment, Picture, Rating

# Create your views here.
def viewEvent(request, eventid):
	event = Event.objects.select_related().get(id = eventid)
	res = model_to_dict(event, fields = ['name', 'place', 'description', 'time'])
	print res
	res['organizor'] = {
		'id': event.organizor.pk,
		'username': event.organizor.username,
		'nickname': event.organizor.profile.nickname,
		'rating': Rating.objects.filter(ratee = event.organizor).aggregate(Avg('score'))['score__avg']
	}
	res['time'] = res['time'].isoformat()
	res['category'] = event.category.name if event.category else ''
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
	event.save()
	return JsonResponse({'success': True, 'id': event.id})

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
	user = User.objects.get(id = user_id)
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
	user = User.objects.get(id = user_id)
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
	user = User.objects.get(id = user_id)
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
	user = User.objects.get(id = user_id)
	try:
		user = User.objects.get(id = user_id)
		event.favoriters.remove(user)
	except:
		res = {'success': False, 'message': 'Invalid user_id'}
		return JsonResponse(res)
	return JsonResponse({'success': True})

def viewComments(request, eventid):
	try:
		event = Event.objects.get(id = eventid)
		comments = event.comment_set.all().select_related()
	except:
		res = {'success': False, 'message': 'Invalid event_id'}
		return JsonResponse(res)
	res = []
	for c in list(comments):
		info = model_to_dict(c, fields = ['id', 'content', 'time'])
		info['time'] = info['time'].isoformat()
		info['user'] = {
			'id': c.user.pk,
			'username': c.user.username,
			'nickname': c.user.profile.nickname,
		}
		res.append(info)
	return JsonResponse({'comments': res})

def addComment(request, eventid):
	# POST for comment
	try:
		user_id = request.POST['user_id']
		content = request.POST['content']
	except:
		res = {'success': False, 'message': 'Invalid Request'}
		return JsonResponse(res)
	try:
		user = User.objects.get(id = user_id)
	except:
		res = {'success': False, 'message': 'Invalid user_id'}
		return JsonResponse(res)
	try:
		event = Event.objects.get(id = eventid)
	except:
		res = {'success': False, 'message': 'Invalid event_id'}
		return JsonResponse(res)
	comment = Comment(user = user, event = event, content = content, time = datetime.datetime.now())
	comment.save()
	return JsonResponse({'success': True, 'id': comment.id})

def removeComment(request, eventid):
	# GET for comment
	try:
		comment_id = request.GET['comment_id']
	except:
		res = {'success': False, 'message': 'Invalid Request'}
		return JsonResponse(res)
	try:
		event = Event.objects.get(id = eventid)
	except:
		res = {'success': False, 'message': 'Invalid event_id'}
		return JsonResponse(res)
	try:
		comment = event.comment_set.filter(id = comment_id)
		comment.delete()
	except:
		res = {'success': False, 'message': 'Invalid comment_id'}
		return JsonResponse(res)
	return JsonResponse({'success': True})

def viewPictures(request, eventid):
	try:
		event = Event.objects.get(id = eventid)
		pictures = event.picture_set.all().select_related()
	except:
		res = {'success': False, 'message': 'Invalid event_id'}
		return JsonResponse(res)
	res = []
	for p in list(pictures):
		info = {}
		info['id'] = info['id']
		info['user'] = {
			'id': p.user.pk,
			'username': p.user.username,
			'nickname': p.user.profile.nickname,
		}
		info['image'] = p.image.url
		info['time'] = p.time.isoformat()
		res.append(info)
	return JsonResponse({'pictures': res})

def addPicture(request, eventid):
	# POST for picture
	try:
		user_id = request.POST['user_id']
		image = request.FILES['image']
	except:
		res = {'success': False, 'message': 'Invalid Request'}
		return JsonResponse(res)
	try:
		user = User.objects.get(id = user_id)
	except:
		res = {'success': False, 'message': 'Invalid user_id'}
		return JsonResponse(res)
	try:
		event = Event.objects.get(id = eventid)
	except:
		res = {'success': False, 'message': 'Invalid event_id'}
		return JsonResponse(res)
	uploadedFile = request.FILES['image']
	try:
		pid = Picture.objects.latest('id') + 1
	except DoesNotExist:
		pid = 1
	filename = str(eventid) + '-' + str(pid) + '.' + uploadedFile.name.split('.')[-1]
	picture = Picture(user = user, event = event, time = datetime.datetime.now())
	picture.image.save(filename, ContentFile(uploadedFile.read()), save = False)
	picture.save()
	return JsonResponse({'success': True})
