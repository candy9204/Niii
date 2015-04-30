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
	res['followings'] = profile.followings.count()
	res['followers'] = profile.followers.count()
	res['rating'] = Rating.objects.filter(ratee = user).aggregate(Avg('score'))['score__avg']
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

def viewFollowings(request, userid):
	user = User.objects.get(id = userid)
	followings = Profile.objects.get(user = user).followings.values('user__id', 'user__username', 'user__profile__nickname', 'photo')
	res = []
	for f in list(followings):
		info = {}
		info['id'] = f['user__id']
		info['username'] = f['user__username']
		info['nickname'] = f['user__profile__nickname']
		try:
			info['photo'] = f['photo'].url
		except:
			info['photo'] = None
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
	followers = Profile.objects.get(user = user).followers.values('user__id', 'user__username', 'user__profile__nickname', 'photo')
	res = []
	for f in list(followers):
		info = {}
		info['id'] = f['user__id']
		info['username'] = f['user__username']
		info['nickname'] = f['user__profile__nickname']
		try:
			info['photo'] = f['photo'].url
		except:
			info['photo'] = None
		res.append(info)
	return JsonResponse({'followers': res})

def viewParticipations(request, userid):
	participations = User.objects.select_related('participations').get(id = userid).participations.values('id', 'name')
	return JsonResponse({'participations': list(participations)})

def viewFavorites(request, userid):
	favorites = User.objects.select_related('favorites').get(id = userid).favorites.values('id', 'name')
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
	