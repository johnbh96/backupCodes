from counter.models.booking import Booking, VehicleBooking
from counter.models.choices import BookingStatus
from counter.models.resource_types import ResourceSeat, ResourceSeatTemplate
from counter.models.vehicle import VehicleQueue, Business, VehicleSeatRate
from counter.serializers.vehicle_queue_serializer import (
    VehicleQueueOut, VehicleQueueRouteOut, VehicleQueueStopOut, VehicleQueueBusinessOut, VehicleQueueSeatOut
)
from datetime import timedelta
from django.contrib.auth.models import User
from django.db import DatabaseError, transaction
from django.db.models import QuerySet
from django.utils import timezone
from typing import Dict, List, Tuple


def search_vehicles_in_queue(
        route_id: int,
        from_time: timezone.datetime,
        skip: int = 0,
        count: int = 10,
        cursor: timezone.datetime = timezone.now(),
) -> Tuple[List[VehicleQueueBusinessOut], timezone.datetime]:
    timezone.now() + timedelta(days=3)
    cursor = cursor or timezone.now()
    vehicle_queues = VehicleQueue.objects.filter(
        rate__route__id=route_id,
        time__gte=from_time,
        time__lte=from_time.replace(hour=23, minute=59, second=59, microsecond=999),
        is_active=True,
        created_at__lte=cursor,
    )
    businesses_in_queue = Business.objects.filter(
        id__in=[q.vehicle.business.id for q in vehicle_queues]
    ).distinct()[skip:count]

    results: List[VehicleQueueBusinessOut] = []
    vehicle_seats: Dict[str, QuerySet[ResourceSeat]] = {}
    for business_in_queue in businesses_in_queue:
        business_vehicle_queues = vehicle_queues.filter(
            rate__business__id=business_in_queue.id,
        )
        queues: List[VehicleQueueOut] = []
        for business_vehicle_queue in business_vehicle_queues:

            seat_template = ResourceSeatTemplate.objects\
                .filter(resource_type=business_vehicle_queue.vehicle.resource_type)\
                .first()

            # fetch only if not cached
            if vehicle_seats.get(seat_template.id) is None:
                vehicle_seats[seat_template.id] = ResourceSeat.objects.filter(seat_template=seat_template)

            booked_seats = VehicleBooking.objects.filter(queue=business_vehicle_queue).values('id')

            seats_out: List[VehicleQueueSeatOut] = []
            for vehicle_seat in vehicle_seats[seat_template.id]:
                seats_out.append(
                    VehicleQueueSeatOut(
                        id_=vehicle_seat.id,
                        row_index=vehicle_seat.row_index,
                        column_index=vehicle_seat.column_index,
                        is_hidden=vehicle_seat.is_hidden,
                        is_disabled=vehicle_seat.is_disabled,
                        # check if booked
                        is_available={'id': vehicle_seat.id} in booked_seats,
                    )
                )

            queues.append(
                VehicleQueueOut(
                    id_=business_vehicle_queue.id,
                    number=business_vehicle_queue.vehicle.name,
                    route=VehicleQueueRouteOut(
                        id_=business_vehicle_queue.rate.route.id,
                        price=business_vehicle_queue.rate.price,
                        start_point=VehicleQueueStopOut(
                            id_=business_vehicle_queue.rate.route.start_point.id,
                            name=business_vehicle_queue.rate.route.start_point.name,
                            address=business_vehicle_queue.rate.route.start_point.address,
                        ),
                        end_point=VehicleQueueStopOut(
                            id_=business_vehicle_queue.rate.route.end_point.id,
                            name=business_vehicle_queue.rate.route.end_point.name,
                            address=business_vehicle_queue.rate.route.end_point.address,
                        ),
                        estimated_duration=timedelta(
                            hours=business_vehicle_queue.rate.estimated_duration.seconds,
                        ),
                    ),
                    seats=seats_out,
                ),
            )
        results.append(
            VehicleQueueBusinessOut(
                id_=business_in_queue.id,
                name=business_in_queue.name,
                queues=queues,
            ),
        )

    return results, cursor


def book_seats(
        user: User,
        queue_id: int,
        seats: List[Tuple[int, int]],
        contact_name: str,
        contact_number: str,
        note: str,
) -> Booking:
    queue = VehicleQueue.objects.filter(id=queue_id).first()
    vehicle_seat_template = ResourceSeatTemplate.objects.filter(
        resource_type__id=queue.vehicle.resource_type.id,
    ).first()
    vehicle_seats = ResourceSeat.objects.filter(
        seat_template__id=vehicle_seat_template.id,
    )
    existing_bookings = VehicleBooking.objects.filter(
        queue=queue,
    )

    available_seats = [
        (seat.row_index, seat.column_index) for seat in vehicle_seats
        if not seat.is_hidden and not seat.is_disabled
    ]
    booked_seats = [
        (seat.row_index, seat.column_index) for seat in existing_bookings
    ]

    seat_rates = VehicleSeatRate.objects.filter(
        route_rate=queue.rate,
    )

    default_price = queue.rate.price
    custom_prices = [
        seat_rate.rate for seat_rate in seat_rates
        if (seat_rate.row_index, seat_rate.column_index) in seats
    ]
    booking_cost = sum(custom_prices) + (len(seats) - len(custom_prices)) * default_price
    booking = Booking(
        user=user,
        resource=queue.vehicle,
        status=BookingStatus.Pending,
        starting_from=queue.time,
        ending_to=queue.time + queue.rate.estimated_duration,
        charged_amount=booking_cost,
        contact_name=contact_name,
        contact_number=contact_number,
        note=note,
    )

    try:
        with transaction.atomic():
            booking.save()
            for seat in seats:

                if not (seat in available_seats):
                    raise ValueError('Seat is not available for booking')

                if seat in booked_seats:
                    raise ValueError('Seat is already booked')

                row_index, column_index = seat
                vehicle_booking = VehicleBooking(
                    booking=booking,
                    queue=queue,
                    row_index=row_index,
                    column_index=column_index,
                    is_disabled=False,
                )
                vehicle_booking.save()

            return booking
    except DatabaseError:
        # TODO(suren): log
        raise Exception('Failed to complete booking')
