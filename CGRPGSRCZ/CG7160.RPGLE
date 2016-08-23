     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2011')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas DL/LE Inter Scale Qualifying Acct Code Maint')   *
      *****************************************************************
      *                                                               *
      *  Midas - User Defined Correspondence                          *
      *                                                               *
      *  CG7160 - DL/LE Interest Scale Qualifying Account Codes       *
      *           Maintenance                                         *
      *                                                               *
      *  Called By: CGC7160                                           *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2011            *
      *                                                               *
      *  Last Amend No. AR814080           Date 17Aug11               *
      *  Prev Amend No. AR814062           Date 16Aug11               *
      *                 CER042  *CREATE    Date 11May11               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR814080 - Validation rule should be added in Interest Scale *
      *             Dealing/Lending Qualifying Account Codes that     *
      *             entry in account code field should be linked to an*
      *             existing Retail Qualifying Account Code           *
      *  AR814062 - Add validation rule in Interest Scale Dealing/    *
      *             Lending Qualifying Acct Codes Maintenance to      *
      *             accept only CD or CL Deal Type for Dealing and    *
      *             accept Loan Types 61, 68 or 69 for Lending        *
      *  CER042 - Interest Scale Report Correspondence                *
      *           (Upgrade of FGE178/179)                             *
      *                                                               *
      *---------------------------------------------------------------*
      *  Indicator Usage                                              *
      *                                                               *
      *  03 - Terminate function                                      *
      *  06 - Confirm delete/ amend                                   *
      *  09 - Add/ display mode                                       *
      *  12 - Previous                                                *
      *  25 - Message SFL processing                                  *
      *  40 - SFLCLR                                                  *
      *  41 - SFLDSP                                                  *
      *  65 - Result of test numeric                                  *
      *  67 - SFL option (PC)                                         *
      *  68 - SFL option error                                        *
      *  69 - SFLNXTCHG                                               *
      *  70 - DL type error      - Add/ Amend mode                    *
      *  71 - DL sub type error  - Add/ Amend mode                    *
      *  72 - Account code error - Add/ Amend mode                    *
      *  73 - Transaction class error - Add/ Amend mode               *
      *  86 - CHAIN/ SETLL                                            *
      *  87 - Delete/ amend record                                    *
      *  88 - Read changed SFL record/s                               *
      *  89 - SFLEND                                                  *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** Interest Scale DL/LE Qualifying Account Codes
     FCGISDQL0  UF A E           K DISK    INFSR(*PSSR)
     F                                     INFDS(INFDS1)
     F                                     RENAME(CGISDQD0:CDQPL1)
     F                                     COMMIT
      ** Deal Type/Sub-Type Codes/Class
     FFDDTSTL0  IF   E           K DISK    INFSR(*PSSR)
      ** Loan Type/Sub-Type Codes/Class
     FSDLOANL0  IF   E           K DISK    INFSR(*PSSR)
      ** Interest Scale Retail Qualifying Account Codes                                     AR814080
     FCGISRQL0  IF A E           K DISK    INFSR(*PSSR)                                     AR814080
      ** Retail Interest Scale Qualifying Account Codes Maint Screen
     FCG7160DF  CF   E             WORKSTN INFDS(INFDS2)
     F                                     SFILE(CG7160S1:WSRRN)
 
      ** Working variables
     D WSMODE          S              5A
     D WSRUN           S              1A
     D WSCHGS          S              3A
     D WSVAL           S              3A
     D WSFERR          S              3A
     D WTyp_STyp_Flg   S              1A                                                    AR814062
     D WACODN          S             10  0                                                  AR814080
     D CDL038          S              1A
     D CLE042          S              1A
      ** Parameter list for Y2SNMGC
     D ZAPGMQ          S             10A
     D ZAPGRL          S              5A
     D ZAMSID          S              7A
     D ZAMSGF          S             10A
     D ZAMSDA          S            132A
     D ZAMSTP          S              7A
      ** Parameter list for AOACODR0
     D PMRTCD          S              7A
     D PMTYPE          S              7A
     D PMACOD          S             10A
      ** Parameter list for AOLOANR0
     D PMDLTP          S              2A
     D PMDLST          S              2A
     D PMTRCL          S              4A
      ** Parameter list for AOSARDR0
     D POptn           S              7A
     D PSard           S              6A
      ** Copyright statement array
     D CPY             S             80    DIM(1) CTDATA PERRCD(1)
      ** Interest Scale DL/LE Qualifying Account Codes INFDS
     D INFDS1        E DS                  EXTNAME(Y2I1DSP)
 
      ** Retail Interest Scale Qualifying Account Codes Maint. Screen
      ** INFDS
     D INFDS2        E DS                  EXTNAME(Y2I#DSP)
 
      ** Database error details DA
     D LDA           E DS           256    EXTNAME(LDA)
 
      ** Installation control details DS
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
 
      ** Account Code details DS
     D SDACOD        E DS                  EXTNAME(SDACODPD)
 
      ** DS for SC Switchable Features
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
 
      ** Local DS for access programs, short DS
     D DSSDY         E DS                  EXTNAME(DSSDY)
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
 
      ** Program status DS
     D PSDS           SDS
 
     D  WPGM             *PROC
     D  WSID                 244    253
     D  USER                 254    263
 
      ** Midas message file default
     D MSGFIL          DS
     D  CSMSGF                 1     10    INZ('CGUSRMSG')
      *
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
     C                   WRITE     CG7160H1
 
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
     C                   WRITE     CG7160F5
     C                   EXFMT     CG7160S0
      ** SFL RRN
     C                   Z-ADD     @#SFRC        DFRNBR
 
      ** Add mode
     C                   ELSE
     C                   EXFMT     CG7160F2
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
      *
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
     C                   WRITE     CG7160S0
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
     C     KYDQL1        SETLL     CDQPL1
     C                   MOVE      *ON           *IN67
     C                   MOVEA     '000000'      *IN(68)
     C                   MOVE      *ON           *IN69
 
      ** Build a SFL page
     C                   DO        SFLPAG
     C                   READ(N)   CDQPL1                                 89
 
      ** At EOF
     C     *IN89         IFEQ      *ON
      ** Position SFL key fields
     C                   MOVE      *HIVAL        Z1DLTP
     C                   MOVE      *HIVAL        Z1DLST
     C                   MOVE      *HIVAL        Z1TRCL
     C                   Z-ADD     9999999999    Z1ACOD
     C                   LEAVE
     C                   ENDIF
 
      ** Initialise SFL fields with data
     C                   CLEAR                   DSOPTN
     C                   MOVE      Z1DLTP        DSDLTP
     C                   MOVE      Z1DLST        DSDLST
     C                   MOVE      Z1TRCL        DSTRCL
     C                   Z-ADD     Z1ACOD        DSACOD
     C                   MOVE      DSACOD        PMACOD
 
      ** Account code description
     C                   CALL      'AOACODR0'
     C                   PARM      *BLANKS       PMRTCD
     C                   PARM      '*KEY   '     PMTYPE
     C                   PARM                    PMACOD
     C     SDACOD        PARM      SDACOD        DSSDY
     C     PMRTCD        IFEQ      *BLANK
     C                   MOVEL(P)  A5ACCN        DSDESC
     C                   ELSE
     C                   MOVE      *BLANK        DSDESC
     C                   ENDIF
 
      ** Increment SFL record number
     C                   ADD       1             WSRRN
      ** Write SFL record
     C                   WRITE     CG7160S1
 
     C                   MOVE      *OFF          *IN67
     C                   MOVE      *OFF          *IN69
     C                   ENDDO
 
      ** If not EOF read one more record, used to set the SFLEND indicatr
     C     *IN89         IFEQ      *OFF
     C                   READ(N)   CDQPL1                                 89
     C                   ENDIF
 
      ** If SFl empty
     C     WSRRN         IFEQ      *ZERO
     C                   MOVE      *OFF          *IN41
     C                   EVAL      ZAMSID = 'ISR0001'
     C                   EXSR      SNDMSG
 
      ** SFl not empty
     C                   ELSE
     C                   MOVE      *ON           *IN41
 
      ** Reset SFL RRN to SFL record number
     C                   Z-ADD     WSRRN         DFRNBR
 
      ** Reset RRN of last record loaded into SFL to SFL record number
     C                   Z-ADD     WSRRN         WSLRRN
     C                   ENDIF
 
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
 
     C                   CLEAR                   CG7160F2
     C                   SELECT
 
      ** Display mode
     C     WSMODE        WHENEQ    'DSPLY'
     C                   MOVEL     'ADD  '       WSMODE
 
      ** Add mode
     C                   OTHER
     C                   MOVEL     'DSPLY'       WSMODE
 
     C                   CLEAR                   Z1DLTP
     C                   CLEAR                   Z1DLST
     C                   CLEAR                   Z1TRCL
     C                   Z-ADD     *ZERO         Z1ACOD
     C                   CLEAR                   DFDLTS
     C                   CLEAR                   DFDLSS
     C                   CLEAR                   DFACOS
 
      ** Clear & load next SFL page
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
 
      ** When SFL position to fields change
     C     DFDLTS        WHENNE    *BLANK
     C     DFDLSS        ORNE      *BLANK
     C     DFACOS        ORNE      *BLANK
     C                   MOVE      DFDLTS        Z1DLTP
     C                   MOVE      DFDLSS        Z1DLST
     C                   MOVE      DFTRCL        Z1TRCL
     C                   MOVE      DFACOS        Z1ACOD
 
     C                   CLEAR                   DFDLTS
     C                   CLEAR                   DFDLSS
     C                   CLEAR                   DFACOS
 
     C                   EXSR      CLRSFL
     C                   EXSR      LODSFL
 
      ** When EOF
     C     *IN89         WHENEQ    *ON
     C                   EVAL      ZAMSID = 'ISR0002'
     C                   EXSR      SNDMSG
 
      ** Load next SFL page
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
      * DSPPRO - Process SFL Option/s                                 *
      * ADDVAL - Validate Add Record Request                          *
      * ADDCRT - Create Record                                        *
      *                                                               *
      *****************************************************************
     C     ENTKEY        BEGSR
 
     C                   SELECT
 
      ** When SFL position to fields change
     C     DFDLTS        WHENNE    *BLANK
     C     DFDLSS        ORNE      *BLANK
     C     DFACOS        ORNE      *BLANK
     C                   MOVE      DFDLTS        Z1DLTP
     C                   MOVE      DFDLSS        Z1DLST
     C                   MOVE      DFTRCL        Z1TRCL
     C                   MOVE      DFACOS        Z1ACOD
 
     C                   CLEAR                   DFDLTS
     C                   CLEAR                   DFDLSS
     C                   CLEAR                   DFACOS
 
     C                   EXSR      CLRSFL
     C                   EXSR      LODSFL
 
      ** When SFl empty
     C     WSMODE        WHENEQ    'DSPLY'
     C     WSRRN         ANDEQ     *ZERO
     C                   EVAL      ZAMSID = 'ISR0001'
     C                   EXSR      SNDMSG
 
      ** Enter key processing
     C                   OTHER
 
      ** Validate screen
     C     WSMODE        IFEQ      'DSPLY'
     C                   EXSR      DSPVAL
 
      ** Screen is valid
     C     WSVAL         IFEQ      'YES'
     C                   EXSR      DSPPRO
     C                   ENDIF
 
      ** Add mode
     C                   ELSE
     C                   EXSR      ADDVAL
 
      ** Screen is valid
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
 
      ** Process first changed SFL record
     C                   READC     CG7160S1                               88
     C     *IN88         DOWEQ     *OFF
 
      ** If SFL option field is blank, setoff the SFLNXTCHG & option
      ** (RI) indicators
     C     DSOPTN        IFEQ      *BLANK
     C                   MOVEA     '00'          *IN(68)
 
      ** Update & read next changed SFL record
     C                   UPDATE    CG7160S1
     C                   READC     CG7160S1                               88
 
     C                   ITER
     C                   ENDIF
 
      ** If SFL option field is NOT one of the following, then error.
      ** 'D' - Delete, 'E' - Enquire or 'A' - Amend
     C     DSOPTN        IFEQ      'D'
     C     DSOPTN        OREQ      'E'
     C     DSOPTN        OREQ      'A'
     C                   ELSE
     C                   MOVE      'NO '         WSVAL
     C                   MOVEA     '11'          *IN(68)
 
      ** If first SFL option field in error
     C     WSFERR        IFEQ      'YES'
     C                   MOVE      'NO '         WSFERR
     C                   Z-ADD     WSRRN         DFRNBR
     C                   ENDIF
     C                   EVAL      ZAMSID = 'ISR0021'
     C                   EXSR      SNDMSG
 
      ** Update & read next changed SFL record
     C                   UPDATE    CG7160S1
     C                   READC     CG7160S1                               88
     C                   ITER
     C                   ENDIF
 
      ** If valid SFL option
     C                   MOVEA     '0'           *IN(68)
     C                   MOVEA     '1'           *IN(69)
 
      ** Update & read next changed SFL record
     C                   UPDATE    CG7160S1
     C                   READC     CG7160S1                               88
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * DSPPRO - Process SFL Option/s                                 *
      *                                                               *
      * Called by:                                                    *
      * ENTKEY - Enter Key Processing                                 *
      *                                                               *
      * Calls:                                                        *
      * TYPDES - Deal/Loan Type/Sub-Type Description                  *
      * DELSCR - Delete Screen Processing                             *
      * ENQSCR - Enquiry Screen Processing                            *
      * AMDSCR - Amend Screen Processing                              *
      * CLRSFL - Clear SFL                                            *
      * LODSFL - Load SFL Next Page                                   *
      *                                                               *
      *****************************************************************
     C     DSPPRO        BEGSR
 
     C                   MOVE      'NO '         WSCHGS
 
      ** Process first changed SFL record
     C                   READC     CG7160S1                               88
     C     *IN88         DOWEQ     *OFF
 
      ** Deal/loan type/sub-type description
     C                   IF        *IN80 = *Off
     C                   EXSR      TYPDES1
     C                   ELSE
     C                   EXSR      TYPDES2
     C                   ENDIF
 
     C                   SELECT
      ** Delete screen processing
     C     DSOPTN        WHENEQ    'D'
     C                   EXSR      DELSCR
 
      ** Enquiry screen processing
     C     DSOPTN        WHENEQ    'E'
     C                   EXSR      ENQSCR
 
      ** Amend screen processing
     C     DSOPTN        WHENEQ    'A'
     C                   EXSR      AMDSCR
     C                   ENDSL
 
      ** Exit selected from previous screen
     C     *IN03         IFEQ      *ON
     C                   LEAVE
     C                   ENDIF
 
     C                   CLEAR                   DSOPTN
     C                   MOVEA     '00'          *IN(68)
 
      ** Update & read next changed SFL record
     C                   UPDATE    CG7160S1
     C                   READC     CG7160S1                               88
     C                   ENDDO
 
      ** If record change/s have taken place then re-build SFL
      ** prior to re-display
     C     *IN03         IFEQ      *OFF
     C     WSCHGS        ANDEQ     'YES'
     C                   MOVE      *BLANK        Z1DLTP
     C                   MOVE      *BLANK        Z1DLST
     C                   MOVE      *BLANK        Z1TRCL
     C                   Z-ADD     *ZERO         Z1ACOD
 
      ** Clear & re-load SFL
     C                   EXSR      CLRSFL
     C                   EXSR      LODSFL
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * TYPDES1 - Deal/Loan Type/Sub-Type Description                 *
      *                                                               *
      * Called by:                                                    *
      * DSPPRO - Process SFL Option/s                                 *
      *                                                               *
      * Calls:                                                        *
      * None                                                          *
      *                                                               *
      *****************************************************************
     C     TYPDES1       BEGSR
 
     C                   MOVE      DSDLTP        WSDLTP
     C                   MOVE      DSDLST        WSDLST
     C                   MOVE      DSTRCL        WSTRCL
 
      ** Deal type/sub-type combination
     C     FDDTL1        CHAIN     FDDTSTPD                           86
 
     C     *IN86         IFEQ      *OFF
     C                   MOVEL(P)  NARR11        D1DES1
     C                   MOVEL(P)  NARR11        D3DES1
     C                   MOVEL(P)  NARR11        D4DES1
 
     C                   ELSE
 
     C     SDLOL1        CHAIN     SDLOANL0                           85
     C     *IN85         IFEQ      *OFF
     C                   MOVEL(P)  AYLNTD        D1DES1
     C                   MOVEL(P)  AYLNTD        D3DES1
     C                   MOVEL(P)  AYLNTD        D4DES1
 
     C                   ELSE
 
      ** Invalid loan type/sub-type combination
     C                   CLEAR                   D1DES1
     C                   CLEAR                   D3DES1
     C                   CLEAR                   D4DES1
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * TYPDES2 - Deal/Loan Type/Sub-Type/ Class Validation           *
      *                                                               *
      * Called by:                                                    *
      * DSPPRO - Process SFL Option/s                                 *
      *                                                               *
      * Calls:                                                        *
      * None                                                          *
      *                                                               *
      *****************************************************************
     C     TYPDES2       BEGSR
 
     C                   MOVE      DSDLTP        WSDLTP
     C                   MOVE      DSDLST        WSDLST
     C                   MOVE      DSTRCL        WSTRCL
 
      ** Deal type/sub-type class combination
     C     FDDTL2        CHAIN     FDDTSTPD                           86
 
     C                   IF        *IN86 = *OFF AND CDL038 = 'Y'
     C                   MOVEL(P)  NARR11        D1DES1
     C                   MOVEL(P)  NARR11        D3DES1
     C                   MOVEL(P)  NARR11        D4DES1
 
     C                   ELSE
     C     SDLOL2        CHAIN     SDLOANL0                           85
     C                   IF        *IN85 = *OFF AND CLE042 = 'Y'
     C                   MOVEL(P)  AYLNTD        D1DES1
     C                   MOVEL(P)  AYLNTD        D3DES1
     C                   MOVEL(P)  AYLNTD        D4DES1
 
     C                   ELSE
 
      ** Invalid loan type/sub-type class combination
     C                   CLEAR                   D1DES1
     C                   CLEAR                   D3DES1
     C                   CLEAR                   D4DES1
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * DELSCR - Delete Screen Processing                             *
      *                                                               *
      * Called by:                                                    *
      * DSPPRO - Process SFL Option/s                                 *
      *                                                               *
      * Calls:                                                        *
      * None                                                          *
      *                                                               *
      *****************************************************************
     C     DELSCR        BEGSR
 
      ** Setup delete screen fields
     C                   MOVE      DSDLTP        D1DLTP
     C                   MOVE      DSDLST        D1DLST
     C                   MOVE      DSTRCL        D1TRCL
     C                   Z-ADD     DSACOD        D1ACOD
     C                   MOVEL(P)  DSDESC        D1DES2
 
      ** Setup record delete warning message
     C                   EVAL      ZAMSID = 'ISR0031'
     C                   EXSR      SNDMSG
 
     C                   MOVE      *OFF          *IN12
 
      ** Until exit or previous
     C     *IN03         DOUEQ     *ON
     C     *IN12         OREQ      *ON
 
     C                   WRITE     #MSGCTL
     C                   EXFMT     CG7160F1
 
     C                   SELECT
     C     *IN03         WHENEQ    *ON
     C     *IN12         OREQ      *ON
 
      ** Confirm delete selected
     C     *IN06         WHENEQ    *ON
 
      ** Attempt to delete the dealing/ lending interest scale
      ** qualifying account code record
     C     CGDQKY        DELETE    CDQPL1                             87
 
      ** If record deleted
     C     *IN87         IFEQ      *OFF
     C                   COMMIT
     C                   ENDIF
 
     C                   MOVE      'YES'         WSCHGS
     C                   MOVE      *ON           *IN12
     C                   ENDSL
     C                   ENDDO
 
      ** Clear the program message queue
     C                   CALL      'Y2CLMSC'
     C                   PARM                    ZAPGMQ
     C                   PARM                    ZAPGRL
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ENQSCR - Enquiry Screen Processing                            *
      *                                                               *
      * Called by:                                                    *
      * DSPPRO - Process SFL Option/s                                 *
      *                                                               *
      * Calls:                                                        *
      * None                                                          *
      *                                                               *
      *****************************************************************
     C     ENQSCR        BEGSR
 
      ** Setup enquiry screen fields
     C                   MOVE      DSDLTP        D3DLTP
     C                   MOVE      DSDLST        D3DLST
     C                   MOVE      DSTRCL        D3TRCL
     C                   Z-ADD     DSACOD        D3ACOD
     C                   MOVEL(P)  DSDESC        D3DES2
     C                   MOVE      *OFF          *IN12
 
      ** Until exit or previous
     C     *IN03         DOUEQ     *ON
     C     *IN12         OREQ      *ON
     C                   EXFMT     CG7160F3
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * AMDSCR - Amend Screen Processing                              *
      *                                                               *
      * Called by:                                                    *
      * DSPPRO - Process SFL Option/s                                 *
      *                                                               *
      * Calls:                                                        *
      * VALTYP - Validate Deal/Loan Type/Sub-Type                     *
      * VALACD - Validate Account Code                                *
      *                                                               *
      *****************************************************************
     C     AMDSCR        BEGSR
 
      ** Setup amend screen fields
     C                   MOVE      DSDLTP        D4DLTP
     C                   MOVE      DSDLST        D4DLST
     C                   MOVE      DSTRCL        D4TRCL
     C                   MOVE      DSACOD        D4ACOD
     C                   MOVEL(P)  DSDESC        D4DES2
 
     C                   MOVEA     '0000'        *IN(70)
     C                   MOVE      *OFF          *IN12
 
      ** Until exit or previous screen
     C     *IN03         DOUEQ     *ON
     C     *IN12         OREQ      *ON
 
     C                   WRITE     #MSGCTL
     C                   EXFMT     CG7160F4
 
      ** Clear the program message queue
     C                   CALL      'Y2CLMSC'
     C                   PARM                    ZAPGMQ
     C                   PARM                    ZAPGRL
 
     C                   SELECT
     C     *IN03         WHENEQ    *ON
     C     *IN12         OREQ      *ON
 
      ** Confirm amend selected
     C     *IN06         WHENEQ    *ON
 
      ** Fields amended
     C                   MOVE      'YES'         WSVAL
     C                   MOVEA     '0000'        *IN(70)
     C                   MOVE      D4DLTP        WSDLTP
     C                   MOVE      D4DLST        WSDLST
     C                   MOVE      D4TRCL        WSTRCL
 
      ** Validate Deal/Loan Type/Sub-Type
     C                   EXSR      VALTYP
 
     C                   MOVE      D4ACOD        WSACOD
 
      ** Validate account code
     C                   EXSR      VALACD
 
      ** Invalid account code
     C     WSVAL         IFEQ      'NO '
     C                   CLEAR                   D4DES2
 
     C                   ELSE
 
      ** Validate for duplicate record
     C                   EXSR      VALKEY
 
     C     WSVAL         IFEQ      'NO '
     C                   MOVEA     '1111'        *IN(70)
     C                   CLEAR                   D4DES1
     C                   CLEAR                   D4DES2
     C                   ELSE
 
      ** Account code description
     C                   MOVEL(P)  A5ACCN        D4DES2
 
      ** Update retail qualifying account code record
     C     CGDQKY        CHAIN     CDQPL1                             86
 
     C     *IN86         IFEQ      *OFF
     C                   MOVE      D4ACOD        Z1ACOD
     C                   MOVE      D4DLTP        Z1DLTP
     C                   MOVE      D4DLST        Z1DLST
     C                   MOVE      D4TRCL        Z1TRCL
     C                   Z-ADD     AGRDNB        Z1LCDT
     C                   MOVE      'A'           Z1LCTP
     C                   UPDATE    CDQPL1
     C                   COMMIT
 
     C                   MOVE      'YES'         WSCHGS
     C                   MOVE      *ON           *IN12
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
      ** Enter key
     C                   OTHER
 
     C                   MOVE      'YES'         WSVAL
     C                   MOVEA     '0000'        *IN(70)
     C                   MOVE      D4DLTP        WSDLTP
     C                   MOVE      D4DLST        WSDLST
     C                   MOVE      D4TRCL        WSTRCL
 
      ** Validate Deal/Loan Type/Sub-Type
     C                   EXSR      VALTYP
 
     C                   MOVE      D4ACOD        WSACOD
      ** Validate account code
     C                   EXSR      VALACD
 
      ** Invalid account code
     C     WSVAL         IFEQ      'NO '
     C                   CLEAR                   D4DES2
 
     C                   ELSE
 
      ** Validate for duplicate record
     C                   EXSR      VALKEY
 
     C     WSVAL         IFEQ      'NO '
     C                   MOVEA     '1111'        *IN(70)
     C                   CLEAR                   D4DES1
     C                   CLEAR                   D4DES2
     C                   ELSE
 
      ** Account code description
     C                   MOVEL(P)  A5ACCN        D4DES2
     C                   ENDIF
     C                   ENDIF
     C                   ENDSL
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ADDVAL - Validate Add Record Request                          *
      *                                                               *
      * Called by:                                                    *
      * ENTKEY - Enter Key Processing                                 *
      *                                                               *
      * Calls:                                                        *
      * VALACD - Validate Account Code                                *
      * VALTYP - Validate Deal/Loan Type/Sub-Type                     *
      * VALKEY - Validate Duplicate Record                            *
      *                                                               *
      *****************************************************************
     C     ADDVAL        BEGSR
 
     C                   MOVE      'YES'         WSVAL
     C                   MOVEA     '0000'        *IN(70)
 
     C                   MOVE      D2DLTP        WSDLTP
     C                   MOVE      D2DLST        WSDLST
     C                   MOVE      D2TRCL        WSTRCL
 
      ** Validate Deal/Loan Type/Sub-Type
     C                   EXSR      VALTYP
     C                   MOVE      D2ACOD        WSACOD
 
      ** Validate account code
     C                   EXSR      VALACD
 
      ** Validate for duplicate record
     C     WSVAL         IFEQ      'YES'
     C                   EXSR      VALKEY
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * VALTYP - Validate Deal/Loan Type/Sub-Type                     *
      *                                                               *
      * Called by:                                                    *
      * ADDVAL - Validate Add Record Request                          *
      * AMDSCR - Amend Screen Processing                              *
      *                                                               *
      * Calls:                                                        *
      * SNDMSG - Send Message To Message Queue                        *
      *                                                               *
      *****************************************************************
     C     VALTYP        BEGSR
 
     C                   DO
 
      ** Deal/loan type required
     C     WSDLTP        IFEQ      *BLANK
     C                   MOVE      'NO '         WSVAL
     C                   MOVE      *ON           *IN70
     C                   CLEAR                   D2DES1
     C                   CLEAR                   D4DES1
     C                   EVAL      ZAMSID = 'ISR0023'
     C                   EXSR      SNDMSG
     C                   ENDIF
 
      ** Deal/loan sub-type required
     C     WSDLST        IFEQ      *BLANK
     C                   MOVE      'NO '         WSVAL
     C                   MOVE      *ON           *IN71
     C                   CLEAR                   D2DES1
     C                   CLEAR                   D4DES1
     C                   EVAL      ZAMSID = 'ISR0024'
     C                   EXSR      SNDMSG
     C                   ENDIF
 
      ** Both CDL038 and CLE042 are switched Off
     C     *IN80         IFEQ      *OFF
 
      ** Deal/loan type OR sub-type OR class blank, do NOT validate further
     C     *IN70         IFEQ      *ON
     C     *IN71         OREQ      *ON
     C                   LEAVE
     C                   ENDIF
     C                   MOVE      *BLANKS       WSTRCL
     C                   MOVE      *BLANKS       D4TRCL
 
      ** Must be a valid deal OR loan type/sub-type combination
      ** Deal type/sub-type combination
     C     FDDTL1        CHAIN     FDDTSTPD                           86
     C     *IN86         IFEQ      *OFF
     C                   MOVEL(P)  NARR11        D2DES1
     C                   MOVEL(P)  NARR11        D4DES1
 
     C                   ELSE
      ** Invalid deal type/sub-type combination
      ** Loan type/sub-type combination
 
      ** Valid loan type/sub-type combination
     C     SDLOL1        CHAIN     SDLOANL0                           85
     C     *IN85         IFEQ      *OFF
     C                   MOVEL(P)  AYLNTD        D2DES1
     C                   MOVEL(P)  AYLNTD        D4DES1
     C                   ELSE
 
      ** Invalid loan type/sub-type combination
     C                   MOVE      'NO '         WSVAL
     C                   MOVEA     '11'          *IN(70)
     C                   CLEAR                   D2DES1
     C                   CLEAR                   D4DES1
     C                   EVAL      ZAMSID = 'ISR0025'
     C                   EXSR      SNDMSG
     C                   ENDIF
     C                   ENDIF
      ** Additional validation for Deal Type Sub Type                                       AR814062
     C                   EXSR      SrVal_DTypSTyp                                           AR814062
 
      ** Either CDL038 or CLE042 is switched ON
     C                   ELSE
     C                   EXSR      SrVal_Init                                               AR814062
     C     *IN70         IFEQ      *ON                                                      AR814062
     C     *IN71         OREQ      *ON                                                      AR814062
     C                   LEAVE                                                              AR814062
     C                   ENDIF                                                              AR814062
      ** Additional Validation for Deal Type Sub Type                                       AR814062
     C                   EXSR      SrVal_DTypSTyp                                           AR814062
 
      ** Blank Transaction Class
     C                   IF        (WSTRCL = *BLANKS AND CDL038 = 'N')
     C     FDDTL1        CHAIN     FDDTSTPD                           86
     C     *IN86         IFEQ      *OFF
     C                   MOVEL(P)  NARR11        D2DES1
     C                   MOVEL(P)  NARR11        D4DES1
     C                   LEAVE
     C                   ENDIF
     C                   ELSEIF    (WSTRCL = *BLANKS AND CLE042 = 'N')
     C     SDLOL1        CHAIN     SDLOANL0                           85
     C     *IN85         IFEQ      *OFF
     C                   MOVEL(P)  AYLNTD        D2DES1
     C                   MOVEL(P)  AYLNTD        D4DES1
     C                   LEAVE
     C                   ENDIF
     C                   ENDIF
     C                   IF        (WSTRCL = *BLANKS AND CDL038 = 'Y') OR
     C                             (WSTRCL = *BLANKS AND CLE042 = 'Y')
     C                   MOVE      'NO '         WSVAL
     C                   MOVE      *ON           *IN73
     C                   EVAL      ZAMSID = 'ISR0037'
     C                   EXSR      SNDMSG
     C                   ENDIF
 
     C     *IN70         IFEQ      *ON
     C     *IN71         OREQ      *ON
     C     *IN73         OREQ      *ON
     C                   LEAVE
     C                   ENDIF
 
      ** Must be a valid deal OR loan type/sub-type/class combination
      ** Deal type/sub-type combination
     C     FDDTL2        CHAIN     FDDTSTPD                           86
     C                   IF        *IN86 = *OFF AND CDL038 = 'Y'
     C                   MOVEL(P)  NARR11        D2DES1
     C                   MOVEL(P)  NARR11        D4DES1
 
     C                   ELSE
      ** Invalid loan type/sub-type/class combination
      ** Loan type/sub-type/class combination
     C     SDLOL2        CHAIN     SDLOANL0                           85
     C                   IF        *IN85 = *OFF AND CLE042 = 'Y'
     C                   MOVEL(P)  AYLNTD        D2DES1
     C                   MOVEL(P)  AYLNTD        D4DES1
     C                   ELSE
 
      ** Invalid loan type/sub-type/class combination
     C                   MOVE      'NO '         WSVAL
     C                   MOVEA     '11'          *IN(70)
     C                   EVAL      *IN73 = *ON
     C                   CLEAR                   D2DES1
     C                   CLEAR                   D4DES1
     C                   EVAL      ZAMSID = 'ISR0038'
     C                   EXSR      SNDMSG
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************                     AR814062
      * SrVal_Init - Initial Validation for Deal Type Sub Type        *                     AR814062
      *              combination                                      *                     AR814062
      *****************************************************************                     AR814062
     C     SrVal_Init    BEGSR                                                              AR814062
     C     FDDTL1        CHAIN     FDDTSTPD                           86                    AR814062
     C     *IN86         IFEQ      *OFF                                                     AR814062
     C                   MOVEL(P)  NARR11        D2DES1                                     AR814062
     C                   MOVEL(P)  NARR11        D4DES1                                     AR814062
     C                   ELSE                                                               AR814062
      ** Invalid deal type/sub-type combination                                             AR814062
      ** Loan type/sub-type combination                                                     AR814062
                                                                                            AR814062
      ** Valid loan type/sub-type combination                                               AR814062
     C     SDLOL1        CHAIN     SDLOANL0                           85                    AR814062
     C     *IN85         IFEQ      *OFF                                                     AR814062
     C                   MOVEL(P)  AYLNTD        D2DES1                                     AR814062
     C                   MOVEL(P)  AYLNTD        D4DES1                                     AR814062
     C                   ELSE                                                               AR814062
                                                                                            AR814062
      ** Invalid loan type/sub-type combination                                             AR814062
     C                   MOVE      'NO '         WSVAL                                      AR814062
     C                   MOVEA     '11'          *IN(70)                                    AR814062
     C                   CLEAR                   D2DES1                                     AR814062
     C                   CLEAR                   D4DES1                                     AR814062
     C                   EVAL      ZAMSID = 'ISR0025'                                       AR814062
     C                   EXSR      SNDMSG                                                   AR814062
     C                   ENDIF                                                              AR814062
     C                   ENDIF                                                              AR814062
     C                   ENDSR                                                              AR814062
                                                                                            AR814062
      *****************************************************************                     AR814062
      * SrVal_DtypStyp - Validate Deal Type/Sub Type ; Additional     *                     AR814062
      *                  validation that the deal type sub type       *                     AR814062
      *                  should only be call loan, call deposit or    *                     AR814062
      *                  demand loan                                  *                     AR814062
      *****************************************************************                     AR814062
     C     SrVal_DtypStypBEGSR                                                              AR814062
                                                                                            AR814062
     C                   EVAL      WTyp_STyp_Flg = 'N'                                      AR814062
     C     FDDTL1        CHAIN     FDDTSTL0                                                 AR814062
     C                   IF        (%FOUND(FDDTSTL0) AND (WSDLTP = 'CD'  OR                 AR814062
     C                                           WSDLTP = 'CL'))                            AR814062
     C                   EVAL      WTyp_STyp_Flg = 'Y'                                      AR814062
     C                   ELSE                                                               AR814062
     C     SDLOL1        CHAIN     SDLOANL0                                                 AR814062
     C                   IF        (%FOUND(SDLOANL0) AND (AYLNPT = 61  OR                   AR814062
     C                              AYLNPT = 68  OR AYLNPT = 69))                           AR814062
     C                   EVAL      WTyp_STyp_Flg = 'Y'                                      AR814062
     C                   ENDIF                                                              AR814062
     C                   ENDIF                                                              AR814062
                                                                                            AR814062
     C                   IF        WTyp_STyp_Flg = 'N'                                      AR814062
     C                   MOVE      'NO '         WSVAL                                      AR814062
     C                   MOVEA     '11'          *IN(70)                                    AR814062
     C                   CLEAR                   D2DES1                                     AR814062
     C                   CLEAR                   D4DES1                                     AR814062
     C                   EVAL      ZAMSID = 'ISR0039'                                       AR814062
     C                   EXSR      SNDMSG                                                   AR814062
     C                   ENDIF                                                              AR814062
                                                                                            AR814062
     C                   ENDSR                                                              AR814062
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * VALACD - Validate Account Code                                *
      *                                                               *
      * Called by:                                                    *
      * ADDVAL - Validate Add Record Request                          *
      * AMDSCR - Amend Screen Processing                              *
      *                                                               *
      * Calls:                                                        *
      * SNDMSG - Send Message To Message Queue                        *
      *                                                               *
      *****************************************************************
     C     VALACD        BEGSR
 
     C                   DO
 
      ** Account code required
     C     WSACOD        IFEQ      *BLANK
     C                   MOVE      'NO '         WSVAL
     C                   MOVE      *ON           *IN72
     C                   CLEAR                   D2DES2
     C                   CLEAR                   D4DES2
     C                   EVAL      ZAMSID = 'ISR0016'
     C                   EXSR      SNDMSG
     C                   LEAVE
     C                   ENDIF
 
      ** Account code must be numeric
     C                   TESTN                   WSACOD               65
     C     *IN65         IFEQ      *OFF
     C                   MOVE      'NO '         WSVAL
     C                   MOVE      *ON           *IN72
     C                   CLEAR                   D2DES2
     C                   CLEAR                   D4DES2
     C                   EVAL      ZAMSID = 'ISR0017'
     C                   EXSR      SNDMSG
     C                   LEAVE
     C                   ENDIF
 
      ** Must be a valid Midas Account Code
     C                   CALL      'AOACODR0'
     C                   PARM      *BLANKS       PMRTCD
     C                   PARM      '*KEY   '     PMTYPE
     C                   PARM      WSACOD        PMACOD
     C     SDACOD        PARM      SDACOD        DSSDY
     C     PMRTCD        IFNE      *BLANK
     C                   MOVE      'NO '         WSVAL
     C                   MOVE      *ON           *IN72
     C                   CLEAR                   D2DES2
     C                   CLEAR                   D4DES2
     C                   EVAL      ZAMSID = 'ISR0018'
     C                   EXSR      SNDMSG
     C                   LEAVE
     C                   ENDIF
      ** Account should be defined in Interest Scale Retail Qualifying Account              AR814080
     C                   MOVE      WSACOD        WACODN                                     AR814080
     C     WACODN        CHAIN     CGISRQL0                                                 AR814080
     C                   IF        NOT %FOUND(CGISRQL0)                                     AR814080
     C                   MOVE      'NO '         WSVAL                                      AR814080
     C                   MOVE      *ON           *IN72                                      AR814080
     C                   CLEAR                   D2DES2                                     AR814080
     C                   CLEAR                   D4DES2                                     AR814080
     C                   EVAL      ZAMSID = 'ISR0040'                                       AR814080
     C                   EXSR      SNDMSG                                                   AR814080
     C                   LEAVE                                                              AR814080
     C                   ENDIF                                                              AR814080
 
      ** Account code description
     C                   MOVEL(P)  A5ACCN        D2DES2
     C                   MOVEL(P)  A5ACCN        D4DES2
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * VALKEY - Validate Duplicate Record                            *
      *                                                               *
      * Called by:                                                    *
      * ADDVAL - Validate Add Record Request                          *
      *                                                               *
      * Calls:                                                        *
      * SNDMSG - Send Message To Message Queue                        *
      *                                                               *
      *****************************************************************
     C     VALKEY        BEGSR
 
      ** Must not already exist within the DL/LE interest scale
      ** qualifying account codes file
     C                   MOVE      Z1DLTP        W1DLTP
     C                   MOVE      Z1DLST        W1DLST
     C                   MOVE      Z1TRCL        W1TRCL
     C                   Z-ADD     Z1ACOD        W1ACOD
     C                   MOVE      WSDLTP        Z1DLTP
     C                   MOVE      WSDLST        Z1DLST
     C                   MOVE      WSTRCL        Z1TRCL
     C                   MOVE      WSACOD        Z1ACOD
 
     C     KYDQL1        SETLL     CDQPL1                                 86
     C     *IN86         IFEQ      *ON
     C                   MOVE      'NO '         WSVAL
     C                   MOVEA     '1111'        *IN(70)
     C                   CLEAR                   D2DES1
     C                   CLEAR                   D2DES2
     C                   CLEAR                   D4DES1
     C                   CLEAR                   D4DES2
     C                   EVAL      ZAMSID = 'ISR0022'
     C                   EXSR      SNDMSG
     C                   ENDIF
 
     C                   MOVE      W1DLTP        Z1DLTP
     C                   MOVE      W1DLST        Z1DLST
     C                   MOVE      W1TRCL        Z1TRCL
     C                   Z-ADD     W1ACOD        Z1ACOD
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ADDCRT - Create Record                                        *
      *                                                               *
      * Called by:                                                    *
      * ENTKEY - Enter Key Processing                                 *
      *                                                               *
      * Calls:                                                        *
      * SNDMSG - Send Message To Message Queue                        *
      *                                                               *
      *****************************************************************
     C     ADDCRT        BEGSR
 
     C                   MOVE      D2ACOD        Z1ACOD
     C                   MOVE      D2DLTP        Z1DLTP
     C                   MOVE      D2TRCL        Z1TRCL
     C                   MOVE      D2DLST        Z1DLST
     C                   Z-ADD     AGRDNB        Z1LCDT
     C                   MOVE      'I'           Z1LCTP
 
      ** Create dealing/lending qualifying account code record
     C                   WRITE     CDQPL1
     C                   COMMIT
 
      ** Completion message
     C                   EVAL      ZAMSID = 'ISR0026'
     C                   EXSR      SNDMSG
 
      ** Clear screen fields
     C                   CLEAR                   CG7160F2
 
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
      * VALACD - Validate Account Code                                *
      * VALKEY - Validate Duplicate Record                            *
      * ADDCRT - Create Record                                        *
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
 
      ** Clear all fields for default mechanism next time
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
 
     C     *DTAARA       DEFINE                  LDA
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
 
      ** Interest Scale DL/LE Qualifying Account Codes
     C     KYDQL1        KLIST
     C                   KFLD                    Z1DLTP
     C                   KFLD                    Z1DLST
     C                   KFLD                    Z1TRCL
     C                   KFLD                    Z1ACOD
      ** Interest Scale DL/LE Qualifying Account Codes
     C     CGDQKY        KLIST
     C                   KFLD                    DSDLTP
     C                   KFLD                    DSDLST
     C                   KFLD                    DSTRCL
     C                   KFLD                    DSACOD
 
      ** Deal Type/Sub-Type Codes
     C     FDDTL1        KLIST
     C                   KFLD                    WSDLTP
     C                   KFLD                    WSDLST
      ** Deal Type/Sub-Type Codes/Class
     C     FDDTL2        KLIST
     C                   KFLD                    WSDLTP
     C                   KFLD                    WSDLST
     C                   KFLD                    WSTRCL
      ** Loan Type/Sub-Type Codes
     C     SDLOL1        KLIST
     C                   KFLD                    WSDLTP
     C                   KFLD                    WSDLST
      ** Loan Type/Sub-Type Codes
     C     SDLOL2        KLIST
     C                   KFLD                    WSDLTP
     C                   KFLD                    WSDLST
     C                   KFLD                    WSTRCL
 
     C     *LIKE         DEFINE    DFRNBR        SFLPAG
     C     *LIKE         DEFINE    DFRNBR        WSRRN
     C     *LIKE         DEFINE    DFRNBR        WSLRRN
     C     *LIKE         DEFINE    DFRNBR        WSCRRN
     C     *LIKE         DEFINE    Z1DLTP        WSDLTP
     C     *LIKE         DEFINE    Z1DLTP        W1DLTP
     C     *LIKE         DEFINE    Z1TRCL        WSTRCL
     C     *LIKE         DEFINE    Z1TRCL        W1TRCL
     C     *LIKE         DEFINE    Z1DLST        WSDLST
     C     *LIKE         DEFINE    Z1DLST        W1DLST
     C     *LIKE         DEFINE    D2ACOD        WSACOD
     C     *LIKE         DEFINE    Z1ACOD        W1ACOD
 
     C                   MOVEL(P)  USER          D0USER
     C                   MOVEL(P)  WSID          D0WSID
     C                   MOVEL(P)  WPGM          D0PGMN
     C                   MOVEL(P)  AGMRDT        D0RUNA
     C                   MOVEL     WPGM          ZAPGMQ
     C                   MOVEL(P)  CSMSGF        ZAMSGF
     C                   MOVEL     WPGM          ##PGM
     C                   Z-ADD     15            SFLPAG
 
      ** If the DL/LE interest scale qualifying account codes file is
      ** empty, the default program mode is 'ADD' otherwise it is
      ** 'DISPLAY'
     C     @1NROP        IFEQ      *ZERO
     C                   MOVEL     'ADD  '       WSMODE
     C                   ELSE
     C                   MOVEL     'DSPLY'       WSMODE
     C                   ENDIF
 
      ** Check if CDL038(Extended Deal Sub Type) feature is switched On
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PMRTCD
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CDL038'      PSard
     C     SCSARD        PARM      SCSARD        DSFDY
     C                   IF        PMRTCD = *BLANKS
     C                   EVAL      CDL038 = 'Y'
     C                   ELSE
     C                   EVAL      CDL038 = 'N'
     C                   ENDIF
 
      ** Check if CLE042(Extended Loan Sub Type) feature is switched On
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PMRTCD
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CLE042'      PSard
     C     SCSARD        PARM      SCSARD        DSFDY
     C                   IF        PMRTCD = *BLANKS
     C                   EVAL      CLE042 = 'Y'
     C                   ELSE
     C                   EVAL      CLE042 = 'N'
     C                   ENDIF
 
     C                   EVAL      *IN80 = '0'
     C                   IF        CLE042 = 'Y' Or CDL038 = 'Y'
     C                   EVAL      *IN80 = '1'
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
 
      ** Check to see that *PSSR has not already been called
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
 
      ** If *PSSR already run, then end the program here
     C     DBFILE        IFNE      *BLANK
     C                   MOVE      *ON           *INU8
     C                   ENDIF
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INLR
     C                   RETURN
 
     C                   ENDSR
      ********************************************************************
** CPY
(c) Misys International Banking Systems Ltd. 2011
