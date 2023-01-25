from warnings import filters
from django.forms import IntegerField
from rest_framework.permissions import AllowAny
from counter.models.vehicle import VehicleRoute
from counter.serializers.vehicle_serializer import VehicleRouteSerializer
from rest_framework import generics
from django_filters import FilterSet,CharFilter,NumberFilter
from rest_framework.pagination import PageNumberPagination

class RoutePagination(PageNumberPagination):
    page_size = 4
    page_query_param = 'p'
    page_size_query_param = 'datasize'
    


class VehicleRouteFilterFileView(FilterSet):
    start_point = CharFilter(field_name='start_point__name',lookup_expr=('icontains'),label='From')
    skiprow = NumberFilter(field_name='id',lookup_expr=('gt'),label='first row numbers to ignore')
    class Meta:
        model = VehicleRoute
        fields = [
            'start_point',
            'skiprow'
        ]


class RouteSearchFile_view(generics.ListAPIView):
    permission_classes = [AllowAny]
    queryset = VehicleRoute.objects.all()
    serializer_class = VehicleRouteSerializer
    filter_class = VehicleRouteFilterFileView
    pagination_class = RoutePagination