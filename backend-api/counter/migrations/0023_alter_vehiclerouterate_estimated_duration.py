# Generated by Django 3.2 on 2022-04-25 03:26

import datetime
from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('counter', '0022_alter_vehiclerouterate_estimated_duration'),
    ]

    operations = [
        migrations.AlterField(
            model_name='vehiclerouterate',
            name='estimated_duration',
            field=models.DurationField(default=datetime.timedelta(seconds=7200), null=True),
        ),
    ]
