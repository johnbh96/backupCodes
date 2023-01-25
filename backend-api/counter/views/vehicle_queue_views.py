from counter.serializers import response_wih_data, response_with_bad_request
from counter.serializers.vehicle_queue_serializer import (
    VehicleQueueSearchSerializer, VehicleQueueSearchResult, VehicleQueueSearchResultSerializer
)
from counter.services.vehicle_service import search_vehicles_in_queue
from dj_rest_auth import jwt_auth
from django.utils import dateparse
from rest_framework import authentication, permissions, viewsets


class VehicleQueueViewSet(viewsets.ViewSet):

    authentication_classes = [authentication.TokenAuthentication, jwt_auth.JWTAuthentication]
    permission_classes = [permissions.AllowAny]

    def search(self, request):
        serializer = VehicleQueueSearchSerializer(data=request.query_params)
        if serializer.is_valid():
            businesses, from_time = search_vehicles_in_queue(
                serializer.data['route'],
                dateparse.parse_datetime(serializer.data['from_time']),
                serializer.data['skip'],
                serializer.data['count'],
                serializer.data.get('cursor'),
            )
            return response_wih_data(
                serializer=VehicleQueueSearchResultSerializer(
                    VehicleQueueSearchResult(
                        from_time=from_time,
                        businesses=businesses,
                    ),
                ),
            )
        return response_with_bad_request(
            serializer=serializer,
        )


search_vehicle_queue = VehicleQueueViewSet.as_view({
    'get': 'search',
})
