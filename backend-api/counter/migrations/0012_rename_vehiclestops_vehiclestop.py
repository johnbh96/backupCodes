# Generated by Django 3.2 on 2022-03-27 08:43

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('counter', '0011_remove_vehicleroute_business'),
    ]

    operations = [
        migrations.RenameModel(
            old_name='VehicleStops',
            new_name='VehicleStop',
        ),
    ]