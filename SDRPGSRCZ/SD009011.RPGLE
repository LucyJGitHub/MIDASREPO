     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD & ICD Initialisation program')                *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  RPGLE/SD009011 - SD & ICD Initialisation program             *
      *                                                               *
      *  Called from: Command Entry line                              *
      *               One-time set-up program.                        *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD061008           Date 31Dec21               *
      *  Prev Amend No. CLE071             Date 18Jul18               *
      *                 MD046248           Date 27Oct17               *
      *                 CLE134             Date 01Aug12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 CRE026             Date 24May06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4.01 -------------------------------------------*
      *                 CAS001  *CREATE    Date 23Nov01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD061008 - Deliverable Data Split for SDFCTLPA and GPFCTLPA  *
      *  CLE071 - Value Dating of Rate Changes to Fees (Recompile)    *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CRE026 - Consumer Banking (Recompile)                        *
      *  CAS001 - Net Present Value (NPV) Accounting                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of Indicators                                            *
      *                                                               *
      *  40 - Chain to file SDFCTLL0                                  *
      *  50 - Error in writing to file SDFCTLPA                       *
      *  60 - End of File                                             *
      *                                                               *
      *  LR - Last record indicator (program termination)             *
      *  U7 and U8 - DB error processing indicator                    *
      *                                                               *
      *****************************************************************
      /SPACE
      *****************************************************************
      *                                                               *
      *  Subroutine Index                                             *
      *                                                               *
      *  *PSSR      - Program exception error routine                 *
      *  *INZSR     - Initial First Cycle processing                  *
      *                                                               *
      *****************************************************************
     FSDDEALL0  UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
      ** Midas SD Dealing ICD data update

     FSDCLNDL0  UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
      ** Midas SD Customer Lending ICD Update

     F*SDFCTLL0* UF A E           K DISK    INFSR(*PSSR)                                    MD061008
     F**********                           COMMIT                                           MD061008
      ** Midas SD Standing Data Controls

      ** Array containing Copyright statement
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
     D/COPY WNCPYSRC,SDH00590

      ** Short Data Structure for Access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)

      ** Local data area for database error details
     D LDA           E DS           256    EXTNAME(LDA)

      ** Program Status Data Structure
     D PSDS           SDS

     D  ##PGM            *PROC
     D  JOB                  244    253
     D  WSID                 244    246
     D  USER                 254    263

      ** Work Variables
     D WDUMP           S              1A
     D WFNAME          S             10A

      ** Main Processing

      ** Initialise new fields in Dealing ICD Files

     C                   READ      SDDEALL0                               60

     C                   IF        *IN60 = *OFF
     C                   EVAL      BNNPVM = *blanks
     C                   EVAL      BNBCYC = *blanks
     C                   EVAL      BNDCMT = *zeros
     C                   EVAL      BNBCPL = *blanks
     C                   UPDATE    @BNREEH
     C                   COMMIT
     C                   ELSE

     ** If file is empty, database error

     C     *LOCK         IN        LDA
     C                   MOVEL     'SDDEALPD'    DBFILE
     C                   MOVEL     '001'         DBASE
     C                   MOVEL     '*FIRST'      DBKEY
     C                   MOVEL     'SD009011'    DBPGM
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C/COPY WNCPYSRC,SDH00591
      ** Initialise new fields in Customer Lending ICD Files

     C                   READ      SDCLNDL0                               60

     C                   IF        *IN60 = *OFF
     C                   EVAL      BPBCPL = *blanks
     C                   UPDATE    @BPREEQ
     C                   COMMIT
     C                   ELSE

     ** If file is empty, database error

     C     *LOCK         IN        LDA
     C                   MOVEL     'SDCLNDPD'    DBFILE
     C                   MOVEL     '002'         DBASE
     C                   MOVEL     '*FIRST'      DBKEY
     C                   MOVEL     'SD009011'    DBPGM
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C/COPY WNCPYSRC,SDH00592

      ** Insert new record SDYLDCPD to SDFCTLPA

     C                   EVAL      WFNAME = 'SDYLDCPD'
     C*****WFNAME        CHAIN     SDFCTLL0                           40                    MD061008
     C                   CALL      'SD000119'                                               MD061008
     C                   PARM      '*RTV'        ZMODE             4                        MD061008
     C                   PARM      WFNAME        AHFLNM           10                        MD061008
     C                   PARM      0             AHNORC            5 0                      MD061008
     C                   PARM      0             AHNOIN            5 0                      MD061008
     C                   PARM      0             AHNOAM            5 0                      MD061008
     C                   PARM      0             AHNODL            5 0                      MD061008
     C                   PARM      *BLANKS       ZRETRN           10                        MD061008
      *                                                                                     MD061008
     C                   SETOFF                                       40                    MD061008
     C     ZRETRN        IFNE      *BLANKS                                                  MD061008
     C                   SETON                                        40                    MD061008
     C                   ENDIF                                                              MD061008
      *                                                                                     MD061008

     C                   IF        *IN40 = *ON
     C                   EVAL      AHFLNM = WFNAME
     C                   EVAL      AHNORC = *ZERO
     C                   EVAL      AHNOIN = *ZERO
     C                   EVAL      AHNOAM = *ZERO
     C                   EVAL      AHNODL = *ZERO
     C**********         WRITE     @AHREAU                              50                  MD061008

     C**********         IF        *IN50 = *ON                                              MD061008
     C******LOCK         IN        LDA                                                      MD061008
     C**********         MOVEL     'SDFCTLPA'    DBFILE                                     MD061008
     C**********         MOVEL     '003'         DBASE                                      MD061008
     C**********         MOVEL     '*WRITE'      DBKEY                                      MD061008
     C**********         MOVEL     'SD009011'    DBPGM                                      MD061008
     C**********         OUT       LDA                                                      MD061008
     C**********         EXSR      *PSSR                                                    MD061008
     C**********         ELSE                                                               MD061008
     C**********         COMMIT                                                             MD061008
     C**********         ENDIF                                                              MD061008

     C                   ENDIF

      ** Insert new record SDYLDRPD to SDFCTLPA

     C                   EVAL      WFNAME = 'SDYLDRPD'
     C*****WFNAME        CHAIN     SDFCTLL0                           40                    MD061008
     C                   CALL      'SD000119'                                               MD061008
     C                   PARM      '*RTV'        ZMODE             4                        MD061008
     C                   PARM      WFNAME        AHFLNM           10                        MD061008
     C                   PARM      0             AHNORC            5 0                      MD061008
     C                   PARM      0             AHNOIN            5 0                      MD061008
     C                   PARM      0             AHNOAM            5 0                      MD061008
     C                   PARM      0             AHNODL            5 0                      MD061008
     C                   PARM      *BLANKS       ZRETRN           10                        MD061008
      *                                                                                     MD061008
     C                   SETOFF                                       40                    MD061008
     C     ZRETRN        IFNE      *BLANKS                                                  MD061008
     C                   SETON                                        40                    MD061008
     C                   ENDIF                                                              MD061008
      *                                                                                     MD061008

     C                   IF        *IN40 = *ON
     C                   EVAL      AHFLNM = WFNAME
     C                   EVAL      AHNORC = *ZERO
     C                   EVAL      AHNOIN = *ZERO
     C                   EVAL      AHNOAM = *ZERO
     C                   EVAL      AHNODL = *ZERO
     C**********         WRITE     @AHREAU                              50                  MD061008

     C**********         IF        *IN50 = *ON                                              MD061008
     C******LOCK         IN        LDA                                                      MD061008
     C**********         MOVEL     'SDFCTLPA'    DBFILE                                     MD061008
     C**********         MOVEL     '004'         DBASE                                      MD061008
     C**********         MOVEL     '*WRITE'      DBKEY                                      MD061008
     C**********         MOVEL     'SD009011'    DBPGM                                      MD061008
     C**********         OUT       LDA                                                      MD061008
     C**********         EXSR      *PSSR                                                    MD061008
     C**********         ELSE                                                               MD061008
     C**********         COMMIT                                                             MD061008
     C**********         ENDIF                                                              MD061008

     C                   ENDIF

      ** End of Program

     C                   EVAL      *INLR = *ON
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Subroutine for Initial First Cycle processing        *
      *                                                               *
      * Called by: Automatically called upon entry to the module      *
      *                                                               *
      * Calls: SR/*PSSR                                               *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR

     C                   MOVEA     CPY@          BIS@             80

      **  Set up Local Data Area (LDA)

     C     *DTAARA       DEFINE                  LDA
     C     *LOCK         IN        LDA
     C                   MOVE      *blanks       DBFILE
     C                   MOVE      *blanks       DBKEY
     C                   MOVE      *blanks       DBPGM
     C                   MOVEL     'SD009011'    DBPGM
     C                   MOVEL     'SD009011'    DBMOD
     C                   Z-ADD     0             DBASE
     C                   OUT       LDA
     C/COPY WNCPYSRC,SDH00593

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR - Program exception error routine                       *
      *                                                               *
      * Called by: SR/*INZSR                                          *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR

     C     WDUMP         IFEQ      *blanks
     C                   MOVE      'Y'           WDUMP
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   MOVE      *ON           *INLR
     C                   DUMP

     C                   RETURN

     C                   ENDIF

     C                   ENDSR
     C****************************************************************
** CPY@
(c) Finastra International Limited 2001
