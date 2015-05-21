from __future__ import division
from django.shortcuts import render
from django.contrib.auth import authenticate
from django.contrib.auth.models import User
from django.http import JsonResponse
from django.core.files.base import ContentFile
from django.forms.models import model_to_dict
from django.core import serializers
from django.db.models import Avg

from server.models import Profile, Rating

# Create your views here.
def login(request):
	# POST for auth
	res = {}
	try:
		username = request.POST['username']
		password = request.POST['password']
	except:
		res['success'] = False
		res['message'] = 'Invalid Request'
	if username and password:
		user = authenticate(username = username, password = password)
		if user is not None:
			if not user.is_active:
				res['success'] = False
				res['message'] = 'Inactive User'
			else:
				res['success'] = True
				res['id'] = user.pk
		else:
			res['success'] = False
			res['message'] = 'Incorrect username or password'
	return JsonResponse(res)

def register(request):
	# POST for reg
	res = {}
	try:
		username = request.POST['username']
		password = request.POST['password']
	except:
		res['success'] = False
		res['message'] = 'Invalid Request'
	if username and password:
		existingUser = User.objects.filter(username = username)
		if len(existingUser) > 0:
			res['success'] = False
			res['message'] = 'Username Exists'
		else:
			# create user
			user = User.objects.create_user(username = username, password = password)
			user.save()
			# create profile
			profile = Profile(user = user, nickname = '')
			profile.save()
			res['success'] = True
			res['id'] = user.pk
			res['username'] = user.username
	return JsonResponse(res)

def viewProfile(request, userid):
	res = {}
	user = User.objects.get(id = userid)
	profile = Profile.objects.get(user = user)
	res['username'] = user.username
	res.update(model_to_dict(profile, fields = ['nickname', 'email', 'gender']))
	try:
		res['photo'] = profile.photo.url
	except:
		res['photo'] = None
	res['followings'] = profile.followings.count()
	res['followers'] = profile.followers.count()
	res['email'] = profile.email
	res['rating'] = Rating.objects.filter(ratee = user).aggregate(Avg('score'))['score__avg']
	return JsonResponse(res)

def updateProfile(request, userid):
	# POST for update
	res = {}
	user = User.objects.get(id = userid)
	profile = Profile.objects.get(user = user)
	if request.POST.get('nickname', None):
		profile.nickname = request.POST['nickname']
	if request.POST.get('email', None):
		profile.email = request.POST['email']
	if request.POST.get('gender', None):
		profile.gender = True if request.POST['gender'] == 'male' else False
	if request.FILES.get('photo', None):
		uploadedFile = request.FILES['photo']
		filename = str(userid) + '.' + uploadedFile.name.split('.')[-1]
		profile.photo.save(filename, ContentFile(uploadedFile.read()), save = False)
	profile.save()
	return JsonResponse({'success': True})

def viewFollowings(request, userid):
	user = User.objects.get(id = userid)
	followings = Profile.objects.get(user = user).followings.all()
	res = []
	for f in list(followings):
		info = {}
		info['id'] = f.user.id
		info['username'] = f.user.username
		info['nickname'] = f.nickname
		try:
			info['photo'] = f.photo.url
		except:
			info['photo'] = None
		info['email'] = f.email
		info['gender'] = f.gender
		info['rating'] = Rating.objects.filter(ratee = f.user).aggregate(Avg('score'))['score__avg']
		res.append(info)
	return JsonResponse({'followings': res})

def addFollowings(request, userid):
	# GET for following
	try:
		following_id = request.GET['following_id']
	except:
		res = {'success': False, 'message': 'Invalid Request'}
		return JsonResponse(res)
	user = User.objects.get(id = userid)
	try:
		following = Profile.objects.get(user = User.objects.get(id = following_id))
		Profile.objects.get(user = user).followings.add(following)
	except:
		res = {'success': False, 'message': 'Invalid following_id'}
		return JsonResponse(res)
	return JsonResponse({'success': True})

def removeFollowings(request, userid):
	# GET for following
	try:
		following_id = request.GET['following_id']
	except:
		res = {'success': False, 'message': 'Invalid Request'}
		return JsonResponse(res)
	user = User.objects.get(id = userid)
	try:
		following = Profile.objects.get(user = User.objects.get(id = following_id))
		Profile.objects.get(user = user).followings.remove(following)
	except:
		res = {'success': False, 'message': 'Invalid following_id or following relation'}
		return JsonResponse(res)
	return JsonResponse({'success': True})

def viewFollowers(request, userid):
	user = User.objects.get(id = userid)
	followers = Profile.objects.get(user = user).followers.all()
	res = []
	for f in list(followers):
		info = {}
		info['id'] = f.user.id
		info['username'] = f.user.username
		info['nickname'] = f.nickname
		try:
			info['photo'] = f.photo.url
		except:
			info['photo'] = None
		info['email'] = f.email
		info['gender'] = f.gender
		info['rating'] = Rating.objects.filter(ratee = f.user).aggregate(Avg('score'))['score__avg']
		res.append(info)
	return JsonResponse({'followers': res})

def viewParticipations(request, userid):
	participations = User.objects.select_related('profile').get(id = userid).participations.values('id', 'name')
	return JsonResponse({'participations': list(participations)})

def viewFavorites(request, userid):
	favorites = User.objects.select_related('profile').get(id = userid).favorites.values('id', 'name')
	return JsonResponse({'favorites': list(favorites)})

def rate(request, userid):
	# POST for rateing
	try:
		ratee_id = request.POST['ratee_id']
		score = int(request.POST['score'])
	except:
		res = {'success': False, 'message': 'Invalid Request'}
		return JsonResponse(res)
	rator = User.objects.get(id = userid)
	try:
		ratee = User.objects.get(id = ratee_id)
		rating = Rating(rator = rator, ratee = ratee, score = score)
		rating.save()
	except:
		res = {'success': False, 'message': 'Invalid ratee_id or score'}
		return JsonResponse(res)
	return JsonResponse({'success': True})

def recommend(request, userid):
	participated = {}
	recommendations = []
	res = []
	currentUser = User.objects.get(id = userid)
	users = User.objects.all()
	list1 = currentUser.participations.all()
	for user in users:
		list2 = user.participations.all()
		if user != currentUser: 
			intersectCount = len(set(list1) & set(list2))
			countOfUser2 = len(list2)
			if countOfUser2 != 0:
				sim = intersectCount/countOfUser2
			else:
				sim = 0
			if sim >= 0.5:
				recommendations.extend(list(set(list2) - set(list1)))
	for r in recommendations:
		info = {}
		info['id'] = r.id
		info['name'] = r.name
		info['time'] = r.time
		info['place'] = r.place
		try:
			info['category'] = r.category.name
		except:
			info['category'] = None
		res.append(info)
	return JsonResponse({'recommendations': res})
	