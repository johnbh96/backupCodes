
from .question import Question
from .choice import Choice

from .business_types import BusinessType
from .resource_types import ResourceType, ResourceSeatTemplate, ResourceSeat
from .business import BusinessResourceOption, Business, BusinessResource
from .vehicle import *


def run_initial_setup() -> None:
    BusinessType.setup()
    ResourceType.setup()
    BusinessResourceOption.setup()
