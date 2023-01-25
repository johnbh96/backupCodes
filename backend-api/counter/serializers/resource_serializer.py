from rest_framework import serializers

from counter.permissions.user_permission import allowed_to_create_resource
from counter.models import (
    Business, BusinessResource, BusinessResourceOption,
    ResourceType,
)


class CreateResourceSerializer(serializers.Serializer):

    business_id = serializers.IntegerField(required=True)
    resource_type = serializers.CharField(required=True, max_length=80)
    number = serializers.CharField(required=True, max_length=40)

    def is_valid_business_id(self, business_id_value: int):
        business_exists: bool = Business.objects.filter(id=business_id_value).exists()
        return business_exists

    def is_valid_resource_type(self, resource_type_name: str):
        return ResourceType.objects.filter(name=resource_type_name.lower()).exists()

    def validate(self, data):
        _business_id = data['business_id']
        _resource_type = data['resource_type']

        business = Business.objects.filter(id=_business_id).first()

        if business is None:
            raise serializers.ValidationError('Business does not exist')

        is_valid_resource_type = BusinessResourceOption.objects.filter(
            business_type__name=business.business_type.name,
            resource_type__name=_resource_type.lower(),
        ).exists()

        if not is_valid_resource_type:
            raise serializers.ValidationError('Invalid Resource Type')

        return data

    def create(self, validated_data) -> BusinessResource:
        requesting_user = validated_data['requesting_user']

        validated_business_id = validated_data['business_id']
        validated_number = validated_data['number']

        business = Business.objects.filter(id=validated_business_id).first()

        if not allowed_to_create_resource(requesting_user=requesting_user, business=business):
            raise serializers.PermissionDenied('Not allowed to add resource')

        business_resource = BusinessResource(
            business=business,
            name=validated_number,
            resource_type=business.resource_type,
        )
        business_resource.save()
        return business_resource


class BusinessResourceSerializer(serializers.ModelSerializer):

    class Meta:
        model = BusinessResource
        fields = '__all__'
        depth = 1
