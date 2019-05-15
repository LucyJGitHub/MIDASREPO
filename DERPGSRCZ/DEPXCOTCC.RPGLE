     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas DE Proj ext ctlr for (F & O) OTC options')       *
      *****************************************************************
      *                                                               *
      *  Midas - Data Export module                                   *
      *                                                               *
      *  DEPXCOTCC - Projected Extract Controller for Financial       *
      *              Futures Over the Counter Transactions            *
      *                                                               *
      *  Function:  This module processes all FF OTC's and            *
      *             calls the module DEPXTOTCC to write records to    *
      *             the projected extract files.                      *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CAP208             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CGL029             Date 01Sep03               *
      *                 CDE005             Date 20Aug02               *
      *                 208221             Date 11Dec02               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CDE002             Date 05Dec00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CDE001  *CREATE    Date 23Nov99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CAP208 - F&O Market Instrument API (Recompile)               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CDE005 - Data Export - Reservation ID                        *
      *  208221 - Enable DEWRKEDTA to get info from data area         *
      *  CDE002 - Data Export - CCRM Revenue Analysis                 *
      *           (Re-compile)                                        *
      *  CDE001 - Data Export - CCRM Limits.                          *
      *                                                               *
      *****************************************************************
 
     FTRANS     IF   E           K DISK    PREFIX(TR_) INFSR(*PSSR)
     FTRSET     IF   E           K DISK    PREFIX(TS_) INFSR(*PSSR)
     FINTYP     IF   E           K DISK    PREFIX(IN_) INFSR(*PSSR)
     FPRICS     IF   E           K DISK    PREFIX(PC_) INFSR(*PSSR)
 
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
 
 
     D TRANSX        E DS                  EXTNAME(TRANSD) PREFIX(TR_)
     D TRSETX        E DS                  EXTNAME(TRSETD) PREFIX(TS_)
     D INTYPX        E DS                  EXTNAME(INTYPD) PREFIX(IN_)
     D PRICSX        E DS                  EXTNAME(PRICSD) PREFIX(PC_)
      *                                                                                       CDE005
     D SCSARD        E DS                  EXTNAME(SCSARDPD) PREFIX(SF_)                      CDE005
      ** External DS for Switchable Features details                                          CDE005
     D DSFDY         E DS                  EXTNAME(DSFDY)                                     CDE005
 
 
 
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
      * EXTRACT ALL F&O OTC OPTIONS
      * OR EXTRACT A SINGLE F&O OTC OPTION
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
      * EXTRACT ALL F&O OTC OPTIONS
      ********************************************************************
     C     EXTALL        BEGSR
      *
     C                   READ      TRANSDF                                99    *
      *
      * Whilst OTC options can be found
      *
     C     *IN99         DOWEQ     '0'
      *
      * Extract any live or newly reversed trades in OTC options
      *
     C     TR_RECI       IFEQ      'D'
     C     TR_RECI       OREQ      '*'
     C     TR_PCAL       IFNE      *BLANK
     C     TR_TRTY       IFEQ      'P'
     C     TR_TRTY       OREQ      'S'
     C                   EXSR      EXTRCT
     C                   END
     C                   END
     C                   END
      *
      * Read the next record
      *
     C                   READ      TRANSDF                                99    *
     C                   END
      *
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * EXTRACT A SINGLE F&O OTC OPTION
      ********************************************************************
     C     EXTSIN        BEGSR
      *
     C                   MOVEL     I#TREF        W#TNBR            6 0
     C     W#TNBR        CHAIN     TRANSDF                            99        *
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
      * Get instrument details
      *
     C     TR_ISTT       CHAIN     INTYPDF                            99        *
 
      * Ignore if instrument not found or if deleted
 
     C     *IN99         IFEQ      '1'
     C     IN_RECI       OREQ      '*'
     C                   GOTO      EEXTRCT
     C                   ENDIF
      *
      * Get trade settlement details
      *
     C                   CLEAR                   TRSETX
     C     TR_TNBR       CHAIN     TRSETDF                            99        *
      *
      * Get 'instrument' price
      *
     C     PRICSK        KLIST
     C                   KFLD                    TR_ISTT
     C                   KFLD                    TR_YRNO
     C                   KFLD                    TR_MTHN
     C                   KFLD                    TR_PCAL
     C                   KFLD                    TR_STRP
     C     PRICSK        CHAIN     PRICSDF                            99        *
     C     *IN99         IFEQ      '1'
     C     PC_RECI       ORNE      'D'
     C                   CLEAR                   PRICSX
     C                   ENDIF
      *
      * Set the action code
      *
     C     TR_RECI       IFEQ      '*'
     C                   MOVEL     'D'           W#ACTN
     C                   ELSE
     C                   MOVEL     'I'           W#ACTN
     C                   ENDIF
      *
     C                   CALLB     'DEPXTOTCC'
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
     C                   PARM                    TRANSX
     C                   PARM                    TRSETX
     C                   PARM                    INTYPX
     C                   PARM                    PRICSX
     C                   PARM                    Dataarea                                     208221
     C                   PARM                    I#RSRV           10                          CDE005
 
      * If data error encountered, log error
 
     C     W#RTCD        IFEQ      '*ERROR '
     C                   CLEAR                   BUFFER
     C     CDE005        IFEQ      'Y'                                                        CDE005
     C                   EVAL      BUFFER = I#PH + 'OTCC' + I#EXTT + I#TREF                   CDE005
     C                             + W#RTCD + W#ERMS + TRANSX + I#RSRV                        CDE005
     C                   ELSE                                                                 CDE005
     C                   EVAL      BUFFER = I#PH + 'OTCC' + I#EXTT + I#TREF
     C                             + W#RTCD + W#ERMS + TRANSX
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
