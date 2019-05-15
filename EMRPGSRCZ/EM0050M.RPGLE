     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas EM Sub-Line Account Code Maintenance')
      *****************************************************************
      *                                                               *
      *  Midas - Exposure Management Module                           *
      *                                                               *
      *  EM0050 - Sub Line Account Code Maintenance                   *
      *                                                               *
      *  Function:  This program allows the user to input, amend and  *
      *  delete the association between account codes and Trade       *
      *  Finance sub-line.                                            *
      *                                                               *
      *  Called By:        - Menu option                              *
      *                                                               *
      *  Calls: DBERRCTL - Error processing                           *
      *         SDC0033  - Get field description                      *
      *         EM0030S  - Select sub-line type                       *
      *         ZA0250   - Clear program sfl message queue            *
      *         AOCREPT  - Add message to program sfl message queue   *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CGL029             Date 01Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CTI002  *CREATE    Date 12Oct98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CTI002 - *CREATE                                             *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    50         For EMTFSAPD reading                            *
      *    51         Sflclr SF1                                      *
      *    52         Sfldsp SF1                                      *
      *    53         Sflnxtchg SF1                                   *
      *    54         Sfl INZ SF1                                     *
      *    55         Sfldspctl SF1                                   *
      *    56         Readc SF1                                       *
      *    57         I/O Ordinary files                              *
      *    59         F9 allowed SSEL allowed                         *
      * 60-63         Screen fields error                             *
      *    67         Sflclr SF2                                      *
      *    68         Enquire Mode                                    *
      *    69         I/O Error ordinary files                        *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  *PSSR  - Error processing                                    *
      *  *INZSR - Initialise                                          *
      *  INISF1 - Initialise SF1                                      *
      *  PMTSF1 - Prompt SF1                                          *
      *  CHKSF1 - Check SF1                                           *
      *  DSPSF2 - Confirm delete in SF2                               *
      *  DUPSF1 - Duplicate accounts in SF1                           *
      *  UPDSF1 - Updating SF1                                        *
      *  FMTSF1 - Format fields SF1                                   *
      *  CKGSF1 - Common checks in SF1                                *
      *  CKISF1 - Checks for add in SF1                               *
      *  CKDSF1 - Check for delete in SF1                             *
      *  CKASF1 - Checks for amend in SF1                             *
      *  INISF2 - Initialise SF2                                      *
      *  CRESF1 - Create records in SF1                               *
      *  DLTSF1 - Delete records in SF1                               *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FEM0050FM  CF   E             WORKSTN
     F                                     SFILE(EM0050S1:EMRNS1)
     F                                     SFILE(EM0050S2:EMRNS2)
     FEMTFSAL0  UF A E           K DISK    INFSR(*PSSR)
     F                                     RENAME(EMTFSA:EMTFSAF0)
     F                                     COMMIT
     FEMTFSAL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(EMTFSA:EMTFSAF1)
     FSDACODL0  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(@A5UPA7:SDACODF0)
     FEMTFSLL0  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(EMTFSL:EMTFSLF0)
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
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
      *
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      *
      ** Data Area giving Installation Control Details
      *
     D PSDS           SDS
      *
      ** Program Status Data Structure
      *
     D##PGM              *PROC
     D  WSID                 244    253
     D  USER                 254    263
      *
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      ** To check no duplicate accounts exists in INSERT
     D*ACOD@****       S              4    DIM(99)                                            CGL029
     D ACOD@           S             10    DIM(99)                                            CGL029
      ** To check no duplicate accounts exists in AMENDMENT
     D*SLTAC@***       S              5    DIM(99)                                            CGL029
     D SLTAC@          S             11    DIM(99)                                            CGL029
      ** To retrieve the right amount during DLTSF1/CRESF1
     D*ACMT@****       S             34    DIM(99)                                            CGL029
     D ACMT@           S             40    DIM(99)                                            CGL029
      *
      ** Subfile
     DSF               DS
     DEMRNS1                          5  0         INZ(0)
     DEMRNS2                               LIKE(EMRNS1) INZ(0)
      *
     DFLAGS            DS
     DWFINSERT                        1
     DWFCNFDLT                             LIKE(WFINSERT)
     DWFPOSPAG                             LIKE(WFINSERT)
     DWFPMTSF1                             LIKE(WFINSERT)
     DWFINIT                               LIKE(WFINSERT)
      *
     DCOUNTERS         DS
     DI                               2  0
     DK                                    LIKE(I)
      *
     DWORKING          DS
     DW#ACOD                               LIKE(SACOD)
     DW#TYPE                               LIKE(STYPE)
     DWNUMBER          C                   CONST('0123456789')
     DWDSLTAC@         S              2  0 INZ(%ELEM(SLTAC@))
     DWDACOD@          S              2  0 INZ(%ELEM(ACOD@))
     DWDACMT@          S              2  0 INZ(%ELEM(ACMT@))
      *
      ** To check duplicate accounts
     DWSLTACDS         DS
     D***WSLTAC*                         5                                                    CGL029
     DWSLTAC                         11                                                       CGL029
     DSSEL                                 OVERLAY(WSLTAC:1)
     DSACOD                                OVERLAY(WSLTAC:2)
      *
      ** To check duplicate accounts
     DWMSLTACDS        DS
     DWMSLTAC                              LIKE(WSLTAC)
     DWMACOD                               LIKE(SACOD) OVERLAY(WMSLTAC:2)
      *
      ** To retrieve the right amount
     D***WACMT**          DS            34                                                    CGL029
     DWACMT            DS            40                                                       CGL029
     DWACOD                                LIKE(SACOD)
     DWEXP                                 LIKE(SAEXP)
     DWLIM                                 LIKE(SALIM)
      *
      ** Parameters for AOCREPT
     DMSGID            S              7
     DMSGF             S             10    INZ('EMUSRMSG')
     DMSGLIB           S             10    INZ('*LIBL')
     DMSGDTA           S            256
     DMSGREL           S              5
     DMSGQ             S             10
     DMSGT             S              7
      /EJECT
      /SPACE 3
      *
      ** +--------------------------------------+
      ** ¦ KEYS DEFINITION                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
     C     KACOD0        KLIST
     C                   KFLD                    A5ACCD
     C     KTFSA0        KLIST
     C                   KFLD                    SATYPE
     C                   KFLD                    SAACOD
     C     KTFSA1        KLIST
     C                   KFLD                    SAACOD
     C     KTFSL0        KLIST
     C                   KFLD                    STYPE
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *****************************************************************
      * MAIN PROCEDURE
      *****************************************************************
      *
      ** PARAMETERS
     C     *ENTRY        PLIST
     C                   PARM                    P#ENQY            1
      *
     C     *INKC         DOWEQ     *OFF
      *
     C                   EXSR      INISF1
      *
      ** No controls and updates if enquire mode
     C     *IN68         IFEQ      '1'
     C     *INKC         IFEQ      '1'
     C                   LEAVE
     C                   ELSE
     C                   ITER
     C                   ENDIF
     C                   ENDIF
      *
     C     *INKD         IFEQ      '1'
     C                   EXSR      PMTSF1
     C                   ITER
     C                   ENDIF
      *
     C                   EXSR      CHKSF1
      *
      ** Check for duplicate combinaisons
     C     MSGID         IFEQ      *BLANK
     C                   EXSR      DUPSF1
     C                   ENDIF
      *
      ** Confirm Delete
     C     MSGID         IFEQ      *BLANK
     C                   EXSR      DSPSF2
      ** If Cancel check again duplicate combinaisons
     C     WFCNFDLT      IFEQ      'N'
     C                   EXSR      DUPSF1
     C                   ENDIF
     C                   ENDIF
      *
     C     MSGID         IFEQ      *BLANK
     C                   EXSR      UPDSF1
      *
     C     *IN69         IFEQ      '0'
     C                   COMMIT
     C                   ELSE
     C                   ROLBK
     C                   UNLOCK    EMTFSAL0
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDDO
     C                   SETON                                        LR
      *
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
      ************ CALL DBERRCTL IF INTERACTIVE PROGRAM ***************
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C     @RUN          IFEQ      *BLANK
     C                   MOVE      'Y'           @RUN              1
     C                   DUMP
      ************ CALL DBERRCTL IF INTERACTIVE PROGRAM ******************
      *
     C                   CALLB     'DBERRCTL'
      *
      ********************************************************************
     C                   ENDIF
      *
      ************ END PROGRAM IF DBERRCTL NOT CALLED ********************
     C                   SETON                                        U7U8LR
     C                   RETURN
      ********************************************************************
      *
     C                   ENDSR
      *****************************************************************
      * *INZSR - INITIAL PROCESSING                                   *
      *****************************************************************
     C     *INZSR        BEGSR
     C                   SETON                                        25
      *
      ** Set up copyright parameter
      *
     C                   MOVEA     CPY@          CPY2@            80
      *
      ** Read in Installation Data
      *
     C     *DTAARA       DEFINE                  RUNDAT
     C     *DTAARA       DEFINE                  LDA
     C                   IN        RUNDAT
      *
      ** Set Date Format Indicator *IN98  on if date format is MMDDYY
      *
     C     AGDFF         IFEQ      'M'
     C                   SETON                                        98
     C                   ENDIF
      *
     C                   MOVEL     AGMRDT        SRUNA
     C                   MOVEL     USER          SUSER
     C                   MOVEL     WSID          SWSID
      *
      ** Protect fields if we are in Enquire Mode
     C     P#ENQY        IFEQ      'Y'
     C                   SETON                                        68
     C                   ELSE
     C                   SETOFF                                       68
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      * S/R INITIALIZE SF1                                            *
      * CALLED BY MAIN PROCEDURE                                      *
      *****************************************************************
     C     INISF1        BEGSR
      *
      ** Initialized here for S/R DUPSF1
     C                   MOVEL     *BLANK        WFCNFDLT
      *
      ** SFLDSP ON
     C                   SETON                                        52
      *
     C     MSGID         IFNE      *BLANK
     C     WFPMTSF1      ORNE      *BLANK
     C                   MOVEL     *BLANK        MSGID
     C                   MOVEL     *BLANK        WFPMTSF1
     C                   WRITE     #MSGCTL
     C                   WRITE     EM0050F1
     C                   EXFMT     EM0050C1
     C                   ELSE
      *
     C     *LOVAL        SETLL     EMTFSAF0                           50
      *
      ** Case insert (F9) or empty record in EMTFSAPD
      *
     C     *INKI         IFEQ      '1'
     C     *IN50         OREQ      '1'
      *
      ** If SF1 empty in enquire mode don't display the lines
     C     *IN50         IFEQ      '1'
     C     P#ENQY        ANDEQ     'Y'
      ** SFLDSP OFF
     C                   SETOFF                                       52
     C                   ENDIF
      *
      ** Reset error indicators for non protected fields
     C                   SETOFF                                       60
     C                   SETOFF                                       61
     C                   SETOFF                                       62
     C                   SETOFF                                       63
     C                   MOVE      'Y'           WFINSERT
      ** Footer text without F9
     C                   SETOFF                                       59
     C                   WRITE     EM0050F1
      ** SFLINZ
     C                   SETON                                        54
     C                   Z-ADD     1             @@RNC1
     C                   WRITE     #MSGCTL
     C                   EXFMT     EM0050C1
     C                   SETOFF                                       54
     C                   ELSE
      *
      ** Other cases
      *
      ** SFLCLR
     C                   SETON                                        51
     C                   WRITE     EM0050C1
     C                   SETOFF                                       51
     C                   Z-ADD     0             EMRNS1
     C                   MOVE      'N'           WFINSERT
     C                   MOVEL     *BLANK        SLTAC@
     C                   MOVEL     *BLANK        ACMT@
     C                   Z-ADD     0             K
     C                   READ      EMTFSAF0                               50
     C                   UNLOCK    EMTFSAL0
     C     *IN50         DOWEQ     '0'
      *
     C                   ADD       1             EMRNS1
     C                   Z-ADD     EMRNS1        @@RNC1
     C                   EXSR      FMTSF1
     C                   SETON                                        59
     C                   WRITE     EM0050S1
      *
     C                   READ      EMTFSAF0                               50
     C                   UNLOCK    EMTFSAL0
     C                   ENDDO
      *
      ** Footer text with F9
     C                   WRITE     EM0050F1
     C                   Z-ADD     1             @@RNC1
     C                   WRITE     #MSGCTL
     C                   EXFMT     EM0050C1
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     END_INISF1    ENDSR
      *****************************************************************
      * S/R PROMPT SF1                                                *
      * CALLED BY MAIN PROCEDURE                                      *
      * CALLS : SDC0033                                               *
      *         EM0030S                                               *
      *****************************************************************
     C     PMTSF1        BEGSR
      *
      ** Get field description from CSRFLD and select
     C                   SELECT
      *
      ** Account Code
     C     @@CFC1        WHENEQ    'SACOD'
     C                   CALL      'SDC0033'
     C                   PARM      *BLANKS       RTNCDE            7
     C                   PARM      *BLANKS       W#ACOD
      *
      ** Update Sub-File
     C     W#ACOD        IFNE      *BLANKS
     C     @@RNS1        CHAIN     EM0050S1                           56
     C     *IN56         IFEQ      '0'
     C                   MOVEL     W#ACOD        SACOD
      ** SFLNXTCHG for S/R CHKSF1
     C                   SETON                                        53
     C                   UPDATE    EM0050S1
     C                   ENDIF
     C                   ENDIF
      *
      ** Offset Balance  Account
     C     @@CFC1        WHENEQ    'SOFFA'
     C                   CALL      'SDC0034'
     C                   PARM      *BLANKS       RTNCDE            7
     C                   PARM      *BLANKS       W#ACOD
      *
      ** Update Sub-File
     C     W#ACOD        IFNE      *BLANKS
     C     @@RNS1        CHAIN     EM0050S1                           56
     C     *IN56         IFEQ      '0'
     C                   MOVE      W#ACOD        SOFFA
     C                   MOVE      W#ACOD        A5ACCD
     C     KACOD0        CHAIN     SDACODF0                           57
     C     *IN57         IFEQ      '0'
     C                   MOVEL     A5ACCN        SOFFN
     C                   ELSE
     C                   MOVEL     *BLANK        SOFFN
     C                   ENDIF
      ** SFLNXTCHG for S/R CHKSF1
     C                   SETON                                        53
     C                   UPDATE    EM0050S1
     C                   ENDIF
     C                   ENDIF
      *
      ** Subline
     C     @@CFC1        WHENEQ    'STYPE'
     C                   CALL      'EM0030S'
     C                   PARM      *BLANKS       W#TYPE
      *
      ** Update Sub-File
     C     W#TYPE        IFNE      *BLANKS
     C     @@RNS1        CHAIN     EM0050S1                           56
     C     *IN56         IFEQ      '0'
     C                   MOVEL     W#TYPE        STYPE
     C     KTFSL0        CHAIN     EMTFSLF0                           57
     C     *IN57         IFEQ      '0'
     C                   MOVEL     SLDESC        SDESC
     C                   ELSE
     C                   MOVEL     *BLANK        SDESC
     C                   ENDIF
      ** SFLNXTCHG for S/R CHKSF1
     C                   SETON                                        53
     C                   UPDATE    EM0050S1
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSL
      *
     C     EMRNS1        IFEQ      0
     C                   Z-ADD     1             @@RNC1
     C                   ELSE
     C                   Z-ADD     EMRNS1        @@RNC1
     C                   ENDIF
      *
     C                   MOVEL     'Y'           WFPMTSF1
      *
     C     END_PMTSF1    ENDSR
      *****************************************************************
      * S/R CHECKING SF1                                              *
      * CALLED BY MAIN PROCEDURE                                      *
      * CALLS : ZA0250                                                *
      *****************************************************************
     C     CHKSF1        BEGSR
      *
      ** Clear the message queue
      *
     C                   CALL      'ZA0250'
      *
     C                   MOVEL     'N'           WFPOSPAG
     C                   Z-ADD     0             EMRNS2
     C                   Z-ADD     0             I
     C                   MOVEL     *BLANK        ACOD@
      *
      ** SFLCLR for Records to be deleted
     C                   SETON                                        67
     C                   WRITE     EM0050C2
     C                   SETOFF                                       67
      *
     C                   READC     EM0050S1                               56
     C     *IN56         DOWEQ     '0'
      *
      ** Global checks common to the 3 cases
     C                   EXSR      CKGSF1
      *
      ** If at least one error encountered, we don't perform the specific
      ** checks. This to avoid problems with cursor location
     C     MSGID         IFEQ      *BLANK
      *
     C                   SELECT
     C     WFINSERT      WHENEQ    'Y'
      ** Checks for Add
     C                   EXSR      CKISF1
     C     SSEL          WHENNE    'D'
      ** Checks for Amend
     C                   EXSR      CKASF1
     C                   OTHER
      ** Checks for Delete
     C                   EXSR      CKDSF1
     C                   ENDSL
      *
     C                   ENDIF
      *
      ** SFLNXTCHG for S/R UPDSF1
     C                   SETON                                        53
      ** To display the right page in case of several errors
     C     MSGID         IFNE      *BLANK
     C     WFPOSPAG      IFEQ      'N'
     C                   MOVEL     'Y'           WFPOSPAG
     C                   Z-ADD     EMRNS1        @@RNC1
     C                   ENDIF
     C                   ENDIF
      *
     C                   UPDATE    EM0050S1
     C                   READC     EM0050S1                               56
     C                   ENDDO
      *
     C     END_CHKSF1    ENDSR
      *****************************************************************
      * S/R CONFIRM DELETE IN SF2                                     *
      * CALLED BY MAIN PROCEDURE                                      *
      *****************************************************************
     C     DSPSF2        BEGSR
      *
     C     EMRNS2        IFNE      0
      *
     C                   MOVE      'Y'           WFCNFDLT
      *
     C                   EXSR      INISF2
      *
     C     *INKL         IFEQ      *ON
     C                   MOVE      'N'           WFCNFDLT
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     END_DSPSF2    ENDSR
      *****************************************************************
      * S/R DUPLICATE ACCOUNTS IN DUPSF1                              *
      * CALLED BY MAIN PROCEDURE                                      *
      *****************************************************************
     C     DUPSF1        BEGSR
      *
     C     WFINSERT      IFEQ      'Y'
     C                   GOTO      END_DUPSF1
     C                   ENDIF
      *
     C                   Z-ADD     1             K
     C     SLTAC@(K)     DOWNE     *BLANK
     C                   MOVE      SLTAC@(K)     WSLTAC
      *
      ** We don't check a record that will be soon deleted
     C     SSEL          IFEQ      'D'
     C     WFCNFDLT      ANDNE     'N'
     C                   ADD       1             K
     C     K             IFGT      WDSLTAC@
     C                   LEAVE
     C                   ELSE
     C                   ITER
     C                   ENDIF
     C                   ENDIF
      *
     C                   MOVE      WSLTAC        WMSLTAC
     C                   Z-ADD     1             EMRNS1
      *
     C     SLTAC@(EMRNS1)DOWNE     *BLANK
     C                   SETOFF                                       60
     C                   MOVE      SLTAC@(EMRNS1)WSLTAC
      ** Duplicated account found
     C     WMACOD        IFEQ      SACOD
     C     K             ANDNE     EMRNS1
      *
      ** If the duplicated combinaison will be soon deleted
      ** We do nothing
     C     SSEL          IFEQ      'D'
     C     WFCNFDLT      ANDNE     'N'
     C                   ADD       1             EMRNS1
     C     EMRNS1        IFGT      WDSLTAC@
     C                   LEAVE
     C                   ELSE
     C                   ITER
     C                   ENDIF
     C                   ENDIF
      *
     C                   MOVEL     'EMT0037'     MSGID
     C                   EXSR      SNDMSG
     C                   SETON                                        60
      *
     C                   Z-ADD     EMRNS1        @@RNC1
     C     @@RNC1        CHAIN     EM0050S1                           56
     C     *IN56         IFEQ      '0'
      ** SFLNXTCHG
     C                   SETON                                        53
     C                   UPDATE    EM0050S1
     C                   ENDIF
      *
     C                   ENDIF
     C                   ADD       1             EMRNS1
     C     EMRNS1        IFGT      WDSLTAC@
     C                   LEAVE
     C                   ENDIF
      *
     C                   ENDDO
     C                   ADD       1             K
     C     K             IFGT      WDSLTAC@
     C                   LEAVE
     C                   ENDIF
      *
     C                   ENDDO
      *
     C     END_DUPSF1    ENDSR
      *****************************************************************
      * S/R UPDATING SF1                                              *
      * CALLED BY MAIN PROCEDURE                                      *
      *****************************************************************
     C     UPDSF1        BEGSR
      *
      ** Instead of updating file EMTFSAPD we prefer delete and create
      ** records which have been changed.
      ** We choose this way to avoid duplicate combinaison
      ** when customer decides to swap 2 Sub Lines or 2 Offset Balance
      ** Account for the same Account.
      *
      ** FIRST STEP : DELETION PROCESSING
     C     WFINSERT      IFNE      'Y'
     C                   READC     EM0050S1                               56
     C     *IN56         DOWEQ     '0'
     C                   EXSR      DLTSF1
      *
     C     *IN69         IFEQ      '1'
     C                   GOTO      END_UPDSF1
     C                   ENDIF
      *
      ** SFLNXTCHG for Add processing
     C                   SETON                                        53
     C                   UPDATE    EM0050S1
      *
     C                   READC     EM0050S1                               56
     C                   ENDDO
     C                   ENDIF
      *
      ** SECOND STEP : ADD PROCESSING
     C                   READC     EM0050S1                               56
     C     *IN56         DOWEQ     '0'
      *
     C                   SELECT
     C     SSEL          WHENEQ    'D'
     C     WFCNFDLT      ANDEQ     'Y'
      ** We create no records
     C                   OTHER
      ** Add processing
     C                   EXSR      CRESF1
     C                   ENDSL
      ** Error I/O
     C     *IN69         IFEQ      '1'
     C                   GOTO      END_UPDSF1
     C                   ENDIF
      *
     C                   READC     EM0050S1                               56
     C                   ENDDO
     C     END_UPDSF1    ENDSR
      *****************************************************************
      * S/R FIELDS FORMATING SF1                                      *
      * CALLED BY S/R INISF1                                          *
      *****************************************************************
     C     FMTSF1        BEGSR
     C                   MOVE      *BLANK        SSEL
     C                   MOVE      SATYPE        STYPE
     C                   MOVE      SAACOD        SACOD
     C     SAOFFA        IFEQ      0
     C                   MOVE      *BLANK        SOFFA
     C                   ELSE
     C                   MOVE      SAOFFA        SOFFA
     C                   ENDIF
      *
      ** We memorize fields in hidden zone.
      ** 1- to be abble to delete the right records in S/R DLTSF1
      ** 2- to avoid deletion of lines that have been filled with blanks
     C                   MOVEL     SATYPE        SHTYPE
     C                   MOVE      SAACOD        SHACOD
     C                   MOVE      SAOFFA        SHOFFA
     C                   MOVE      SOFFA         A5ACCD
     C     KACOD0        CHAIN     SDACODF0                           57
     C     *IN57         IFEQ      '0'
     C                   MOVEL     A5ACCN        SOFFN
     C                   ELSE
     C                   MOVEL     *BLANK        SOFFN
     C                   ENDIF
      *
     C     KTFSL0        CHAIN     EMTFSLF0                           57
     C     *IN57         IFEQ      '0'
     C                   MOVEL     SLDESC        SDESC
     C                   ELSE
     C                   MOVEL     *BLANK        SDESC
     C                   ENDIF
      *
      ** Fill array to detect duplicate sequence in S/R CKASF1
     C                   ADD       1             K
     C                   MOVE      WSLTAC        SLTAC@(K)
      *
      ** Fill array to preserve the link between Exposure Account and the
      ** amounts
     C                   MOVE      SACOD         WACOD
     C                   MOVE      SALIM         WLIM
     C                   MOVE      SAEXP         WEXP
     C                   MOVE      WACMT         ACMT@(K)
      *
     C     END_FMTSF1    ENDSR
      *****************************************************************
      * S/R COMMONS CHECKS IN SF1                                     *
      * CALLED BY S/R CHKSF1                                          *
      *****************************************************************
     C     CKGSF1        BEGSR
     C                   SETOFF                                       60
     C                   SETOFF                                       61
     C                   SETOFF                                       62
     C                   SETOFF                                       63
      *
      ** We dont need to check other fields if we want to delete the
      ** subfile line's
     C     WFINSERT      IFNE      'Y'
     C     SSEL          ANDEQ     'D'
     C                   GOTO      END_CKGSF1
      *
      ** The only value allowed for selection field is D
     C                   ELSE
     C     SSEL          IFNE      *BLANK
     C                   MOVEL     'EMT0004'     MSGID
     C                   MOVEL(P)  SSEL          MSGDTA
     C                   EXSR      SNDMSG
     C                   SETON                                        61
     C                   ENDIF
     C                   ENDIF
      *
     C                   MOVEL     *BLANK        SDESC
     C                   MOVEL     *BLANK        SOFFN
      *
      ** Subline is mandatory
     C     STYPE         IFEQ      *BLANK
     C     SACOD         IFNE      *BLANK
     C     SOFFA         ORNE      *BLANK
     C                   MOVEL     'EMT0011'     MSGID
     C                   EXSR      SNDMSG
     C                   SETON                                        63
     C                   ENDIF
     C                   ENDIF
      *
      ** Subline must exist
     C     *IN63         IFEQ      '0'
     C     STYPE         ANDNE     *BLANK
     C     KTFSL0        SETLL     EMTFSLF0                               57
     C     *IN57         IFEQ      '0'
     C                   MOVEL     'EMT0049'     MSGID
     C                   EXSR      SNDMSG
     C                   SETON                                        63
     C                   ELSE
     C     KTFSL0        READE     EMTFSLF0                               57
     C     *IN57         IFEQ      '0'
     C                   MOVEL     SLDESC        SDESC
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      ** Account number is mandatory
     C     SACOD         IFEQ      *BLANK
     C     STYPE         IFNE      *BLANK
     C     SOFFA         ORNE      *BLANK
     C                   MOVEL     'EMT0011'     MSGID
     C                   EXSR      SNDMSG
     C                   SETON                                        60
     C                   ENDIF
     C                   ENDIF
      *
      ** Value 0 is not allowed for the account number
     C     *IN60         IFEQ      '0'
     C     SACOD         IFEQ      *ZEROS
     C                   MOVEL     'EMT0035'     MSGID
     C                   EXSR      SNDMSG
     C                   SETON                                        60
     C                   ENDIF
     C                   ENDIF
      *
      ** Account number is to be numeric
     C     *IN60         IFEQ      '0'
     C     SACOD         IFNE      *BLANK
     C     WNUMBER       CHECK     SACOD                                  60
     C     *IN60         IFEQ      '1'
     C                   MOVEL     'EMT0036'     MSGID
     C                   EXSR      SNDMSG
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      ** Account must exist
      ** Account must be a trade finance contingent account
     C     *IN60         IFEQ      '0'
     C     SACOD         ANDNE     *BLANK
     C                   MOVEL     'N'           A5TFCT
     C                   MOVE      SACOD         A5ACCD
     C     KACOD0        SETLL     SDACODF0                               57
     C     *IN57         IFEQ      '1'
     C     KACOD0        READE     SDACODF0                               57
     C                   ENDIF
     C     A5TFCT        IFNE      'Y'
     C                   MOVEL     'EMT0014'     MSGID
     C                   MOVEL(P)  SACOD         MSGDTA
     C                   EXSR      SNDMSG
     C                   SETON                                        60
     C                   ENDIF
     C                   ENDIF
      *
      ** Offset balance and Exposure Account cannot have se same code
     C     *IN60         IFEQ      '0'
     C     SACOD         ANDNE     *BLANK
     C     SOFFA         ANDEQ     SACOD
     C                   MOVEL     'EMT0051'     MSGID
     C                   EXSR      SNDMSG
     C                   SETON                                        60
     C                   SETON                                        62
     C                   ENDIF
      *
      ** Value 0 is not allowed for the offset balance
     C     SOFFA         IFEQ      *ZEROS
     C                   MOVEL     'EMT0035'     MSGID
     C                   EXSR      SNDMSG
     C                   SETON                                        62
     C                   ENDIF
      *
      ** Offset balance is to be numeric
     C     *IN62         IFEQ      '0'
     C     SOFFA         IFNE      *BLANK
     C     WNUMBER       CHECK     SOFFA                                  62
     C     *IN62         IFEQ      '1'
     C                   MOVEL     'EMT0036'     MSGID
     C                   EXSR      SNDMSG
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      ** Offset balance account must exist
      ** Offset balance account must not be a trade finance account
     C     *IN62         IFEQ      '0'
     C     SOFFA         IFNE      *BLANK
     C                   MOVE      SOFFA         A5ACCD
     C     KACOD0        SETLL     SDACODF0                               57
     C     *IN57         IFEQ      '1'
     C     KACOD0        READE     SDACODF0                               57
     C     *IN57         IFEQ      '0'
     C     A5TFCT        ANDNE     'Y'
     C                   MOVEL     A5ACCN        SOFFN
     C                   ELSE
     C                   MOVEL     'EMT0053'     MSGID
     C                   MOVEL(P)  SOFFA         MSGDTA
     C                   EXSR      SNDMSG
     C                   SETON                                        62
     C                   ENDIF
     C                   ELSE
     C                   MOVEL     'EMT0052'     MSGID
     C                   MOVEL(P)  SOFFA         MSGDTA
     C                   EXSR      SNDMSG
     C                   SETON                                        62
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C     END_CKGSF1    ENDSR
      *****************************************************************
      * CHECKS FOR ADD INSF1                                          *
      * CALLED BY S/R CHKSF1                                          *
      *****************************************************************
     C     CKISF1        BEGSR
      *
      ** An account cannot have different sub-lines
     C     *IN60         IFEQ      '0'
     C     SACOD         ANDNE     *BLANK
     C                   MOVE      SACOD         SAACOD
     C     KTFSA1        CHAIN     EMTFSAF1                           57
     C     *IN57         IFEQ      '0'
     C                   MOVEL     'EMT0050'     MSGID
     C                   EVAL      MSGDTA = SACOD + SATYPE
     C                   EXSR      SNDMSG
     C                   SETON                                        60
     C                   ENDIF
     C                   ENDIF
      *
      ** Account must not already exist in the subfile
     C     *IN60         IFEQ      '0'
     C     SACOD         ANDNE     *BLANK
     C                   Z-ADD     1             I
     C     ACOD@(I)      DOWNE     *BLANK
     C                   MOVEA     ACOD@(I)      WMACOD
     C     SACOD         IFEQ      WMACOD
     C                   MOVEL     'EMT0037'     MSGID
     C                   EXSR      SNDMSG
     C                   SETON                                        60
     C                   LEAVE
     C                   ENDIF
     C                   ADD       1             I
     C     I             IFGT      WDACOD@
     C                   LEAVE
     C                   ENDIF
     C                   ENDDO
     C                   ENDIF
      *
      ** Filling Arrays to detect duplicate account codes
     C     *IN60         IFEQ      '0'
     C     SACOD         ANDNE     *BLANK
     C                   MOVEA     SACOD         ACOD@(I)
     C                   ENDIF
      *
     C     END_CKISF1    ENDSR
      *****************************************************************
      * S/R CHECKS FOR DELETE IN SF1                                  *
      * CALLED BY S/R CHKSF1                                          *
      *****************************************************************
     C     CKDSF1        BEGSR
     C                   Z-ADD     EMRNS1        K
      *
      ** If line of sub-file is filled with blanks we need to check it
      ** in S/R DUPSF1
      ** We must display this line if user wants to delete it
     C     SACOD         IFEQ      *BLANK
     C     SOFFA         ANDEQ     *BLANK
     C     STYPE         ANDEQ     *BLANK
     C                   MOVEL     SHTYPE        STYPE
     C                   MOVE      SHACOD        SACOD
     C     SHOFFA        IFEQ      *ZEROS
     C                   MOVE      *BLANK        SOFFA
     C                   MOVE      *BLANK        SOFFN
     C                   ELSE
     C                   MOVE      SHOFFA        SOFFA
     C     KACOD0        CHAIN     SDACODF0                           57
     C     *IN57         IFEQ      '0'
     C                   MOVEL     A5ACCN        SOFFN
     C                   ELSE
     C                   MOVEL     *BLANK        SOFFN
     C                   ENDIF
     C                   ENDIF
     C     KTFSL0        CHAIN     EMTFSLF0                           57
     C     *IN57         IFEQ      '0'
     C                   MOVEL     SLDESC        SDESC
     C                   ELSE
     C                   MOVEL     *BLANK        SDESC
     C                   ENDIF
     C                   ENDIF
      *
     C                   MOVEA     WSLTAC        SLTAC@(K)
      *
     C                   ADD       1             EMRNS2
     C                   WRITE     EM0050S2
      *
     C     END_CKDSF1    ENDSR
      *****************************************************************
      * S/R CHECKS FOR AMEND IN SF1                                   *
      * CALLED BY S/R CHKSF1                                          *
      *****************************************************************
     C     CKASF1        BEGSR
      *
     C                   Z-ADD     EMRNS1        K
      *
      ** If line of sub-file is filled with blank we need to check it
      ** in S/R DUPSF1
     C     SACOD         IFEQ      *BLANK
     C     SOFFA         ANDEQ     *BLANK
     C     STYPE         ANDEQ     *BLANK
     C                   MOVEL     SHTYPE        STYPE
     C                   MOVE      SHACOD        SACOD
     C     SHOFFA        IFEQ      *ZEROS
     C                   MOVE      *BLANK        SOFFA
     C                   MOVE      *BLANK        SOFFN
     C                   ELSE
     C                   MOVE      SHOFFA        SOFFA
     C     KACOD0        CHAIN     SDACODF0                           57
     C     *IN57         IFEQ      '0'
     C                   MOVEL     A5ACCN        SOFFN
     C                   ELSE
     C                   MOVEL     *BLANK        SOFFN
     C                   ENDIF
     C                   ENDIF
     C     KTFSL0        CHAIN     EMTFSLF0                           57
     C     *IN57         IFEQ      '0'
     C                   MOVEL     SLDESC        SDESC
     C                   ELSE
     C                   MOVEL     *BLANK        SDESC
     C                   ENDIF
     C                   ENDIF
      *
     C                   MOVEA     WSLTAC        SLTAC@(K)
      *
     C     END_CKASF1    ENDSR
      *****************************************************************
      * S/R INITIALIZE SF2                                            *
      * CALLED BY S/R DSPSF2                                          *
      *****************************************************************
     C     INISF2        BEGSR
      *
     C                   WRITE     EM0050F2
      *
     C                   EXFMT     EM0050C2
      *
     C     END_INISF2    ENDSR
      *****************************************************************
      * S/R CREATE RECORDS IN SF1                                     *
      * CALLED BY S/R UPDSF1                                          *
      *****************************************************************
     C     CRESF1        BEGSR
      *
     C                   CLEAR                   EMTFSAF0
      *
      ** To not create a account with blanks
     C     SACOD         IFEQ      *BLANK
     C     SHACOD        IFEQ      *BLANK
     C     SHTYPE        ANDEQ     *BLANK
     C     SHOFFA        ANDEQ     *BLANK
     C                   GOTO      END_CRESF1
     C                   ELSE
      ** To avoid deletion when filling existing fields with blanks
     C                   MOVE      SHACOD        SACOD
     C                   MOVE      SHOFFA        SOFFA
     C                   MOVEL     SHTYPE        STYPE
     C                   ENDIF
     C                   ENDIF
      *
      ** Retrieve the amounts for EMTFSAPD
     C     WFINSERT      IFNE      'Y'
     C                   Z-ADD     1             K
     C     ACMT@(K)      DOWNE     *BLANK
      *
     C                   MOVEA     ACMT@(K)      WACMT
     C     WACOD         IFEQ      SACOD
     C                   MOVE      WLIM          SALIM
     C                   MOVE      WEXP          SAEXP
     C                   LEAVE
     C                   ENDIF
      *
     C                   ADD       1             K
     C     K             IFGT      WDACMT@
     C                   LEAVE
     C                   ENDIF
     C                   ENDDO
     C                   ENDIF
      *
     C                   MOVE      SACOD         SAACOD
     C                   MOVE      SOFFA         SAOFFA
     C                   MOVEL     STYPE         SATYPE
     C                   WRITE     EMTFSAF0                             69
      *
     C     *IN69         IFEQ      '1'
     C                   MOVEL     'EMT0044'     MSGID
     C                   MOVEL(P)  'EMTFSAPD'    MSGDTA
     C                   EXSR      SNDMSG
     C                   ENDIF
      *
     C     END_CRESF1    ENDSR
      *****************************************************************
      * S/R DELETE RECORDS IN SF1                                     *
      * CALLED BY S/R UPDSF1                                          *
      *****************************************************************
     C     DLTSF1        BEGSR
      *
     C                   MOVEL     SHTYPE        SATYPE
     C                   MOVE      SHACOD        SAACOD
     C     KTFSA0        SETLL     EMTFSAF0                               57
     C     *IN57         IFEQ      '0'
     C                   GOTO      END_DLTSF1
     C                   ENDIF
      *
     C     KTFSA0        READE     EMTFSAF0                             6957
     C     *IN69         IFEQ      '1'
     C                   MOVEL     'EMT0045'     MSGID
     C                   EXSR      SNDMSG
     C                   GOTO      END_DLTSF1
     C                   ENDIF
      *
     C                   DELETE    EMTFSAF0                             69
     C     *IN69         IFEQ      '1'
     C                   MOVEL     'EMT0044'     MSGID
     C                   MOVEL(P)  'EMTFSAPD'    MSGDTA
     C                   EXSR      SNDMSG
     C                   GOTO      END_DLTSF1
     C                   ENDIF
      *
     C     END_DLTSF1    ENDSR
      *****************************************************************
      * S/R SNDMSG SEND PROGRAM MESSAGE                               *
      * CALLED BY SEVERAL SUBROUTINES                                 *
      * CALLS : AOCREPT                                               *
      *****************************************************************
     C     SNDMSG        BEGSR
      ** Only write message if requested
     C     MSGID         IFNE      *BLANK
     C                   CALLB     'AOCREPT'
     C                   PARM                    MSGID
     C                   PARM                    MSGF
     C                   PARM                    MSGLIB
     C                   PARM                    MSGDTA
     C                   PARM      '*SAME'       MSGREL
     C                   PARM                    ##PGM
     C                   PARM      *BLANK        MSGQ
     C                   PARM      *BLANK        MSGT
      *
     C                   MOVEL     *BLANK        MSGDTA
      *
     C                   ENDIF
      *
     C     END_SNDMSG    ENDSR
      *
      ********************************************************************
      *
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
