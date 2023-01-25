from counter.models.booking import Booking
from counter.models.business import BusinessResource
from counter.models.vehicle import VehicleQueue
from counter.models.resource_types import ResourceType
from rest_framework import serializers
from typing import List, Tuple


class ResourceTypeOut:

    def __init__(self, resource_type: ResourceType):
        self.id = resource_type.id
        self.name = resource_type.name
        self.description = resource_type.description
        self.group_type = resource_type.group_type
        self.capacity_type = resource_type.capacity_type
        self.default_capacity = resource_type.default_capacity
        self.duration_type = resource_type.duration_type
        self.label_singular = resource_type.label_singular
        self.label_plural = resource_type.label_plural


class ResourceTypeSerializer(serializers.Serializer):
    id = serializers.IntegerField()
    name = serializers.CharField()
    description = serializers.CharField()
    group_type = serializers.CharField()
    capacity_type = serializers.CharField()
    default_capacity = serializers.CharField()
    duration_type = serializers.DateTimeField()
    label_singular = serializers.CharField()
    label_plural = serializers.CharField()


class VehicleOut:

    def __init__(self, business_resource: BusinessResource):
        self.id = business_resource.id
        self.resource_type = business_resource.resource_type
        self.group_letter = business_resource.group_letter
        self.name = business_resource.name
        self.capacity = business_resource.capacity


class VehicleSerializer(serializers.Serializer):
    id = serializers.IntegerField()
    resource_type = ResourceTypeSerializer()
    group_letter = serializers.CharField()
    name = serializers.CharField()
    capacity = serializers.IntegerField()


class BookingOut:

    def __init__(self, booking: Booking):
        self.id = booking.id
        self.status = booking.status
        self.starting_from = booking.starting_from
        self.ending_to = booking.ending_to
        self.charged_amount = booking.charged_amount
        self.contact_name = booking.contact_name
        self.contact_number = booking.contact_number

        # build resource based on resource type
        self.resource = VehicleOut(booking.resource)


class BookingSerializer(serializers.Serializer):
    id = serializers.IntegerField()
    status = serializers.CharField()
    starting_from = serializers.DateTimeField()
    ending_to = serializers.DateTimeField()
    charged_amount = serializers.IntegerField()
    contact_name = serializers.CharField()
    contact_number = serializers.CharField()

    resource = VehicleSerializer()


class VehicleQueueOut:

    def __init__(self, vehicle_queue: VehicleQueue):
        self.id = vehicle_queue.id
        self.time = vehicle_queue.time
        self.is_active = vehicle_queue.is_active


class VehicleQueueSerializer(serializers.Serializer):
    id = serializers.IntegerField()
    time = serializers.DateTimeField()
    is_active = serializers.BooleanField()


class VehicleSeatOut:

    def __init__(self, row_index: int, column_index: int):
        self.row_index = row_index
        self.column_index = column_index


class VehicleSeatSerializer(serializers.Serializer):
    row_index = serializers.IntegerField()
    column_index = serializers.IntegerField()


class VehicleSeatBookingOut(BookingOut):

    def __init__(self, booking: Booking, queue: VehicleQueue, seats: List[Tuple[int, int]]):
        super().__init__(booking)
        self.queue = VehicleQueueOut(vehicle_queue=queue)
        self.seats = []
        for (row_index, column_index) in seats:
            self.seats.append(
                VehicleSeatOut(
                    row_index=row_index,
                    column_index=column_index,
                ),
            )


class VehicleSeatBookingSerializer(BookingSerializer):
    queue = VehicleQueueSerializer()
    seats = VehicleSeatSerializer(many=True)
