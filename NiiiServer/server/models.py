from django.db import models
from django.contrib.auth.models import User

# Create your models here.

class Profile(models.Model):
	user = models.OneToOneField(User)
	nickname = models.CharField(max_length = 50, blank = True)
	gender = models.NullBooleanField(blank = True)
	photo = models.ImageField(upload_to = 'photos', null = True, blank = True)
	followings = models.ManyToManyField('self', related_name = 'followers', symmetrical = False, blank = True)

	def __str__(self):
		return self.user.username

class Category(models.Model):
	name = models.CharField(max_length = 50)

	def __str__(self):
		return self.name

class Event(models.Model):
	# basic
	name = models.CharField(max_length = 50)
	organizor = models.ForeignKey(User)
	place = models.CharField(max_length = 50)
	description = models.TextField(max_length = 5000)
	time = models.DateTimeField()
	# relation
	category = models.ForeignKey(Category, null = True, blank = True)
	participants = models.ManyToManyField(User, related_name = 'participations', blank = True)
	favoriters = models.ManyToManyField(User, related_name = 'favorites', blank = True)

	def __str__(self):
		return self.name

class Rating(models.Model):
	rator = models.ForeignKey(User, related_name = '+')
	ratee = models.ForeignKey(User, related_name = '+')
	score = models.IntegerField()

	def __str__(self):
		return '%s->%s@%d' % (self.rator.username, self.ratee.username, self.score)

class Comment(models.Model):
	user = models.ForeignKey(User)
	event = models.ForeignKey(Event)
	content = models.TextField(max_length = 5000)
	time = models.DateTimeField()

	def __str__(self):
		return 'Comment: %s->%s' % (self.user.username, self.event.name)

class Picture(models.Model):
	user = models.ForeignKey(User)
	event = models.ForeignKey(Event)
	image = models.ImageField(upload_to = 'album')
	time = models.DateTimeField()

	def __str__(self):
		return 'Picture: %s->%s' % (self.user.username, self.event.name)