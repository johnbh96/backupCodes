from counter.services.booking_service import get_booking_detail, RequestFailed
from counter.serializers import response_wih_data, response_with_failure
from counter.serializers.booking_serializer import (
    VehicleSeatBookingSerializer,
)
from dj_rest_auth import jwt_auth
from rest_framework import authentication, permissions, viewsets


class BookingViewSet(viewsets.ViewSet):

    authentication_classes = []
    permission_classes = [permissions.AllowAny]

    def details(self, request, pk=None):
        result = get_booking_detail(user=request.user, booking_id=pk)
        if isinstance(result, RequestFailed):
            return response_with_failure(
                reason=result
            )
        return response_wih_data(
            serializer=VehicleSeatBookingSerializer(
                result,
            ),
        )


booking_details = BookingViewSet.as_view({
    'get': 'details',
})
