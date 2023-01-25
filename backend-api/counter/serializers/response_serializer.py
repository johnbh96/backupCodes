from django.http import JsonResponse
from rest_framework import serializers
from counter.models import ResourceSeat, ResourceSeatTemplate


class BusinessTypeSerializer(serializers.Serializer):
    id = serializers.IntegerField(read_only=True)
    name = serializers.CharField(read_only=True)
    label_singular = serializers.CharField(read_only=True)
    label_plural = serializers.CharField(read_only=True)
    description = serializers.CharField(read_only=True)


class ResourceOptionSerializer(serializers.Serializer):
    id = serializers.IntegerField(read_only=True)
    name = serializers.CharField(read_only=True)
    description = serializers.CharField(read_only=True)
    group_type = serializers.CharField(read_only=True)
    capacity_type = serializers.CharField(read_only=True)
    default_capacity = serializers.IntegerField(read_only=True)
    duration_type = serializers.CharField(read_only=True)
    label_singular = serializers.CharField(read_only=True)
    label_plural = serializers.CharField(read_only=True)


class ResourceSeatSerializer(serializers.ModelSerializer):
    class Meta:
        model = ResourceSeat
        fields = ['id', 'row_index', 'column_index', 'is_hidden', 'is_disabled']


class ResourceSeatTemplateSerializer(serializers.ModelSerializer):
    seats = ResourceSeatSerializer(many=True, read_only=True)

    class Meta:
        model = ResourceSeatTemplate
        fields = ['id', 'name', 'row_count', 'column_count', 'seats']
