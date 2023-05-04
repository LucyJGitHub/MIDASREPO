     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2023')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SF Menu Access Audit Log Housekeeping')          *
      *****************************************************************
      *                                                               *
      *  Midas - Security Profile Facility                            *
      *                                                               *
      *  SF000500 - Menu Item Access Audit log Housekeeping           *
      *                                                               *
      *  (c) Finastra Systems Technology, Inc. 2023                   *
      *                                                               *
      *  Last Amend No. CSF014  *CREATE    Date 16Feb23               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSF014 - Menu Item Access Audit Log Housekeeping             *
      *                                                               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  F U N C T I O N  O F  I N D I C A T O R S                    *
      *                                                               *
      *    10         Record not found on GPAUMNPD                    *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *PSSR - Error processing                                      *
      * *INZSR - Initialise                                           *
      * SRSELECT - Select Access Log Audit records for deletion       *
      *                                                               *
      *****************************************************************

     FSFAUMNPD  UF   E             DISK    INFSR(*PSSR)
     F                                     COMMIT

     D @RUN            S              1
     D ZWDTIN          S              8S 0
     D DateOut         S              8S 0
     D @@DAYN          S              5P 0
     D PSysVal01       S             20A   INZ('RetainMenuAccessLog')
     D PCurSet01       S            200A
     D PSysVal02       S             20A   INZ('BrgMidasSystemPrefix')
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
     D DSSFAUMN      E DS                  EXTNAME(SFAUMNPD)
      *
     DDSHEADER         DS            53
     D DSUser                  1     10A
     D DSZone                 11     12A
     D DSMenu                 13     27A
     D DSTmst                          Z

      ** Main Processing
     C                   Exsr      SRSELECT
      *
     C                   MOVE      '1'           *INLR
     C                   COMMIT
      *
     C                   RETURN
      /SPACE 5
      ********************************************************************
      * SRSELECT
      ********************************************************************
     C     SRSELECT      BEGSR

     C                   READ      SFAUMNPD                               10
     C     *IN10         DOWEQ     '0'                                          DoWhile *IN10 = 0

     C                   MOVEL     DSSFAUMN      DSHEADER

      ** Only process records on this zone

     C     ZonePrefix    IFEQ      DsZone

      ** Convert Timestamp to Midas Day No.
     C                   MOVEL     *BLANKS       WORKDATE          8
     C                   EVAL      WORKDATE = %CHAR(DSTmst:*ISO0)
     C                   MOVEL     WORKDATE      ZWDTIN
     C                   EXSR      ZDATE10
     C                   Z-ADD     ZZMDNO        W#Tmst            5 0

      * If timestamp was before the WorkDays (Rundate - Retention days)
     C     W#Tmst        IFLE      WorkDays
     C                   DELETE    SFAUMND0
     C                   ENDIF

     C                   ENDIF

     C                   READ      SFAUMNPD                               10
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

      * Get System Value - Menu Access Audit Log Retention Period

     C                   CALLB     'AOSVALR0'
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

     C                   IF        PRtCd = *BLANKS
     C                   MOVEL     PCurSet01     RetentionDays     3 0
     C                   MOVEL     PCurSet02     ZonePrefix        2
     C                   ELSE

     C                   IF        PRtCd <> '*NRF'
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SDSVLCTD'
     C                   EVAL      DBase = 102
     C                   EVAL      DBKey = PSysVal01
     C                   EVAL      DBPgm = 'SF000500'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   ENDIF
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
     C                   MOVEL     'SF000500'    DBPGM
     C                   MOVE      '1'           *INU7
     C                   MOVE      '1'           *INU8
     C                   MOVE      '1'           *INLR
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      * Calculate Deletion date using System Value Retention Period:
     C     BJRDNB        SUB       RetentionDays WorkDays          5 0

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
