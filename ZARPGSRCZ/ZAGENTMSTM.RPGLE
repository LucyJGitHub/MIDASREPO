     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ZA Generate a timestamp')
      *****************************************************************
      *                                                               *
      *  Midas - Common routines                                      *
      *                                                               *
      *  ZAGENTMSTM - Generate a timestamp                            *
      *                                                               *
      *  Function:  This module uses APIs to generate a timestamp     *
      *             field.  This allows us to                         *
      *             generate the timestamp using bound calls and no   *
      *             database functions, which should be quicker than  *
      *             the existing methods.                             *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *  Prev Amend No. CAANNN  *CREATE    Date DDMmmYY               *
      *                                    Date DDMmmYY               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CAAnnn - <<Description of change>>                           *
      *                                                               *
      *****************************************************************
 
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** The following data structure is used for the QMHRTVM system API,
      ** to contain the error code structure.
      ** It was copied from the member QUSEC in QSYSINC/QRPGLESRC, and the
      ** variable-length field at the end of the structure set to 8 for the .
      ** amount of error data.  Note that the structure was copied in and
      ** amended, rather than being /COPYd principally so that the Bytes
      ** Provided field can be initialised with the INZ keyword.
     DQUSEC            DS
     D*                                             Qus EC
      ** The %LEN initialisation technique cannot be used at the time of
      ** development because it is not supported below V3R7M0; but it could
      ** and should be reintroduced at a later date.
     D*QUSBPRV****             1      4B 0          INZ(%LEN(QUSED01))
     D QUSBPRV                 1      4B 0          INZ(16)
     D*                                             Bytes Provided
     D QUSBAVL                 5      8B 0          INZ(0)
     D*                                             Bytes Available
     D QUSEI                   9     15
     D*                                             Exception Id
     D QUSERVED               16     16
     D*                                             Reserved
     D QUSED01                17     32
     D*                                      Exception data
 
      ** The data/time value returned from the API, broken down
     D OutDate         DS
     D  APIYear                1      4A
     D  APIMonth               5      6A
     D  APIDay                 7      8A
     D  APIHour                9     10A
     D  APIMin                11     12A
     D  APISec                13     14A
     D  APIMilli              15     17A
 
      ** The timestamp format, returned from this procedure
     D TimeStmpDS      DS
     D  RetYear                1      4A
     D                         5      5A   INZ('-')
     D  RetMonth               6      7A
     D                         8      8A   INZ('-')
     D  RetDay                 9     10A
     D                        11     11A   INZ('-')
     D  RetHour               12     13A
     D                        14     14A   INZ('.')
     D  RetMin                15     16A
     D                        17     17A   INZ('.')
     D  RetSec                18     19A
     D                        20     20A   INZ('.')
     D  RetMilli              21     23A
     D  RetMicro              24     26A   INZ('000')
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Input date format for the API.  *CURRENT means the current
      ** machine clock time.
     D InFormat        S             10A   INZ('*CURRENT')
 
      ** Input variable for the API.  This value is ignored because
      ** *CURRENT is used above, but a value must be passed anyway
     D InVariable      S              1A
 
      ** Output format for the API to return. *DTS means system timestamp.
     D OutFormat       S             10A   INZ('*YYMD')
 
      ** The timestamp field returned by this module
     D TimeStamp       S               Z
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
     C     Start         TAG
      ** Note: the above tag is only there to force the first comments in
      ** the C-specs to appear after the D- or I-specs in compiled listings.
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *inzsr is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Use the API to get a 17-byte date/time value (down to the
      ** microsecond)
     C                   CALL      'QWCCVTDT'
      **                                      Input format
     C                   PARM                    InFormat
      **                                      Input variable
     C                   PARM                    InVariable
      **                                      Output format
     C                   PARM                    OutFormat
      **                                      Date/time returned
     C                   PARM                    OutDate
      **                                      Error structure
     C                   PARM                    QUSEC
 
      ** The OutDate field returned from the API and TimeStamp fields
      ** returned from this procedure have been broken down by data
      ** structures.  Copy the data from one to the other and exit.
     C                   EVAL      RetYear  = APIYear
     C                   EVAL      RetMonth = APIMonth
     C                   EVAL      RetDay   = APIDay
     C                   EVAL      RetHour  = APIHour
     C                   EVAL      RetMin   = APIMin
     C                   EVAL      RetSec   = APISec
     C                   EVAL      RetMilli = APIMilli
 
     C                   MOVEL     TimeStmpDS    TimeStamp
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *inzsr - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *inzsr        BEGSR
 
     C     *entry        PLIST
      ** Returned parameters
      ** -------------------
      ** Return code (10A, returned to caller)
     C                   PARM                    TimeStamp
 
     C                   ENDSR
 
      ********************************************************************
