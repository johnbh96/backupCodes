# Generated by Django 3.2 on 2022-04-17 04:07

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('counter', '0016_alter_vehiclequeue_created_at'),
    ]

    operations = [
        migrations.AlterField(
            model_name='vehiclequeue',
            name='created_at',
            field=models.DateTimeField(),
        ),
    ]
