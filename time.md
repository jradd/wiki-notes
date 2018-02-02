|  
<font color="#ffffff" face="helvetica, arial"> 
<big><big>**time**</big></big></font> | <font color="#ffffff" face="helvetica, arial">[index](.)
(built-in)</font> |

<tt>This module provides various functions to manipulate time values.

There are two standard representations of time.  One is the number
of seconds since the Epoch, in UTC (a.k.a. GMT).  It may be an integer
or a floating point number (to represent fractions of seconds).
The Epoch is system-defined; on Unix, it is generally January 1st, 1970.
The actual value can be retrieved by calling [gmtime](#-gmtime)(0).

The other representation is a tuple of 9 integers giving local time.
The tuple items are:
  year (four digits, e.g. 1998)
  month (1-12)
  day (1-31)
  hours (0-23)
  minutes (0-59)
  seconds (0-59)
  weekday (0-6, Monday is 0)
  Julian day (day in the year, 1-366)
  DST (Daylight Savings Time) flag (-1, 0 or 1)
If the DST flag is 0, the time is given in the regular time zone;
if it is 1, the time is given in the DST time zone;
if it is -1, [mktime](#-mktime)() should guess based on the date and time.

Variables:

timezone -- difference in seconds between UTC and local standard time
altzone -- difference in  seconds between UTC and local DST time
daylight -- whether local time should reflect DST
tzname -- tuple of (standard time zone name, DST time zone name)

Functions:

[time](#-time)() -- return current time in seconds since the Epoch as a float
[clock](#-clock)() -- return CPU time since process start as a float
[sleep](#-sleep)() -- delay for a number of seconds given as a float
[gmtime](#-gmtime)() -- convert seconds since Epoch to UTC tuple
[localtime](#-localtime)() -- convert seconds since Epoch to local time tuple
[asctime](#-asctime)() -- convert time tuple to string
[ctime](#-ctime)() -- convert time in seconds to string
[mktime](#-mktime)() -- convert local time tuple to seconds since Epoch
[strftime](#-strftime)() -- convert time tuple to string according to format specification
[strptime](#-strptime)() -- parse string to time tuple according to format specification
[tzset](#-tzset)() -- change the local timezone</tt>

|  
<font color="#ffffff" face="helvetica, arial"><big>**Classes**</big></font> |

<dl>

<dt><font face="helvetica, arial">[__builtin__.object](__builtin__.html#object)</font></dt>

<dd>

<dl>

<dt><font face="helvetica, arial">[struct_time](time.html#struct_time)</font></dt>

</dl>

</dd>

</dl>

|  
<font color="#000000" face="helvetica, arial"><a name="struct_time">class **struct_time**</a>([__builtin__.object](__builtin__.html#object))</font> |
 <tt>The time value as returned by [gmtime](#-gmtime)(), [localtime](#-localtime)(), and [strptime](#-strptime)(), and
accepted by [asctime](#-asctime)(), [mktime](#-mktime)() and [strftime](#-strftime)().  May be considered as a
sequence of 9 integers.

Note that several fields' values are not the same as those defined by
the C language standard for struct tm.  For example, the value of the
field tm_year is the actual year, not year - 1900.  See individual
fields' descriptions for details.
 </tt> |
 Methods defined here:

<dl>

<dt><a name="struct_time-__add__">**__add__**</a>(...)</dt>

<dd><tt>x.[__add__](#struct_time-__add__)(y) <==> x+y</tt></dd>

</dl>

<dl>

<dt><a name="struct_time-__contains__">**__contains__**</a>(...)</dt>

<dd><tt>x.[__contains__](#struct_time-__contains__)(y) <==> y in x</tt></dd>

</dl>

<dl>

<dt><a name="struct_time-__eq__">**__eq__**</a>(...)</dt>

<dd><tt>x.[__eq__](#struct_time-__eq__)(y) <==> x==y</tt></dd>

</dl>

<dl>

<dt><a name="struct_time-__ge__">**__ge__**</a>(...)</dt>

<dd><tt>x.[__ge__](#struct_time-__ge__)(y) <==> x>=y</tt></dd>

</dl>

<dl>

<dt><a name="struct_time-__getitem__">**__getitem__**</a>(...)</dt>

<dd><tt>x.[__getitem__](#struct_time-__getitem__)(y) <==> x[y]</tt></dd>

</dl>

<dl>

<dt><a name="struct_time-__getslice__">**__getslice__**</a>(...)</dt>

<dd><tt>x.[__getslice__](#struct_time-__getslice__)(i, j) <==> x[i:j]

Use of negative indices is not supported.</tt></dd>

</dl>

<dl>

<dt><a name="struct_time-__gt__">**__gt__**</a>(...)</dt>

<dd><tt>x.[__gt__](#struct_time-__gt__)(y) <==> x>y</tt></dd>

</dl>

<dl>

<dt><a name="struct_time-__hash__">**__hash__**</a>(...)</dt>

<dd><tt>x.[__hash__](#struct_time-__hash__)() <==> hash(x)</tt></dd>

</dl>

<dl>

<dt><a name="struct_time-__le__">**__le__**</a>(...)</dt>

<dd><tt>x.[__le__](#struct_time-__le__)(y) <==> x<=y</tt></dd>

</dl>

<dl>

<dt><a name="struct_time-__len__">**__len__**</a>(...)</dt>

<dd><tt>x.[__len__](#struct_time-__len__)() <==> len(x)</tt></dd>

</dl>

<dl>

<dt><a name="struct_time-__lt__">**__lt__**</a>(...)</dt>

<dd><tt>x.[__lt__](#struct_time-__lt__)(y) <==> x<y</tt></dd>

</dl>

<dl>

<dt><a name="struct_time-__mul__">**__mul__**</a>(...)</dt>

<dd><tt>x.[__mul__](#struct_time-__mul__)(n) <==> x*n</tt></dd>

</dl>

<dl>

<dt><a name="struct_time-__ne__">**__ne__**</a>(...)</dt>

<dd><tt>x.[__ne__](#struct_time-__ne__)(y) <==> x!=y</tt></dd>

</dl>

<dl>

<dt><a name="struct_time-__reduce__">**__reduce__**</a>(...)</dt>

</dl>

<dl>

<dt><a name="struct_time-__repr__">**__repr__**</a>(...)</dt>

<dd><tt>x.[__repr__](#struct_time-__repr__)() <==> repr(x)</tt></dd>

</dl>

<dl>

<dt><a name="struct_time-__rmul__">**__rmul__**</a>(...)</dt>

<dd><tt>x.[__rmul__](#struct_time-__rmul__)(n) <==> n*x</tt></dd>

</dl>

* * *

Data descriptors defined here:

<dl>

<dt>**tm_hour**</dt>

<dd><tt>hours, range [0, 23]</tt></dd>

</dl>

<dl>

<dt>**tm_isdst**</dt>

<dd><tt>1 if summer time is in effect, 0 if not, and -1 if unknown</tt></dd>

</dl>

<dl>

<dt>**tm_mday**</dt>

<dd><tt>day of month, range [1, 31]</tt></dd>

</dl>

<dl>

<dt>**tm_min**</dt>

<dd><tt>minutes, range [0, 59]</tt></dd>

</dl>

<dl>

<dt>**tm_mon**</dt>

<dd><tt>month of year, range [1, 12]</tt></dd>

</dl>

<dl>

<dt>**tm_sec**</dt>

<dd><tt>seconds, range [0, 61])</tt></dd>

</dl>

<dl>

<dt>**tm_wday**</dt>

<dd><tt>day of week, range [0, 6], Monday is 0</tt></dd>

</dl>

<dl>

<dt>**tm_yday**</dt>

<dd><tt>day of year, range [1, 366]</tt></dd>

</dl>

<dl>

<dt>**tm_year**</dt>

<dd><tt>year, for example, 1993</tt></dd>

</dl>

* * *

Data and other attributes defined here:

<dl>

<dt>**__new__** = <built-in method __new__ of type object></dt>

<dd><tt>T.[__new__](#struct_time-__new__)(S, ...) -> a new [object](__builtin__.html#object) with type S, a subtype of T</tt></dd>

</dl>

<dl>

<dt>**n_fields** = 9</dt>

</dl>

<dl>

<dt>**n_sequence_fields** = 9</dt>

</dl>

<dl>

<dt>**n_unnamed_fields** = 0</dt>

</dl>

 |

 |

|  
<font color="#ffffff" face="helvetica, arial"><big>**Functions**</big></font> |

<dl>

<dt><a name="-asctime">**asctime**</a>(...)</dt>

<dd><tt>[asctime](#-asctime)([tuple]) -> string

Convert a time tuple to a string, e.g. 'Sat Jun 06 16:26:11 1998'.
When the time tuple is not present, current time as returned by [localtime](#-localtime)()
is used.</tt></dd>

</dl>

<dl>

<dt><a name="-clock">**clock**</a>(...)</dt>

<dd><tt>[clock](#-clock)() -> floating point number

Return the CPU time or real time since the start of the process or since
the first call to [clock](#-clock)().  This has as much precision as the system
records.</tt></dd>

</dl>

<dl>

<dt><a name="-ctime">**ctime**</a>(...)</dt>

<dd><tt>[ctime](#-ctime)(seconds) -> string

Convert a time in seconds since the Epoch to a string in local time.
This is equivalent to [asctime](#-asctime)([localtime](#-localtime)(seconds)). When the time tuple is
not present, current time as returned by [localtime](#-localtime)() is used.</tt></dd>

</dl>

<dl>

<dt><a name="-gmtime">**gmtime**</a>(...)</dt>

<dd><tt>[gmtime](#-gmtime)([seconds]) -> (tm_year, tm_mon, tm_mday, tm_hour, tm_min,
                       tm_sec, tm_wday, tm_yday, tm_isdst)

Convert seconds since the Epoch to a time tuple expressing UTC (a.k.a.
GMT).  When 'seconds' is not passed in, convert the current time instead.</tt></dd>

</dl>

<dl>

<dt><a name="-localtime">**localtime**</a>(...)</dt>

<dd><tt>[localtime](#-localtime)([seconds]) -> (tm_year,tm_mon,tm_mday,tm_hour,tm_min,
                          tm_sec,tm_wday,tm_yday,tm_isdst)

Convert seconds since the Epoch to a time tuple expressing local time.
When 'seconds' is not passed in, convert the current time instead.</tt></dd>

</dl>

<dl>

<dt><a name="-mktime">**mktime**</a>(...)</dt>

<dd><tt>[mktime](#-mktime)(tuple) -> floating point number

Convert a time tuple in local time to seconds since the Epoch.</tt></dd>

</dl>

<dl>

<dt><a name="-sleep">**sleep**</a>(...)</dt>

<dd><tt>[sleep](#-sleep)(seconds)

Delay execution for a given number of seconds.  The argument may be
a floating point number for subsecond precision.</tt></dd>

</dl>

<dl>

<dt><a name="-strftime">**strftime**</a>(...)</dt>

<dd><tt>[strftime](#-strftime)(format[, tuple]) -> string

Convert a time tuple to a string according to a format specification.
See the library reference manual for formatting codes. When the time tuple
is not present, current time as returned by [localtime](#-localtime)() is used.</tt></dd>

</dl>

<dl>

<dt><a name="-strptime">**strptime**</a>(...)</dt>

<dd><tt>[strptime](#-strptime)(string, format) -> [struct_time](#struct_time)

Parse a string to a time tuple according to a format specification.
See the library reference manual for formatting codes (same as [strftime](#-strftime)()).</tt></dd>

</dl>

<dl>

<dt><a name="-time">**time**</a>(...)</dt>

<dd><tt>[time](#-time)() -> floating point number

Return the current time in seconds since the Epoch.
Fractions of a second may be present if the system clock provides them.</tt></dd>

</dl>

<dl>

<dt><a name="-tzset">**tzset**</a>(...)</dt>

<dd><tt>[tzset](#-tzset)()

Initialize, or reinitialize, the local timezone to the value stored in
os.environ['TZ']. The TZ environment variable should be specified in
standard Unix timezone format as documented in the tzset man page
(eg. 'US/Eastern', 'Europe/Amsterdam'). Unknown timezones will silently
fall back to UTC. If the TZ environment variable is not set, the local
timezone is set to the systems best guess of wallclock time.
Changing the TZ environment variable without calling tzset *may* change
the local timezone used by methods such as localtime, but this behaviour
should not be relied on.</tt></dd>

</dl>

 |

|  
<font color="#ffffff" face="helvetica, arial"><big>**Data**</big></font> |
 **accept2dyear** = 1
**altzone** = 14400
**daylight** = 1
**timezone** = 18000
**tzname** = ('EST', 'EDT') |
