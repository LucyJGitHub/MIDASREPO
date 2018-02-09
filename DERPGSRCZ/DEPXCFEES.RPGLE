     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas DE Proj ext ctlr for customer lending fees')     *
      *****************************************************************
      *                                                               *
      *  Midas - Data Export module                                   *
      *                                                               *
      *  DEPXCFEES - Projected Extract Controller for Customer        *
      *              Lending Fees                                     *
      *                                                               *
      *  Function:  This module processes all of the fees currently   *
      *             on file and calls the projected extract           *
      *             module to write details to the projected extract  *
      *             files.                                            *
      *             These records will be used to update details on   *
      *             the Generic transaction files which will          *
      *             subsequently feed into the Historic extract for   *
      *             revenue analysis, thereby writing records to the  *
      *             historic extract files.                           *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      *                 CLE139             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      *                 CDE005             Date 22Aug02               *
      *                 208221             Date 11Dec02               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 204452             Date 03May02               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CDE002  *CREATE    Date 05Dec00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE134 - Past Due Call Loan Processing                       *
      *  CLE148 - Alpha Loan Reference                                *
      *  CLE139 - Lending Fee Capitalisation (Recompile)              *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CDE005 - Data Export - Reservation ID                        *
      *  208221 - Only extract fees with Confirmed Indicator = Y      *
      *           Enable DEWRKEDTA to get info from data area         *
      *  204452 - Recompiled due to changed PF/LEFEED.                *
      *  CDE002 - Data Export - CCRM Revenue Analysis.                *
      *                                                               *
      *****************************************************************
      *
     FLEFEEDL1  IF   E           K DISK
     F                                     INCLUDE(LEFEEDF)
     F                                     PREFIX(FE_)
     FFACHSAL1  IF   E           K DISK
     F                                     INCLUDE(FACHISAF)
     F                                     PREFIX(FH_)
 
      *****************************************************************
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
      **    False      logical = *off (for inidcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      * P E R I O D   D E T A I L S
     D/COPY DECPYSRC,DEXCPERDD
 
 
     D LEFEEX        E DS                  EXTNAME(LEFEED) PREFIX(FE_)
     D FACHISX       E DS                  EXTNAME(FACHISA) PREFIX(FH_)
     D SCSARD        E DS                  EXTNAME(SCSARDPD) PREFIX(SF_)                      CDE005
      ** External DS for Switchable Features details                                          CDE005
     D DSFDY         E DS                  EXTNAME(DSFDY)                                     CDE005
      *
     D W#FEE           DS
     D**FECNUM**               1      6  0                                             155429 CSD027
     D  FECNUM                 1      6A                                                      CSD027
     D  FEFACL                 7     11  0                                                    155429
     D**FELOAN**              12     17  0                                             155429 CLE148
     D  FELOAN                12     17                                                       CLE148
     D  FEFSEQ                18     19  0                                                    155429
      *
      * Extract All Fees or Extract a Single Fee
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
      * EXTALL - Extract All Fees
      ********************************************************************
     C     EXTALL        BEGSR
      *
     C                   READ      LEFEEDL1                               99    *
      *
      * Whilst fees can be found
      *
     C     *IN99         DOWEQ     '0'
      *
      * Extract any live or matured fees
      *
     C                   EXSR      EXTRCT
      *
      * Read the next record
      *
     C                   READ      LEFEEDL1                               99    *
     C                   END
      *
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * EXTSIN - Extract a Single Fee
      ********************************************************************
     C     EXTSIN        BEGSR
      *
     C     FEEKEY        KLIST
     C                   KFLD                    FECNUM
     C                   KFLD                    FEFACL
     C                   KFLD                    FELOAN
     C                   KFLD                    FEFSEQ
      *
     C                   MOVEL     I#TREF        W#FEE
     C     FEEKEY        CHAIN     LEFEEDL1                           99        *
      *
      * If the fee is found, extract it
      *
     C     *IN99         IFEQ      '0'
     C                   EXSR      EXTRCT
     C                   ENDIF
      *
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * EXTRCT - Process specific extract
      ********************************************************************
     C     EXTRCT        BEGSR
      *                                                                                       208221
      * Only extract if fee is confirmed                                                      208221
      *                                                                                       208221
     C     FE_FEAUTO     IFEQ      'Y'                                                        208221
     C     FE_FEAUTO     OREQ      'C'                                                        CLE134
     C     CLE134        ANDEQ     'Y'                                                        CLE134
     C     FE_FEAUT2     OREQ      'C'                                                        CLE134
     C     CLE134        ANDEQ     'Y'                                                        CLE134
      *
      * Get start of facility history header (record type 'FS' on FACHISA)
      * for calculated facility related fees.
      *
     C     FE_FECALT     IFNE      *BLANKS
      *
     C     FACHKY        KLIST
     C                   KFLD                    FE_FECNUM
     C                   KFLD                    FE_FEFACL
     C                   KFLD                    FE_FEPSTD
      *
     C     FACHKY        SETLL     FACHSAL1
     C     FACHKY        READE     FACHSAL1                               99
      *
      * If record for the same customer, facility and date is not found,
      * read previous record
      *
     C     *IN99         IFEQ      '1'
     C     FACHKY        SETLL     FACHSAL1
     C                   READP     FACHSAL1                               99
     C     *IN99         IFEQ      '1'
     C                   CLEAR                   FACHISX
     C                   ENDIF
     C                   ENDIF
      *
     C                   ELSE
      *
      * Process flat facility related fees and loan related fees.
      * Loan related fees are always flat amounts.
      *
     C                   CLEAR                   FACHISX
     C                   ENDIF
      *
      * Set the action code
      *
     C     FE_FERECI     IFEQ      'D'
     C     FE_FERECI     OREQ      'M'
     C                   MOVEL     'I'           W#ACTN
     C                   ELSE
     C                   MOVEL     'D'           W#ACTN
     C                   ENDIF
      *
     C                   CALLB     'DEPXTFEES'
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
     C                   PARM                    LEFEEX
     C                   PARM                    FACHISX
     C                   PARM                    Dataarea                                     208221
     C                   PARM                    I#RSRV           10                          CDE005
 
      * If data error encountered, log error
 
     C     W#RTCD        IFEQ      '*ERROR '
     C                   CLEAR                   BUFFER
     C                   EVAL      BUFFER = I#PH + 'FEES' + I#EXTT + I#TREF                   CDE005
     C                             + W#RTCD + W#ERMS + LEFEEX + I#RSRV                        CDE005
     C                   ELSE                                                                 CDE005
     C                   EVAL      BUFFER = I#PH + 'FEES' + I#EXTT + I#TREF
     C                             + W#RTCD + W#ERMS + LEFEEX
     C                   ENDIF                                                                CDE005
     C                   CALLB     'DEWRTELOG'
     C                   PARM                    BUFFER         4000
     C**********         ENDIF                                                                CDE005
     C                   ENDIF                                                                208221
      *
     C     EEXTRCT       ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * *INZSR --- INITIAL PROCESSING
      ********************************************************************
     C     *INZSR        BEGSR
      *
      * Receive Prime Input Parameters
      *
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           30
      * Inputs
     C                   PARM                    I#EXTT            4
     C                   PARM                    I#EOB             1
     C**********         PARM                    I#TREF           20                          CGL029
     C                   PARM                    I#TREF           26                          CGL029
     C                   PARM                    I#RSRV           10                          CDE005
 
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
      *                                                                                       CLE134
      ** Determine if Past Due Call Loan is ON                                                CLE134
      *                                                                                       CLE134
     C                   MOVEL     'N'           CLE134            1                          CLE134
     C                   CALL      'AOSARDR0'                                                 CLE134
     C                   PARM      *BLANKS       @RTCD                                        CLE134
     C                   PARM      '*VERIFY'     @OPTN                                        CLE134
     C                   PARM      'CLE134'      @SARD                                        CLE134
     C     SCSARD        PARM      SCSARD        DSFDY                                        CLE134
      *                                                                                       CLE134
     C     @RTCD         IFEQ      *BLANK                                                     CLE134
     C                   MOVEL     'Y'           CLE134                                       CLE134
     C                   ENDIF                                                                CLE134
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY DECPYSRC,DEPSSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2001
