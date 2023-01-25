from rest_framework import generics
from rest_framework.permissions import AllowAny
from rest_framework.response import Response
from rest_framework.views import APIView
from counter.models.vehicle import (
    VehicleRoute, VehicleStop, VehicleQueue, VehicleRouteRateTemplate
)
from counter.serializers.vehicle_serializer import (
    VehicleRouteSerializer, VehicleStopSerializer, VehicleTimetableSerializer, VehicleRouteRateTemplateSerializer,
)
from django_filters import (
    FilterSet, DateTimeFilter, CharFilter,
)


class VehicleRouteFilter(FilterSet):
    start_point = CharFilter(field_name='start_point__name', lookup_expr='icontains')

    class Meta:
        model = VehicleRoute
        fields = [
            'start_point',
        ]


class RouteSearch(generics.ListAPIView):
    permission_classes = [AllowAny]
    queryset = VehicleRoute.objects.all()
    serializer_class = VehicleRouteSerializer
    filter_class = VehicleRouteFilter


class VehicleListAPIView(APIView):
    permission_classes = [AllowAny]

    def get(self, request):
        vehicle_route_model = VehicleRoute.objects.all()
        vehicle_route_serializer = VehicleRouteSerializer(vehicle_route_model, many=True)
        return Response(vehicle_route_serializer.data)


class EndPointListAPIView(APIView):
    permission_classes = [AllowAny]

    def get(self, request):
        vehicle_stop_model = VehicleStop.objects.all()
        vehicle_stop_serializer = VehicleStopSerializer(vehicle_stop_model, many=True)
        return Response(vehicle_stop_serializer.data)


class ListVehicleTimetableAPIView(APIView):
    permission_classes = [AllowAny]

    def get(self, request):
        vehicle_schedule_model = VehicleQueue.objects.all()
        vehicle_schedule_serializer = VehicleTimetableSerializer(vehicle_schedule_model, many=True)
        return Response(vehicle_schedule_serializer.data)


class VehicleTableFilter(FilterSet):
    departure = DateTimeFilter(field_name="departure_time", lookup_expr='gte')
    route = CharFilter(field_name='route__start_point__name', lookup_expr='icontains')

    class Meta:
        model = VehicleQueue
        fields = [
            'route',
            'departure',
        ]


class VehicleScheduleSearch(generics.ListAPIView):
    permission_classes = [AllowAny]
    queryset = VehicleQueue.objects.all()
    serializer_class = VehicleTimetableSerializer
    filter_class = VehicleTableFilter


class VehicleRouteRateTemplateAPIView(APIView):
    permission_classes = [AllowAny]

    def get(self, request):
        rate_template_model = VehicleRouteRateTemplate.objects.all()
        vehicle_rate_template_serializer = VehicleRouteRateTemplateSerializer(rate_template_model,many=True)
        return Response(vehicle_rate_template_serializer.data)
