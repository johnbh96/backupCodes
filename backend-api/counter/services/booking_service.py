from counter.models.booking import Booking, VehicleBooking
from counter.serializers.booking_serializer import VehicleSeatBookingOut
from counter.serializers.error_serializer import RequestFailed, ResourceNotFound, AccessNotAllowed
from django.contrib.auth.models import User
from typing import Optional, Union, List, Tuple


def get_booking_detail(user: User, booking_id: int) -> Union[RequestFailed, VehicleSeatBookingOut]:
    booking = Booking.objects.filter(id=booking_id).first()
    if booking is None:
        return ResourceNotFound(message="Booking not found")
    if booking.user != user:
        if not user.is_staff:
            return AccessNotAllowed(message="Not allowed")
    vehicle_seat_bookings = VehicleBooking.objects.filter(booking=booking)
    seats: List[Tuple[int, int]] = list(
        map(
            lambda vsb: (vsb.row_index, vsb.column_index),
            vehicle_seat_bookings,
        )
    )
    return VehicleSeatBookingOut(
        booking=booking,
        queue=vehicle_seat_bookings.first().queue,
        seats=seats,
    )
