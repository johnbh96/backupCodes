from rest_framework import serializers

from counter.models import Business, BusinessType, ResourceType, BusinessResourceOption


class BusinessRequestSerializer(serializers.Serializer):
    name = serializers.CharField(required=True, max_length=320)
    business_type_name = serializers.CharField(required=True)
    resource_type_name = serializers.CharField(required=True)
    address = serializers.CharField(required=True, max_length=500)

    def is_valid_business_type_name(self, business_type_name: str):
        return BusinessType.objects.filter(name=business_type_name).exists()

    def is_valid_resource_type_name(self, resource_type_name: str):
        return ResourceType.objects.filter(name=resource_type_name).exists()

    def validate_business_type_name(self, value):
        is_valid_business_type_name = self.is_valid_business_type_name(value)
        if not is_valid_business_type_name:
            raise serializers.ValidationError('Invalid business type name')
        return value

    def validate_resource_type_name(self, value):
        is_valid_resource_type_name = self.is_valid_resource_type_name(value)
        if not is_valid_resource_type_name:
            raise serializers.ValidationError('Invalid resource type name')
        return value

    def validate(self, data):
        is_valid_resource_type_id = BusinessResourceOption.objects.filter(
            business_type__name=data['business_type_name'],
            resource_type__name=data['resource_type_name'],
        )
        if not is_valid_resource_type_id:
            raise serializers.ValidationError('Invalid resource type selected')
        return data

    def create(self, validated_data):

        requesting_user = validated_data['requesting_user']
        business_type = BusinessType.objects.filter(name=validated_data['business_type_name']).first()
        resource_type = ResourceType.objects.filter(name=validated_data['resource_type_name']).first()

        business = Business(
            name=validated_data['name'],
            owner=requesting_user,
            creator=requesting_user,
            business_type=business_type,
            resource_type=resource_type,
            address=validated_data['address'],
        )
        business.save()
        return business

    def update(self, instance, validated_data):
        instance.name = validated_data.get('email', instance.name)
        instance.address = validated_data.get('address', instance.address)
        instance.save()
        return instance


class BusinessMinSerializer(serializers.ModelSerializer):
    class Meta:
        model = Business
        fields = ['id', 'name', 'address']
        depth = 1


class BusinessSerializer(serializers.ModelSerializer):
    class Meta:
        model = Business
        exclude = ('owner', 'creator',)
        depth = 1
