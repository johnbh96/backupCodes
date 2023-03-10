# Generated by Django 3.2 on 2022-04-17 04:05

import datetime
import django.core.validators
from django.db import migrations, models
from django.utils.timezone import utc


class Migration(migrations.Migration):

    dependencies = [
        ('counter', '0014_auto_20220412_0424'),
    ]

    operations = [
        migrations.AlterField(
            model_name='vehiclequeue',
            name='created_at',
            field=models.DateTimeField(default=datetime.datetime(2022, 4, 17, 4, 5, 45, 934612, tzinfo=utc)),
        ),
        migrations.AlterField(
            model_name='vehiclerouteratetemplate',
            name='column_number',
            field=models.IntegerField(validators=[django.core.validators.MinValueValidator(0)]),
        ),
        migrations.AlterField(
            model_name='vehiclerouteratetemplate',
            name='row_number',
            field=models.IntegerField(validators=[django.core.validators.MinValueValidator(0)]),
        ),
        migrations.AlterUniqueTogether(
            name='vehiclerouteratetemplate',
            unique_together={('business', 'route', 'resource_type', 'row_number', 'column_number')},
        ),
    ]
