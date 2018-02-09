     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas DE Proj ext ctlr for securities trades')         *
      *****************************************************************
      *                                                               *
      *  Midas - Data Export module                                   *
      *                                                               *
      *  DEPXCSTRD - Projected Extract Controller for Securities      *
      *              Trades                                           *
      *                                                               *
      *  Function:  This module processes all SE (non-internal) trades*
      *             and calls the module DEPXTSTRD to write records to*
      *             the projected extract files.                      *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CRE073             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSE075             Date 17Nov05               *
      *                 CSD027             Date 09Dec05               *
      *                 CSE071             Date 19Jul05               *
      *                 BUG3122            Date 17Jul04               *
      *                 CGL029             Date 01Sep03               *
      *                 CDE005             Date 20Aug02               *
      *                 CAS006             Date 21Jan03               *
      *                 208221             Date 11Dec02               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CDE002             Date 05Dec00               *
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSD006             Date 15May01               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CSE023             Date 12Jul00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CDE001  *CREATE    Date 23Nov99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CSE075 - US Enhanced Treasury Upgrade to MidasPlus           *
      *           (Recompile)                                         *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  BUG3122 - Recompiled due to changes in SDSECSPD.             *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CDE005 - Data Export - Reservation ID                        *
      *  CAS006 - Hedge Accounting Phase B (Recompile)                *
      *  208221 - Enable DEWRKEDTA to get info from data area         *
      *  CDE002 - Data Export - CCRM Revenue Analysis                 *
      *           (Re-compile)                                        *
      *  CSD006 - Recompiled over changed SECTYD.                     *
      *  CSE023 - Treaty Withholding Tax.                             *
      *  CDE001 - Data Export - CCRM Limits.                          *
      *                                                               *
      *****************************************************************
 
     FTRADS     IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(TR_)
     FSECTY     IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(SE_)
     FINVTP     IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(IN_)
 
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indicator processing)
      **    False      logical = *off (for indicator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      * P E R I O D   D E T A I L S
     D/COPY DECPYSRC,DEXCPERDD
 
 
     D TRADSX        E DS                  EXTNAME(TRADSD) PREFIX(TR_)
     D SECTYX        E DS                  EXTNAME(SECTYD) PREFIX(SE_)
     D INVTPX        E DS                  EXTNAME(INVTPD) PREFIX(IN_)
 
     DSDSECS         E DS                  EXTNAME(SDSECSPD)
      ** SECURITY CLIENT DETAILS
     D SCSARD        E DS                  EXTNAME(SCSARDPD) PREFIX(SF_)                      CDE005
      ** External DS for Switchable Features details                                          CDE005
     D DSFDY         E DS                  EXTNAME(DSFDY)                                     CDE005
     DDSSDY          E DS                  EXTNAME(DSSDY)
      ** SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
 
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           30
      * INPUTS
     C                   PARM                    I#EXTT            4
     C                   PARM                    I#EOB             1
     C**********         PARM                    I#TREF           20                          CGL029
     C                   PARM                    I#TREF           26                          CGL029
     C                   PARM                    I#RSRV           10                          CDE005
      *
      * EXTRACT ALL SECURITIES TRADES
      * OR EXTRACT A SINGLE SECURITY TRADE
      *
     C     I#EXTT        IFEQ      '*ALL'
     C                   EXSR      EXTALL
     C                   SETON                                        LR
     C                   ELSE
     C                   EXSR      EXTSIN
     C                   ENDIF
      *
     C                   RETURN
      *
     C/SPACE 5
      ********************************************************************
      * EXTRACT ALL SECURITIES TRADES
      ********************************************************************
     C     EXTALL        BEGSR
      *
     C                   READ      TRADSDF                                99    *
      *
      * Whilst trades can be found
      *
     C     *IN99         DOWEQ     '0'
      *
      * Extract any unsettled or newly deleted trades
      ** RECI= D & L => inserted & inserted not authorized
      ** RECI= A & P => changed  & changed not authorized
      ** RECI= C & R => deleted  & deleted not authorized
      *
     C     TR_RECI       IFEQ      'D'
     C     TR_RECI       OREQ      'L'
     C     TR_RECI       OREQ      'A'
     C     TR_RECI       OREQ      'P'
     C     TR_RECI       OREQ      'C'
     C     TR_RECI       OREQ      'R'
     C                   EXSR      EXTRCT
     C                   END
      *
      * Read the next record
      *
     C                   READ      TRADSDF                                99    *
     C                   END
      *
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * EXTRACT A SINGLE SECURITIES TRADE
      ********************************************************************
     C     EXTSIN        BEGSR
      *
     C                   MOVEL     I#TREF        W#TDRF            6
     C     W#TDRF        CHAIN     TRADSDF                            99        *
      *
      * If the trade is found
      * extract it
      *
     C     *IN99         IFEQ      '0'
     C                   EXSR      EXTRCT
     C                   ENDIF
      *
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * EXTRACT
      ********************************************************************
     C     EXTRCT        BEGSR
      *
      * Get trade counterparty securities customer details
      *
     C                   MOVEL     TR_TCNR       @AENB
     C                   CALLB     'AOSECSR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY    '    @OPTN             7
     C                   PARM                    @AENB             6
     C     SDSECS        PARM      SDSECS        DSSDY
 
      * Ignore if customer not found or if classification is internal
 
     C     @RTCD         IFEQ      '*NRF   '
     C     BFCLAS        OREQ      'I'
     C                   GOTO      EEXTRCT
     C                   ENDIF
      *
      * Get security details
      *
     C     TR_TDSS       CHAIN     SECTYDF                            99        *
 
      * Ignore if security not found or if deleted or matured
 
     C     *IN99         IFEQ      '1'
     C     SE_RECI       OREQ      '*'
     C     SE_RECI       OREQ      'M'
     C                   GOTO      EEXTRCT
     C                   ENDIF
      *
      * Get investment type details
      *
     C     INVTPK        KLIST
     C                   KFLD                    SE_NMCY
     C                   KFLD                    SE_SITP
     C     INVTPK        CHAIN     INVTPDF                            99        *
 
      * Ignore if investment type not found or if deleted
 
     C     *IN99         IFEQ      '1'
     C     IN_RECI       OREQ      '*'
     C                   GOTO      EEXTRCT
     C                   ENDIF
      *
      * Set the action code
      *
     C     TR_RECI       IFEQ      'C'
     C     TR_RECI       OREQ      'R'
     C                   MOVEL     'D'           W#ACTN
     C                   ELSE
     C                   MOVEL     'I'           W#ACTN
     C                   ENDIF
      *
     C                   CALLB     'DEPXTSTRD'
     C                   PARM      *BLANK        W#RTCD            7            * RETURN CODE
     C                   PARM      *BLANK        W#ERMS           30            * ERROR MESSAGE
     C                   PARM                    W#ACTN            1            * ACTION CODE
     C                   PARM      I#EXTT        W#EXTT            4
     C                   PARM      I#PH          W#PH              1
     C                   PARM      I#EOB         W#EOB             1
     C                   PARM      I#RDNB        W#RDNB            5 0
     C                   PARM      I#DNWD        W#DNWD            5 0
     C                   PARM      I#HCOD        W#HCOD            5 0
     C                   PARM      I#EXTD        W#EXTD            5 0
     C                   PARM      I#EVCD        W#EVCD            5 0
     C                   PARM      I#PCOD        W#PCOD            5 0
     C                   PARM                    PeriodEDT
     C                   PARM                    TRADSX
     C                   PARM                    SECTYX
     C                   PARM                    INVTPX
     C                   PARM                    BFCLAS
     C                   PARM                    Dataarea                                     208221
     C                   PARM                    I#RSRV           10                          CDE005
 
      * If data error encountered, log error
 
     C     W#RTCD        IFEQ      '*ERROR '
     C                   CLEAR                   BUFFER
     C     CDE005        IFEQ      'Y'                                                        CDE005
     C                   EVAL      BUFFER = I#PH + 'STRD' + I#EXTT + I#TREF                   CDE005
     C                             + W#RTCD + W#ERMS + TRADSX + I#RSRV                        CDE005
     C                   ELSE                                                                 CDE005
     C                   EVAL      BUFFER = I#PH + 'STRD' + I#EXTT + I#TREF
     C                             + W#RTCD + W#ERMS + TRADSX
     C                   ENDIF                                                                CDE005
     C                   CALLB     'DEWRTELOG'
     C                   PARM                    BUFFER         4000
     C                   ENDIF
      *
     C     EEXTRCT       ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * *INZSR --- INITIAL PROCESSING
      ********************************************************************
     C     *INZSR        BEGSR
 
      * This is a projections extract
 
     C                   MOVE      'P'           I#PH
 
      * Get Extract control information
 
      /COPY DECPYSRC,DEXTGTCT
 
      ** Determine if Data Export - Reservation ID is active                                  CDE005
     C                   CALL      'AOSARDR0'                                                 CDE005
     C                   PARM      *BLANKS       @RTCD             7                          CDE005
     C                   PARM      '*VERIFY'     @OPTN             7                          CDE005
     C                   PARM      'CDE005'      @SARD             6                          CDE005
     C     SCSARD        PARM      SCSARD        DSFDY                                        CDE005
      *                                                                                       CDE005
     C     @RTCD         IFEQ      *BLANK                                                     CDE005
     C                   MOVEL     'Y'           CDE005            1                          CDE005
     C                   ENDIF                                                                CDE005
      *                                                                                       CDE005
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY DECPYSRC,DEPSSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2001
