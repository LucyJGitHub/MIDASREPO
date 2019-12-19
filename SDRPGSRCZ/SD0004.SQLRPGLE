     H DEBUG
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD054605
/*STD *  RPGSQLBND                                                    *                     MD054605
/*EXI *  TEXT('Midas SD Initialisation program for CRE009')
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  SD0004    - Initialise new field in Retail Details File      *
      *                                                               *
      *  Phase  - I/C                                                 *
      *                                                               *
      *  Called by: SDC0004                                           *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD054605           Date 17Oct19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 CAP205             Date 23Mar10               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CLE025             Date 20Oct03               *
      *                 CRE009  *Create    Date 06Aug02               *
      *                                                               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD054605 - Deliverable Data Split for SDSVALPD               *
      *  MD046248 - Finastra Rebranding                               *
      *  CAP205 - Teller Related APIs - Account Balance Check         *
      *           (Recompile)                                         *
      *  CLE025 - Credit Lines                                        *
      *  CRE009 - Projected Account Movements for Retail Accounts     *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Indicators list:                                             *
      *                                                               *
      *  89 - READ PF/SDSVALPD                                        *
      *                                                               *
      *****************************************************************
      *
      ** Retail Projected Movements end date per currency
     F*SDSVALL0* UF A E           K DISK                                                    MD054605
      *
      /SPACE 3
      *
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      ** Array containing Copyright statement
      *
      /SPACE 3
      *
     D LDA           E DS           256    EXTNAME(LDA)
      ** Local data area for database error details
      *
     D PSDS           SDS
      ** Program Status Data Structure
      *
     D  UPGM             *PROC
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** Data structures used by access programs SHORT
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** Bank Details
      *
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ** Switchable features                                                                  CLE025
      *                                                                                       CLE025
     D SYSVAL          C                   CONST('ProjectedDaysRetail')
      ** Name of new system value for CRE009
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *              M  A  I  N     P  R  O  G  R  A  M               *
      *                                                               *
      *****************************************************************
      *
      ** Initialization process
      *
     C                   EXSR      #IINIT
      *
      ** Process Output to Report
      *
     C                   EXSR      #IPROC
      *
      ** End Process
      *
     C                   EXSR      #IEND
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  SR/#IINIT - Initialization process                           *
      *                                                               *
      *  Called by: M A I N                                           *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     #IINIT        BEGSR
      *
     C                   MOVEA     CPY@          CPY2@            80
     C                   MOVEL     UPGM          DBPGM
      *
     C     *DTAARA       DEFINE                  LDA                            Dcl LDA
      *
     C                   MOVE      *BLANKS       KSYSV            20
     C                   MOVEL     SYSVAL        KSYSV
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C     @RTCD         IFNE      *BLANK
     C     *LOCK         IN        LDA
     C                   Z-ADD     1             DBASE                          *************
     C                   MOVEL     *BLANKS       DBFILE                         *DB ERROR 01*
     C                   MOVE      'SDBANKPD'    DBFILE                         *************
     C                   MOVEL(P)  '*FIRST  '    DBKEY
     C                   MOVEL(P)  'RE0940'      DBPGM
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *                                                                                       CLE025
      ** Check if enhancement CLE025 (Credit Lines) is on                                     CLE025
      *                                                                                       CLE025
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*VERIFY '    POPTN             7
     C                   PARM      'CLE025'      PSARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *                                                                                       CLE025
     C     PRTCD         IFNE      *BLANKS
     C     PRTCD         ANDNE     '*NRF   '
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '*FIRST  '    DBKEY
     C                   Z-ADD     2             DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *                                                                                       CLE025
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CLE025            1
     C                   ELSE
     C                   MOVE      'N'           CLE025
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  SR/#IPROC - Details Extract                                  *
      *                                                               *
      *  Called by: M A I N                                           *
      *                                                               *
      *  Calls:                                                       *
      *                                                               *
      *****************************************************************
     C     #IPROC        BEGSR
      *
      ** Check if record exists in file
     C*****KSYSV         CHAIN     SDSVALL0                           89                    MD054605
      *
     C******IN89         IFEQ      *ON                                                      MD054605
     C**********         MOVEL     SYSVAL        GISVAL                                     MD054605
     C**********         MOVE      'RE'          GIMMOD                                     MD054605
     C**********         MOVEL     'RETAIL'      GIMMSN                                     MD054605
     C**********         MOVE      'N'           GIHELP                                     MD054605
     C**********         MOVE      'CRE009'      GISWCH                                     MD054605
     C**********         MOVE      'R'           GIJUST                                     MD054605
     C**********         MOVE      '3'           GIDLEN                                     MD054605
     C**********         Z-ADD     BJRDNB        GILCD                                      MD054605
     C**********         MOVEL     'I'           GILCT                                      MD054605
     C**********         MOVE      '4'           GIVAL                                      MD054605
     C**********         MOVE      '4'           GIDFT                                      MD054605
      *                                                                                       CLE025
     C*****CLE025        IFEQ      'Y'                                                      MD054605
     C**********         MOVE      'CLE025'      GISWCH                                     MD054605
     C**********         MOVEL(P)  '009'         GIVAL                                      MD054605
     C**********         MOVEL(P)  '009'         GIDFT                                      MD054605
     C**********         ENDIF                                                              MD054605
      *                                                                                       CLE025
     C**********         WRITE     @SVALL0
      *                                                                                     MD054605
      ** Set default values if it exists
      *
     C**********         ELSE                                                               MD054605
     C**********         MOVE      *BLANKS       @GIVAL          200                        MD054605
     C**********         MOVE      *BLANKS       @GIDFT          200                        MD054605
     C**********         MOVE      '4'           @GIVAL          200                        MD054605
     C**********         MOVE      '4'           @GIDFT          200                        MD054605
     C**********         MOVE      @GIVAL        GIVAL                                      MD054605
     C**********         MOVE      @GIDFT        GIDFT                                      MD054605
      *                                                                                       CLE025
     C/EXEC SQL                                                                             MD054605
     C+ update SDSVLXTD                                                                     MD054605
     C+  SET GIVAL = '4'                                                                    MD054605
     C+ where GISVAL = :KSYSV                                                               MD054605
     C/END-EXEC                                                                             MD054605
     C/EXEC SQL                                                                             MD054605
     C+ update SDSVLCTD                                                                     MD054605
     C+  SET GIDFT = '4'                                                                    MD054605
     C+ where GISVAL = :KSYSV                                                               MD054605
     C/END-EXEC                                                                             MD054605
     C     CLE025        IFEQ      'Y'
     C**********         MOVE      'CLE025'      GISWCH                                     MD054605
     C**********         MOVEL(P)  '009'         GIVAL                                      MD054605
     C**********         MOVEL(P)  '009'         GIDFT                                      MD054605
     C/EXEC SQL                                                                             MD054605
     C+ update SDSVLXTD                                                                     MD054605
     C+  SET GIVAL = '009'                                                                  MD054605
     C+ where GISVAL = :KSYSV                                                               MD054605
     C/END-EXEC                                                                             MD054605
     C/EXEC SQL                                                                             MD054605
     C+ update SDSVLCTD                                                                     MD054605
     C+  SET GIDFT = '009'                                                                  MD054605
     C+ where GISVAL = :KSYSV                                                               MD054605
     C/END-EXEC                                                                             MD054605
     C                   ENDIF
      *                                                                                       CLE025
     C**********         UPDATE    @SVALL0                                                  MD054605
     C**********         ENDIF                                                              MD054605
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  SR/#IEND  - End Processing                                   *
      *                                                               *
      *  Called by: M A I N                                           *
      *                                                               *
      *  Calls:                                                       *
      *                                                               *
      *****************************************************************
     C     #IEND         BEGSR
      *
     C                   MOVE      *ON           *INLR
     C                   RETURN
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program exception error routine                     *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *  Called by: (**calling routines**)                            *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
      *
     C     @RUN          IFEQ      *BLANK
     C                   MOVE      'Y'           @RUN              1
     C                   SETON                                        U7U8LR
     C                   DUMP
     C                   ENDIF
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
**  CPY@
(c) Finastra International Limited 2002
