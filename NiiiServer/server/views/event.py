from django.shortcuts import render
from django.contrib.auth import authenticate
from django.contrib.auth.models import User
from django.http import JsonResponse
from django.core.files.base import ContentFile
from django.forms.models import model_to_dict
from django.core import serializers
#from django.core.exceptions import DoesNotExist
from django.db.models import Avg, Count

import dateutil.parser
import datetime

from server.models import Event, Category, Comment, Picture, Rating, Profile

# Create your views here.
def viewEvent(request, eventid):
	event = Event.objects.select_related().get(id = eventid)
	res = model_to_dict(event, fields = ['name', 'place', 'description', 'time'])
	res['organizor'] = {
		'id': event.organizor.pk,
		'username': event.organizor.username,
		'nickname': event.organizor.profile.nickname,
		'rating': Rating.objects.filter(ratee = event.organizor).aggregate(Avg('score'))['score__avg']
	}
	res['time'] = res['time'].isoformat()
	res['category'] = event.category.name if event.category else ''
	participants = event.participants.all()
	res['participants'] = []
	for part in participants:
		info = {
			'id' : part.id,
			'username' : part.username,
			'nickname' : part.profile.nickname,
			'email' : part.profile.email,
			"gender" : part.profile.gender,
			"rating" : Rating.objects.filter(ratee = part).aggregate(Avg('score'))['score__avg'],

			'photo': part.profile.photo.url if hasattr(part.profile.photo, 'url') else None
		}
		res['participants'].append(info)
	# check if current user has joined/favorited
	user_id = request.GET['user_id']
	user = User.objects.get(id = user_id)
	res['is_joined'] = True if user in event.participants.all() else False
	res['is_favorited'] = True if user in event.favoriters.all() else False

	return JsonResponse(res)

def viewPopularEvents(request):
	events = Event.objects.annotate(total_count = Count('participants', distinct = True) + Count('favoriters', distinct = True)).order_by('-total_count').values('id', 'name', 'place', 'time','category__name', 'total_count')[:10]
	for event in events:
		event['time'] = event['time'].isoformat()
	return JsonResponse({'events': list(events)})

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

def search(request):
	res = []
	searchString = ""
	try:
		searchString = request.POST['searchString']
	except:
		res['success'] = False
		res['message'] = 'Invalid Request'
	if searchString == "":
		pevents = Event.objects.annotate(total_count = Count('participants', distinct = True) + Count('favoriters', distinct = True)).order_by('-total_count').values('id', 'name', 'place', 'time','category__name', 'total_count')[:10]
		for event in pevents:
			event['time'] = event['time'].isoformat()
			info = {}
			info['id'] = event['id']
			info['name'] = event['name']
			info['time'] = event['time']
			info['place'] = event['place']	
			info['category'] = event['category__name']
			info['type'] = 0
			res.append(info)
		return JsonResponse({'results': res})
	else:
		searchString= searchString.lower()
		events = Event.objects.all()
		for event in events:
			eventName = event.name.lower()
			descript = event.description.lower()
			searchField = eventName + descript
			if searchField.find(searchString) >=0:
				info = {}
				info['id'] = event.id
				info['name'] = event.name
				info['time'] = event.time
				info['place'] = event.place
				if event.category:
					info['category'] = event.category.name
				else:
					info['category'] = None
				# type = 0 event
				info['type'] = 0
				res.append(info)
		users = User.objects.all()
		for user in users:
			if user.username != "admin":
				p = Profile.objects.get(user = user)
				names1 = p.nickname.lower()
				names2 = user.username.lower()
				names = names1 + names2
				if names.find(searchString) >=0:
					info = {}
					info['id'] = user.id
					info['username'] = user.username
					info['nickname'] = p.nickname
					info['email'] = p.email
					info['gender'] = p.gender
					if p.photo:
						info['photo'] = p.photo.url
					else:
						info['photo'] = None
					info['rating'] = Rating.objects.filter(ratee = user).aggregate(Avg('score'))['score__avg']
					# type = 1 user
					info['type'] = 1
					res.append(info)
		return JsonResponse({'results': res})

def viewEventsByCat(request, categoryid):
	res = []
	events = Event.objects.filter(category = categoryid).values('id', 'name', 'time', 'place')
	for e in events:
		info = {}
		info['id'] = e['id']
		info['name'] = e['name']
		info['time'] = e['time']
		info['place'] = e['place']
		res.append(info)
	return JsonResponse({'events': res})

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
		info['id'] = p.id
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
	except Picture.DoesNotExist:
		pid = 1
	filename = str(eventid) + '-' + str(pid) + '.' + uploadedFile.name.split('.')[-1]
	picture = Picture(user = user, event = event, time = datetime.datetime.now())
	picture.image.save(filename, ContentFile(uploadedFile.read()), save = False)
	picture.save()
	return JsonResponse({'success': True})
