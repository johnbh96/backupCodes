# Generated by Django 3.2 on 2022-03-27 08:08

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('counter', '0009_auto_20220327_0737'),
    ]

    operations = [
        migrations.CreateModel(
            name='VehicleRoute',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('business', models.ForeignKey(on_delete=django.db.models.deletion.PROTECT, to='counter.business')),
            ],
        ),
        migrations.CreateModel(
            name='VehicleStops',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('name', models.CharField(max_length=120)),
                ('address', models.CharField(max_length=200)),
            ],
        ),
        migrations.CreateModel(
            name='VehicleTimeTable',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('departure_time', models.DateTimeField()),
                ('resource', models.ForeignKey(on_delete=django.db.models.deletion.PROTECT, to='counter.businessresource')),
                ('route', models.ForeignKey(on_delete=django.db.models.deletion.PROTECT, to='counter.vehicleroute')),
            ],
        ),
        migrations.CreateModel(
            name='VehicleRouteRateTemplate',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('row_number', models.IntegerField()),
                ('column_number', models.IntegerField()),
                ('rate', models.IntegerField()),
                ('is_disabled', models.BooleanField(default=True)),
                ('resource_type', models.ForeignKey(on_delete=django.db.models.deletion.PROTECT, to='counter.resourcetype')),
                ('route', models.ForeignKey(on_delete=django.db.models.deletion.PROTECT, to='counter.vehicleroute')),
            ],
        ),
        migrations.AddField(
            model_name='vehicleroute',
            name='end_point',
            field=models.ForeignKey(on_delete=django.db.models.deletion.PROTECT, related_name='end_point', to='counter.vehiclestops'),
        ),
        migrations.AddField(
            model_name='vehicleroute',
            name='start_point',
            field=models.ForeignKey(on_delete=django.db.models.deletion.PROTECT, related_name='start_point', to='counter.vehiclestops'),
        ),
    ]
