import holidays

def get_holiday_dates(year):
    nyse_holidays = holidays.financial_holidays('NYSE', years=year, observed=True)
    return sorted(list(nyse_holidays.items()))

def get_encoded_date(date):
    month = date.month
    day = date.day
    return (month << 5) | day

def get_hex_string_for_year(year):
    holiday_dates = get_holiday_dates(year)
    print(year, len(holiday_dates))
    if year == 2028:
        print(holiday_dates)
    encoded_dates = [get_encoded_date(date) for (date, _) in holiday_dates]
    if len(encoded_dates) == 9:
        encoded_dates.insert(0, 0)
        encoded_dates.append(0)
    if len(encoded_dates) == 10:
        encoded_dates.append(0)
    encoded_year = 0
    for date in encoded_dates:
        encoded_year = (encoded_year << 9) | date
    return hex(encoded_year)[2:].zfill(26)

def get_hex_string_for_years(start_year, num_years):
    return ''.join([get_hex_string_for_year(year) for year in range(start_year, start_year + num_years)])

print(get_hex_string_for_years(2023, 101))
