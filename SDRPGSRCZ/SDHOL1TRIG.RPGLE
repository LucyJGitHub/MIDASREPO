     H OPTION(*NODEBUGIO:*SRCSTMT)
     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2010')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD Update Holidays Extract File')                *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDHOL1TRIG - Midas SD Update Holidays Extract File           *
      *                                                               *
      *  Function:  This program will update SDHOL1PD file everytime  *
      *             SDHOLPD is changed                                *
      *                                                               *
      *  (c) Finastra International Limited 2010                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CRE071  *CREATE    Date 05Oct10               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE071 - BankFusion Midas Teller CBS related changes         *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *PSSR     - Error Processing                                  *
      * *INZSR    - Program Initialisation                            *
      * SrUpdate  - Update records in SDHOL1PD                        *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FSDHOL1L0  UF A E           K DISK    INFSR(*PSSR)
      ** Holidays file
 
      *****************************************************************
      /EJECT
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
     D TrigBuffer      DS
      ** First entry parameter
 
     D  PFlName                1     10
      ** Physical file name
 
     D  MbrName               21     30
      ** Member name
 
     D  TrgEvent              31     31
      ** Trigger event 1=Insert, 2=Delete, 3=Update, 4=Read
 
     D  TrgTime               32     32
      ** Trigger time  1=After, 2=Before
 
     D  BOff                  49     52B 0
      ** Offset to the before image of the record
 
     D  BLen                  53     56B 0
      ** Length of the before image of the record
 
     D  AOff                  65     68B 0
      ** Offset to the after image of the record
 
     D  ALen                  69     72B 0
      ** Length of the after image of the record
 
     D  EntryData            117  10117A
      ** Images
 
     D TrigLength      DS
      ** Second entry parameter
 
     D  Leng                   1      4B 0
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
     D SDHOLPD       E DS                  EXTNAME(SDHOLPD)
 
     D CurrencyCode            1      3
     D LocationCode            4      6
     D YearNumber              7     10
     D Jan1DayNumber          11     13p 0
     D Dec31DayNumber         14     16p 0
     D January                17     47    DIM(31)
     D February               48     76    DIM(29)
     D March                  77    107    DIM(31)
     D April                 108    137    DIM(30)
     D May                   138    168    DIM(31)
     D June                  169    198    DIM(30)
     D July                  199    229    DIM(31)
     D August                230    260    DIM(31)
     D September             261    290    DIM(30)
     D October               291    321    DIM(31)
     D November              322    351    DIM(30)
     D December              352    382    DIM(31)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D Index           S              2S 0
     D Month           S                   LIKE(D1MNTH)
     D Day             S                   LIKE(D1DAYS)
     D Holiday         S                   LIKE(D1HOLF)
     D Date            S                   LIKE(D1SDAT)
     D Run             S              1N
     D DateString      S             10A
     D RetCode         S              7A
     D Option          S              7A
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
 
      ** Insert or Update Event
 
     C                   IF        TrgEvent = '1' or
     C                             TrgEvent = '3'
 
     C                   EVAL      SDHOLPD = %SUBST(TrigBuffer:AOff+1)
 
      ** January
 
     C                   FOR       Index  = 1 to %ELEM(January)
     C                   EVAL      DateString = YearNumber + '-' + '01' + '-' +
     C                             %EDITC(Index:'X')
     C                   MOVE      DateString    Date
     C                   EVAL      Month = 'January'
     C                   EVAL      Day = Index
     C                   EVAL      Holiday = January(Index)
     C                   EXSR      SrUpdate
     C                   ENDFOR
 
      ** February
 
     C                   FOR       Index  = 1 to %ELEM(February)
     C                   EVAL      DateString = YearNumber + '-' + '02' + '-' +
     C                             %EDITC(Index:'X')
     C     *ISO          TEST(D E)               DateString
     C                   IF        not %ERROR
     C                   MOVE      DateString    Date
     C                   EVAL      Month = 'February'
     C                   EVAL      Day = Index
     C                   EVAL      Holiday = February(Index)
     C                   EXSR      SrUpdate
     C                   ENDIF
     C                   ENDFOR
 
      ** March
 
     C                   FOR       Index  = 1 to %ELEM(March)
     C                   EVAL      DateString = YearNumber + '-' + '03' + '-' +
     C                             %EDITC(Index:'X')
     C                   MOVE      DateString    Date
     C                   EVAL      Month = 'March'
     C                   EVAL      Day = Index
     C                   EVAL      Holiday = March(Index)
     C                   EXSR      SrUpdate
     C                   ENDFOR
 
      ** April
 
     C                   FOR       Index  = 1 to %ELEM(April)
     C                   EVAL      DateString = YearNumber + '-' + '04' + '-' +
     C                             %EDITC(Index:'X')
     C                   MOVE      DateString    Date
     C                   EVAL      Month = 'April'
     C                   EVAL      Day = Index
     C                   EVAL      Holiday = April(Index)
     C                   EXSR      SrUpdate
     C                   ENDFOR
 
      ** May
 
     C                   FOR       Index  = 1 to %ELEM(May)
     C                   EVAL      DateString = YearNumber + '-' + '05' + '-' +
     C                             %EDITC(Index:'X')
     C                   MOVE      DateString    Date
     C                   EVAL      Month = 'May'
     C                   EVAL      Day = Index
     C                   EVAL      Holiday = May(Index)
     C                   EXSR      SrUpdate
     C                   ENDFOR
 
      ** June
 
     C                   FOR       Index  = 1 to %ELEM(June)
     C                   EVAL      DateString = YearNumber + '-' + '06' + '-' +
     C                             %EDITC(Index:'X')
     C                   MOVE      DateString    Date
     C                   EVAL      Month = 'June'
     C                   EVAL      Day = Index
     C                   EVAL      Holiday = June(Index)
     C                   EXSR      SrUpdate
     C                   ENDFOR
 
      ** July
 
     C                   FOR       Index  = 1 to %ELEM(July)
     C                   EVAL      DateString = YearNumber + '-' + '07' + '-' +
     C                             %EDITC(Index:'X')
     C                   MOVE      DateString    Date
     C                   EVAL      Month = 'July'
     C                   EVAL      Day = Index
     C                   EVAL      Holiday = July(Index)
     C                   EXSR      SrUpdate
     C                   ENDFOR
 
      ** August
 
     C                   FOR       Index  = 1 to %ELEM(August)
     C                   EVAL      DateString = YearNumber + '-' + '08' + '-' +
     C                             %EDITC(Index:'X')
     C                   MOVE      DateString    Date
     C                   EVAL      Month = 'August'
     C                   EVAL      Day = Index
     C                   EVAL      Holiday = August(Index)
     C                   EXSR      SrUpdate
     C                   ENDFOR
 
      ** September
 
     C                   FOR       Index  = 1 to %ELEM(September)
     C                   EVAL      DateString = YearNumber + '-' + '09' + '-' +
     C                             %EDITC(Index:'X')
     C                   MOVE      DateString    Date
     C                   EVAL      Month = 'September'
     C                   EVAL      Day = Index
     C                   EVAL      Holiday = September(Index)
     C                   EXSR      SrUpdate
     C                   ENDFOR
 
      ** October
 
     C                   FOR       Index  = 1 to %ELEM(October)
     C                   EVAL      DateString = YearNumber + '-' + '10' + '-' +
     C                             %EDITC(Index:'X')
     C                   MOVE      DateString    Date
     C                   EVAL      Month = 'October'
     C                   EVAL      Day = Index
     C                   EVAL      Holiday = October(Index)
     C                   EXSR      SrUpdate
     C                   ENDFOR
 
      ** November
 
     C                   FOR       Index  = 1 to %ELEM(November)
     C                   EVAL      DateString = YearNumber + '-' + '11' + '-' +
     C                             %EDITC(Index:'X')
     C                   MOVE      DateString    Date
     C                   EVAL      Month = 'November'
     C                   EVAL      Day = Index
     C                   EVAL      Holiday = November(Index)
     C                   EXSR      SrUpdate
     C                   ENDFOR
 
      ** December
 
     C                   FOR       Index  = 1 to %ELEM(December)
     C                   EVAL      DateString = YearNumber + '-' + '12' + '-' +
     C                             %EDITC(Index:'X')
     C                   MOVE      DateString    Date
     C                   EVAL      Month = 'December'
     C                   EVAL      Day = Index
     C                   EVAL      Holiday = December(Index)
     C                   EXSR      SrUpdate
     C                   ENDFOR
     C                   ENDIF
 
      ** Process delete event
 
     C                   IF        TrgEvent = '2'
     C                   EVAL      SDHOLPD = %SUBST(TrigBuffer:BOff+1)
     C     KeyList2      SETLL     SDHOL1L0
     C     KeyList2      READE     SDHOL1L0
     C                   DOW       NOT %EOF(SDHOL1L0)
     C                   DELETE    SDHOL1D0
     C     KeyList2      READE     SDHOL1L0
     C                   ENDDO
     C                   ENDIF
 
     C                   EVAL      *INLR =  *ON
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrUpdate - Update records in SDHOL1PD                        *
      *                                                               *
      *****************************************************************
     C     SrUpdate      BEGSR
 
     C     KeyList1      CHAIN     SDHOL1L0
     C                   IF        %FOUND(SDHOL1L0)
     C                   IF        Month <> D1MNTH  OR
     C                             Day <> D1DAYS OR
     C                             Holiday <> D1HOLF
     C                   EVAL      D1MNTH = Month
     C                   EVAL      D1DAYS = Day
     C                   EVAL      D1HOLF = Holiday
     C                   EVAL      D1CHDT = BJRDNB
     C                   UPDATE    SDHOL1D0
     C                   ENDIF
 
     C                   ELSE
     C                   EVAL      D1CYCD = CurrencyCode
     C                   EVAL      D1LCCD = LocationCode
     C                   EVAL      D1YRNB = YearNumber
     C                   EVAL      D1MNTH = Month
     C                   EVAL      D1DAYS = Day
     C                   EVAL      D1HOLF = Holiday
     C                   EVAL      D1SDAT = Date
     C                   EVAL      D1CHDT = BJRDNB
 
     C                   WRITE     SDHOL1D0
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Initialisation Subroutine                            *
      *                                                               *
      * Called by: Automatically called                               *
      *                                                               *
      * Calls: AOBANKR0                                               *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    TrigBuffer
     C                   PARM                    TrigLength
 
     C     KeyList1      KLIST
     C                   KFLD                    CurrencyCode
     C                   KFLD                    LocationCode
     C                   KFLD                    YearNumber
     C                   KFLD                    Date
 
     C     KeyList2      KLIST
     C                   KFLD                    CurrencyCode
     C                   KFLD                    LocationCode
     C                   KFLD                    YearNumber
 
      ** Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       RetCode
     C                   PARM      '*FIRST '     Option
     C                   PARM                    SDBANK
 
      ** Database Error
 
     C                   IF        RetCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE  = 1
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBKEY  = Option
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   IF        Run = *OFF
     C                   EVAL      Run = *ON
     C                   DUMP
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
