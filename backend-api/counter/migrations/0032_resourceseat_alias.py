# Generated by Django 3.2 on 2022-07-30 09:49

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('counter', '0031_auto_20220730_0931'),
    ]

    operations = [
        migrations.AddField(
            model_name='resourceseat',
            name='alias',
            field=models.CharField(default='default', max_length=80),
            preserve_default=False,
        ),
    ]
