     H DEBUG
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas LE APR Trigger Program for LOAMSDK')             *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LE6004 - Midas LE APR TRIGGER PROGRAM FOR LOAMSDK            *
      *                                                               *
      *  Function:  This program applies an insert and amend trigger  *
      *             to PF/LOAMSDK.                                    *
      *                                                               *
      *                                                               *
      *  (c) Finastra International Limited 2016                      *
      *                                                               *
      *  Last Amend No. CER050  *Create    Date 16Jun19               *
      *  Prev Amend No. XXXXXX             Date ddMmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER050 - Annualised Percentage Rate (APR)                    *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      *  SRINIT - Initial Processing                                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *                                                               *
      *   LR - Last Record Indicator                                  *
      *                                                               *
      *****************************************************************
      *
      * Array containing Copyright statement
     D ARRCPY          S             80    DIM(1) CTDATA PERRCD(1)
      *
      * Physical file name/library/member
     D PPARM1          DS          5000
      *
     D  QFNAME                 1     10
     D  QLNAME                11     20
     D  QMNAME                21     30
      * Trigger Event ('1'=Insert, '3'=Update)
     D  QEVENT                31     31
      * Trigger Time ('1'=After, '2'=Before)
     D  QTTIME                32     32
      * Commit Lock Level ('0'=*NONE, '1'=*CHG, '2'=*CS, '3'=*ALL)
     D  QCOMIT                33     33
      * CCSID
     D  QCCSID                37     40B 0
      * Offset to original record
     D  Q1ROFF                49     52B 0
      * Length of the original record
     D  Q1RLEN                53     56B 0
      * Offset to original record null byte map
     D  Q1NOFF                57     60B 0
      * Length of the original null byte map
     D  Q1NLEN                61     64B 0
      * Offset to new record
     D  Q2ROFF                65     68B 0
      * Length of new record
     D  Q2RLEN                69     72B 0
      * Offset to the new record null byte map
     D  Q2NOFF                73     76B 0
      * Length of null byte map
     D  Q2NLEN                77     80B 0
      *
     D PPARM2          DS
     D  QLENG                  1      4B 0
     D QFILEB          DS          2500
      * "Before image of file"
     D  RECIB                  1      1
     D  AMTPB                 23     24
     D  BRTTB                 27     28  0
     D  RTSPB                 35     37
     D  FEAMB                 59     65P 0
     D  LSMDB                267    269P 0
     D QFILEA          DS          2500
      * "After image of file"
     D  RECIA                  1      1
     D  LNRFA                  2      7
     D  AMTPA                 23     24
     D  BRTTA                 27     28  0
     D  RTSPA                 35     37
     D  FEAMA                 59     65P 0
     D  LSMDA                267    269P 0
      *
      * Program Status Data Structure - gives Job/Workstation name and
      * User ID
     D PSDS           SDS
     D  ##PGM            *PROC
     D  JOB                  244    253
     D  WSID                 244    246
     D  USER                 254    263
      *
      * Local data area for database error details
     D LDA           E DS           256    EXTNAME(LDA)
     D  W24          E                     EXTFLD(SPARE)
      *
      * *LOCK IN LDA immediately before and OUT LDA immediately
      * after each database error handling.
      *                                     134 141 DBFILE
      *        Defines:                     142 170 DBKEY
      *                                     171 180 DBPGM
      *                                     181 1830DBASE
      *
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *            M A I N   P R O C E S S I N G                      *
      *                                                               *
      * Calls: SRINIT Initial processing                              *
      *                                                               *
      *****************************************************************
      *
      * Initial processing
     C                   EXSR      SRINIT
      *
      * If a record is added to LOAMSDK and the loan amendment type is
      * PI, SC, BC or MR call LEC6002
     C     QEVENT        IFEQ      '1'
     C     AMTPA         IFEQ      'PI'
     C     AMTPA         OREQ      'SC'
     C     AMTPA         OREQ      'BC'
     C     AMTPA         OREQ      'MR'
     C                   CALL      'LEC6002'                            89
     C                   PARM                    PRCOD             7
     C                   PARM                    LNRFA
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      * If a record is updated in LOAMSDK, check to see what fields
      * have been changed and call LEC6002 if necessary
     C     QEVENT        IFEQ      '3'
      *
     C     AMTPA         IFEQ      'PI'
     C     AMTPA         OREQ      'SC'
     C     AMTPA         OREQ      'BC'
     C     AMTPA         OREQ      'MR'
      *
     C     RECIA         IFNE      RECIB
     C     BRTTA         ORNE      BRTTB
     C     RTSPA         ORNE      RTSPB
     C     FEAMA         ORNE      FEAMB
     C     LSMDA         ORNE      LSMDB
     C                   CALL      'LEC6002'                            89
     C                   PARM                    PRCOD             7
     C                   PARM                    LNRFA
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     PRCOD         IFNE      *BLANKS
     C     *IN89         OREQ      *ON
     C                   Z-ADD     1             DBASE                          ** DB ERR 01 **
     C                   MOVEL     'LOAMSDK'     DBFILE                         ***************
     C                   MOVEL     ##PGM         DBPGM
     C                   DUMP
     C                   CALL      'DBERRCTL'
     C                   SETON                                        U7U8LR
     C                   ENDIF
      *
      * Exit from program
     C                   MOVE      *ON           *INLR
     C                   RETURN
      *
      /EJECT
      *****************************************************************
      * SRINIT - Initial Processing                                   *
      * Calls:                                                        *
      * Called by: Main Processing                                    *
      *****************************************************************
      *
     C     SRINIT        BEGSR                                                  ** SRINIT **
      *
      * Trigger Program parameters
     C     *ENTRY        PLIST
     C                   PARM                    PPARM1
     C                   PARM                    PPARM2
      *
      * Set up copyright parameter
     C                   MOVEA     ARRCPY        WCPY             80
      *
      * Using offsets and lengths provided get the before and after
      * images
     C     Q1ROFF        ADD       1             Q                 5 0
     C     Q1RLEN        SUBST     PPARM1:Q      QFILEB
     C     Q2ROFF        ADD       1             Q
     C     Q2RLEN        SUBST     PPARM1:Q      QFILEA
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
** ARRCPY
(C) Finastra International Limited 2016
