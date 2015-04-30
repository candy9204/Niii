# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations
from django.conf import settings


class Migration(migrations.Migration):

    dependencies = [
        migrations.swappable_dependency(settings.AUTH_USER_MODEL),
        ('server', '0002_auto_20150429_2256'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='rating',
            name='event',
        ),
        migrations.RemoveField(
            model_name='rating',
            name='person',
        ),
        migrations.AddField(
            model_name='rating',
            name='ratee',
            field=models.ForeignKey(related_name='+', default=None, to=settings.AUTH_USER_MODEL),
            preserve_default=False,
        ),
        migrations.AddField(
            model_name='rating',
            name='rator',
            field=models.ForeignKey(related_name='+', default=None, to=settings.AUTH_USER_MODEL),
            preserve_default=False,
        ),
        migrations.AlterField(
            model_name='event',
            name='organizor',
            field=models.ForeignKey(to=settings.AUTH_USER_MODEL),
        ),
    ]
