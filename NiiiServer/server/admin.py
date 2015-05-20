from django.contrib import admin

from server.models import Profile, Category, Event, Rating, Comment, Picture

# Register your models here.
@admin.register(Profile)
class ProfileAdmin(admin.ModelAdmin):
	pass

@admin.register(Category)
class CategoryAdmin(admin.ModelAdmin):
	pass

@admin.register(Event)
class EventAdmin(admin.ModelAdmin):
	pass

@admin.register(Rating)
class RatingAdmin(admin.ModelAdmin):
	pass

@admin.register(Comment)
class CommentAdmin(admin.ModelAdmin):
	pass

@admin.register(Picture)
class PictureAdmin(admin.ModelAdmin):
	pass
