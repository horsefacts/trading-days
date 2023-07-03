import pytz
from dateutil import rrule
from datetime import datetime

def generate_dst_dates(year):
    tz = pytz.timezone('America/New_York')
    dst_start_date = list(rrule.rrule(rrule.YEARLY, dtstart=datetime(year, 3, 8, 2, 0, 0), until=datetime(year, 12, 31),
                                       bymonth=3, byweekday=rrule.SU(2)))[0]
    dst_end_date = list(rrule.rrule(rrule.YEARLY, dtstart=datetime(year, 11, 1, 2, 0, 0), until=datetime(year, 12, 31),
                                     bymonth=11, byweekday=rrule.SU(1)))[0]

    # Localize datetime to New York timezone
    dst_start_date = tz.localize(dst_start_date)
    dst_end_date = tz.localize(dst_end_date)

    return dst_start_date, dst_end_date

def get_dst_timestamps(year):
    tz = pytz.timezone('America/New_York')
    epoch = tz.localize(datetime(2023, 1, 1, 0, 0, 0))

    dst_start_date, dst_end_date = generate_dst_dates(year)
    # Convert localized datetime to Unix timestamp and subtract epoch timestamp
    dst_start_timestamp = int(dst_start_date.timestamp()) - int(epoch.timestamp())
    dst_end_timestamp = int(dst_end_date.timestamp()) - int(epoch.timestamp())

    return dst_start_timestamp, dst_end_timestamp

def get_hex_string_for_years(start_year, num_years):
    result = []
    for year in range(start_year, start_year + num_years):
        start_timestamp, end_timestamp = get_dst_timestamps(year)
        result.append(hex(start_timestamp)[2:].zfill(8))  # 8 hex characters for a uint32
        result.append(hex(end_timestamp)[2:].zfill(8))
    return ''.join(result)

print(get_hex_string_for_years(2024, 100))
