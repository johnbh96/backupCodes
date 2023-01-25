from counter.models import VehicleRoute
from datetime import datetime, timedelta, time, date
from rest_framework import serializers
from typing import List


class VehicleQueueSeatOut:

    def __init__(
            self,
            id_: int,
            row_index: int,
            column_index: int,
            is_hidden: bool,
            is_disabled: bool,
            is_available: bool,
    ):
        self.id = id_
        self.row_index = row_index
        self.column_index = column_index
        self.is_hidden = is_hidden
        self.is_disabled = is_disabled
        self.is_available = is_available


class VehicleQueueSeatSerializer(serializers.Serializer):
    id = serializers.IntegerField()
    row_index = serializers.IntegerField()
    column_index = serializers.IntegerField()
    is_hidden = serializers.BooleanField()
    is_disabled = serializers.BooleanField()
    is_available = serializers.BooleanField()


class VehicleQueueStopOut:

    def __init__(
            self,
            id_: int,
            name: str,
            address: str,
    ):
        self.id = id_
        self.name = name
        self.address = address


class VehicleQueueStopSerializer(serializers.Serializer):
    name = serializers.CharField()
    address = serializers.CharField()


class VehicleQueueRouteOut:

    def __init__(
            self,
            id_: int,
            price: float,
            start_point: VehicleQueueStopOut,
            end_point: VehicleQueueStopOut,
            estimated_duration: timedelta,
    ):
        self.id = id_
        self.price = price
        self.start_point = start_point
        self.end_point = end_point
        self.estimated_duration = estimated_duration


class VehicleQueueRouteSerializer(serializers.Serializer):
    id = serializers.IntegerField()
    price = serializers.FloatField()
    start_point = VehicleQueueStopSerializer()
    end_point = VehicleQueueStopSerializer()
    estimated_duration = serializers.DurationField()


class VehicleQueueOut:

    def __init__(
            self,
            id_: int,
            number: str,
            route: VehicleQueueRouteOut,
            seats: List[VehicleQueueSeatOut],
    ):
        self.id = id_
        self.number = number
        self.route = route
        self.seats = seats


class VehicleQueueOutSerializer(serializers.Serializer):
    id = serializers.IntegerField()
    number = serializers.CharField()
    route = VehicleQueueRouteSerializer()
    seats = VehicleQueueSeatSerializer(many=True)


class VehicleQueueBusinessOut(serializers.Serializer):

    def __init__(
            self,
            id_: int,
            name: str,
            queues: List[VehicleQueueOut],
    ):
        self.id = id_
        self.name = name
        self.queues = queues


class VehicleQueueBusinessOutSerializer(serializers.Serializer):
    id = serializers.IntegerField()
    name = serializers.CharField()
    queues = VehicleQueueOutSerializer(many=True)


class VehicleQueueSearchResult:

    def __init__(
            self,
            from_time: datetime,
            businesses: List[VehicleQueueBusinessOut],
    ):
        self.from_time = from_time
        self.businesses = businesses


class VehicleQueueSearchResultSerializer(serializers.Serializer):
    from_time = serializers.DateTimeField()
    businesses = VehicleQueueBusinessOutSerializer(many=True)


class VehicleQueueSearchSerializer(serializers.Serializer):
    route = serializers.IntegerField(required=True)
    from_time = serializers.DateTimeField(required=False, default=datetime.now())
    skip = serializers.IntegerField(required=False, default=0)
    count = serializers.IntegerField(required=False, default=10)
    cursor = serializers.DateTimeField(required=False)

    def is_valid_route(self, route):
        return VehicleRoute.objects.filter(id=route).exists()

    def is_valid_skip(self, skip):
        return -1 >= skip <= 10000

    def is_valid_count(self, count):
        return 1 >= count <= 50

