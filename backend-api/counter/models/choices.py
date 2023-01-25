from django.utils.translation import gettext_lazy as _

from django.db import models


class ResourceGroupType(models.TextChoices):
    LetterFirst = 'LetterFirst', _('Letter First')
    DigitFirst = 'DigitFirst', _('Digit First')
    Individual = 'Individual', _('Individual')


class ResourceCapacityType(models.TextChoices):
    FixedDefault = 'FixedDefault', _('Fixed Default')
    UserEditable = 'UserEditable', _('User Editable')
    SeatTemplate = 'SeatTemplate', _('Seat Template')


class ResourceDurationType(models.TextChoices):
    InHours = 'InHours', _('In Hours')
    InDays = 'InDays', _('In Days')
    TimeTabled = 'TimeTabled', _('Time Tabled')


class BookingStatus(models.TextChoices):
    Pending = 'Pending', _('Pending ')


class BookingChannelType(models.TextChoices):
    YatruSewa = 'YatruSewa', _('Yatru Sewa')


class NotificationType(models.TextChoices):
    Booking = 'Booking', _('Booking')


class BookingNotificationType(models.TextChoices):
    NewBooking = 'NewBooking', _('New Booking')
    CancelledBooking = 'CancelledBooking', _('Booking Cancelled')
    ConfirmedBooking = 'ConfirmedBooking', _('Booking Confirmed')
