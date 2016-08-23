     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*OVR *  OVRDBF FILE(DEALSX) TOFILE(DEALS) SHARE(*NO)                 *                       CDE002
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas DE Projected extract controller for FX deals')   *
      *****************************************************************
      *                                                               *
      *  Midas - Data Export module                                   *
      *                                                               *
      *  DEPXCFXDL - Projected Extract Controller for Foreign         *
      *              Exchange Deals                                   *
      *                                                               *
      *  Function:  This module processes all FX Deals and calls the  *
      *             module DEPXTFXDL to write records to the          *
      *             projected extract files.                          *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CGL165             Date 17Feb15               *
      *  Prev Amend No. CDL096             Date 22Sep14               *
      *                 CDL094             Date 11Jun14               *
      *                 CSW212             Date 03May12               *
      *                 CER059             Date 19Jul10               *
      *                 CER043             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CDL049             Date 05Jul06               *
      *                 CSD027             Date 09Dec05               *
      *                 CDL028             Date 07Feb05               *
      *                 CGL029             Date 01Sep03               *
      *                 CDE005             Date 20Aug02               *
      *                 CAS004             Date 26Jun02               *
      *                 208221             Date 11Dec02               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CDE002             Date 05Dec00               *
      * Midas DBA 3.05 -----------------------------------------------*
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CDL008             Date 02May00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CDE001  *CREATE    Date 23Nov99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompiled)                                        *
      *  CSW212 - SWIFT 2012 Changes (Recompile)                      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *           (Recompile)                                         *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL028 - Automatic Rate Interpolations (Recompile)           *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CDE005 - Data Export - Reservation ID                        *
      *  CAS004 - Hedge Accounting Phase A (Recompile)                *
      *  208221 - Enable DEWRKEDTA to get info from data area         *
      *  CDE002 - Data Export - CCRM Revenue Analysis.                *
      *  CDL008 - Continuous Linked Settlement                        *
      *  CDE001 - Data Export - CCRM Limits.                          *
      *                                                               *
      *****************************************************************
 
     FFXDEALLL  IF   E           K DISK    INFSR(*PSSR)
     F                                     INCLUDE(FXDEALP0)
     FDEALS     IF   E           K DISK    INFSR(*PSSR)
     F                                     INCLUDE(DEALSDBF)
     FDEALSX    IF   E           K DISK    INFSR(*PSSR)                                       CDE002
     F                                     INCLUDE(DEALSDBF)                                  CDE002
     F                                     RENAME(DEALSDBF:DEALSDBFX)                         CDE002
     F                                     PREFIX(OL_)                                        CDE002
 
     F/COPY WNCPYSRC,DEPXCFXF01
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
 
 
     D FXDEAL        E DS                  EXTNAME(FXDEALPP)
     D DEALDB        E DS                  EXTNAME(DEALSDB)
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
     C/COPY WNCPYSRC,DEPXCFXC01
      *
      * EXTRACT ALL FX DEALS
      * OR EXTRACT A SINGLE FX DEAL
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
      * EXTRACT ALL FX DEALS
      ********************************************************************
     C     EXTALL        BEGSR
      *
     C                   READ      FXDEALP0                               99    *
      *
      * Whilst deals can be found
      *
     C     *IN99         DOWEQ     '0'
      *
      * Extract any live or newly reversed FX deals
      *
     C     FHDSTS        IFEQ      'C'
     C     FHDSTS        OREQ      'A'
     C     FHDSTS        OREQ      'R'
     C     FHDDLT        OREQ      'D'
     C/COPY WNCPYSRC,DEPXCFXC02
     C                   EXSR      EXTRCT
     C/COPY WNCPYSRC,DEPXCFXC03
     C                   ENDIF
      *
      * Read the next record
      *
     C                   READ      FXDEALP0                               99    *
     C                   END
      *
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * EXTRACT A SINGLE FX DEAL
      ********************************************************************
     C     EXTSIN        BEGSR
      *
     C                   MOVEL     I#TREF        W#DLNO            6 0
     C     W#DLNO        CHAIN     FXDEALP0                           99        *
      *
      * If the deal is found
      * extract it
      *
     C     *IN99         IFEQ      '0'
     C/COPY WNCPYSRC,DEPXCFXC04
     C                   EXSR      EXTRCT
     C/COPY WNCPYSRC,DEPXCFXC05
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
      * Get further deal details needed from DEALSDB
      *
     C                   CLEAR                   DEALDB
     C     FHDN38        CHAIN     DEALSDBF                           99        *
                                                                                              CDE002
      * Get 1st leg of swap                                                                   CDE002
                                                                                              CDE002
     C     FSLI          IFEQ      2                                                          CDE002
     C     SODN          CHAIN     DEALSDBFX                          99                      CDE002
     C                   ENDIF                                                                CDE002
      *
      * Set the action code
      *
     C     FHDDLT        IFEQ      'D'
     C                   MOVEL     'D'           W#ACTN
     C                   ELSE
     C                   MOVEL     'I'           W#ACTN
     C                   ENDIF
      *
     C                   CALLB     'DEPXTFXDL'
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
     C                   PARM                    FXDEAL
     C                   PARM                    DEALDB
     C                   PARM                    OL_ACEI                                      CDE002
     C                   PARM                    Dataarea                                     208221
     C                   PARM                    I#RSRV           10                          CDE005
 
      * If data error encountered, log error
 
     C     W#RTCD        IFEQ      '*ERROR '
     C                   CLEAR                   BUFFER
     C     CDE005        IFEQ      'Y'                                                        CDE005
     C                   EVAL      BUFFER = I#PH + 'FXDL' + I#EXTT + I#TREF                   CDE005
     C                             + W#RTCD + W#ERMS + FXDEAL + I#RSRV                        CDE005
     C                   ELSE                                                                 CDE005
     C                   EVAL      BUFFER = I#PH + 'FXDL' + I#EXTT + I#TREF
     C                             + W#RTCD + W#ERMS + FXDEAL
     C                   ENDIF                                                                CDE005
     C                   CALLB     'DEWRTELOG'
     C                   PARM                    BUFFER         4000
     C                   ENDIF
      *
     C                   ENDSR
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
(c) Misys International Banking Systems Ltd. 2001
