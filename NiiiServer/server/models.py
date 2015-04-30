from django.db import models
from django.contrib.auth.models import User

# Create your models here.

class Profile(models.Model):
	user = models.OneToOneField(User)
	nickname = models.CharField(max_length = 50)
	gender = models.NullBooleanField(blank = True)
	photo = models.ImageField(upload_to = 'photos', null = True, blank = True)
	followings = models.ManyToManyField('self', related_name = 'followers', symmetrical = False, blank = True)

class Category(models.Model):
	name = models.CharField(max_length = 50)

class Event(models.Model):
	# basic
	name = models.CharField(max_length = 50)
	organizor = models.ForeignKey(Profile)
	place = models.CharField(max_length = 50)
	description = models.TextField(max_length = 5000)
	time = models.DateTimeField()
	# relation
	category = models.ForeignKey(Category, null = True, blank = True)
	participants = models.ManyToManyField(User, related_name = 'participations', blank = True)
	favoriters = models.ManyToManyField(User, related_name = 'favorites', blank = True)

class Rating(models.Model):
	person = models.ForeignKey(User)
	event = models.ForeignKey(Event)
	score = models.IntegerField()

class Comment(models.Model):
	user = models.ForeignKey(User)
	content = models.TextField(max_length = 5000)
	time = models.DateTimeField()

class Picture(models.Model):
	user = models.ForeignKey(User)
	event = models.ForeignKey(Event)
	image = models.ImageField(upload_to = 'album')