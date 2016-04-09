     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI * ALWNULL(*USRCTL)                                              *
/*EXI *  TEXT('Midas GO Exception Report Housekeeping')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GOEXRPTIDY - Housekeeping for T_GPEXRPH & T_GPEXRPD.         *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2004            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. BG4444             Date 04Oct04              *
      *  Prev Amend No. CGP008  *CREATE    Date 15Sep04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  BG4444 - COB failure - Negative Retention date.              *
      *  CGP008 - Exception Reporting                                 *
      *                                                               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  F U N C T I O N  O F  I N D I C A T O R S                    *
      *                                                               *
      *    10         Record not found on T_GPEXRPH                   *
      *    11         Record not found on T_GPEXRPD                   *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *PSSR - Error processing                                      *
      * *INZSR - Initialise                                           *
      * SRSELECT - Select Exception header records for deletion.      *
      * SRDETAIL - Delete corresponding Exception Detail record.      *
      *                                                               *
      *****************************************************************
 
     FT_GPEXRPH UF   E             DISK    INFSR(*PSSR)
     F                                     RENAME(T_GPEXRPH:GPEXRPH)
     FT_GPEXRPD UF   E             DISK    INFSR(*PSSR)
     F                                     RENAME(T_GPEXRPD:GPEXRPD)
 
     D @RUN            S              1
     D ZWDTIN          S              8S 0
     D DeleteDate      S               D
     D DateOut         S              8S 0
     D @@DAYN          S              5P 0
     D PSysVal01       S             20A   INZ('ExcptRptRetention')
     D PCurSet01       S            200A
     D PSysVal02       S             20A
     D PCurSet02       S            200A
     D PSysVal03       S             20A
     D PCurSet03       S            200A
     D PSysVal04       S             20A
     D PCurSet04       S            200A
     D PSysVal05       S             20A
     D PCurSet05       S            200A
     D PSysVal06       S             20A
     D PCurSet06       S            200A
     D PSysVal07       S             20A
     D PCurSet07       S            200A
     D PSysVal08       S             20A
     D PCurSet08       S            200A
     D PSysVal09       S             20A
     D PCurSet09       S            200A
     D PSysVal10       S             20A
     D PCurSet10       S            200A
     D WSysVal01       S              3P 0
     D TimeStamp       S               Z
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** Bank details
      *
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for access programs, short data structure
      *
     D LDA           E DS           256    EXTNAME(LDA)
      *
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      ** Cannot use the external description of binary fields, e.g.
      ** field ERID would be taken to be 20 Integer long which is
      ** equivalent of 10A, instead of 18 Binary which is equivalent of 8A
      *
     D DSGPEXRPH     E DS                  EXTNAME(T_GPEXRPH)
      *
     DDSHEADER         DS            24
     D DSERID                  1      8I 0
     D DSAPI                   9     12A
     D DSZONE                 15     24A
     D W#ZONE                 17     24A
 
      ** Main Processing
     C                   EXSR      SRSELECT
      *
     C                   RETURN
      /SPACE 5
      ********************************************************************
      * SRSELECT
      ********************************************************************
     C     SRSELECT      BEGSR
 
     C                   READ      T_GPEXRPH                              10
     C     *IN10         DOWEQ     '0'                                          DoWhile *IN10 = 0
 
 
     C                   MOVEL     DSGPEXRPH     DSHEADER
      * Only process records in this zone
     C     O#ZONE        IFEQ      ERZONE
      *
      ** Format Transaction Write Date
     C                   MOVEL     *BLANKS       WORKDATE          8
     C                   EVAL      WORKDATE = %CHAR(ERWDAT:*ISO0)
     C                   MOVEL     WORKDATE      ZWDTIN
     C                   EXSR      ZDATE10
     C                   Z-ADD     ZZMDNO        W#WDAT            5 0            Midas day no.
      *
      ** Format Transaction Expiry Date
     C                   MOVEL     *BLANKS       WORKDATE          8
     C                   EVAL      WORKDATE = %CHAR(EREXPY:*ISO0)
     C                   MOVEL     WORKDATE      ZWDTIN
     C                   EXSR      ZDATE10
     C                   Z-ADD     ZZMDNO        W#EXPY            5 0            Midas day no.
      *
      ** If transaction is not committed, clear its exception records if
      ** not a predeal check transactions reserved beyond the rundate:
      *
      ** If transaction was not committed, so Write Date is zero:
      *
     C     W#WDAT        IFEQ      *ZEROS                                       If Write Date Null
      *
      ** If transaction has not been reserved, or expiry date has passed:
      *
     C     W#EXPY        IFEQ      *ZEROS
     C     EREXPY        ORLT      TimeStamp
      *
     C                   DELETE    GPEXRPH
     C                   EXSR      SRDETAIL
     C                   ENDIF
      *
     C                   ELSE                                                   Not Null
      *
      * If record was processed before the Deletion Date, delete Header
     C     ERPDAT        IFLT      DeleteDate
     C                   DELETE    GPEXRPH
      * and delete all Exception Detail Records:
     C                   EXSR      SRDETAIL
     C                   ENDIF
 
     C                   ENDIF                                                  EndIf Date Null
 
     C                   ENDIF                                                  EndIf Date Null
 
     C                   READ      T_GPEXRPH                              10
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *DTAARA       DEFINE                  LDA
     C                   MOVEL     *BLANK        I#ERMS           50
      *
      * Get Current Time Stamp:
     C                   CALL      'ZAGENTS'
     C                   PARM                    NEWTIM           26
     C                   MOVEL     NEWTIM        TimeStamp
      * Get Global System Value - Exception Reporting Retention Period
 
     C                   CALLB     'GPAOSVALR0'
     C                   PARM      *BLANKS       PRtCd             7
     C                   PARM                    PSysVal01
     C                   PARM                    PCurSet01
     C                   PARM                    PSysVal02
     C                   PARM                    PCurSet02
     C                   PARM                    PSysVal03
     C                   PARM                    PCurSet03
     C                   PARM                    PSysVal04
     C                   PARM                    PCurSet04
     C                   PARM                    PSysVal05
     C                   PARM                    PCurSet05
     C                   PARM                    PSysVal06
     C                   PARM                    PCurSet06
     C                   PARM                    PSysVal07
     C                   PARM                    PCurSet07
     C                   PARM                    PSysVal08
     C                   PARM                    PCurSet08
     C                   PARM                    PSysVal09
     C                   PARM                    PCurSet09
     C                   PARM                    PSysVal10
     C                   PARM                    PCurSet10
 
     C**********         EVAL      RetentionDays = 99999                                      BG4444
     C                   EVAL      RetentionDays = 10000                                      BG4444
 
     C                   IF        PRtCd = *BLANKS
     C                   MOVEL     PCurSet01     RetentionDays     5 0
     C                   ELSE
 
     C                   IF        PRtCd <> '*NRF'
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'GPSVALPD'
     C                   EVAL      DBase = 102
     C                   EVAL      DBKey = PSysVal01
     C                   EVAL      DBPgm = 'GOEXRPTIDY'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDIF
      * Get Zone
 
      /COPY GOCPYSRC,GOGETZONE
      *
      ** Access Bank Details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG   '     PRTCD             7
     C                   PARM      '*FIRST '     POPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C     PRTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   Z-ADD     001           DBASE
     C                   MOVEL     *BLANKS       DBKEY
     C                   MOVEL     'BANK'        DBKEY
     C                   MOVEL     'GOEXRPTIDY'  DBPGM
     C                   MOVE      '1'           *INU7
     C                   MOVE      '1'           *INU8
     C                   MOVE      '1'           *INLR
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      * Calculate Deletion date using System Value Retention Period:
     C     BJRDNB        SUB       RetentionDays WorkDays          5 0
      *                                                                                       BG4444
      ** Deletion Date must not be negative:                                                  BG4444
     C     WorkDays      IFLE      0                                                          BG4444
     C                   Z-ADD     10000         WorkDays                                     BG4444
     C                   ENDIF                                                                BG4444
      *                                                                                       BG4444
      ** WorkDays is in the form of a Midas Day Number.                                       BG4444
      ** Need to convert it to an SQL formatted number e.g 23-SEP-2004                        BG4444
      *
     C                   Z-ADD     WorkDays      @@DAYN
     C                   EXSR      ZDATE9
     C                   MOVEL     DateOut       WDateOut         10
     C                   EVAL      DeleteDate = %DATE(WDateOut:*ISO0)
 
     C                   ENDSR
      ********************************************************************
      * ZDATE10
      ********************************************************************
     C     ZDATE10       BEGSR
     C                   CALLB     'ZDATE10'
     C                   PARM                    ZWDTIN
     C                   PARM                    ZZMDNO            5 0
     C                   ENDSR
      *****************************************************************
      *****************************************************************
      /SPACE 5
      ********************************************************************
      * ZDATE9
      ********************************************************************
     C     ZDATE9        BEGSR
     C                   CALLB     'ZDATE9'
     C                   PARM                    @@DAYN
     C                   PARM                    DateOut
     C                   PARM                    @@RTN             1
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      *                                                               *
      * SRDETAIL - Delete all Detail records for this header record.  *
      *                                                               *
      *****************************************************************
     C     SRDETAIL      BEGSR
     C     ERID          CHAIN     GPEXRPD                            11
     C     *IN11         DOWEQ     '0'
     C                   DELETE    GPEXRPD
     C     ERID          CHAIN     GPEXRPD                            11
     C                   ENDDO
 
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
     C                   DUMP
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
