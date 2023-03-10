# Generated by Django 3.2 on 2022-04-24 16:54

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('counter', '0019_vehicleseatrate'),
    ]

    operations = [
        migrations.RenameField(
            model_name='vehiclerouterate',
            old_name='rate',
            new_name='price',
        ),
        migrations.AddField(
            model_name='vehiclequeue',
            name='rate',
            field=models.ForeignKey(default=460, on_delete=django.db.models.deletion.PROTECT, to='counter.vehiclerouterate'),
            preserve_default=False,
        ),
        migrations.AddField(
            model_name='vehiclerouterate',
            name='estimated_duration',
            field=models.TimeField(null=True),
        ),
    ]
