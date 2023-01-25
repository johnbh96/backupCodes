from rest_framework import serializers
from counter.models import VehicleRoute, BusinessResource
from counter.models.vehicle import VehicleStop, VehicleQueue , VehicleRouteRateTemplate
from counter.serializers.business_serializer import BusinessMinSerializer
from counter.serializers.resource_type_serializer import BusinessTypeMinSerializer


class VehicleStopSerializer(serializers.ModelSerializer):
    class Meta:
        model = VehicleStop
        # it can impact on stops serializers and route serializers can be tested by using "__all__"
        fields = ['name']

    def validate_name(self, data):
        return data.lower() 


class VehicleRouteSerializer(serializers.ModelSerializer):
    id = serializers.IntegerField()
    start_point = serializers.SerializerMethodField()
    end_point = serializers.SerializerMethodField()

    class Meta:
        model = VehicleRoute
        fields = ['id', 'start_point','end_point']
        
    def get_start_point(self, obj):
        return VehicleStopSerializer(obj.start_point).data

    def get_end_point(self, obj):
        return VehicleStopSerializer(obj.end_point).data  

    def validate(self,values):
        sp=values.post('start_point')
        ep=values.post('end_point')       # sp=values['start_point']  same
        if sp == ep:
            raise serializers.ValidationError("start point and end point are match")
        return values    


class VehicleAsResourceSerializer(serializers.ModelSerializer):
    business = serializers.SerializerMethodField()
    resource_type = serializers.SerializerMethodField()

    class Meta:
        model = BusinessResource
        fields = ['name', 'business', 'resource_type']
        depth = 1

    def get_business(self, obj):
        return BusinessMinSerializer(obj.business).data

    def get_resource_type(self, obj):
        return BusinessTypeMinSerializer(obj.resource_type).data


class VehicleRouteSearchSerializer(serializers.ModelSerializer):
    start_point = serializers.SerializerMethodField()
    end_point = serializers.SerializerMethodField()

    class Meta:
        model = VehicleRoute
        fields = ['start_point', 'end_point']
        
    def get_start_point(self, obj):
        return VehicleStopSerializer(obj.start_point).data

    def get_end_point(self, obj):
        return VehicleStopSerializer(obj.end_point).data    


class VehicleTimetableSerializer(serializers.ModelSerializer):
    
    route = serializers.SerializerMethodField()
    resource = serializers.SerializerMethodField()

    class Meta:
        model = VehicleQueue
        fields = [
            'id',
            'resource',
            'route',
            'departure_time',
        ]

    def get_resource(self, obj):
        return VehicleAsResourceSerializer(obj.vehicle).data

    def get_route(self, obj):
        return VehicleRouteSearchSerializer(obj.route).data    


class VehicleRouteRateTemplateSerializer(serializers.ModelSerializer):
    business = serializers.SerializerMethodField()
    route = serializers.SerializerMethodField()
    resource_type = serializers.SerializerMethodField()

    class Meta:
        model = VehicleRouteRateTemplate
        fields = [
            'id',
            'business',
            'route',
            'resource_type',
            'row_number',
            'column_number',
            'rate',
            'is_disabled',
        ]

    def get_route(self, obj):
        return VehicleRouteSearchSerializer(obj.route).data

    def get_business(self, obj):
        return BusinessMinSerializer(obj.business).data

    def get_resource_type(self, obj):
        return BusinessTypeMinSerializer(obj.resource_type).data 