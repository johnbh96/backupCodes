from django.urls import path

from .views import (
    ListQuestions, ListBusinessTypes,
    create_business, handle_business,
    ResourceOptions, ResourceTemplate,
    create_resource,
    verify_web_hook,
)
from .views.vehicle_route_views import RouteSearch
from .views.vehicle_queue_views import search_vehicle_queue
from .views.book_vehicle_seats_view import book_vehicle_seats
from .views.booking_views import booking_details

urlpatterns = [
    path('questions/', ListQuestions.as_view()),
    path('business/types', ListBusinessTypes.as_view()),
    path('business/type/<str:business_type_name>/options', ResourceOptions.as_view()),
    path('resource/type/<str:resource_type_name>/template', ResourceTemplate.as_view()),
    path('hooks/messenger', verify_web_hook),
    path('business/<int:pk>', handle_business),
    path('business', create_business),
    path('resource', create_resource),

    path('search/vehicle/routes', RouteSearch.as_view(), name='search_vehicle_routes'),
    path('search/vehicle/queues', search_vehicle_queue),

    path('book/vehicle/seats', book_vehicle_seats),

    path('booking/<int:pk>', booking_details),
]
