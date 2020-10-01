     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas DE Projected ext ctlr for NAs purchased')        *
      *****************************************************************
      *                                                               *
      *  Midas - Data Export module                                   *
      *                                                               *
      *  DEPXCNASP - Projected Extract Controller for Money Market    *
      *              Negotiable Assets Purchased                      *
      *                                                               *
      *  Function:  This module processes all MM NA's Purchased and   *
      *             calls the module DEPXTNASP to write records to    *
      *             the projected extract files.                      *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CDL099             Date 06Oct17               *
      *                 CGL165             Date 17Feb15               *
      *                 CDL096             Date 22Sep14               *
      *                 CDL094             Date 11Jun14               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CDL049             Date 05Jul06               *
      *                 CSD027             Date 09Dec05               *
      *                 CDL028             Date 07Feb05               *
      *                 CDL020             Date 03Feb04               *
      *                 CDL019             Date 03Feb04               *
      *                 CDL018             Date 03Feb04               *
      *                 CDL017             Date 03Feb04               *
      *                 CDL016             Date 03Feb04               *
      *                 CGL029             Date 01Sep03               *
      *                 222727             Date 05Nov03               *
      *                 CDE005             Date 22Aug02               *
      *                 CAS005             Date 16Dec02               *
      *                 CAS004             Date 26Jun02               *
      *                 208221             Date 11Dec02               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CDE002             Date 05Dec00               *
      * Midas DBA 3.05 -----------------------------------------------*
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CDE001  *CREATE    Date 23Nov99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *           (Recompile)                                         *
      *  MD046248 - Finastra Rebranding                               *
      *  CDL099 - Split Value Date (Recompile)                        *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompiled)                                        *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL028 - Automatic Rate Interpolations (Recompile)           *
      *  CDL020 - Apply Base Rate at Value Date (Recompile)           *
      *  CDL019 - Allow Base Rate Changes on Fixed Deposits/Loans     *
      *           (Recompile)                                         *
      *  CDL018 - Multiple Settlement Accounts on Loans/Deposits      *
      *           (Recompile)                                         *
      *  CDL017 - Penalty Fee & Early Maturity of Fixed Term Loan/Dep *
      *           (Recompile)                                         *
      *  CDL016 - Automatic rollover of Fixed Term Loans/Deposits     *
      *           (Recompile)                                         *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  222727 - Release 5.0 errors  (Recompile)                     *
      *  CDE005 - Data Export - Reservation ID                        *
      *  CAS005 - Enhancements to CAS001, CAS002 and CAS004           *
      *           (Recompile)                                         *
      *  CAS004 - Hedge Accounting Phase A (Recompile)                *
      *  208221 - Enable DEWRKEDTA to get info from data area         *
      *  CDE002 - Data Export - CCRM Revenue Analysis                 *
      *           (Re-compile)                                        *
      *  CDE001 - Data Export - CCRM Limits.                          *
      *                                                               *
      *****************************************************************

     FMMDEALLL  IF   E           K DISK    INFSR(*PSSR)
     F                                     INCLUDE(MMDENBP0)
     FDEALS     IF   E           K DISK    INFSR(*PSSR)
     F                                     INCLUDE(DEALSDDF)

     F/COPY WNCPYSRC,DEPXCNAF01
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


     D MMDENB        E DS                  EXTNAME(MMDENBPP)
     D DEALDD        E DS                  EXTNAME(DEALSDD)
     D  QQRON1       E                     EXTFLD(RONSQQ)                                     CGL029
     D  QQPON1       E                     EXTFLD(PONSQQ)                                     CGL029
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
     C/COPY WNCPYSRC,DEPXCNAC01
      *
      * EXTRACT ALL NA'S PURCHASED
      * OR EXTRACT A SINGLE NA PURCHASED
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
      * EXTRACT ALL NA'S PURCHASED
      ********************************************************************
     C     EXTALL        BEGSR
      *
     C                   READ      MMDENBP0                               99    *
      *
      * Whilst deals can be found
      *
     C     *IN99         DOWEQ     '0'
      *
      * Extract any live or newly reversed NA's purcased
      *
     C     HLDSTS        IFEQ      'C'
     C     HLDSTS        OREQ      'A'
     C     HLDSTS        OREQ      'R'
     C     HLDDLT        OREQ      'D'
     C/COPY WNCPYSRC,DEPXCNAC02
     C                   EXSR      EXTRCT
     C/COPY WNCPYSRC,DEPXCNAC03
     C                   END
      *
      * Read the next record
      *
     C                   READ      MMDENBP0                               99    *
     C                   END
      *
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * EXTRACT A SINGLE NA PURCHASED
      ********************************************************************
     C     EXTSIN        BEGSR
      *
     C                   MOVEL     I#TREF        W#DLNO            6 0
     C     W#DLNO        CHAIN     MMDENBP0                           99        *
      *
      * If the deal is found
      * extract it
      *
     C     *IN99         IFEQ      '0'
     C/COPY WNCPYSRC,DEPXCNAC04
     C                   EXSR      EXTRCT
     C/COPY WNCPYSRC,DEPXCNAC05
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
      * Get further deal details needed from DEALSDD
      *
     C                   CLEAR                   DEALDD
     C     HLDN38        CHAIN     DEALSDDF                           99        *
      *
      * Set the action code
      *
     C     HLDDLT        IFEQ      'D'
     C                   MOVEL     'D'           W#ACTN
     C                   ELSE
     C                   MOVEL     'I'           W#ACTN
     C                   ENDIF
      *
     C                   CALLB     'DEPXTNASP'
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
     C                   PARM                    MMDENB
     C                   PARM                    DEALDD
     C                   PARM                    Dataarea                                     208221
     C                   PARM                    I#RSRV           10                          CDE005

      * If data error encountered, log error

     C     W#RTCD        IFEQ      '*ERROR '
     C                   CLEAR                   BUFFER
     C     CDE005        IFEQ      'Y'                                                        CDE005
     C                   EVAL      BUFFER = I#PH + 'NASP' + I#EXTT + I#TREF                   CDE005
     C                             + W#RTCD + W#ERMS + MMDENB + I#RSRV                        CDE005
     C                   ELSE                                                                 CDE005
     C                   EVAL      BUFFER = I#PH + 'NASP' + I#EXTT + I#TREF
     C                             + W#RTCD + W#ERMS + MMDENB
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
(c) Finastra International Limited 2001
