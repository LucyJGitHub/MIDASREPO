     H DEBUG
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas LE APR Trigger Program for LEFEED')              *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LE6005 - Midas LE APR Trigger Program for LEFEED             *
      *                                                               *
      *  Function:  This program applies an insert and amend trigger  *
      *             to PF/LEFEED.                                     *
      *                                                               *
      *  Called By:                                                   *
      *                                                               *
      *  (c) Finastra International Limited 2016                      *
      *                                                               *
      *  Last Amend No. CER050  *Create    Date 16Jun19               *
      *  Prev Amend No. xxxxxx             Date ddMmmyy               *
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
     D PPARM1          DS          5000
      *
      * Physical file name/library/member
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
     D  FERECB                 1      1
     D  FEFCOB                24     25  0
     D  FEFCCB                28     30
     D  FEFAMB                31     37P 0
     D  FEPSTB                38     40P 0
     D  FEPENB                41     43P 0
     D  FEPYOB                44     44
     D QFILEA          DS          2500
      * "After image of file"
     D  FERECA                 1      1
     D  FELOAN                16     21
     D  FEFCOA                24     25  0
     D  FEFCCA                28     30
     D  FEFAMA                31     37P 0
     D  FEPSTA                38     40P 0
     D  FEPENA                41     43P 0
     D  FEPYOA                44     44
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
      * after each database error handling
      *                                     134 141 DBFILE
      *         Defines:                     142 170 DBKEY
      *                                      171 180 DBPGM
      *                                      181 1830DBASE
      *
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *            M A I N   P R O C E S S I N G                      *
      *                                                               *
      * Calls: SRINIT - Initial processing                            *
      *                                                               *
      *****************************************************************
      *
      * Initial processing
     C                   EXSR      SRINIT
      *
      * If a record is added to LEFEED and the fee relates to the loan
      * i.e. the loan number is not 0
     C     QEVENT        IFEQ      '1'
     C     FELOAN        ANDNE     *Blanks
     C                   CALL      'LEC6002'                            89
     C                   PARM                    PRCOD             7
     C                   PARM                    FELOAN
      *
     C                   ENDIF
      *
      * If a record is updated in LEFEED, check to see what fields
      * have been changed and call LEC6002 if necessary
     C     QEVENT        IFEQ      '3'
     C     FELOAN        ANDNE     *Blanks
      *
     C     FERECA        IFNE      FERECB
     C     FEFCOA        ORNE      FEFCOB
     C     FEFCCA        ORNE      FEFCCB
     C     FEFAMA        ORNE      FEFAMB
     C     FEPSTA        ORNE      FEPSTB
     C     FEPENA        ORNE      FEPENB
     C     FEPYOA        ORNE      FEPYOB
     C                   CALL      'LEC6002'                            89
     C                   PARM                    PRCOD             7
     C                   PARM                    FELOAN
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      *
     C     PRCOD         IFNE      *BLANKS
     C     *IN89         OREQ      *ON
     C                   Z-ADD     1             DBASE                          ** DB ERR 01 **
     C                   MOVEL     'LEFEED'      DBFILE                         ***************
     C                   MOVEL     ##PGM         DBPGM
     C                   DUMP
     C                   CALL      'DBERRCTL'
     C                   SETON                                        U7U8LR
     C                   ENDIF
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
