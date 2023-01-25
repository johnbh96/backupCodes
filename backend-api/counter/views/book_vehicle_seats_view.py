from counter.serializers import response_wih_data, response_with_bad_request
from counter.serializers.book_vehicle_seats_serializer import (
    SubmitVehicleSeatsBooking, VehicleSeatBookingResponse, VehicleSeatBookingRespSerializer,
)
from counter.services.vehicle_service import (
    book_seats,
)
from dj_rest_auth import jwt_auth
from rest_framework import authentication, permissions, viewsets


class BookVehicleSeatsViewSet(viewsets.ViewSet):

    authentication_classes = [authentication.TokenAuthentication, jwt_auth.JWTAuthentication]
    permission_classes = [permissions.AllowAny]

    def submit(self, request):
        serializer = SubmitVehicleSeatsBooking(data=request.data)
        if serializer.is_valid():
            booking = book_seats(
                request.user,
                queue_id=serializer.data['queue'],
                seats=[(seat['row_index'], seat['column_index']) for seat in serializer.data['seats']],
                contact_name=serializer.data['contact_name'],
                contact_number=serializer.data['contact_number'],
                note=serializer.data['note'],
            )
            return response_wih_data(
                serializer=VehicleSeatBookingRespSerializer(
                    VehicleSeatBookingResponse(id_=booking.id),
                ),
            )
        return response_with_bad_request(serializer=serializer)


book_vehicle_seats = BookVehicleSeatsViewSet.as_view({
    'post': 'submit',
})
