# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('server', '0001_initial'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='profile',
            name='friends',
        ),
        migrations.AddField(
            model_name='profile',
            name='followings',
            field=models.ManyToManyField(related_name='followers', to='server.Profile', blank=True),
        ),
    ]
