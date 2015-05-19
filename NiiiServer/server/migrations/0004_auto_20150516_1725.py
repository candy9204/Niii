# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('server', '0003_auto_20150430_1100'),
    ]

    operations = [
        migrations.AddField(
            model_name='comment',
            name='event',
            field=models.ForeignKey(default=None, to='server.Event'),
            preserve_default=False,
        ),
        migrations.AddField(
            model_name='picture',
            name='time',
            field=models.DateTimeField(default=None),
            preserve_default=False,
        ),
    ]
