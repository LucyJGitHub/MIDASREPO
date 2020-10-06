     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2011')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas Historic Interest Scale Report Maintenance')     *
      *****************************************************************
      *                                                               *
      *  Midas - User Defined Correspondence                          *
      *                                                               *
      *  CG7150 - Midas Historic Interest Scale Acct Print Request    *
      *                                                               *
      * Function: Program shows a screen to enter requests for an     *
      *           interest scale report of a specified account for a  *
      *           for a specific period.                              *
      *                                                               *
      *  Called By: CGC7150 - Historic Int. Scale Report Print Request*
      *                       Request                                 *
      *                                                               *
      *  (c) Finastra International Limited 2011                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CER042  *CREATE    Date 11May11               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *           (Recompile)                                         *
      *  MD046248 - Finastra Rebranding                               *
      *  CER042 - Interest Scale Report Correspondence                *
      *           (Upgrade of FGE178/179)                             *
      *                                                               *
      *---------------------------------------------------------------*
      *  Indicator Usage                                              *
      *                                                               *
      *  03 - Terminate function                                      *
      *  06 - Confirm delete                                          *
      *  09 - Add/ display mode                                       *
      *  12 - Previous                                                *
      *  25 - Message SFL processing                                  *
      *  40 - SFLCLR                                                  *
      *  41 - SFLDSP                                                  *
      *  65 - Result of test numeric & array lookup                   *
      *  66 - Account (PC)       - Add mode                           *
      *  67 - SFL option (PC)                                         *
      *  68 - SFL option error                                        *
      *  69 - SFLNXTCHG                                               *
      *  70 - Account error      - Add mode                           *
      *  71 - First month error  - Add mode                           *
      *  72 - Last month error   - Add mode                           *
      *  73 - Delete Mode                                             *
      *  87 - Delete record                                           *
      *  88 - Read changed SFL record/s                               *
      *  89 - SFLEND                                                  *
      *                                                               *
      *****************************************************************
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *INZSR      - Initialise                                      *
      * *PSSR       - Error processing                                *
      *                                                               *
      *****************************************************************

      ** Interest Scale Historic Print Request - Update/ Add
     FCGISHPL0  UF A E           K DISK    INFSR(*PSSR)
     F                                     INFDS(INFDS1)
     F                                     RENAME(CGISHPD0:ZHPDL0)
     F                                     COMMIT
      ** Interest Scale Both Qualifying Account Codes - Read
     FCGISBQL0  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(CGISDQD0:ZDQDL0)
     F                                     RENAME(CGISRQD0:ZRQDL0)
      ** Historic Interest Scale Account Print Request Screen
     FCG7150DF  CF   E             WORKSTN INFDS(INFDS2)
     F                                     SFILE(CG7150S1:WSRRN)

      ** Parameter list for Y2SNMGC
     D ZAPGMQ          S             10A
     D ZAPGRL          S              5A
     D ZAMSID          S              7A
     D ZAMSGF          S             10A
     D ZAMSDA          S            132A
     D ZAMSTP          S              7A
      ** Parameter list for AOACCTR0
     D PMRTCD          S              7A
     D PMTYPE          S              7A
     D PMACID          S             10A
     D PMCNUM          S              6A
     D PMCCY           S              3A
     D PMACOD          S             10A
     D PMACSQ          S              2A
     D PMBRCA          S              3A
      ** Working variables
     D WSMODE          S              5A
     D WSRUN           S              1A
     D WSCHGS          S              3A
     D WSVAL           S              3A
     D WSFERR          S              3A

      ** Copyright statement array
     D CPY             S             80    DIM(1) CTDATA PERRCD(1)
      ** Month names array
     D MTH             S              9    DIM(12) CTDATA PERRCD(1)
      ** Interest Scale Historic Print Request INFDS
     D INFDS1        E DS                  EXTNAME(Y2I1DSP)
      ** Historic Interest Scale Account Print Request Screen INFDS
     D INFDS2        E DS                  EXTNAME(Y2I#DSP)
      *  Database error details DA
     D LDA           E DS           256    EXTNAME(LDA)
      ** Installation control details DS
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      ** Account details DS
     D SDACCN        E DS                  EXTNAME(ACCNTAB)
      ** Local DS for access programs, long DS
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Midas user details DS (ZMUSER)
     D WUSER           DS            17
     D  WSURID                 1     10
      ** Program status DS
     D PSDS           SDS
      *
     D  WPGM             *PROC
     D  WSID                 244    253
     D  USER                 254    263
      ** Midas message file default
     D MSGFIL          DS
     D  CSMSGF                 1     10    INZ('CGUSRMSG')
      ** Midas Account Number DS
     D WSACCT          DS
     D  WSBRCA                 1      3
     D  WSCNUM                 4      9
     D  WSCCY                 10     12
     D  WSACOD                13     22
     D  WSACSQ                23     24
      ** Date 'CCYYMMDD' DS
     D WSCYMD          DS
     D  WSCY                   1      4
     D  W1CY                   1      4  0
     D  WSCC                   1      2  0
     D  WSYY                   3      4  0
     D  WSMM                   5      6  0
     D  WSDD                   7      8  0

      *****************************************************************
      *                                                               *
      * Main routine - Main controlling subroutine                    *
      *                                                               *
      * Called by: None                                               *
      *                                                               *
      * Calls:                                                        *
      * CLRSFL - Clear SFL                                            *
      * LODSFL - Load SFL Next Page                                   *
      * CHGMOD - Change Mode                                          *
      * PAGDWN - Page Down                                            *
      * ENTKEY - Enter Key Processing                                 *
      *                                                               *
      *****************************************************************
      ** Screen header
     C                   WRITE     CGC7150H1
      ** Display mode
     C     WSMODE        IFEQ      'DSPLY'
     C                   EXSR      CLRSFL
     C                   EXSR      LODSFL
     C                   ENDIF
      ** Process selection screen until F3
     C     *IN03         DOWEQ     *OFF
     C                   WRITE     #MSGCTL
      ** Display mode
     C     WSMODE        IFEQ      'DSPLY'
     C                   WRITE     CG7150F1
     C                   EXFMT     CG7150S0
      ** SFL RRN
     C                   Z-ADD     @#SFRC        DFRNBR
      ** Add mode
     C                   ELSE
     C                   EXFMT     CG7150F0
     C                   ENDIF
      ** Clear the program message queue
     C                   CALL      'Y2CLMSC'
     C                   PARM                    ZAPGMQ
     C                   PARM                    ZAPGRL

     C                   SELECT
      ** Exit
     C     *IN03         WHENEQ    *ON
     C                   LEAVE
      ** Change mode
     C     *IN09         WHENEQ    *ON
     C                   EXSR      CHGMOD
      ** Pagedown & display mode
     C     *IN25         WHENEQ    *ON
     C     WSMODE        ANDEQ     'DSPLY'
     C                   EXSR      PAGDWN

     C                   OTHER
      ** Enter key
     C                   EXSR      ENTKEY
     C                   ENDSL

     C                   ENDDO
      ** Terminate function
     C                   MOVE      *ON           *INLR
     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * CLRSFL - Clear SFL                                            *
      *                                                               *
      * Called by:                                                    *
      * Main routine - Main controlling subroutine                    *
      *                                                               *
      * Calls:                                                        *
      * None                                                          *
      *                                                               *
      *****************************************************************
     C     CLRSFL        BEGSR
      ** Clear SFL & reset SFL display indicator
     C                   MOVE      *ON           *IN40
     C                   WRITE     CG7150S0
     C                   MOVE      *OFF          *IN40
      ** Reset SFL record number
     C                   Z-ADD     *ZERO         WSRRN
      ** Reset RRN of last record loaded into SFL
     C                   Z-ADD     *ZERO         WSLRRN

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * LODSFL - Load SFL Next Page                                   *
      *                                                               *
      * Called by:                                                    *
      * Main routine - Main controlling subroutine                    *
      *                                                               *
      * Calls:                                                        *
      * SNDMSG - Send Message To Message Queue                        *
      *                                                               *
      *****************************************************************
     C     LODSFL        BEGSR

      ** Reset SFL record number to RRN of last record loaded into SFL
     C                   Z-ADD     WSLRRN        WSRRN
      ** Position SFL
     C     BZHPL0        SETLL     ZHPDL0

     C                   MOVE      *ON           *IN67
     C                   MOVEA     '000000'      *IN(68)
     C                   MOVE      *ON           *IN69
      ** Build a SFL page
     C                   DO        SFLPAG
     C                   READ(N)   ZHPDL0                                 89
      ** At EOF
     C     *IN89         IFEQ      *ON

      ** Position SFL key fields
     C                   MOVE      *HIVAL        Z2BRCA
     C                   MOVE      *ALL'9'       Z2CNUM
     C                   MOVE      *HIVAL        Z2CCY
     C                   MOVE      *ALL'9'       Z2ACOD
     C                   MOVE      *ALL'9'       Z2ACSQ
     C                   MOVE      *ALL'9'       Z2REFN
     C                   MOVE      *HIVAL        Z2REFT
     C                   MOVE      *ALL'9'       Z2FMTH
     C                   MOVE      *ALL'9'       Z2LMTH
     C                   LEAVE
     C                   ENDIF
      ** Initialise SFL fields with data
     C                   CLEAR                   DSOPTN
     C                   MOVEL(P)  Z2BRCA        WSBRCA
     C                   MOVE      Z2CNUM        WSCNUM
     C                   MOVEL(P)  Z2CCY         WSCCY
     C                   MOVE      Z2ACOD        WSACOD
     C                   MOVE      Z2ACSQ        WSACSQ
     C                   MOVEL(P)  WSACCT        DSACCT
     C                   MOVE      Z2FMTH        DSFMTH

     C     Z2LMTH        IFEQ      *ZERO
     C                   CLEAR                   DSLMTH
     C                   ELSE
     C                   MOVE      Z2LMTH        DSLMTH
     C                   ENDIF

      ** Increment SFL record number
     C                   ADD       1             WSRRN

      ** Write SFL record
     C                   WRITE     CG7150S1

     C                   MOVE      *OFF          *IN67
     C                   MOVE      *OFF          *IN69
     C                   ENDDO

      ** If not EOF read one more record, used to set the SFLEND
      ** indicator
     C     *IN89         IFEQ      *OFF
     C                   READ(N)   ZHPDL0                                 89
     C                   ENDIF

      ** If SFl empty
     C     WSRRN         IFEQ      *ZERO
     C                   MOVE      *OFF          *IN41

     C                   MOVE      'ISR0001'     ZAMSID
     C                   EXSR      SNDMSG

      ** If SFl not empty
     C                   ELSE
     C                   MOVE      *ON           *IN41

      ** Reset SFL RRN to SFL record number
     C                   Z-ADD     WSRRN         DFRNBR

      ** Reset RRN of last record loaded into SFL to SFL record number
     C                   Z-ADD     WSRRN         WSLRRN
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * CHGMOD - Change Mode                                          *
      *                                                               *
      * Called by:                                                    *
      * Main routine - Main controlling subroutine                    *
      *                                                               *
      * Calls:                                                        *
      * CLRSFL - Clear SFL                                            *
      * LODSFL - Load SFL Next Page                                   *
      *                                                               *
      *****************************************************************
     C     CHGMOD        BEGSR

     C                   CLEAR                   CG7150F0

     C                   SELECT
      ** Display mode ...
     C     WSMODE        WHENEQ    'DSPLY'
     C                   MOVEL     'ADD  '       WSMODE
      ** Add mode ...
     C                   OTHER
     C                   MOVEL     'DSPLY'       WSMODE
      ** Account ...
     C                   MOVE      *BLANK        Z2BRCA
     C                   MOVE      *ZERO         Z2CNUM
     C                   MOVE      *BLANK        Z2CCY
     C                   MOVE      *ZERO         Z2ACOD
     C                   MOVE      *ZERO         Z2ACSQ
     C                   MOVE      *ZERO         Z2REFN
     C                   MOVE      *BLANK        Z2REFT
      ** First month ...
     C                   MOVE      *ZERO         Z2FMTH
      ** Last month ...
     C                   MOVE      *ZERO         Z2LMTH

     C                   CLEAR                   DFACTS
     C                   CLEAR                   DFFMTS
     C                   CLEAR                   DFLMTS
     C                   EXSR      CLRSFL
     C                   EXSR      LODSFL
     C                   ENDSL

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * PAGDWN - Page Down                                            *
      *                                                               *
      * Called by:                                                    *
      * Main routine - Main controlling subroutine                    *
      *                                                               *
      * Calls:                                                        *
      * CLRSFL - Clear SFL                                            *
      * LODSFL - Load SFL Next Page                                   *
      * SNDMSG - Send Message To Message Queue                        *
      *                                                               *
      *****************************************************************
     C     PAGDWN        BEGSR

     C                   SELECT
      ** When SFL position to fields change ...
     C     DFACTS        WHENNE    *BLANK
     C     DFFMTS        ORNE      *BLANK
     C     DFLMTS        ORNE      *BLANK
     C                   MOVE      *ZERO         Z2REFN
     C                   MOVE      *BLANK        Z2REFT
     C                   MOVE      *ZERO         Z2FMTH
     C                   MOVE      *ZERO         Z2LMTH

      ** Account ...
     C     DFACTS        IFNE      *BLANK
     C                   MOVEL(P)  DFACTS        WSACCT
     C                   MOVEL(P)  WSBRCA        Z2BRCA
     C                   MOVE      WSCNUM        Z2CNUM
     C                   MOVEL(P)  WSCCY         Z2CCY
     C                   MOVE      WSACOD        Z2ACOD
     C                   MOVE      WSACSQ        Z2ACSQ
     C                   ENDIF

      ** First month ...
     C     DFFMTS        IFNE      *BLANK
     C                   MOVE      DFFMTS        Z2FMTH
     C                   ENDIF

      ** Last month ...
     C     DFLMTS        IFNE      *BLANK
     C                   MOVE      DFLMTS        Z2LMTH
     C                   ENDIF

     C                   CLEAR                   DFACTS
     C                   CLEAR                   DFFMTS
     C                   CLEAR                   DFLMTS

     C                   EXSR      CLRSFL
     C                   EXSR      LODSFL
      ** When EOF ...
     C     *IN89         WHENEQ    *ON
     C                   MOVE      'ISR0002'     ZAMSID
     C                   EXSR      SNDMSG

      ** Load next SFL page ...
     C                   OTHER
     C                   EXSR      LODSFL
     C                   ENDSL

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ENTKEY - Enter Key Processing                                 *
      *                                                               *
      * Called by:                                                    *
      * Main routine - Main controlling subroutine                    *
      *                                                               *
      * Calls:                                                        *
      * CLRSFL - Clear SFL                                            *
      * LODSFL - Load SFL Next Page                                   *
      * SNDMSG - Send Message To Message Queue                        *
      * DSPVAL - Validate SFL Option/s                                *
      * DSPDEL - Delete Historic Interest Scale Request/s             *
      * ADDVAL - Validate Historic Interest Scale Request             *
      * ADDCRT - Create Historic Interest Scale Request/s             *
      *                                                               *
      *****************************************************************
     C     ENTKEY        BEGSR
      *
     C                   SELECT

      ** When SFL position to fields change ...
     C     DFACTS        WHENNE    *BLANK
     C     DFFMTS        ORNE      *BLANK
     C     DFLMTS        ORNE      *BLANK
     C                   MOVE      *ZERO         Z2REFN
     C                   MOVE      *BLANK        Z2REFT
     C                   MOVE      *ZERO         Z2FMTH
     C                   MOVE      *ZERO         Z2LMTH

      ** Account ...
     C     DFACTS        IFNE      *BLANK
     C                   MOVEL(P)  DFACTS        WSACCT
     C                   MOVEL(P)  WSBRCA        Z2BRCA
     C                   MOVE      WSCNUM        Z2CNUM
     C                   MOVEL(P)  WSCCY         Z2CCY
     C                   MOVE      WSACOD        Z2ACOD
     C                   MOVE      WSACSQ        Z2ACSQ
     C                   ENDIF

      ** First month ...
     C     DFFMTS        IFNE      *BLANK
     C                   MOVE      DFFMTS        Z2FMTH
     C                   ENDIF
      ** Last month ...
     C     DFLMTS        IFNE      *BLANK
     C                   MOVE      DFLMTS        Z2LMTH
     C                   ENDIF
     C                   CLEAR                   DFACTS
     C                   CLEAR                   DFFMTS
     C                   CLEAR                   DFLMTS
     C                   EXSR      CLRSFL
     C                   EXSR      LODSFL
      ** When SFl empty ..
     C     WSMODE        WHENEQ    'DSPLY'
     C     WSRRN         ANDEQ     *ZERO
     C                   MOVE      'ISR0001'     ZAMSID
     C                   EXSR      SNDMSG
      ** Other enter key processing ...
     C                   OTHER
      ** Display mode ...
     C     WSMODE        IFEQ      'DSPLY'
     C                   EXSR      DSPVAL

     C     WSVAL         IFEQ      'YES'
     C                   EXSR      DSPDEL
     C                   ENDIF
      ** Add mode ...
     C                   ELSE
     C                   EXSR      ADDVAL

     C     WSVAL         IFEQ      'YES'
     C                   EXSR      ADDCRT
     C                   ENDIF
     C                   ENDIF
     C                   ENDSL

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * DSPVAL - Validate SFL Option/s                                *
      *                                                               *
      * Called by:                                                    *
      * ENTKEY - Enter Key Processing                                 *
      *                                                               *
      * Calls:                                                        *
      * SNDMSG - Send Message To Message Queue                        *
      *                                                               *
      *****************************************************************
     C     DSPVAL        BEGSR

     C                   MOVE      'YES'         WSVAL
     C                   MOVE      'YES'         WSFERR
      ** Process first changed SFL record ...
     C                   READC     CG7150S1                               88
     C     *IN88         DOWEQ     *OFF

      ** If SFL option field is blank, setoff the SFLNXTCHG & option
      ** (RI) indicators ...
     C     DSOPTN        IFEQ      *BLANK
     C                   MOVEA     '00'          *IN(68)

      ** Update & read next changed SFL record ...
     C                   UPDATE    CG7150S1
     C                   READC     CG7150S1                               88

     C                   ITER
     C                   ENDIF

      ** If SFL option field is NOT 'D' - delete ...
     C     DSOPTN        IFNE      'D'
     C                   MOVE      'NO '         WSVAL
     C                   MOVEA     '11'          *IN(68)

      ** If first SFL option field in error ...
     C     WSFERR        IFEQ      'YES'
     C                   MOVE      'NO '         WSFERR
     C                   Z-ADD     WSRRN         DFRNBR
     C                   ENDIF

     C                   MOVE      'ISR0015'     ZAMSID
     C                   EXSR      SNDMSG

      ** Update & read next changed SFL record ...
     C                   UPDATE    CG7150S1
     C                   READC     CG7150S1                               88
     C                   ITER
     C                   ENDIF

      ** If SFL option field is 'D' - delete ...
     C                   MOVEA     '0'           *IN(68)
     C                   MOVEA     '1'           *IN(69)

      ** Update & read next changed SFL record ...
     C                   UPDATE    CG7150S1
     C                   READC     CG7150S1                               88
     C                   ENDDO

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * DSPDEL - Delete Historic Interest Scale Request/s             *
      *                                                               *
      * Called by:                                                    *
      * ENTKEY - Enter Key Processing                                 *
      *                                                               *
      * Calls:                                                        *
      * DELSCR - Delete Screen Processing                             *
      * CLRSFL - Clear SFL                                            *
      * LODSFL - Load SFL Next Page                                   *
      *                                                               *
      *****************************************************************
     C     DSPDEL        BEGSR

     C                   MOVE      *OFF          *IN66
     C                   MOVE      *ON           *IN73
     C                   MOVE      'NO '         WSCHGS

      ** Process first changed SFL record ...
     C                   READC     CG7150S1                               88
     C     *IN88         DOWEQ     *OFF

      ** Delete screen processing ...
     C                   EXSR      DELSCR
      ** F3=Exit selected from delete screen ...
     C     *IN03         IFEQ      *ON
     C                   LEAVE
     C                   ENDIF
     C                   CLEAR                   DSOPTN
     C                   MOVEA     '00'          *IN(68)
      ** Update & read next changed SFL record ...
     C                   UPDATE    CG7150S1
     C                   READC     CG7150S1                               88
     C                   ENDDO
     C                   MOVE      *ON           *IN66
     C                   MOVE      *OFF          *IN73
      ** If record deletion/s have taken place then re-build SFL
      ** prior to re-display ...
     C     *IN03         IFEQ      *OFF
     C     WSCHGS        ANDEQ     'YES'
     C                   MOVE      *LOVAL        Z2BRCA
     C                   MOVE      *ALL'0'       Z2CNUM
     C                   MOVE      *LOVAL        Z2CCY
     C                   MOVE      *ALL'0'       Z2ACOD
     C                   MOVE      *ALL'0'       Z2ACSQ
     C                   MOVE      *ALL'0'       Z2REFN
     C                   MOVE      *LOVAL        Z2REFT
     C                   MOVE      *ALL'0'       Z2FMTH
     C                   MOVE      *ALL'0'       Z2LMTH
     C                   EXSR      CLRSFL
     C                   EXSR      LODSFL
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * DELSCR - Delete Screen Processing                             *
      *                                                               *
      * Called by:                                                    *
      * DSPDEL - Delete Historic Interest Scale Request/s             *
      *                                                               *
      * Calls:                                                        *
      * DELSET - Setup Delete Screen Fields                           *
      *                                                               *
      *****************************************************************
     C     DELSCR        BEGSR

     C                   MOVE      *OFF          *IN12
      ** Setup delete screen fields ...
     C                   EXSR      DELSET

     C     *IN03         DOUEQ     *ON
     C     *IN12         OREQ      *ON
     C                   WRITE     #MSGCTL
     C                   EXFMT     CG7150F0

     C                   SELECT
     C     *IN03         WHENEQ    *ON
     C     *IN12         OREQ      *ON

      ** F6=Confirm Delete selected ...
     C     *IN06         WHENEQ    *ON

      ** Setup key list fields ...
     C                   MOVE      D1ACCT        WSACCT
     C                   MOVE      WSBRCA        Z2BRCA
     C                   MOVE      WSCNUM        Z2CNUM
     C                   MOVE      WSCCY         Z2CCY
     C                   MOVE      WSACOD        Z2ACOD
     C                   MOVE      WSACSQ        Z2ACSQ
     C                   CLEAR                   Z2REFN
     C                   CLEAR                   Z2REFT
     C                   MOVE      D1FDTE        Z2FMTH
     C                   MOVE      D1LDTE        Z2LMTH

      ** Attempt to delete the historic interest scale print request ...
     C     BZHPL0        DELETE    ZHPDL0                             87

      ** If the record to be deleted was found ...
     C     *IN87         IFEQ      *OFF
     C                   COMMIT
     C                   ENDIF

     C                   MOVE      'YES'         WSCHGS
     C                   MOVE      *ON           *IN12
     C                   ENDSL
     C                   ENDDO

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * DELSET - Setup Delete Screen Fields                           *
      *                                                               *
      * Called by:                                                    *
      * DELSCR - Delete Screen Processing                             *
      *                                                               *
      * Calls:                                                        *
      * None                                                          *
      *                                                               *
      *****************************************************************
     C     DELSET        BEGSR

      ** Setup delete screen fields ...
     C                   CLEAR                   CG7150F0
     C                   MOVE      DSACCT        D1ACCT
     C                   MOVE      DSFMTH        D1FDTE
     C                   MOVE      DSLMTH        D1LDTE

      ** Setup account name ...
     C     3             SUBST     D1ACCT:1      PMBRCA
     C     6             SUBST     D1ACCT:4      PMCNUM
     C     3             SUBST     D1ACCT:10     PMCCY
     C     10            SUBST     D1ACCT:13     PMACOD
     C     2             SUBST     D1ACCT:23     PMACSQ

      ** Obtain account name from ACCNTAB ...
     C                   CALL      'AOACCTR0'
     C                   PARM      *BLANKS       PMRTCD
     C                   PARM      '*KEY   '     PMTYPE
     C                   PARM      *BLANK        PMACID
     C                   PARM                    PMCNUM
     C                   PARM                    PMCCY
     C                   PARM                    PMACOD
     C                   PARM                    PMACSQ
     C                   PARM                    PMBRCA
     C     SDACCN        PARM      SDACCN        DSSDY

      ** If the account exists in ACCNTAB, then output account name
      ** on screen ...
     C     PMRTCD        IFEQ      *BLANK
     C                   MOVEL(P)  ANAM          D1ACTN
     C                   ENDIF

      ** Setup first month description ...
     C                   MOVE      *ALL'0'       WSCYMD
     C                   MOVEL     D1FDTE        WSCYMD

     C     D1FDTE        IFNE      *BLANK
     C     MTH(WSMM)     CAT(P)    WSCY:1        D1FDTN
     C                   ENDIF

      ** Setup last month description ...
     C                   MOVE      *ALL'0'       WSCYMD
     C                   MOVEL     D1LDTE        WSCYMD

     C     D1LDTE        IFNE      *BLANK
     C     MTH(WSMM)     CAT(P)    WSCY:1        D1LDTN
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ADDVAL - Validate Historic Interest Scale Request             *
      *                                                               *
      * Called by:                                                    *
      * ENTKEY - Enter Key Processing                                 *
      *                                                               *
      * Calls:                                                        *
      * SNDMSG - Send Message To Message Queue                        *
      *                                                               *
      *****************************************************************
     C     ADDVAL        BEGSR

     C                   MOVE      'YES'         WSVAL
     C                   MOVE      *ON           *IN66
     C                   MOVEA     '000'         *IN(70)

      ** Account Number

     C     3             SUBST     D1ACCT:1      PMBRCA
     C     6             SUBST     D1ACCT:4      PMCNUM
     C     3             SUBST     D1ACCT:10     PMCCY
     C     10            SUBST     D1ACCT:13     PMACOD
     C     2             SUBST     D1ACCT:23     PMACSQ

      ** The account must exist in ACCNTAB ...
     C                   CALL      'AOACCTR0'
     C                   PARM      *BLANKS       PMRTCD
     C                   PARM      '*KEY   '     PMTYPE
     C                   PARM      *BLANK        PMACID
     C                   PARM                    PMCNUM
     C                   PARM                    PMCCY
     C                   PARM                    PMACOD
     C                   PARM                    PMACSQ
     C                   PARM                    PMBRCA
     C     SDACCN        PARM      SDACCN        DSSDY

      ** If the account exists in ACCNTAB, then output account name
      ** on screen ...
     C     PMRTCD        IFEQ      *BLANK
     C                   MOVEL(P)  ANAM          D1ACTN
      ** Account does NOT exist in ACCNTAB ...
     C                   ELSE
     C                   MOVE      'NO '         WSVAL
     C                   CLEAR                   D1ACTN
     C                   MOVE      *ON           *IN70
     C                   MOVE      'ISR0003'     ZAMSID
     C                   EXSR      SNDMSG
     C                   ENDIF

      ** If the account exists in ACCNTAB, then the account code
      ** portion of the account must exist in the interest scale both
      ** qualifying account codes file (multi format LF) ...
     C     *IN70         IFEQ      *OFF
     C                   MOVE      PMACOD        Z1ACOD

      ** Check account code using first LF format ...
     C     Z1ACOD        CHAIN     ZDQDL0                             70
     C     *IN70         IFEQ      *ON
     C                   MOVE      PMACOD        Z6ACOD

      ** If NRF then check account code using second LF format ...
     C     Z6ACOD        CHAIN     ZRQDL0                             70
     C     *IN70         IFEQ      *ON
      ** Account code not a qualifying account code ...
     C                   MOVE      'NO '         WSVAL
     C                   MOVE      'ISR0004'     ZAMSID
     C                   EXSR      SNDMSG
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      ** First Month
     C                   DO

      ** Mandatory ...
     C     D1FDTE        IFEQ      *BLANK
     C                   MOVE      'NO '         WSVAL
     C                   CLEAR                   D1FDTN
     C                   MOVE      *OFF          *IN66
     C                   MOVE      *ON           *IN71

     C                   MOVE      'ISR0005'     ZAMSID
     C                   EXSR      SNDMSG
     C                   LEAVE
     C                   ENDIF

      ** First month must be numeric ...
     C                   TESTN                   D1FDTE               65

     C     *IN65         IFEQ      *OFF
     C                   MOVE      'NO '         WSVAL
     C                   CLEAR                   D1FDTN
     C                   MOVE      *OFF          *IN66
     C                   MOVE      *ON           *IN71

     C                   MOVE      'ISR0006'     ZAMSID
     C                   EXSR      SNDMSG

     C                   LEAVE
     C                   ENDIF

     C                   MOVE      *ALL'0'       WSCYMD
     C                   MOVEL     D1FDTE        WSCYMD
     C                   Z-ADD     1             WSDD

      ** First year 'CCYY' must NOT be before 1972 ...
     C     W1CY          IFLT      1972
     C                   MOVE      'NO '         WSVAL
     C                   CLEAR                   D1FDTN
     C                   MOVE      *OFF          *IN66
     C                   MOVE      *ON           *IN71
     C                   MOVE      'ISR0007'     ZAMSID
     C                   EXSR      SNDMSG
     C                   LEAVE
     C                   ENDIF

      ** First year 'MM' must be in range 01 thru 12 ...
     C     WSMM          IFLT      01
     C     WSMM          ORGT      12
     C                   MOVE      'NO '         WSVAL
     C                   CLEAR                   D1FDTN
     C                   MOVE      *OFF          *IN66
     C                   MOVE      *ON           *IN71
     C                   MOVE      'ISR0008'     ZAMSID
     C                   EXSR      SNDMSG
     C                   LEAVE
     C                   ENDIF

      ** First month screen description ...
     C     MTH(WSMM)     CAT(P)    WSCY:1        D1FDTN

      ** Store 'First Month' value ...
     C                   MOVEL     WSCYMD        WSFDTE
     C                   ENDDO
      ** Last Month

     C                   DO
      ** Optional ...
     C     D1LDTE        IFEQ      *BLANK

     C                   LEAVE
     C                   ENDIF

      ** Last month must be numeric ...
     C                   TESTN                   D1LDTE               65
     C     *IN65         IFEQ      *OFF
     C                   MOVE      'NO '         WSVAL
     C                   CLEAR                   D1LDTN
     C                   MOVE      *OFF          *IN66
     C                   MOVE      *ON           *IN72
     C                   MOVE      'ISR0009'     ZAMSID
     C                   EXSR      SNDMSG
     C                   LEAVE
     C                   ENDIF

     C                   MOVE      *ALL'0'       WSCYMD
     C                   MOVEL     D1LDTE        WSCYMD
     C                   Z-ADD     1             WSDD
      ** Last year 'CCYY' must NOT be before 1972 ...
     C     W1CY          IFLT      1972
     C                   MOVE      'NO '         WSVAL
     C                   CLEAR                   D1LDTN
     C                   MOVE      *OFF          *IN66
     C                   MOVE      *ON           *IN72
     C                   MOVE      'ISR0010'     ZAMSID
     C                   EXSR      SNDMSG

     C                   LEAVE
     C                   ENDIF

      ** Last year 'MM' must be in range 01 thru 12 ...
     C     WSMM          IFLT      01
     C     WSMM          ORGT      12
     C                   MOVE      'NO '         WSVAL
     C                   CLEAR                   D1LDTN
     C                   MOVE      *OFF          *IN66
     C                   MOVE      *ON           *IN72
     C                   MOVE      'ISR0011'     ZAMSID
     C                   EXSR      SNDMSG

     C                   LEAVE
     C                   ENDIF

      ** Last month screen description ...
     C     MTH(WSMM)     CAT(P)    WSCY:1        D1LDTN
      ** Store 'Last Month' value ...
     C                   MOVEL     WSCYMD        WSLDTE
     C                   ENDDO

      ** Last month is valid ...
     C     *IN72         IFEQ      *OFF
     C     D1LDTE        ANDNE     *BLANK

      ** Last month must be greater than the first month ...
     C     WSLDTE        IFLE      WSFDTE
     C                   MOVE      'NO '         WSVAL
     C                   MOVE      *OFF          *IN66
     C                   MOVE      *ON           *IN72
     C                   MOVE      'ISR0012'     ZAMSID
     C                   EXSR      SNDMSG
     C                   ENDIF
     C                   ENDIF

      ** Duplicate Historic Interest Scale Request/s

      ** If account, first & last month are valid ...
     C     *IN70         IFEQ      *OFF
     C     *IN71         ANDEQ     *OFF
     C     *IN72         ANDEQ     *OFF

     C                   MOVE      D1ACCT        WSACCT
     C                   MOVE      WSBRCA        Z2BRCA
     C                   MOVE      WSCNUM        Z2CNUM
     C                   MOVE      WSCCY         Z2CCY
     C                   MOVE      WSACOD        Z2ACOD
     C                   MOVE      WSACSQ        Z2ACSQ
     C                   CLEAR                   Z2REFN
     C                   CLEAR                   Z2REFT
     C                   MOVE      D1FDTE        Z2FMTH

     C     D1LDTE        IFEQ      *BLANK
     C                   Z-ADD     *ZERO         Z2LMTH
     C                   ELSE
     C                   MOVE      D1LDTE        Z2LMTH
     C                   ENDIF

      ** Duplicate interest scale request/s are NOT allowed ...
     C     BZHPL0        SETLL     ZHPDL0                                 70

     C     *IN70         IFEQ      *ON
     C                   MOVE      'NO '         WSVAL
     C                   MOVEA     '11'          *IN(71)
     C                   MOVE      'ISR0013'     ZAMSID
     C                   EXSR      SNDMSG
     C                   ENDIF
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ADDCRT - Create Historic Interest Scal Request/s              *
      *                                                               *
      * Called by:                                                    *
      * ENTKEY - Enter Key Processing                                 *
      *                                                               *
      * Calls:                                                        *
      * SNDMSG - Send Message To Message Queue                        *
      *                                                               *
      *****************************************************************
     C     ADDCRT        BEGSR

      ** Create historic interest scale print request ...
     C                   WRITE     ZHPDL0
     C                   COMMIT
      ** Completion message ...
     C                   MOVE      'ISR0014'     ZAMSID
     C                   EXSR      SNDMSG

      ** Clear screen fields ...
     C                   CLEAR                   CG7150F0

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SNDMSG - Send Message To Message Queue                        *
      *                                                               *
      * Called by:                                                    *
      * LODSFL - Load SFL Next Page                                   *
      * PAGDWN - Page Down                                            *
      * ENTKEY - Enter Key Processing                                 *
      * DSPVAL - Validate SFL Option/s                                *
      * ADDVAL - Validate Historic Interest Scale Request             *
      * ADDCRT - Create Historic Interest Scale Request/s             *
      *                                                               *
      * Calls:                                                        *
      * None                                                          *
      *                                                               *
      *****************************************************************
     C     SNDMSG        BEGSR

     C                   CALL      'Y2SNMGC'
     C                   PARM                    ZAPGMQ
     C                   PARM                    ZAPGRL
     C                   PARM                    ZAMSID
     C                   PARM                    ZAMSGF
     C                   PARM                    ZAMSDA
     C                   PARM                    ZAMSTP
      ** Clear all fields for default mechanism next time ...
     C                   MOVEL     *BLANK        ZAPGRL
     C                   MOVEL     *BLANK        ZAMSID
     C                   MOVEL     *BLANK        ZAMSDA
     C                   MOVEL     *BLANK        ZAMSTP

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - First Time In Processing                             *
      *                                                               *
      * Called by:                                                    *
      * Automatically                                                 *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR

     C                   MOVEA     CPY           CPY2             80
     C     *DTAARA       DEFINE                  LDA
     C     *DTAARA       DEFINE    ZMUSER        WUSER
     C                   IN        WUSER
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT

      ** Interest Scale Historic Print Request (L0)
     C     BZHPL0        KLIST
     C                   KFLD                    Z2BRCA
     C                   KFLD                    Z2CNUM
     C                   KFLD                    Z2CCY
     C                   KFLD                    Z2ACOD
     C                   KFLD                    Z2ACSQ
     C                   KFLD                    Z2REFN
     C                   KFLD                    Z2REFT
     C                   KFLD                    Z2FMTH
     C                   KFLD                    Z2LMTH

     C     *LIKE         DEFINE    Z2FMTH        WSFDTE
     C     *LIKE         DEFINE    Z2FMTH        WSLDTE
     C     *LIKE         DEFINE    DFRNBR        SFLPAG
     C     *LIKE         DEFINE    DFRNBR        WSRRN
     C     *LIKE         DEFINE    DFRNBR        WSLRRN
     C     *LIKE         DEFINE    DFRNBR        WSCRRN

     C                   MOVEL(P)  USER          D0USER
     C                   MOVEL(P)  WSID          D0WSID
     C                   MOVEL(P)  WPGM          D0PGMN
     C                   MOVEL(P)  AGMRDT        D0RUNA
     C                   MOVEL     WPGM          ZAPGMQ
     C                   MOVEL(P)  CSMSGF        ZAMSGF
     C                   MOVEL     WPGM          ##PGM
     C                   Z-ADD     16            SFLPAG

      ** If the interest scale historic print request file is empty, the
      ** default program mode is 'ADD' otherwise it is 'DISPLAY' ...
     C     @1NROP        IFEQ      *ZERO
     C                   MOVEL     'ADD  '       WSMODE
     C                   ELSE
     C                   MOVEL     'DSPLY'       WSMODE
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - File exception/ error subroutine                     *
      *                                                               *
      * Called by:                                                    *
      * Automatically                                                 *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR

      ** Check to see that *PSSR has not already been called ...
     C     WSRUN         IFEQ      *BLANK
     C                   MOVE      'Y'           WSRUN
     C     DBFILE        IFNE      *BLANK
     C                   MOVE      *ON           *INU8
     C                   ENDIF
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INLR
     C                   DUMP

      ** Program running interactively, call the error handling program
     C                   CALL      'DBERRCTL'
     C                   ENDIF

      ** If *PSSR already run, then end the program here ...
     C     DBFILE        IFNE      *BLANK
     C                   MOVE      *ON           *INU8
     C                   ENDIF

     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INLR
     C                   RETURN

     C                   ENDSR
      ********************************************************************
** CPY
(c) Finastra International Limited 2011
** MTH
January
February
March
April
May
June
July
August
September
October
November
December
