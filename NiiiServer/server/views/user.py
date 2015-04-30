from django.shortcuts import render
from django.contrib.auth import authenticate
from django.contrib.auth.models import User
from django.http import JsonResponse
from django.core.files.base import ContentFile
from django.forms.models import model_to_dict
from django.core import serializers

from server.models import Profile

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
			if user.is_active:
				res['success'] = False
				res['message'] = 'Inactive User'
			else:
				res['success'] = True
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
	res.update(model_to_dict(profile, fields = ['nickname', 'gender']))
	try:
		res['photo'] = profile.photo.url
	except:
		res['photo'] = None
	return JsonResponse(res)

def updateProfile(request, userid):
	# POST for update
	res = {}
	user = User.objects.get(id = userid)
	profile = Profile.objects.get(user = user)
	if request.POST.get('nickname', None):
		profile.nickname = request.POST['nickname']
	if request.POST.get('gender', None):
		profile.gender = True if request.POST['gender'] == 'male' else False
	if request.FILES.get('photo', None):
		uploadedFile = request.FILES['photo']
		filename = str(userid) + '.' + uploadedFile.name.split('.')[-1]
		profile.photo.save(filename, ContentFile(uploadedFile.read()), save = False)
	profile.save()
	return JsonResponse({'success': True})

def viewFollowing(request, userid):
	user = User.objects.get(id = userid)
	followings = Profile.objects.get(user = user).followings.values('user__id', 'user__username', 'photo')
	res = list(followings)
	for f in res:
		try:
			f['photo'] = f['photo'].url
		except:
			f['photo'] = None
	return JsonResponse({'followings': res})

def addFollowing(request, userid):
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

def removeFollowing(request, userid):
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

def viewFollower(request, userid):
	user = User.objects.get(id = userid)
	followers = Profile.objects.get(user = user).followers.values('user__id', 'user__username', 'photo')
	res = list(followers)
	for f in res:
		try:
			f['photo'] = f['photo'].url
		except:
			f['photo'] = None
	return JsonResponse({'followers': res})