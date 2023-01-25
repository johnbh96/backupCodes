from rest_framework import serializers


class SeatIndexSerializer(serializers.Serializer):
    row_index = serializers.IntegerField(required=True)
    column_index = serializers.IntegerField(required=True)


class SubmitVehicleSeatsBooking(serializers.Serializer):
    queue = serializers.IntegerField(required=True)
    seats = SeatIndexSerializer(many=True)
    contact_name = serializers.CharField()
    contact_number = serializers.CharField()
    note = serializers.CharField()


class VehicleSeatBookingResponse:

    def __init__(self, id_: int):
        self.id = id_


class VehicleSeatBookingRespSerializer(serializers.Serializer):
    id = serializers.IntegerField(required=True)
