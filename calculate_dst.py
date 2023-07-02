from dateutil import rrule
from datetime import datetime

def generate_dst_dates(year):
    dst_start_date = list(rrule.rrule(rrule.YEARLY, dtstart=datetime(year, 3, 8), until=datetime(year, 12, 31),
                                       bymonth=3, byweekday=rrule.SU(2)))[0]
    dst_end_date = list(rrule.rrule(rrule.YEARLY, dtstart=datetime(year, 11, 1), until=datetime(year, 12, 31),
                                     bymonth=11, byweekday=rrule.SU(1)))[0]
    return dst_start_date, dst_end_date

def get_encoded_date(date, start_day):
    return date.day - start_day

def get_hex_string_for_year(year):
    dst_start_date, dst_end_date = generate_dst_dates(year)
    print("assertDSTStartEndEq({year}, {dst_start_date}, {dst_end_date})".format(year=year, dst_start_date=dst_start_date.date().day, dst_end_date=dst_end_date.date().day))
    encoded_start_date = get_encoded_date(dst_start_date, 8)
    encoded_end_date = get_encoded_date(dst_end_date, 1)
    encoded_year = (encoded_start_date << 3) | encoded_end_date
    return hex(encoded_year)[2:].zfill(2)

def get_hex_string_for_years(start_year, num_years):
    return ''.join([get_hex_string_for_year(year) for year in range(start_year, start_year + num_years)])

print(get_hex_string_for_years(2023, 101))
