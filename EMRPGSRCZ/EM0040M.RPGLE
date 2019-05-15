     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas EM Customer sub-limit maintenance')              *
      *****************************************************************
      *                                                               *
      *  Midas - Exposure Management Module                           *
      *                                                               *
      *  EM0040 - Customer sub-limit maintenance                      *
      *                                                               *
      *  Function:  This module provides maintenance over file        *
      *  over EMTFCBPD EMTFEXPD                                       *
      *  You cannot leave these screen until the Total T/F is not     *
      *  equal to the sum of the customer balance limit sub type.     *
      *  There are 2 exceptions for this rule                         *
      *  - Sum of customer balances is 0                              *
      *  - T/F limit is an amount (and not a percentage) and is 0     *
      *                                                               *
      *  Called By: EM0020 - EM limits maintenance                    *
      *                                                               *
      *  Calls: DBERRCTL - Error processing                           *
      *         ZA0840   - Format amounts                             *
      *         SDC0033  - Get field description                      *
      *         EM9000S  - Select exposure scaling file               *
      *         ZA0250   - Clear program subfile message queue        *
      *         AOCREPT  - Add message to program sfl message queue   *
      *                                                               *
      *  Component of: EM0020 Midas EM limits maintenance             *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CTI007             Date 31Mar14               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CTI002   *CREATE   Date 18Sep98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CTI007 - Trade Finance BF Midas 2.2 Exposure Management      *
      *           (Recompile)                                         *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    50         For EMTFCBPD reading                            *
      *    51         Sflclr SF1                                      *
      *    52         Sfldsp SF1                                      *
      *    53         Sflnxtchg SF1                                   *
      *    54         Sfl INZ SF1                                     *
      *    55         Sfldspctl SF1                                   *
      *    56         Readc SF1                                       *
      *    57         I/O Ordinary files                              *
      *    59         F9 allowed SSEL allowed                         *
      * 60-63         Screen fields error                             *
      * 65-66         Screen fields error                             *
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
      *  CHKC1  - Check control SF1                                   *
      *  DSPSF2 - Confirm delete in SF2                               *
      *  UPDSF1 - Updating SF1                                        *
      *  FMTSF1 - Format fields SF1                                   *
      *  FMTC1  - Format fields control SF1                           *
      *  CKISF1 - Checks for add in SF1                               *
      *  CKASF1 - Checks for amend in SF1                             *
      *  CKDSF1 - Check for delete in SF1                             *
      *  CKGSF1 - Common checks in SF1                                *
      *  INISF2 - Initialise SF2                                      *
      *  CRESF1 - Create records in SF1                               *
      *  DLTSF1 - Delete records in SF1                               *
      *  AMDSF1 - Amend records in SF1                                *
      *  FMTAMT - Checks and formats amounts                          *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FEM0040FM  CF   E             WORKSTN
     F                                     SFILE(EM0040S1:EMRNS1)
     F                                     SFILE(EM0040S2:EMRNS2)
     FEMTFCBL0  UF A E           K DISK    INFSR(*PSSR)
     F                                     RENAME(EMTFCB:EMTFCBF0)
     F                                     COMMIT
     FEMTFEXL0  UF A E           K DISK    INFSR(*PSSR)
     F                                     RENAME(EMTFEX:EMTFEXF0)
     F                                     COMMIT
     FEMTFSAL1  UF A E           K DISK    INFSR(*PSSR)
     F                                     RENAME(EMTFSA:EMTFSAF1)
     F                                     COMMIT
     FEMEXSCL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(@EKREKR:EMEXSCF1)
     FLBLBCSJ7  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDLBCSJ0:SDCUSTF7)
     FSDACODL0  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(@A5UPA7:SDACODF0)
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
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
     D*ACD@*****       S              4    DIM(99)                                            CGL029
     D ACD@            S             10    DIM(99)                                            CGL029
      *
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
     DWFPOSITV                             LIKE(WFINSERT)
      *
     DCOUNTERS         DS
     DI                               2  0
      *
     DWORKING          DS
     DSSBLI
     DWTSBLI                               LIKE(CBLIM)
     DWCBLIM                               LIKE(CBLIM)
     DWOCBLIM                              LIKE(CBLIM)
     DWSBLI                                LIKE(CBLIM)
     DWSLIMA                               LIKE(SLIM)
     DWSLIMN                               LIKE(CBLIM)
     DW#ACOD                               LIKE(SACNO)
     DW#SCAL                               LIKE(SSCL)
     DWALPH                                LIKE(@@ALPH)
     DWNUMBER          C                   CONST('0123456789')
     D@MSGID                          7
     D@MSGIDAM                             LIKE(@MSGID)
     DWMSDA1           DS
     DWFICH1                         10
     DWACOD1                               LIKE(SACNO)
     DWAMNT1                         +1    LIKE(@@ALPH)
     DSSCL             DS
     DWSCL1                           1
     DWSCL2                           1
      *
      ** Parameters for ZA0840
     DRetCodeIn        S             10
     D@@ALPH           S             16
     D@@IDP            S              3  0
     D@@IINT           S              3  0
     D@@MTID           S              1
     D@@Ercd           S              1  0
     D@@Amt            S             15  0
     DBNDCSP           S              1
      *
      ** Parameters for AOCREPT
     DMSGID            S                   LIKE(@MSGID)
     DMSGF             S             10    INZ('EMUSRMSG')
     DMSGLIB           S             10    INZ('*LIBL')
     DMSGDTA           S            256
     DMSGREL           S              5
     DMSGQ             S             10
     DMSGT             S              7
      *
      ** Parameters for EM0998
      /COPY EMCPYSRC,EM0998IILE
      /EJECT
      /SPACE 3
      *
      ** +--------------------------------------+
      ** ¦ KEYS DEFINITION                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
     C     KACOD0        KLIST
     C                   KFLD                    SACNO
     C     KTFCB0        KLIST
     C                   KFLD                    P#CUST
     C     KTFCB1        KLIST
     C                   KFLD                    P#CUST
     C                   KFLD                    CBACNO
     C     KEXSC0        KLIST
     C                   KFLD                    SSCL
     C     KTFSA1        KLIST
     C                   KFLD                    SAACOD
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
     C                   PARM                    P#CUST            6
     C                   PARM                    P#TFLI           10 0
     C                   PARM                    P#ENQY            1
     C                   PARM                    P#PCTG            1
      *
     C     *INKC         DOWEQ     *OFF
     C     @MSGIDAM      ORNE      *BLANK
     C     @MSGID        ORNE      *BLANK
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
     C     *INKC         IFEQ      '1'
     C     @MSGIDAM      ANDEQ     *BLANK
     C     @MSGID        ANDEQ     *BLANK
     C                   LEAVE
     C                   ENDIF
      *
     C     *INKD         IFEQ      '1'
     C                   EXSR      PMTSF1
     C                   ITER
     C                   ENDIF
      *
     C                   EXSR      CHKSF1
      *
     C     @MSGID        IFEQ      *BLANK
      *
      ** Confirm Delete
     C                   EXSR      DSPSF2
      *
     C                   EXSR      UPDSF1
      *
     C     *IN69         IFEQ      '0'
     C                   COMMIT
     C                   ELSE
     C                   ROLBK
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Check here because total amount might change in S/R UPDSF1
     C                   EXSR      CHKC1
      *
     C                   ENDDO
      *
      ** Free EM0998 and close EMTRCKPD in amend mode if at least
      ** one error encountered
     C     P#ENQY        IFNE      'Y'
     C     WFPOSITV      ANDNE     *BLANK
     C                   MOVEL     '1'           P#INLR
     C                   CALL      'EM0998'
     C                   PARM                    P#0998
     C                   ENDIF
      *
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
     C                   Z-ADD     0             WTSBLI
     C                   MOVEL     P#CUST        SCNUM
     C     KTFCB0        CHAIN     SDCUSTF7                           57
     C     *IN57         IFEQ      '0'
     C                   MOVEL     BBCSSN        SCSSN
     C                   ENDIF
      *
     C                   MOVE      P#TFLI        @@ALPH
     C                   EXSR      FMTAMT
     C                   MOVE      @@ALPH        STFLI
      *
     C                   ENDSR
      *****************************************************************
      * S/R INITIALIZE SF1                                            *
      * CALLED BY MAIN PROCEDURE                                      *
      *****************************************************************
     C     INISF1        BEGSR
      *
      ** SFLDSP ON
     C                   SETON                                        52
      *
     C     @MSGID        IFNE      *BLANK
     C     WFPMTSF1      ORNE      *BLANK
     C                   MOVEL     *BLANK        WFPMTSF1
     C                   EXSR      FMTC1
     C                   WRITE     #MSGCTL
     C                   EXFMT     EM0040C1
     C                   ELSE
      *
     C     KTFCB0        SETLL     EMTFCBF0                               50
      *
      ** Case insert (F9) or empty record in EMTFCBPD
      *
     C     *INKI         IFEQ      '1'
     C     *IN50         OREQ      '0'
      *
      ** If SF1 empty in enquire mode don't display the lines
     C     *IN50         IFEQ      '0'
     C     P#ENQY        ANDEQ     'Y'
      ** SFLDSP OFF
     C                   SETOFF                                       52
     C                   ENDIF
      *
      ** Reset error indicators for non protected fields
     C                   SETOFF                                       62
     C                   SETOFF                                       63
     C                   MOVE      'Y'           WFINSERT
      ** Footer text without F9
     C                   SETOFF                                       59
     C                   WRITE     EM0040F1
      ** SFLINZ
     C                   SETON                                        54
     C                   Z-ADD     1             @@RNC1
     C                   EXSR      FMTC1
     C                   WRITE     #MSGCTL
     C                   EXFMT     EM0040C1
     C                   SETOFF                                       54
     C                   ELSE
      *
      ** Other cases
      *
      ** SFLCLR
     C                   SETON                                        51
     C                   WRITE     EM0040C1
     C                   SETOFF                                       51
     C                   Z-ADD     0             EMRNS1
     C                   Z-ADD     0             WTSBLI
     C                   MOVE      'N'           WFINSERT
     C     KTFCB0        READE     EMTFCBF0                               50
     C                   UNLOCK    EMTFCBL0
     C     *IN50         DOWEQ     '0'
      *
     C                   ADD       1             EMRNS1
     C                   Z-ADD     EMRNS1        @@RNC1
     C                   EXSR      FMTSF1
     C                   SETON                                        59
     C     CBACNO        CHAIN     EMTFSAL1                           57
     C     *IN57         IFEQ      *OFF
     C                   MOVE      SATYPE        #TYPE
     C                   ENDIF
      *
     C                   WRITE     EM0040S1
      *
     C     KTFCB0        READE     EMTFCBF0                               50
     C                   UNLOCK    EMTFCBL0
     C                   ENDDO
      *
      ** Footer text with F9
     C                   WRITE     EM0040F1
     C                   EXSR      FMTC1
     C                   Z-ADD     1             @@RNC1
     C                   WRITE     #MSGCTL
     C                   EXFMT     EM0040C1
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
      *         EM0090S                                               *
      *****************************************************************
     C     PMTSF1        BEGSR
      *
      ** Get field description from CSRFLD and select
     C                   SELECT
      *
      ** Account Code only in insert
     C     @@CFC1        WHENEQ    'SACNO'
     C     WFINSERT      ANDEQ     'Y'
     C                   CALL      'SDC0033'
     C                   PARM      *BLANKS       RTNCDE            7
     C                   PARM      *BLANKS       W#ACOD
      *
      ** Update Sub-File
     C     W#ACOD        IFNE      *BLANKS
     C     @@RNS1        CHAIN     EM0040S1                           56
     C     *IN56         IFEQ      '0'
     C                   MOVEL     W#ACOD        SACNO
     C     KACOD0        CHAIN     SDACODF0                           57
     C     *IN57         IFEQ      '0'
     C                   MOVEL     A5ACCN        SACCN
     C                   ELSE
     C                   MOVEL     *BLANK        SACCN
     C                   ENDIF
      ** SFLNXTCHG for S/R CHKSF1
     C                   SETON                                        53
     C                   UPDATE    EM0040S1
     C                   ENDIF
     C                   ENDIF
      *
      ** Scaling File
     C     @@CFC1        WHENEQ    'SSCL'
     C                   CALL      'EM9000S'
     C                   PARM      *BLANKS       RTNCDE            7
     C                   PARM      *BLANKS       W#SCAL
      *
      ** Update Sub-File
     C     W#SCAL        IFNE      *BLANKS
     C     @@RNS1        CHAIN     EM0040S1                           56
     C     *IN56         IFEQ      '0'
     C                   MOVEL     W#SCAL        SSCL
      ** SFLNXTCHG for S/R CHKSF1
     C                   SETON                                        53
     C                   UPDATE    EM0040S1
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
     C                   MOVEL     *BLANK        @MSGIDAM
     C                   MOVEL     *BLANK        @MSGID
      *
      ** Clear the message queue
      *
     C                   CALL      'ZA0250'
      *
     C                   MOVEL     'N'           WFPOSPAG
     C                   Z-ADD     0             EMRNS2
     C                   Z-ADD     0             I
     C                   MOVEL     *BLANK        ACD@
      *
      ** SFLCLR for Records to be deleted
     C                   SETON                                        67
     C                   WRITE     EM0040C2
     C                   SETOFF                                       67
      *
     C                   READC     EM0040S1                               56
     C     *IN56         DOWEQ     '0'
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
      ** Global checks common to the 3 cases
     C                   EXSR      CKGSF1
      *
      ** SFLNXTCHG for S/R UPDSF1
     C                   SETON                                        53
      ** To display the right page in case of several errors
     C     @MSGID        IFNE      *BLANK
     C     WFPOSPAG      IFEQ      'N'
     C                   MOVEL     'Y'           WFPOSPAG
     C                   Z-ADD     EMRNS1        @@RNC1
     C                   ENDIF
     C                   ENDIF
      *
     C                   UPDATE    EM0040S1
     C                   READC     EM0040S1                               56
     C                   ENDDO
      *
     C     END_CHKSF1    ENDSR
      *****************************************************************
      * S/R CHECKING CONTROL SF1                                      *
      * CALLED BY MAIN PROCEDURE                                      *
      *****************************************************************
     C     CHKC1         BEGSR
     C                   SETOFF                                       65
     C                   SETOFF                                       66
      *
     C     P#PCTG        IFEQ      'N'
     C     WTSBLI        IFNE      P#TFLI
     C     WTSBLI        ANDNE     0
     C     P#TFLI        ANDNE     0
     C                   MOVEL     'EMT0041'     @MSGIDAM
     C                   MOVEL     @MSGIDAM      MSGID
     C                   EXSR      SNDMSG
     C                   SETON                                        65
     C                   SETON                                        66
     C                   ENDIF
     C                   ELSE
     C     WTSBLI        IFNE      P#TFLI
     C     WTSBLI        ANDNE     0
     C                   MOVEL     'EMT0041'     @MSGIDAM
     C                   MOVEL     @MSGIDAM      MSGID
     C                   EXSR      SNDMSG
     C                   SETON                                        65
     C                   SETON                                        66
     C                   ENDIF
     C                   ENDIF
      *
     C     END_CHKC1     ENDSR
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
      * S/R UPDATING SF1                                              *
      * CALLED BY MAIN PROCEDURE                                      *
      *****************************************************************
     C     UPDSF1        BEGSR
      *
     C                   READC     EM0040S1                               56
     C     *IN56         DOWEQ     '0'
      *
     C                   SELECT
     C     WFINSERT      WHENEQ    'Y'
      ** Add processing
     C                   EXSR      CRESF1
     C     SSEL          WHENEQ    'D'
     C     WFCNFDLT      ANDEQ     'Y'
      ** Deletion processing
     C                   EXSR      DLTSF1
     C                   OTHER
      ** Amendment processing
     C                   EXSR      AMDSF1
     C                   ENDSL
      ** Error I/O
     C     *IN69         IFEQ      '1'
     C                   LEAVE
     C                   ENDIF
      *
     C                   READC     EM0040S1                               56
     C                   ENDDO
     C     END_UPDSF1    ENDSR
      *****************************************************************
      * S/R FIELDS FORMATING SF1                                      *
      * CALLED BY S/R INISF1                                          *
      *****************************************************************
     C     FMTSF1        BEGSR
     C                   MOVE      *BLANK        SSEL
     C                   MOVE      CBACNO        SACNO
     C                   MOVE      CBLIM         SLIM
      *
     C                   MOVE      CBLIM         @@ALPH
     C                   EXSR      FMTAMT
     C                   MOVE      @@ALPH        SLIM
     C                   MOVE      @@ALPH        SHLIM
     C                   MOVE      @@AMT         WSBLI
      *
     C                   MOVEL     CBSCL         SSCL
      *
     C     P#PCTG        IFEQ      'N'
     C     WSBLI         IFGT      P#TFLI
     C     P#TFLI        ANDNE     0
     C                   SETON                                        62
     C                   ELSE
     C                   SETOFF                                       62
     C                   ENDIF
     C                   ELSE
     C     WSBLI         IFGT      P#TFLI
     C                   SETON                                        62
     C                   ELSE
     C                   SETOFF                                       62
     C                   ENDIF
     C                   ENDIF
      *
     C     KACOD0        CHAIN     SDACODF0                           57
     C     *IN57         IFEQ      '0'
     C                   MOVEL     A5ACCN        SACCN
     C                   ELSE
     C                   MOVEL     *BLANK        SACCN
     C                   ENDIF
      *
     C                   ADD       WSBLI         WTSBLI
      *
     C     END_FMTSF1    ENDSR
      *****************************************************************
      * S/R FIELDS FORMATTING CONTROL SF1                             *
      * CALLED BY S/R INISF1                                          *
      *****************************************************************
     C     FMTC1         BEGSR
      *
     C                   MOVE      WTSBLI        @@ALPH
     C                   EXSR      FMTAMT
     C                   MOVE      @@ALPH        SSBLI
      *
     C     P#PCTG        IFEQ      'N'
     C     WTSBLI        IFEQ      P#TFLI
     C     WTSBLI        OREQ      0
     C     P#TFLI        OREQ      0
     C                   MOVEL     'N'           WFINIT
     C                   SETOFF                                       65
     C                   SETOFF                                       66
     C                   ELSE
      *
      * When it is the first processing we display msg
     C     WFINIT        IFNE      'N'
     C                   MOVEL     'N'           WFINIT
     C                   MOVEL     'EMT0041'     @MSGIDAM
     C                   MOVEL     @MSGIDAM      MSGID
     C                   EXSR      SNDMSG
     C                   ENDIF
     C                   SETON                                        65
     C                   SETON                                        66
     C                   ENDIF
     C                   ELSE
     C     WTSBLI        IFEQ      P#TFLI
     C     WTSBLI        OREQ      0
     C                   MOVEL     'N'           WFINIT
     C                   SETOFF                                       65
     C                   SETOFF                                       66
     C                   ELSE
      *
      * When it is the first processing we display msg
     C     WFINIT        IFNE      'N'
     C                   MOVEL     'N'           WFINIT
     C                   MOVEL     'EMT0041'     @MSGIDAM
     C                   MOVEL     @MSGIDAM      MSGID
     C                   EXSR      SNDMSG
     C                   ENDIF
     C                   SETON                                        65
     C                   SETON                                        66
     C                   ENDIF
     C                   ENDIF
      *
     C     END_FMTC1     ENDSR
      *****************************************************************
      * CHECKS FOR ADD INSF1                                          *
      * CALLED BY S/R CHKSF1                                          *
      *****************************************************************
     C     CKISF1        BEGSR
     C                   SETOFF                                       60
      *
      ** Account number is mandatory
     C     SACNO         IFEQ      *BLANK
     C                   MOVEL     *BLANK        SACCN
     C     SLIM          IFNE      *BLANK
     C     SSCL          ORNE      *BLANK
     C                   MOVEL     'EMT0011'     @MSGID
     C                   MOVEL     @MSGID        MSGID
     C                   EXSR      SNDMSG
     C                   SETON                                        60
     C                   ENDIF
     C                   ENDIF
      *
      ** Value 0 is not allowed for the account number
     C     *IN60         IFEQ      '0'
     C     SACNO         IFEQ      *ZEROS
     C                   MOVEL     'EMT0035'     @MSGID
     C                   MOVEL     @MSGID        MSGID
     C                   EXSR      SNDMSG
     C                   SETON                                        60
     C                   ENDIF
     C                   ENDIF
      *
      ** Account number is to be numeric
     C     *IN60         IFEQ      '0'
     C     SACNO         IFNE      *BLANK
     C     WNUMBER       CHECK     SACNO                                  60
     C     *IN60         IFEQ      '1'
     C                   MOVEL     'EMT0036'     @MSGID
     C                   MOVEL     @MSGID        MSGID
     C                   EXSR      SNDMSG
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      ** Duplicate account detected
     C     *IN60         IFEQ      '0'
     C     SACNO         IFNE      *BLANK
     C                   Z-ADD     1             I
     C     ACD@(I)       DOWNE     *BLANK
     C     ACD@(I)       IFEQ      SACNO
     C                   MOVEL     'EMT0037'     @MSGID
     C                   MOVEL     @MSGID        MSGID
     C                   EXSR      SNDMSG
     C                   SETON                                        60
     C                   LEAVE
     C                   ENDIF
     C                   ADD       1             I
     C                   ENDDO
     C                   ENDIF
     C                   ENDIF
      *
      ** Account must exist
      ** Account must be a trade finance contingent account
     C     *IN60         IFEQ      '0'
     C     SACNO         IFNE      *BLANK
     C                   MOVEL     *BLANK        SACCN
     C                   MOVEL     'N'           A5TFCT
     C     KACOD0        SETLL     SDACODF0                               57
     C     *IN57         IFEQ      '1'
     C     KACOD0        READE     SDACODF0                               57
     C     *IN57         IFEQ      '0'
     C     A5TFCT        ANDEQ     'Y'
     C                   MOVEL     A5ACCN        SACCN
     C                   ENDIF
     C                   ENDIF
     C     A5TFCT        IFNE      'Y'
     C                   MOVEL     'EMT0014'     @MSGID
     C                   MOVEL(P)  SACNO         MSGDTA
     C                   MOVEL     @MSGID        MSGID
     C                   EXSR      SNDMSG
     C                   SETON                                        60
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      ** A Sub-Line must be defined for this account
     C     *IN60         IFEQ      '0'
     C     SACNO         IFNE      *BLANK
     C                   MOVE      SACNO         SAACOD
     C*    KTFSA1        SETLL     EMTFSAL1                               57
     C     KTFSA1        CHAIN     EMTFSAL1                           57
     C     *IN57         IFEQ      *ON
     C                   MOVEL     'EMT0055'     @MSGID
     C                   MOVEL(P)  SACNO         MSGDTA
     C                   MOVEL     @MSGID        MSGID
     C                   EXSR      SNDMSG
     C                   SETON                                        60
     C                   ELSE
     C                   MOVE      SATYPE        #TYPE
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      ** Account must not already exist in customer balance
     C     *IN60         IFEQ      '0'
     C     SACNO         IFNE      *BLANK
     C                   MOVE      SACNO         CBACNO
     C     KTFCB1        SETLL     EMTFCBL0                               57
     C     *IN57         IFEQ      '1'
     C                   MOVEL     'EMT0034'     @MSGID
     C                   MOVEL(P)  SACNO         MSGDTA
     C                   MOVEL     @MSGID        MSGID
     C                   EXSR      SNDMSG
     C                   SETON                                        60
     C                   ENDIF
      ** Filling Array of Account to detect duplicate account
     C     *IN60         IFEQ      '0'
     C                   MOVEA     SACNO         ACD@(I)
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C     END_CKISF1    ENDSR
      *****************************************************************
      * S/R CHECKS FOR AMEND IN SF1                                   *
      * CALLED BY S/R CHKSF1                                          *
      *****************************************************************
     C     CKASF1        BEGSR
     C                   SETOFF                                       61
      *
      ** The only value allowed for selection field is D
     C     SSEL          IFNE      *BLANK
     C                   MOVEL     'EMT0004'     @MSGID
     C                   MOVEL(P)  SSEL          MSGDTA
     C                   MOVEL     @MSGID        MSGID
     C                   EXSR      SNDMSG
     C                   SETON                                        61
     C                   ENDIF
      *
     C     END_CKASF1    ENDSR
      *****************************************************************
      * S/R CHECKS FOR DELETE IN SF1                                  *
      * CALLED BY S/R CHKSF1                                          *
      *****************************************************************
     C     CKDSF1        BEGSR
     C                   SETOFF                                       61
     C                   ADD       1             EMRNS2
     C                   WRITE     EM0040S2
      *
     C     END_CKDSF1    ENDSR
      *****************************************************************
      * S/R COMMONS CHECKS IN SF1                                     *
      * CALLED BY S/R CHKSF1                                          *
      *****************************************************************
     C     CKGSF1        BEGSR
     C                   SETOFF                                       62
     C                   SETOFF                                       63
     C                   SETOFF                                       66
     C                   MOVE      *BLANK        WSLIMA
     C                   Z-ADD     0             WSLIMN
      *
      ** Amount must be correct
     C     SLIM          IFNE      *BLANK
     C                   MOVE      SLIM          @@ALPH
     C                   EXSR      FMTAMT
     C                   MOVE      @@ALPH        WSLIMA
     C                   MOVE      @@AMT         WSLIMN
     C     @@Ercd        IFNE      0
     C                   MOVEL     'EMT0043'     @MSGID
     C                   MOVEL     @MSGID        MSGID
     C                   EXSR      SNDMSG
     C                   SETON                                        62
     C                   ENDIF
     C                   ENDIF
      *
     C     *IN62         IFEQ      '0'
      *
     C     SHLIM         IFNE      SLIM
     C                   MOVE      SHLIM         @@ALPH
     C                   EXSR      FMTAMT
     C                   MOVE      @@ALPH        SHLIM
     C                   MOVE      @@AMT         WSBLI
     C                   SUB       WSBLI         WTSBLI
      *
     C                   MOVE      WSLIMA        SHLIM
     C                   MOVE      WSLIMN        WSBLI
     C                   ADD       WSBLI         WTSBLI
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** We dont need to check other fields if we want to delete the
      ** subfile line's
     C     SSEL          IFEQ      'D'
     C                   GOTO      END_CKGSF1
     C                   ENDIF
      *
     C     SLIM          IFNE      *BLANK
     C     P#PCTG        IFEQ      'N'
     C     WSLIMN        IFGT      P#TFLI
     C     P#TFLI        ANDNE     0
     C                   MOVEL     'EMT0040'     @MSGIDAM
     C                   MOVEL     @MSGIDAM      MSGID
     C                   EXSR      SNDMSG
     C                   SETON                                        62
     C                   ENDIF
     C                   ELSE
     C     WSLIMN        IFGT      P#TFLI
     C                   MOVEL     'EMT0040'     @MSGIDAM
     C                   MOVEL     @MSGIDAM      MSGID
     C                   EXSR      SNDMSG
     C                   SETON                                        62
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C     SSCL          IFNE      *BLANK
      *
      ** The matching pattern for Scaling Factor is T% (% = 0,...,9)
     C     WSCL1         IFNE      'T'
     C                   MOVEL     'EMT0038'     @MSGID
     C                   MOVEL     @MSGID        MSGID
     C                   EXSR      SNDMSG
     C                   SETON                                        63
     C                   ELSE
     C     WNUMBER       CHECK     WSCL2                                  63
     C     *IN63         IFEQ      '1'
     C                   MOVEL     'EMT0038'     @MSGID
     C                   MOVEL     @MSGID        MSGID
     C                   EXSR      SNDMSG
     C                   ENDIF
     C                   ENDIF
      *
      ** Scaling factor must exist
     C     KEXSC0        SETLL     EMEXSCF1                               57
     C     *IN57         IFEQ      '0'
     C                   MOVEL     'EMT0039'     @MSGID
     C                   MOVEL     @MSGID        MSGID
     C                   EXSR      SNDMSG
     C                   SETON                                        63
     C                   ENDIF
      *
     C                   ENDIF
     C     END_CKGSF1    ENDSR
      *****************************************************************
      * S/R INITIALIZE SF2                                            *
      * CALLED BY S/R DSPSF2                                          *
      *****************************************************************
     C     INISF2        BEGSR
      *
     C                   WRITE     EM0040F2
      *
     C                   EXFMT     EM0040C2
      *
     C     END_INISF2    ENDSR
      *****************************************************************
      * S/R CREATE RECORDS IN SF1                                     *
      * CALLED BY S/R UPDSF1                                          *
      *****************************************************************
     C     CRESF1        BEGSR
      ** To not create a account with blanks
     C     SACNO         IFEQ      *BLANK
     C                   GOTO      END_CRESF1
     C                   ENDIF
      ** Fill ALL the fields
     C                   MOVE      P#CUST        CBCUST
     C                   MOVE      SACNO         CBACNO
     C                   MOVE      SLIM          @@ALPH
     C                   EXSR      FMTAMT
     C                   MOVE      @@AMT         CBLIM
     C                   MOVE      SSCL          CBSCL
     C                   Z-ADD     0             CBOFFB
     C                   WRITE     EMTFCBF0                             69
      *
     C     *IN69         IFEQ      '1'
     C                   MOVEL     'EMT0044'     @MSGID
     C                   MOVEL(P)  'EMTFCBPD'    MSGDTA
     C                   MOVEL     @MSGID        MSGID
     C                   EXSR      SNDMSG
     C                   GOTO      END_CRESF1
     C                   ENDIF
      *
     C                   Z-ADD     CBLIM         WCBLIM
     C                   EXSR      UPDLIM
      *
     C     END_CRESF1    ENDSR
      *****************************************************************
      * S/R DELETE RECORDS IN SF1                                     *
      * CALLED BY S/R UPDSF1                                          *
      *****************************************************************
     C     DLTSF1        BEGSR
      *
     C                   MOVE      SACNO         CBACNO
     C     KTFCB1        CHAIN     EMTFCBF0                           5769
     C     *IN69         IFEQ      '1'
     C                   MOVEL     'EMT0045'     @MSGID
     C                   MOVEL     @MSGID        MSGID
     C                   EXSR      SNDMSG
     C                   GOTO      END_DLTSF1
     C                   ENDIF
      *
     C     *IN57         IFEQ      '0'
     C                   DELETE    EMTFCBF0                             69
     C     *IN69         IFEQ      '1'
     C                   MOVEL     'EMT0044'     @MSGID
     C                   MOVEL(P)  'EMTFCBPD'    MSGDTA
     C                   MOVEL     @MSGID        MSGID
     C                   EXSR      SNDMSG
     C                   GOTO      END_DLTSF1
     C                   ENDIF
     C                   ENDIF
      *
     C     KTFCB1        SETLL     EMTFEXF0
     C     KTFCB1        READE     EMTFEXF0                             6957
     C     *IN57         DOWEQ     '0'
      *
     C     *IN69         IFEQ      '1'
     C                   MOVEL     'EMT0045'     @MSGID
     C                   MOVEL     @MSGID        MSGID
     C                   EXSR      SNDMSG
     C                   GOTO      END_DLTSF1
     C                   ENDIF
      *
     C                   DELETE    EMTFEXF0                             69
     C     *IN69         IFEQ      '1'
     C                   MOVEL     'EMT0044'     @MSGID
     C                   MOVEL(P)  'EMTFEXPD'    MSGDTA
     C                   MOVEL     @MSGID        MSGID
     C                   EXSR      SNDMSG
     C                   GOTO      END_DLTSF1
     C                   ENDIF
      *
     C     KTFCB1        READE     EMTFEXF0                             6957
     C                   ENDDO
      *
     C                   MOVE      SHLIM         @@ALPH
     C                   EXSR      FMTAMT
     C                   MOVE      @@AMT         WSBLI
     C                   SUB       WSBLI         WTSBLI
      *
     C     CBLIM         MULT      -1            WCBLIM
     C                   EXSR      UPDLIM
      *
     C     END_DLTSF1    ENDSR
      *****************************************************************
      * S/R AMEND RECORDS IN SF1                                      *
      * CALLED BY S/R UPDSF1                                          *
      *****************************************************************
     C     AMDSF1        BEGSR
     C                   MOVE      SACNO         CBACNO
     C     KTFCB1        CHAIN     EMTFCBF0                           5769
     C     *IN69         IFEQ      '1'
     C                   MOVEL     'EMT0045'     @MSGID
     C                   MOVEL     @MSGID        MSGID
     C                   EXSR      SNDMSG
     C                   GOTO      END_AMDSF1
     C                   ENDIF
      *
     C     *IN57         IFEQ      '0'
     C                   Z-ADD     CBLIM         WOCBLIM
     C                   MOVE      SLIM          @@ALPH
     C                   EXSR      FMTAMT
     C                   MOVE      @@AMT         CBLIM
     C                   MOVE      SSCL          CBSCL
     C                   EXCEPT    TFCBF0
     C                   ENDIF
      *
      ** To update the limits of all dependancies we need first to
      ** substract the amounts with the old one before to add the
      ** new one.
     C     WOCBLIM       MULT      -1            WCBLIM
     C                   EXSR      UPDLIM
     C                   Z-ADD     CBLIM         WCBLIM
     C                   EXSR      UPDLIM
      *
     C     END_AMDSF1    ENDSR
      *****************************************************************
      * S/R UPDLIM UPDATE LIMITS FOR T/F FILE                         *
      * CALLED BY S/R CRESF1                                          *
      *           S/R AMDSF1                                          *
      *           S/R DLTSF1                                          *
      * CALLS : EM0998                                                *
      *****************************************************************
     C     UPDLIM        BEGSR
     C                   MOVE      SACNO         SAACOD
     C     KTFSA1        CHAIN     EMTFSAF1                           5769
     C     *IN69         IFEQ      '1'
     C     *IN57         OREQ      '1'
     C                   MOVEL     'EMT0054'     P#MSG
     C                   MOVEL     'EMTFSAPD'    WFICH1
     C                   MOVE      SAACOD        WACOD1
      *
     C     WCBLIM        IFLT      0
     C     WCBLIM        MULT      -1            WCBLIM
     C                   MOVEL     'N'           WFPOSITV
     C                   ELSE
     C                   MOVEL     'Y'           WFPOSITV
     C                   ENDIF
      *
     C                   MOVE      WCBLIM        @@ALPH
     C                   EXSR      FMTAMT
     C                   MOVEL     @@ALPH        WALPH
     C     WFPOSITV      IFEQ      'Y'
     C                   EVAL      WAMNT1 = '+' + WALPH
     C                   ELSE
     C                   EVAL      WAMNT1 = '-' + WALPH
     C                   ENDIF
      *
     C                   MOVEL     WMSDA1        P#MSDA
     C                   MOVEL     'EM0040'      P#PGMN
     C                   MOVEL     'EMUSRMSG'    P#MSGF
     C                   MOVEL     '0'           P#INLR
     C                   CALL      'EM0998'
     C                   PARM                    P#0998
     C                   GOTO      END_UPDLIM
     C                   ENDIF
      *
     C     *IN57         IFEQ      '0'
     C                   ADD       WCBLIM        SALIM
     C                   EXCEPT    TFSAF1
     C                   ENDIF
      *
      *
     C     END_UPDLIM    ENDSR
      *****************************************************************
      * S/R FMTAMT FORMAT/CHECK AMOUNTS                               *
      * CALLED BY SEVERAL SUBROUTINES                                 *
      * CALLS : ZA0840                                                *
      *****************************************************************
     C     FMTAMT        BEGSR
     C                   CALLB     'ZA0840'
     C                   PARM                    RetCodeIn
     C                   PARM                    @@ALPH
     C                   PARM      0             @@IDP
     C                   PARM      15            @@IINT
     C                   PARM      'Y'           @@MTID
     C                   PARM                    @@Ercd
     C                   PARM                    @@Amt
     C                   PARM      '.'           BNDCSP
     C     END_FMTAMT    ENDSR
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
     C                   MOVEL     *BLANK        MSGID
     C                   MOVEL     *BLANK        MSGDTA
      *
     C                   ENDIF
      *
     C     END_SNDMSG    ENDSR
      *
      ********************************************************************
     OEMTFCBF0  E            TFCBF0
     O                       CBLIM
     O                       CBSCL
     OEMTFSAF1  E            TFSAF1
     O                       SALIM
**  CPY@
(c) Finastra International Limited 2001
