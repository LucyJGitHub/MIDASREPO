     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas DE Hist Ext Ctlr for Securities Book Posns')     *
      *****************************************************************
      *                                                               *
      *  Midas - Data Export module                                   *
      *                                                               *
      *  DEHXCSBPS - Historic Extract Controller for Securities       *
      *              Trading Book Positions                           *
      *                                                               *
      *  Function:  This module processes all SE Book Positions and   *
      *             calls the module DEPXTSBPS to write records to    *
      *             the historic extract files.                       *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CLE134             Date 01Aug12               *
      *  Prev Amend No. CRE073             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 234300             Date 28Sep06               *
      *                 CSE075             Date 17Nov05               *
      *                 CSD027             Date 09Dec05               *
      *                 CSE071             Date 19Jul05               *
      *                 CGL029             Date 01Sep03               *
      *                 CDE005             Date 20Aug02               *
      *                 CAS006             Date 21Jan03               *
      *                 208221             Date 11Dec02               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CDE002  *CREATE    Date 05Dec00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  234300 - Recompiled over changed in PF/HSTTRD.               *
      *  CSE075 - US Enhanced Treasury Upgrade to MidasPlus           *
      *           (Recompile)                                         *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CDE005 - Data Export - Reservation ID                        *
      *  CAS006 - Hedge Accounting Phase B (Recompile)                *
      *  208221 - Enable DEWRKEDTA to get info from data area         *
      *  CDE002 - Data Export - CCRM Revenue Analysis.                *
      *                                                               *
      *****************************************************************
 
     FBKPHD     IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(BH_)
     FBKPOS     IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(BP_)
     FSECTY     IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(SE_)
     FINVTP     IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(IN_)
     FTRDMTH    IF   E           K DISK
 
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
 
 
     D BKPHDX        E DS                  EXTNAME(BKPHDD) PREFIX(BH_)
     D BKPOSX        E DS                  EXTNAME(BKPOSD) PREFIX(BP_)
     D SECTYX        E DS                  EXTNAME(SECTYD) PREFIX(SE_)
     D INVTPX        E DS                  EXTNAME(INVTPD) PREFIX(IN_)
 
 
     D                 DS
     D  I#POSID                1     20
     D  TDSS                   1     10
     D  TDBK                  12     13
     D  TDBA                  15     17
     D  TDMI                  19     19
 
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for BANK details
     D SDSTRD        E DS                  EXTNAME(SDSTRDPD)
      ** External DS for SECURITIES TRADING details
     D SCSARD        E DS                  EXTNAME(SCSARDPD) PREFIX(SF_)                      CDE005
      ** External DS for Switchable Features details                                          CDE005
     D DSFDY         E DS                  EXTNAME(DSFDY)
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
 
 
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
      * EXTRACT ALL SECURITIES BOOK POSITIONS
      * OR EXTRACT A SINGLE SECURITY BOOK POSITION
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
      * EXTRACT ALL SECURITIES BOOK POSITIONS
      ********************************************************************
     C     EXTALL        BEGSR
      *
     C                   READ      BKPHDDF                                99    *
      *
      * Whilst positions can be found
      *
     C     *IN99         DOWEQ     '0'
      *
      * Extract any live positions
      *
     C     BH_BHTV       IFEQ      Trade_Val
     C     BH_RECI       ANDEQ     'D'
     C                   EXSR      EXTRCT
     C                   END
      *
      * Read the next record
      *
     C                   READ      BKPHDDF                                99    *
     C                   END
      *
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * EXTRACT A SINGLE SECURITY BOOK POSITION
      ********************************************************************
     C     EXTSIN        BEGSR
      *
     C                   MOVEL     I#TREF        I#POSID
     C     BKPHDK        KLIST
     C                   KFLD                    TDSS
     C                   KFLD                    TDBA
     C                   KFLD                    TDBK
     C                   KFLD                    TDMI
     C                   KFLD                    Trade_Val
 
     C     BKPHDK        CHAIN     BKPHDDF                            99        *
      *
      * If the position is found
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
      * Get security details
      *
     C     BH_BHSC       CHAIN     SECTYDF                            99        *
 
      * Ignore if security not found or if deleted or matured
 
     C     *IN99         IFEQ      '1'
     C     SE_RECI       OREQ      '*'
     C     SE_MATY       ORNE      *ZERO
     C     SE_MATY       ANDLT     W#D001
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
      * Get further position details needed from BKPOSD
      *
     C     BKPOSK        KLIST
     C                   KFLD                    BH_BHSC
     C                   KFLD                    BH_BHBA
     C                   KFLD                    BH_BHBK
     C                   KFLD                    BH_BHMK
     C                   KFLD                    BH_BHTV
     C                   KFLD                    BP_BPPD
     C     BKPOSP        KLIST
     C                   KFLD                    BH_BHSC
     C                   KFLD                    BH_BHBA
     C                   KFLD                    BH_BHBK
     C                   KFLD                    BH_BHMK
     C                   KFLD                    BH_BHTV
      *
      *  Obtain the position prior to the start of the year.
      *
     C                   CLEAR                   BKPOSX
     C                   Z-ADD     W#D001        BP_BPPD
 
     C     BKPOSK        SETGT     BKPOS
     C     BKPOSP        READPE    BKPOS                                  99
      *
      *  If a position is present
      *  No processing is required if it's flat and the latest position
      *
     C     *IN99         IFEQ      '0'
     C     BP_BPPD       ANDEQ     BH_LPSD
     C     BP_NPSN       ANDEQ     *ZERO
     C     BH_LPCD       ANDLT     W#D001
     C                   GOTO      EEXTRCT
     C                   ENDIF
      *
      *  If a position is present
      *  Set the latest position date to its position date
      *
     C     *IN99         IFEQ      '0'
     C                   Z-ADD     BP_BPPD       BH_LPSD
     C                   ENDIF
      *
      *  If no position is present prior to year-end, the position date
      *  is the day prior to the value date of the first trade present
      *
     C     *IN99         IFEQ      '1'
 
     C     TRADK         KLIST
     C                   KFLD                    BH_BHBA
     C                   KFLD                    BH_BHBK
     C                   KFLD                    BH_BHSC
     C                   KFLD                    BH_BHMK
 
     C     TRADK         SETLL     TRDMTH
     C     *IN99         DOUEQ     '1'
     C     RECI          ORNE      '*'
     C     RECI          ANDNE     'C'
     C     RECI          ANDNE     'R'
     C     TRADK         READE     TRDMTH                                 99
     C                   ENDDO
 
      * no trades, so bypass
 
     C     *IN99         IFEQ      '1'
     C                   GOTO      EEXTRCT
     C                   ENDIF
 
     C     TDVD          SUB       1             BH_LPSD
 
     C                   ENDIF
      *
      * Set the action code
      *
     C                   MOVEL     'I'           W#ACTN
      *
     C                   CALLB     'DEPXTSBPS'
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
     C                   PARM                    BKPHDX
     C                   PARM                    BKPOSX
     C                   PARM                    SECTYX
     C                   PARM                    INVTPX
     C                   PARM                    Dataarea                                     208221
     C                   PARM                    I#RSRV           10                          CDE005
 
      * If data error encountered, log error
 
     C     W#RTCD        IFEQ      '*ERROR '
     C                   CLEAR                   BUFFER
     C     CDE005        IFEQ      'Y'                                                        CDE005
     C                   EVAL      BUFFER = I#PH + 'SBPS' + I#EXTT + I#TREF                   CDE005
     C                             + W#RTCD + W#ERMS + BKPHDX + I#RSRV                        CDE005
     C                   ELSE                                                                 CDE005
     C                   EVAL      BUFFER = I#PH + 'SBPS' + I#EXTT + I#TREF
     C                             + W#RTCD + W#ERMS + BKPHDX
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
 
      * This is an historic extract
 
     C                   MOVE      'H'           I#PH
 
      * Get Extract control information
 
      /COPY DECPYSRC,DEXTGTCT
 
 
      *
      **  Access Bank Details
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      **  Access Securities Trading details
      *
     C                   CALLB     'AOSTRDR0'
     C                   PARM      '*DBERR  '    @RTCD
     C                   PARM      '*FIRST  '    @OPTN
     C     SDSTRD        PARM      SDSTRD        DSSDY
      *
      ** Extract value date positions
      *
     C                   MOVEL     'V'           Trade_Val         1
      *                                                                                       CDE005
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
      *
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY DECPYSRC,DEPSSR
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
