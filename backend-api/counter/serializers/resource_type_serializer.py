from rest_framework import serializers

from counter.models import ResourceType


class BusinessTypeMinSerializer(serializers.ModelSerializer):
    class Meta:
        model = ResourceType
        fields = ['id', 'name', 'description']


class BusinessTypeSerializer(serializers.ModelSerializer):
    class Meta:
        model = ResourceType
        fields = '__all__'
