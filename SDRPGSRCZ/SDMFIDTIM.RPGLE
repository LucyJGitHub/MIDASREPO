     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2008')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Module to compute date and time based on parms')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDMFIDTIM - This module accepts date, sign and offset from   *
      *              calling program then perform necessary date      *
      *              conversion or retrieval                          *
      *                                                               *
      *  Function:  This program is used for the computation of dates *
      *             based on the offset and sign retrieved            *
      *                                                               *
      *  Called By: SD001005 - Midas SD Time Zone Maintenance         *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2008            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Last Amend No. BUG20932           Date 28Aug08               *
      *  Prev Amend No. BUG19628           Date 29Jul08               *
      *                 CSW208  *CREATE    Date 15Apr08               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  BUG20932 - Wrong date reflected in 98E based on the time     *
      *             conversion                                        *
      *  BUG19628  - DST is being switched on even if start time is   *
      *              not yet reached                                  *
      *  CSW208 - SWIFT Changes 2008                                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use Of Indicators.                                           *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  *PSSR    - Error processing                                  *
      *  *INZSR   - Initialise                                        *
      *  CnvTimeToUTC - Converts system time to UT                    *
      *  CnvTimeFormt - Converts Branch/Local Time to Market Time     *
      *  GetMrktSgOff - Retrieve Market Offset and Sign               *
      *  GetBrchOffst - Retrieve Branch Offset & Sign                 *
      *  GetSystOffst - Retrieve System Offset & Sign                 *
      *  SRGetOffset - Get sign and offset                            *
      *  SRZDate1 - Validate & Convert Date to a Day Number           *
      *                                                               *
      *****************************************************************
      *---------------------------------------------------------------*
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Automatically Included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      *
      ** The Following /COPY Line Includes The LDA Layout,
      ** The Copyright Array Definition,
      ** AND The Following Named Constants:
      **    True       Logical = *On (For Indcator Processing)
      **    False      Logical = *Off (For Indcator Processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (The Name Of The Database
      **                         Error Handler)
      ** AND The Following Variables:
      **    RunBefore  1A (for the PSSR)
      *
     D/COPY ZACPYSRC,STD_D_SPEC
      *
      ** +--------------------------------------+
      ** Program Status Data Structure          |
      ** =============================          |
      ** +--------------------------------------+
      *
      ** The Following /COPY Line Includes All The Defined Fields In
      ** The PSDS.  They Have Meaningful Names, Prefixed By 'PS'.
      *
     D/COPY ZACPYSRC,PSDS
      *
      ** +--------------------------------------+
      ** ¦ End Of Automatically Included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Arrays AND Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** First DS for Access Programs, Short Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** DS SDBANK Based On SDBANKPD
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External DS for SDMICCPD
     D SDMICP        E DS                  EXTNAME(SDMICCPD)
 
      ** +--------------------------------------+
      ** ¦ Declared Variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Work variables
      *
     D   WTzLc         S              1A   INZ(*BLANKS)
     D   WZone         S             10A   INZ(*BLANKS)
     D   WBrCa         S              3A   INZ(*BLANKS)
     D   WInDate       S              5P 0 INZ(*ZEROS)
     D   WTizoCode     S             10A   INZ(*BLANKS)
     D   WCurDate      S              5P 0 INZ(*ZEROS)
     D   WTime         S               T   TIMFMT(*HMS)
     D   WDate         S               D   DATFMT(*YMD)
     D   WCurTime      S               T   TIMFMT(*HMS)                                    BUG19628
     D   WTimeStr      S              6A   INZ(*Blanks)                                    BUG19628
      *
     D   S1HH          S              2S 0 INZ(*ZEROS)
     D   S1MM          S              2S 0 INZ(*ZEROS)
     D   S2HH          S              2S 0 INZ(*ZEROS)
     D   S2MM          S              2S 0 INZ(*ZEROS)
      *
     D   PTzcd         S             10A   INZ(*BLANKS)
      *
     D   PZDate        S              6A   INZ(*BLANKS)
     D   PZDayNo       S              5P 0 INZ(*ZEROS)
     D   PErrorFlag    S              1A   INZ(*BLANKS)
      *
     D   PRtcd         S              7A   INZ(*BLANKS)
     D   PTime         S               T   TIMFMT(*HMS)
     D   POptn         S              7A   INZ(*BLANKS)
     D   WRun          S              1A   INZ(*BLANKS)
      *
      ** Parameters for program SD001008
      *
     D   PTzLc         S              1A
     D   PZone         S             10A
     D   PBrCd         S              3A
     D   PMiCd         S              4A
     D   PInDate       S              5P 0
     D   PEffOffset    S              4A
     D   PSign         S              1A
     D   PCurtime      S              6S 0                                                 BUG19628
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
      ** Entry Parameter
      *
     D   POpType       S              2A
     D   PDate1        S              6A
     D   PTime1        S              6A
     D   PSign1        S              1A
     D   POffSet1      S              4A
     D   PDate2        S              6A
     D   PTime2        S              6A
     D   PSign2        S              1A
     D   POffSet2      S              4A
     D   PBranch       S              3A
     D   PMicCode      S              4A
     D   WMicCode      S              4A
      *
     D   PTimeStamp    S             26Z                                                    BUG20932
                                                                                            BUG20932
     D TimeStmpDS      DS                                                                   BUG20932
     D  RetYear                1      4A                                                    BUG20932
     D                         5      5A   INZ('-')                                         BUG20932
     D  RetMonth               6      7A                                                    BUG20932
     D                         8      8A   INZ('-')                                         BUG20932
     D  RetDay                 9     10A                                                    BUG20932
     D                        11     11A   INZ('-')                                         BUG20932
     D  RetHour               12     13A                                                    BUG20932
     D                        14     14A   INZ('.')                                         BUG20932
     D  RetMin                15     16A                                                    BUG20932
     D                        17     17A   INZ('.')                                         BUG20932
     D  RetSec                18     19A                                                    BUG20932
     D                        20     20A   INZ('.')                                         BUG20932
     D  RetMilli              21     23A                                                    BUG20932
     D  RetMicro              24     26A   INZ('000')                                       BUG20932
                                                                                            BUG20932
      *
      ** --------------------------------------------------------------
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      *****************************************************************
      *
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial Processing Is Performed Automatically: The *INZSR  ¦
      ** ¦ Is Executed At Program Activation.                         ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      *****************************************************************
      *  MAIN - Processing                                            *
      *****************************************************************
      *
     C                   SELECT
     C                   WHEN       pOpType = '01'
     C                   EXSR      CnvTimeToUTC
     C                   WHEN       pOpType = '02'
     C                   EXSR      CnvTimeFormt
     C                   WHEN       pOpType = '03'
     C                   EXSR      GetMrktSgOff
     C                   WHEN       pOpType = '04'
     C                   EXSR      GetBrchOffst
     C                   WHEN       pOpType = '05'
     C                   EXSR      GetSystOffst
     C                   ENDSL
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  CnvTimeToUTC - Converts Time to UTC                          *
      *                                                               *
      *  CALLed by: MAIN Processing                                   *
      *                                                               *
      *  *ENTRY Parameters                                            *
      *   POpType         :  01                                       *
      *   PDate1          :  Contains the date passed                 *
      *   PTime1          :  Contains the system time to be converted *
      *   PSign1          :  Contains the sign                        *
      *   POffSet1        :  Contains the offset                      *
      *   PDate2          :  *BLANKS                                  *
      *   PTime2          :  *BLANKS                                  *
      *   PSign2          :  *BLANKS                                  *
      *   POffSet2        :  *BLANKS                                  *
      *   PBranch         :  *BLANKS                                  *
      *   PMicCode        :  *BLANKS                                  *
      *  Upon Return                                                  *
      *   PTime2          : Contains the date adjusted to UTC         *
      *   PDate2          : Contains the date adjusted to UTC         *
      *   PSign2          : Contains the sign of UTC                  *
      *   POffSet2        : Contains the offset of UTC                *
      *                                                               *
      *  CALLs: None                                                  *
      *                                                               *
      *****************************************************************
     C     CnvTimeToUTC  BEGSR
      *
     C                   EVAL      WTime = %TIME(PTime1:*HMS0)
      *
     C                   MOVEL     POffSet1      S1HH
     C                   MOVE      POffSet1      S1MM
      *
     C                   EVAL      PTime  = WTime
     C                   IF        PDate1 <> *BLANKS
     C                   IF        BJDFIN  = 'D'
     C                   EVAL      WDate = %DATE(PDate1:*DMY0)
     C                   ELSE
     C                   EVAL      WDate = %DATE(PDate1:*MDY0)
     C                   ENDIF
     C                   ENDIF
     C                   EVAL      PTimeStamp = WDate + WTime                               BUG20932
      *
      ** If system offset is positive
      ** Current Time = Local Time - System Offset +/- Branch Offset
      *
     C                   IF        (PSIGN1 = '+')
     C                   SUBDUR    S1HH:*HOURS   WTime
     C                   SUBDUR    S1MM:*MINUTES WTime
      *
     C                   SUBDUR    S1HH:*Hours   PTimeStamp                                 BUG20932
     C                   SUBDUR    S1MM:*Minutes PTimeStamp                                 BUG20932
                                                                                            BUG20932
     C**********         IF        WTime >= %TIME('12:00:00':*HMS) AND                      BUG20932
     C**********                   WTime <= %TIME('23:59:59':*HMS) AND                      BUG20932
     C**********                   PTime >= %TIME('00:00:00':*HMS) AND                      BUG20932
     C**********                   PTime <= %TIME('11:59:59':*HMS)                          BUG20932
     C**********         SUBDUR    1:*DAYS       WDate                                      BUG20932
     C**********         ENDIF                                                              BUG20932
      *
     C                   ELSEIF    (PSIGN1 = '-')
     C                   ADDDUR    S1HH:*HOURS   WTime
     C                   ADDDUR    S1MM:*MINUTES WTime
      *
     C                   ADDDUR    S1HH:*Hours   PTimeStamp                                 BUG20932
     C                   ADDDUR    S1MM:*Minutes PTimeStamp                                 BUG20932
                                                                                            BUG20932
     C**********         IF        WTime >= %TIME('00:00:00':*HMS) AND                      BUG20932
     C**********                   WTime <= %TIME('11:59:59':*HMS) AND                      BUG20932
     C**********                   PTime >= %TIME('12:00:00':*HMS) AND                      BUG20932
     C**********                   PTime <= %TIME('23:59:59':*HMS)                          BUG20932
     C**********         ADDDUR    1:*DAYS       WDate                                      BUG20932
     C**********         ENDIF                                                              BUG20932
      *
     C                   ENDIF
      *
     C                   MOVEL     PTimeStamp    TimeStmpDS                                 BUG20932
     C                   MOVEL     RETDAY        #WDAYM            4                        BUG20932
     C                   MOVE      RETMONTH      #WDAYM                                     BUG20932
     C                   MOVE      RETYEAR       #WYEAR            2                        BUG20932
     C                   MOVEL     #WDAYM        PDate1                                     BUG20932
     C                   MOVE      #WYEAR        PDate1                                     BUG20932
     C                                                                                      BUG20932
     C                   IF        (BJDFIN  = 'D')                                          BUG20932
     C                   EVAL      WDate = %DATE(PDate1:*DMY0)                              BUG20932
     C                   ELSE                                                               BUG20932
     C                   EVAL      WDate = %DATE(PDate1:*MDY0)                              BUG20932
     C                   ENDIF                                                              BUG20932
      *                                                                                     BUG20932
     C                   IF        BJDFIN  = 'D'
     C                   EVAL      PDate2  = %CHAR(WDate:*DMY0)
     C                   ELSE
     C                   EVAL      PDate2  = %CHAR(WDate:*MDY0)
     C                   ENDIF
      *
     C                   EVAL      PTime2  = %CHAR(WTime:*HMS0)
     C                   EVAL      PSign2  = '+'
     C                   EVAL      POffset2= '000000'
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  CnvTimeFormt  - Converts Branch/Local Time to Market Time    *
      *                  or Vice Versa                                *
      *                                                               *
      *  CALLed by: MAIN Processing                                   *
      *                                                               *
      *  *ENTRY Parameters                                            *
      *   POpType         :  02                                       *
      *   PDate1          :  Local or Market Execution Date           *
      *   PTime1          :  Local or Market Execution Time           *
      *   PSign1          :  Local or Market Execution Sign           *
      *   POffSet1        :  Local or Market Execution Offset         *
      *   PDate2          :  *BLANKS                                  *
      *   PTime2          :  *BLANKS                                  *
      *   PSign2          :  Local or Market Execution Sign           *
      *   POffSet2        :  Local or Market Execution Offset         *
      *   PBranch         :  *BLANKS                                  *
      *   PMicCode        :  *BLANKS                                  *
      *  Upon Return                                                  *
      *   PDate2          :  Local or Market Execution Date           *
      *   PTime2          :  Local or Market Execution Time           *
      *                                                               *
      *  CALLs: None                                                  *
      *                                                               *
      *****************************************************************
     C     CnvTimeFormt  BEGSR
      *
     C                   EVAL      WTime  = %TIME(PTIME1:*HMS0)
     C                   EVAL      PTime  = %TIME(PTIME1:*HMS0)
      *
     C                   IF        BJDFIN  = 'D'
     C                   EVAL      WDate = %DATE(PDate1:*DMY0)
     C                   ELSE
     C                   EVAL      WDate = %DATE(PDate1:*MDY0)
     C                   ENDIF
     C                   EVAL      PTimeStamp = WDate + WTime                               BUG20932
      *
     C                   MOVEL     POffSet1      S1HH
     C                   MOVE      POffSet1      S1MM
     C                   MOVEL     POffSet2      S2HH
     C                   MOVE      POffSet2      S2MM
      *
     C                   IF        (PSign1 = '+')
     C                   SUBDUR    S1HH:*HOURS   WTime
     C                   SUBDUR    S1MM:*MINUTES WTime
      *
     C                   SUBDUR    S1HH:*Hours   PTimeStamp                                 BUG20932
     C                   SUBDUR    S1MM:*Minutes PTimeStamp                                 BUG20932
                                                                                            BUG20932
     C**********         IF        WTime >= %Time('12:00:00':*HMS) AND                      BUG20932
     C**********                   WTime <= %Time('23:59:59':*HMS) AND                      BUG20932
     C**********                   PTime >= %Time('00:00:00':*HMS) AND                      BUG20932
     C**********                   PTime <= %Time('11:59:59':*HMS)                          BUG20932
     C**********         SUBDUR    1:*Days       WDate                                      BUG20932
     C**********         ENDIF                                                              BUG20932
      *
     C                   ELSEIF    (PSign1 = '-')
     C                   ADDDUR    S1HH:*HOURS   WTIME
     C                   ADDDUR    S1MM:*MINUTES WTIME
      *
     C                   ADDDUR    S1HH:*Hours   PTimeStamp                                 BUG20932
     C                   ADDDUR    S1MM:*Minutes PTimeStamp                                 BUG20932
                                                                                            BUG20932
     C**********         IF        WTime >= %TIME('00:00:00':*HMS) AND                      BUG20932
     C**********                   WTime <= %TIME('11:59:59':*HMS) AND                      BUG20932
     C**********                   PTime >= %TIME('12:00:00':*HMS) AND                      BUG20932
     C**********                   PTime <= %TIME('23:59:59':*HMS)                          BUG20932
     C**********         ADDDUR    1:*DAYS       WDate                                      BUG20932
     C**********         ENDIF                                                              BUG20932
      *
     C                   ENDIF
      *
     C                   EVAL      PTime  = WTime
      *
     C                   IF        (pSign2 = '+')
     C                   ADDDUR    S2HH:*HOURS   WTime
     C                   ADDDUR    S2MM:*MINUTES WTime
      *
     C                   ADDDUR    S2HH:*Hours   PTimeStamp                                 BUG20932
     C                   ADDDUR    S2MM:*Minutes PTimeStamp                                 BUG20932
                                                                                            BUG20932
     C**********         IF        WTime >= %TIME('00:00:00':*HMS) AND                      BUG20932
     C**********                   WTime <= %TIME('11:59:59':*HMS) AND                      BUG20932
     C**********                   PTime >= %TIME('12:00:00':*HMS) AND                      BUG20932
     C**********                   Ptime <= %TIME('23:59:59':*HMS)                          BUG20932
     C**********         ADDDUR    1:*DAYS       WDate                                      BUG20932
     C**********         ENDIF                                                              BUG20932
      *
     C                   ELSEIF    (pSign2 = '-')
     C                   SUBDUR    S2HH:*HOURS   WTime
     C                   SUBDUR    S2MM:*MINUTES WTime
      *
     C                   SUBDUR    S2HH:*Hours   PTimeStamp                                 BUG20932
     C                   SUBDUR    S2MM:*Minutes PTimeStamp                                 BUG20932
                                                                                            BUG20932
     C**********         IF        WTime >= %TIME('12:00:00':*HMS) AND                      BUG20932
     C**********                   WTime <= %TIME('23:59:59':*HMS) AND                      BUG20932
     C**********                   PTime >= %TIME('00:00:00':*HMS) AND                      BUG20932
     C**********                   PTime <= %TIME('11:59:59':*HMS)                          BUG20932
     C**********         SUBDUR    1:*DAYS       WDate                                      BUG20932
     C**********         ENDIF                                                              BUG20932
      *
     C                   ENDIF
      *
     C                   MOVEL     PTimeStamp    TimeStmpDS                                 BUG20932
     C                   MOVEL     RETDAY        #WDAYM            4                        BUG20932
     C                   MOVE      RETMONTH      #WDAYM                                     BUG20932
     C                   MOVE      RETYEAR       #WYEAR            2                        BUG20932
     C                   MOVEL     #WDAYM        PDate1                                     BUG20932
     C                   MOVE      #WYEAR        PDate1                                     BUG20932
     C                                                                                      BUG20932
     C                   IF        (BJDFIN  = 'D')                                          BUG20932
     C                   EVAL      WDate = %DATE(PDate1:*DMY0)                              BUG20932
     C                   ELSE                                                               BUG20932
     C                   EVAL      WDate = %DATE(PDate1:*MDY0)                              BUG20932
     C                   ENDIF                                                              BUG20932
 
     C                   IF        BJDFIN  = 'D'
     C                   EVAL      PDate2  = %CHAR(WDate:*DMY0)
     C                   ELSE
     C                   EVAL      PDate2  = %CHAR(WDate:*MDY0)
     C                   ENDIF
     C                   EVAL      PTime2  = %CHAR(WTime:*HMS0)
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  GetMrktSgOff  - Retrieve Sign and Offset of Market based on  *
      *                  the Time Zone and DST code                   *
      *                                                               *
      *  CALLed by: MAIN Processing, SRAmend, SRInsert                *
      *                                                               *
      *  *ENTRY Parameters                                            *
      *   POpType         :  '03'                                     *
      *   PDate1          :  Contains the effective date              *
      *   PTime1          :  *BLANKS                                  *
      *   PSign1          :  *BLANKS                                  *
      *   POffSet1        :  *BLANKS                                  *
      *   PDate2          :  *BLANKS                                  *
      *   PTime2          :  *BLANKS                                  *
      *   PSign2          :  *BLANKS                                  *
      *   POffSet2        :  *BLANKS                                  *
      *   PBranch         :  *BLANKS                                  *
      *   PMicCode        :  Contains the MIC Code                    *
      *  Upon Return                                                  *
      *   PSign1          :  Contains the sign of the offset retrived *
      *   POffset1        :  Contains the retrieved                   *
      *                                                               *
      *  CALLed by: Main Processing                                   *
      *                                                               *
      *  CALLs: SrGetOffset                                           *
      *                                                               *
      *****************************************************************
     C     GetMrktSgOff  BEGSR
      *
      ** Determine current date in Midas Format
      *
     C                   EVAL      PZDate = PDate1
     C                   EXSR      SRZDate1
     C                   Z-ADD     PZDayNo       WCurDate
      *
      ** CALL AOMICCR0 to get Market Identification details
      *
     C                   CALL      'AOMICCR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY   '     Poptn
     C                   PARM                    PMicCode
     C     SDMICP        PARM      SDMICP        DSFDY
      *
     C                   IF        (PRtCd  <> *BLANKS) AND
     C                             (PRtcd  =  '*ERROR')
     C                   EVAL      DbFile = 'SDMICCPD'
     C                   EVAL      DBase = 3
     C                   EVAL      Dbkey =  PMicCode
     C                   EXSR      *Pssr
     C                   ENDIF
     C                   EVAL      WTzLc = 'M'
     C                   EVAL      WTizoCode = MITZCD
     C                   EVAL      WMicCode  = PMicCode
     C                   EVAL      WBrCa = *BLANKS
     C                   EVAL      WZone = *BLANKS
     C                   EVAL      WInDate = PZDayNo
      *
     C                   EVAL      WCurTime = %TIME()                                      BUG19628
     C                   EVAL      WTimeStr = %CHAR(WCurTime:*HMS0)                        BUG19628
     C                   MOVE      WTimeStr      PCurTime                                  BUG19628
      *                                                                                    BUG19628
     C                   EXSR      SrGetOffset
      *
     C                   EVAL      PSign1 = PSign
     C                   EVAL      POffset1 = PEffOffset
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  GetBrchOffst  - Get Branch Offset                            *
      *                                                               *
      *  CALLed by: MAIN Processing                                   *
      *                                                               *
      *  *ENTRY Parameters                                            *
      *   POpType         :  04                                       *
      *   PDate1          :  System Date                              *
      *   PTime1          :  *BLANKS                                  *
      *   PSign1          :  *BLANKS                                  *
      *   POffSet1        :  *BLANKS                                  *
      *   PDate2          :  *BLANKS                                  *
      *   PTime2          :  *BLANKS                                  *
      *   PSign2          :  *BLANKS                                  *
      *   POffSet2        :  *BLANKS                                  *
      *   PBranch         :  DDREEN                                   *
      *   PMicCode        :  *BLANKS                                  *
      *  Upon Return                                                  *
      *   PSign1          :  Contains the booking branch sign offset  *
      *   POffSet1        :  Contains the booking branch offset       *
      *                                                               *
      *  CALLs: SrGetOffset                                           *
      *                                                               *
      *****************************************************************
     C     GetBrchOffst  BEGSR
      *
     C                   EVAL      PZDate = PDate1
     C                   EXSR      SRZDate1
     C                   EVAL      WTzLc = 'B'
     C                   EVAL      WTizoCode = *BLANKS
     C                   EVAL      WMicCode  = *BLANKS
     C                   EVAL      WBrCa = PBranch
     C                   EVAL      WZone = *BLANKS
     C                   EVAL      WInDate = PZDayNo
      *
     C                   EVAL      WCurTime = %TIME()                                      BUG19628
     C                   EVAL      WTimeStr = %CHAR(WCurTime:*HMS0)                        BUG19628
     C                   MOVE      WTimeStr      PCurTime                                  BUG19628
      *                                                                                    BUG19628
     C                   EXSR      SrGetOffset
      *
     C                   EVAL      PSign1 = PSign
     C                   EVAL      POffset1 = PEffOffset
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  GetSystOffst  - Get System Offset                            *
      *                                                               *
      *  CALLed by: MAIN Processing                                   *
      *                                                               *
      *  *ENTRY Parameters                                            *
      *   POpType         :  05                                       *
      *   PDate1          :  System Date                              *
      *   PTime1          :  *BLANKS                                  *
      *   PSign1          :  *BLANKS                                  *
      *   POffSet1        :  *BLANKS                                  *
      *   PDate2          :  *BLANKS                                  *
      *   PTime2          :  *BLANKS                                  *
      *   PSign2          :  *BLANKS                                  *
      *   POffSet2        :  *BLANKS                                  *
      *   PBranch         :  DDREEN                                   *
      *   PMicCode        :  *BLANKS                                  *
      *  Upon Return                                                  *
      *   PSign1          :  Contains the system sign offset          *
      *   POffSet1        :  Contains the system offset               *
      *                                                               *
      *  CALLs: SrGetOffset                                           *
      *                                                               *
      *****************************************************************
     C     GetSystOffst  BEGSR
      *
     C                   EVAL      PZDate = PDate1
     C                   EXSR      SRZDate1
     C                   EVAL      WTzLc = 'S'
     C                   EVAL      WTizoCode = *BLANKS
     C                   EVAL      WMicCode  = *BLANKS
     C                   EVAL      WBrCa = *BLANKS
     C                   EVAL      WZone = *BLANKS
     C                   EVAL      WInDate = PZDayNo
      *
     C                   EVAL      WCurTime = %TIME()                                      BUG19628
     C                   EVAL      WTimeStr = %CHAR(WCurTime:*HMS0)                        BUG19628
     C                   MOVE      WTimeStr      PCurTime                                  BUG19628
      *                                                                                    BUG19628
     C                   EXSR      SrGetOffset
      *
     C                   EVAL      PSign1 = PSign
     C                   EVAL      POffset1 = PEffOffset
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrGetOffset - Get Offset/Sign                                *
      *                                                               *
      *  Called by: GetBrchOffst, GetMrktSgOff, GetSystOffst          *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SrGetOffset   BEGSR
      *
     C                   CALL      'SD001008'
     C                   PARM      WTzLc         PTzLc
     C                   PARM      WTizocode     PTzCd
     C                   PARM      WMicCode      PMiCd
     C                   PARM      WBrCa         PBrCd
     C                   PARM      WZone         PZone
     C                   PARM      WInDate       PInDate
     C                   PARM      *ZEROS        PEffOffset
     C                   PARM      *BLANKS       PSign
     C                   PARM                    PCurTime                                  BUG19628
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRZDate1 - Validate & Convert Date to a Day Number           *
      *                                                               *
      *  Called by: GetBrchOffst, GetMrktSgOff, GetSystOffst          *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRZDate1      BEGSR
      *
     C                   CALLB     'ZDATE1'
     C                   PARM                    PZDate
     C                   PARM                    PZDayNo
     C                   PARM                    BJDFIN
     C                   PARM                    PErrorFlag
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation Routine                      *
      *                                                               *
      *  CALLed by: Implicitly On Program Activation                  *
      *                                                               *
      *  CALLs: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM                    pOpType
     C                   PARM                    pDate1
     C                   PARM                    pTime1
     C                   PARM                    pSign1
     C                   PARM                    pOffset1
     C                   PARM                    pDate2
     C                   PARM                    pTime2
     C                   PARM                    pSign2
     C                   PARM                    pOffset2
     C                   PARM                    pBranch
     C                   PARM                    pMicCode
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*FIRST'      POptn
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C                   IF        PRtcd <> *BLANKS
      *
     C                   EVAL      DBKEY = POptn
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 1
      *
     C                   EXSR      *PSSR
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR - Program Exception Error Routine                      *
      *                                                               *
      *  Called By: Automatically if a program error occurs,          *
      *             or directly by the program code using EXSR.       *
      *             This subroutine DUMPs the program just once.      *
      *                                                               *
      *  CALLs: None                                                  *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
      *
     C                   IF        WRun = *BLANKS
      *
     C                   EVAL      WRun = 'Y'
     C                   DUMP
      *
     C                   CALL      'DBERRCTL'
      *
     C                   ENDIF
      *
     C                   EVAL      *INU7 = *On
     C                   EVAL      *INU8 = *On
     C                   EVAL      *INLR = *On
     C                   RETURN
      *
     C                   ENDSR
      *
** CPY@
(c) Misys International Banking Systems Ltd. 2007
