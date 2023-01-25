from rest_framework import serializers

from counter.models import BusinessType


class BusinessTypeSerializer(serializers.ModelSerializer):
    class Meta:
        model = BusinessType
        fields = '__all__'
