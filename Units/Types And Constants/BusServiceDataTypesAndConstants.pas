unit BusServiceDataTypesAndConstants;

  {====================================================}
  { centralised location for basic types and constants }
  { Author: Tony Foster                                }
  { Date: January 2022                                 }
  {====================================================}

interface

type
  TLineParseResult        = (prNoError, prBlankLine, prUnreadableElement);
  TDayOfWeek              = (dwMonday, dwTuesday, dwWednesday, dwThursday, dwFriday, dwSaturday, dwSunday);
  TDaysOfWeek             = set of TDayOfWeek;
  TServiceScheduleGroup   = (sgWeekdays, sgSaturday, sgSunday);
  TServiceScheduleGroups  = set of TServiceScheduleGroup;
  TCharacterState         = (csNothing, csOpeningString, csClosingString, csInString, csDelimiter, csError);

  TServiceDefinition      = record
     OperatorName         : string;
     ServiceName          : string;
     ActiveDays           : TDaysOfWeek;
  end;

const
  C_ERROR_FORMAT          = 'Error in line: %S';
  C_NO_ERROR_FORMAT       = '%S read OK';
  C_FILE_NOT_FOUND        = 'Error. File Not Found: %S';
  C_ERROR_COUNT_FORMAT    = 'Error Count: %D';
  C_ERROR_NO_CLASS        = 'Error. Required implementation classes not registered.';
  C_GENERAL_DISPLAY_ERROR = 'Error. Unspecified display error';
  C_ERROR_NO_LINEREADER   = 'Error. Controller has no valid Line Reader item.';
  C_ERROR_READING_FILE    = 'Error. Exception encountered reading file. Exception text: %S';
  C_ERROR_NO_VIEW         = 'Error. Controller has no valid View item.';
  C_ERROR_NO_MODEL        = 'Error. Controller has no valid Model item.';
  C_ERROR_NO_ROOT         = 'Error. Controller has no valid data root item.';
  C_ERROR_NO_NODE         = 'Error. View failed to supply display element.';
  C_ERROR_NODE_DATA       = 'Error. Unable to access tree node data item.';
  C_ERROR_INVALID_GROUP   = 'Error. Top level node: inappropriate name.';
  C_SCHEDULE              = 'Schedule';
  C_NOT_RUNNING           = '-';
  C_NO_DATA_COMPONENTS    = 'No Data';
  C_READ_TIME             = 'Read: %Dms';
  C_CSV_FILTER            = 'CSV Files (*.csv)|*.csv';
  C_STRING_STRING         = '%S: %S';
  C_PRECISE_TIME          = 'hh:mm:ss:zzz';

  C_WEEKDAYS: TDaysOfWeek = [dwMonday, dwTuesday, dwWednesday, dwThursday, dwFriday];

  CA_SCHEDULE_GROUPNAMES  : array[TServiceScheduleGroup] of string = ('Monday to Friday', 'Saturday', 'Sunday');
  CA_DAYNAME_ABBREV       : array[TDayOfWeek] of string = ('M', 'T', 'W', 'T', 'F', 'S', 'S');

implementation

end.
