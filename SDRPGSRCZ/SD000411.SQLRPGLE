      *****************************************************************
     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2019')
      *****************************************************************
/**** *  RPGBASEBND                                                   *                     MD054605
/*STD *  RPGSQLBND                                                    *                     MD054605
/*EXI *  TEXT('Midas SD Validate Interface User if Active')           *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000411 - Validate Interface User if Active                 *
      *                                                               *
      *  Function:  This program validates a User if attached to      *
      *             a live Interface.                                 *
      *                                                               *
      *  (c) Finastra International Limited 2019                      *
      *                                                               *
      *  Last Amend No. MD054605           Date 17Oct19               *
      *  Prev Amend No. MD053314 *CREATE   Date 30Apr19               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD054605 - Deliverable Data Split for SDSVALPD               *
      *  MD053314 - Ensure user cannot be deleted when attached to    *
      *             an Interface.                                     *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SrInsert - Insert a Validation List Entry                    *
      *  SrModify - Modify a validation List Entry                    *
      *  SrDelete - Delete a Validation list Entry                    *
      *  SrFind - Find a Validation list Entry                        *
      *  *PSSR     - Error processing                                 *
      *  *INZSR    - Initialise                                       *
      *                                                               *
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      ** Interface Password Validation Core File.
     FSDIPVCL0  IF   E           K DISK    INFSR(*pssr)
     F*SDSVALL0* IF   E           K DISK    INFSR(*pssr)                                    MD054605
     F*GPSVALL0* IF   E           K DISK    INFSR(*pssr)                                    MD054605
     F**********                           RENAME(@SVALL0:@SVALR0)                          MD054605
     FSDCWCDPD  IF   E             DISK    INFSR(*pssr)
     FSDCORMPD  IF   E             DISK    INFSR(*pssr)
     FSDFONTPD  IF   E             DISK    INFSR(*pssr)
     FSDMGMEPD  IF   E             DISK    INFSR(*pssr)

      *****************************************************************
      /EJECT
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ Prototypes                           ¦
      ** ¦ ==========                           ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

      ** "Entry ID" information.
     D EIDINFO         DS
      ** Length of entry ID.
     D  EIDLen                 1      4B 0 INZ(10)
      ** CCSID of entry ID.
     D  EIDccsid               5      8B 0 INZ(9)
      ** Entry ID.
     D  EIDdata                9    108
     D SDSVAL        E DS                  EXTNAME(SDSVLJW0)                                MD054605
     D NullIndsG       s              5i 0 dim(21)                                          MD054605
     D GPSVAL        E DS                  EXTNAME(GPSVLJW0)                                MD054605
     D                                     PREFIX(G)                                        MD054605
     D NullInds        s              5i 0 dim(16)                                          MD054605

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D WRun            S              1A
     D BANKF01         S             20A   INZ('AcctRulesUser')
     D BANKF02         S             20A   INZ('AcctRulesIntUserAMAD')
     D BANKF03         S             20A   INZ('ForecastUsr')
     D BANKF04         S             20A   INZ('MQPDPUserIDCOB')
     D BANKF05         S             20A   INZ('JMSTechnicalUser')
     D BANKF06         S             20A   INZ('BankFusionUserName')
     D KYC01           S             20A   INZ('KYCDBUser')
     D FRS01           S             20A   INZ('FTPUserLogin')
     D PEA01           S             20A   INZ('PEASystemUsername')
     D PEA02           S             20A   INZ('PEAFTPUserID')

      ** Constants used to identify action code to be performed.
     D ACTIVE          C                   CONST('*ACTIVE')

      *****************************************************************
      /EJECT
      *****************************************************************
      ** MAIN - Processing
      *****************************************************************
      *
      ** Perform check of User ID across the selected Interface
     C     PID           SETLL     SDIPVCL0
     C     PID           READE     SDIPVCL0                               51
     C     *IN51         DOWEQ     *OFF
     C     PRetCd        ANDEQ     *BLANKS
      *
     C                   IF        ICUFLD = 'GIVAL'
      * Bankfusion, KYC, FRS Regulatory, PEA
     C                   SELECT
     C                   WHEN      ICINTF = 'BANKFUSION'
     C*****BANKF01       CHAIN     SDSVALL0                           52                    MD054605
     C/EXEC SQL                                                                             MD054605
     C+ SELECT *                                                                            MD054605
     C+ into :SDSVAL :NullInds                                                              MD054605
     C+ from SDSVLJW0                                                                       MD054605
     C+ where GISVAL = :BANKF01                                                             MD054605
     C/END-EXEC                                                                             MD054605
     C     PUser         IFEQ      GIVAL
     C                   EVAL      PRetCd = ACTIVE
     C                   ENDIF
      *
     C*****BANKF02       CHAIN     SDSVALL0                           52                    MD054605
     C/EXEC SQL                                                                             MD054605
     C+ SELECT *                                                                            MD054605
     C+ into :SDSVAL :NullInds                                                              MD054605
     C+ from SDSVLJW0                                                                       MD054605
     C+ where GISVAL = :BANKF02                                                             MD054605
     C/END-EXEC                                                                             MD054605
     C     PUser         IFEQ      GIVAL
     C                   EVAL      PRetCd = ACTIVE
     C                   ENDIF
      *
     C*****BANKF03       CHAIN     SDSVALL0                           52                    MD054605
     C/EXEC SQL                                                                             MD054605
     C+ SELECT *                                                                            MD054605
     C+ into :SDSVAL :NullInds                                                              MD054605
     C+ from SDSVLJW0                                                                       MD054605
     C+ where GISVAL = :BANKF03                                                             MD054605
     C/END-EXEC                                                                             MD054605
     C     PUser         IFEQ      GIVAL
     C                   EVAL      PRetCd = ACTIVE
     C                   ENDIF
      *
     C*****BANKF04       CHAIN     SDSVALL0                           52                    MD054605
     C/EXEC SQL                                                                             MD054605
     C+ SELECT *                                                                            MD054605
     C+ into :SDSVAL :NullInds                                                              MD054605
     C+ from SDSVLJW0                                                                       MD054605
     C+ where GISVAL = :BANKF04                                                             MD054605
     C/END-EXEC                                                                             MD054605
     C     PUser         IFEQ      GIVAL
     C                   EVAL      PRetCd = ACTIVE
     C                   ENDIF
      *
     C*****BANKF05       CHAIN     SDSVALL0                           52                    MD054605
     C/EXEC SQL                                                                             MD054605
     C+ SELECT *                                                                            MD054605
     C+ into :SDSVAL :NullInds                                                              MD054605
     C+ from SDSVLJW0                                                                       MD054605
     C+ where GISVAL = :BANKF05                                                             MD054605
     C/END-EXEC                                                                             MD054605
     C     PUser         IFEQ      GIVAL
     C                   EVAL      PRetCd = ACTIVE
     C                   ENDIF
      *
     C*****BANKF06       CHAIN     @SVALR0                            52                    MD054605
     C/EXEC SQL                                                                             MD054605
     C+ SELECT *                                                                            MD054605
     C+ into :GPSVAL :NullIndsG                                                             MD054605
     C+ from GPSVLJW0                                                                       MD054605
     C+ where GISVAL = :BANKF06                                                             MD054605
     C/END-EXEC                                                                             MD054605
     C*****PUser         IFEQ      GIVAL                                                    MD054605
     C     PUser         IFEQ      GGIVAL                                                   MD054605
     C                   EVAL      PRetCd = ACTIVE
     C                   ENDIF
      * KYC
     C                   WHEN      ICINTF = 'COMPLKYC'
     C*****KYC01         CHAIN     SDSVALL0                           52                    MD054605
     C/EXEC SQL                                                                             MD054605
     C+ SELECT *                                                                            MD054605
     C+ into :SDSVAL :NullInds                                                              MD054605
     C+ from SDSVLJW0                                                                       MD054605
     C+ where GISVAL = :KYC01                                                               MD054605
     C/END-EXEC                                                                             MD054605
     C     PUser         IFEQ      GIVAL
     C                   EVAL      PRetCd = ACTIVE
     C                   ENDIF
      * FRS
     C                   WHEN      ICINTF = 'FRSREGULATORY'
     C*****FRS01         CHAIN     SDSVALL0                           52                    MD054605
     C/EXEC SQL                                                                             MD054605
     C+ SELECT *                                                                            MD054605
     C+ into :SDSVAL :NullInds                                                              MD054605
     C+ from SDSVLJW0                                                                       MD054605
     C+ where GISVAL = :FRS01                                                               MD054605
     C/END-EXEC                                                                             MD054605
     C     PUser         IFEQ      GIVAL
     C                   EVAL      PRetCd = ACTIVE
     C                   ENDIF
      * PEA
     C                   WHEN      ICINTF = 'PEA'
     C*****PEA01         CHAIN     SDSVALL0                           52                    MD054605
     C/EXEC SQL                                                                             MD054605
     C+ SELECT *                                                                            MD054605
     C+ into :SDSVAL :NullInds                                                              MD054605
     C+ from SDSVLJW0                                                                       MD054605
     C+ where GISVAL = :PEA01                                                               MD054605
     C/END-EXEC                                                                             MD054605
     C     PUser         IFEQ      GIVAL
     C                   EVAL      PRetCd = ACTIVE
     C                   ENDIF
     C*****PEA02         CHAIN     SDSVALL0                           52                    MD054605
     C/EXEC SQL                                                                             MD054605
     C+ SELECT *                                                                            MD054605
     C+ into :SDSVAL :NullInds                                                              MD054605
     C+ from SDSVLJW0                                                                       MD054605
     C+ where GISVAL = :PEA02                                                               MD054605
     C/END-EXEC                                                                             MD054605
     C     PUser         IFEQ      GIVAL
     C                   EVAL      PRetCd = ACTIVE
     C                   ENDIF
     C                   ENDSL
      *
     C                   ELSE
      *
     C                   SELECT
      * Compliance Watch
     C                   WHEN      ICFNAM = 'SDCWCDPD'
     C     1             CHAIN     SDCWCDPD                           52
     C     PUser         IFEQ      W1CAUS
     C                   EVAL      PRetCd = ACTIVE
     C                   ENDIF
     C
      * Corr Manager
     C                   WHEN      ICFNAM = 'SDCORMPD'
     C     1             CHAIN     SDCORMPD                           52
     C     PUser         IFEQ      CMFUSR
     C                   EVAL      PRetCd = ACTIVE
     C                   ENDIF
      * FONTIS
     C                   WHEN      ICFNAM = 'SDFONTPD'
     C     1             CHAIN     SDFONTPD                           52
     C     PUser         IFEQ      F8MUFS
     C                   EVAL      PRetCd = ACTIVE
     C                   ENDIF
      * Swift Alliance
     C                   WHEN      ICFNAM = 'SDMGMEPD'
     C     1             CHAIN     SDMGMEPD                           52
     C     PUser         IFEQ      ENSUSR
     C                   EVAL      PRetCd = ACTIVE
     C                   ENDIF
      *
     C                   ENDSL
     C                   ENDIF
      *
     C     PID           READE     SDIPVCL0                               51
     C                   ENDDO

     C                   EVAL      *INLR = *ON

     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation Routine                      *
      *                                                               *
      *  Calls: *PSSR                                                 *
      *                                                               *
      *****************************************************************

     C     *INZSR        BEGSR

     C     *ENTRY        PLIST
      ** Interface.
     C                   PARM                    PID              20
      ** Interface User.
     C                   PARM                    PUser            50
      ** Return Code
     C                   PARM                    PRetCd            7

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR - Program exception error routine                      *
      *                                                               *
      *  Called By: Automatically If a program error occurs,          *
      *             or directly by the program code using EXSR.       *
      *             This subroutine DUMPs the program just once.      *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************

     C     *PSSR         BEGSR

     C                   IF        WRun = *BLANKS

     C                   EVAL      WRun = 'Y'
     C                   DUMP

     C                   ENDIF

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN

     C                   ENDSR

      *****************************************************************
