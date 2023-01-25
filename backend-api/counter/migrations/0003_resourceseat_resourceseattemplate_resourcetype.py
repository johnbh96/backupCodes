# Generated by Django 3.2 on 2022-01-15 11:01

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('counter', '0002_businesstype'),
    ]

    operations = [
        migrations.CreateModel(
            name='ResourceType',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('name', models.CharField(max_length=80)),
                ('description', models.CharField(max_length=240)),
                ('group_type', models.CharField(choices=[('LetterFirst', 'Letter First'), ('DigitFirst', 'Digit First'), ('Individual', 'Individual')], default='LetterFirst', max_length=80)),
                ('capacity_type', models.CharField(choices=[('FixedDefault', 'Fixed Default'), ('UserEditable', 'User Editable'), ('SeatTemplate', 'Seat Template')], default='FixedDefault', max_length=80)),
                ('default_capacity', models.IntegerField(null=True)),
                ('duration_type', models.CharField(choices=[('InHours', 'In Hours'), ('InDays', 'In Days'), ('TimeTabled', 'Time Tabled')], default='InHours', max_length=80)),
                ('label_singular', models.CharField(max_length=100)),
                ('label_plural', models.CharField(max_length=120)),
            ],
        ),
        migrations.CreateModel(
            name='ResourceSeatTemplate',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('name', models.CharField(max_length=6)),
                ('row_count', models.IntegerField()),
                ('column_count', models.IntegerField()),
                ('resource_type', models.ForeignKey(on_delete=django.db.models.deletion.PROTECT, to='counter.resourcetype')),
            ],
        ),
        migrations.CreateModel(
            name='ResourceSeat',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('row_index', models.IntegerField()),
                ('column_index', models.IntegerField()),
                ('is_hidden', models.BooleanField()),
                ('is_disabled', models.BooleanField()),
                ('seat_template', models.ForeignKey(on_delete=django.db.models.deletion.PROTECT, to='counter.resourceseattemplate')),
            ],
        ),
    ]