     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MX Saved Data Update - RETAIL module')           *
      *****************************************************************
      *                                                               *
      *  Midas - Meridian Export Module                               *
      *                                                               *
      *  MXSDUPDRE - Saved Data Update - RETAIL Module                *
      *                                                               *
      *  Function:  This module updates the retail saved data files.  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CRE041             Date 28Sep12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CDL049             Date 11Jul06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG2304            Date 30Apr04               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CMX003             Date 05Nov00               *
      *                 CMX002             Data 26Sep00               *
      *                 CMX001  *CREATE    Data 01Jan00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CRE041 - Enhancements to Customer Exchanges (Recompile)      *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG2304 - Various file layout changes. Recompile.            *
      *  CMX003 - Meridian Export Enhancements - Phase 2              *
      *           (RE-COMPILE OVER CHANGED /COPY)                     *
      *  CMX002 - Meridian Export Enhancements - Phase 1              *
      *  CMX001 - Meridian Export                                     *
      *                                                               *
      *****************************************************************
 
     FCUSEXCE   IP   E             DISK    INFSR(*PSSR) PREFIX(C_)
     FMXSRECEPD UF A E           K DISK    RENAME(CUSEXCEF:MXSRECEP0)
     F                                     INFSR(*PSSR) PREFIX(PC_)
 
     FTTRANPD   IS   E             DISK    INFSR(*PSSR) PREFIX(TR_)
     F                                     INCLUDE(TTRANPDF)
     FMXSRETRPD UF A E           K DISK    RENAME(TTRANPDF:MXSRETRP0)
     F                                     INFSR(*PSSR) PREFIX(PTR_)
 
     FTTCHGPD   IS   E             DISK    INFSR(*PSSR) PREFIX(TC_)
     F                                     INCLUDE(TTCHGPDF)
     FMXSRETCPD UF A E           K DISK    RENAME(TTCHGPDF:MXSRETCP0)
     F                                     INFSR(*PSSR) PREFIX(PTC_)
 
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
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
 
      * CUSEXCE
     D RECE          E DS                  EXTNAME(CUSEXCE)
     D                                     PREFIX(C_)
     D P_RECE        E DS                  EXTNAME(MXSRECEPD)
     D                                     PREFIX(PC_)
 
      * TTRANPD
     D RETR          E DS                  EXTNAME(TTRANPD)
     D                                     PREFIX(TR_)
     D P_RETR        E DS                  EXTNAME(MXSRETRPD)
     D                                     PREFIX(PTR_)
 
      * TTCHGPD
     D RETC          E DS                  EXTNAME(TTCHGPD)
     D                                     PREFIX(TC_)
     D P_RETC        E DS                  EXTNAME(MXSRETCPD)
     D                                     PREFIX(PTC_)
 
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for BANK details
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
 
     D MXEXPCTL      E DS                  EXTNAME(MXEXPCTL)
 
 
     ICUSEXCEF      01
     ITTRANPDF      02
     ITTCHGPDF      03
 
 
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           30
      * INPUT
      * Start of Month (Y/N)
     C                   PARM                    S_O_Month         1
 
      * If a customer exchange
 
     C     *in01         IFEQ      '1'
     C     C_RECI        IFEQ      'D'
     C     C_RECI        OREQ      'C'
     C                   MOVEL     C_BRCA        I#BRCA
     C                   EXSR      FILTER
 
      * If customer exchange is for export
      * Update Saved CUSEXCE details
 
     C     Exp_BRCA      IFEQ      'Y'
     C                   EXSR      UPD_CE
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
      * If a teller transaction detail record
 
     C     *in02         IFEQ      '1'
     C     TR_RECI       IFEQ      'D'
     C                   MOVEL     TR_ITLB       I#BRCA
     C                   EXSR      FILTER
 
      * If teller transaction detail is for export
      * Update Saved TTRANPD details
 
     C     Exp_BRCA      IFEQ      'Y'
     C                   EXSR      UPD_TR
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
      * If a teller transaction charge record
 
     C     *in03         IFEQ      '1'
     C     TC_RECI       IFEQ      'D'
 
      * Update Saved TTCHGPD details
 
     C                   EXSR      UPD_TC
     C                   ENDIF
     C                   ENDIF
 
      *
      /SPACE 5
      ********************************************************************
      * Filter
      ********************************************************************
     C     FILTER        BEGSR
 
      * On change of branch
      * Determine if branch is to be included in the export
 
     C     I#BRCA        IFNE      Prev_BRCA
     C                   MOVE      'D'           I#LD
     C                   EXSR      BRCA_FLT
     C                   MOVEL     I#BRCA        Prev_BRCA         3
     C                   ENDIF
 
     C                   ENDSR
     C********************************************************************
      /SPACE 5
      ********************************************************************
      * Update Saved CUSEXCE details
      ********************************************************************
     C     UPD_CE        BEGSR
 
     C     C_IPDN        CHAIN     MXSRECEP0                          99        *
     C                   EVAL      P_RECE = RECE
     C                   EVAL      PC_LCD = CURSOM
     C     *IN99         IFEQ      '1'
     C                   WRITE     MXSRECEP0
     C                   ELSE
     C                   UPDATE    MXSRECEP0
     C                   ENDIF
 
     C                   ENDSR
     C********************************************************************
      /SPACE 5
      ********************************************************************
      * Update Saved TTRANPD details
      ********************************************************************
     C     UPD_TR        BEGSR
 
     C     TRETRK        KLIST
     C                   KFLD                    BJRDNB
     C                   KFLD                    TR_TBRI
     C                   KFLD                    TR_ITLB
     C                   KFLD                    TR_TBID
     C                   KFLD                    TR_TBTN
 
     C     TRETRK        CHAIN     MXSRETRP0                          99        *
     C                   EVAL      P_RETR = RETR
     C                   EVAL      PTR_TTGEND = BJRDNB
     C                   EVAL      PTR_TTCSOM = CURSOM
     C     *IN99         IFEQ      '1'
     C                   WRITE     MXSRETRP0
     C                   ELSE
     C                   UPDATE    MXSRETRP0
     C                   ENDIF
 
     C                   ENDSR
     C********************************************************************
      /SPACE 5
      ********************************************************************
      * Update Saved TTCHGPD details
      ********************************************************************
     C     UPD_TC        BEGSR
 
     C     TRETCK        KLIST
     C                   KFLD                    BJRDNB
     C                   KFLD                    TC_TBID
     C                   KFLD                    TC_TBTN
 
     C     TRETCK        CHAIN     MXSRETCP0                          99        *
     C                   EVAL      P_RETC = RETC
     C                   EVAL      PTC_TTGEND = BJRDNB
     C                   EVAL      PTC_TTCSOM = CURSOM
     C     *IN99         IFEQ      '1'
     C                   WRITE     MXSRETCP0
     C                   ELSE
     C                   UPDATE    MXSRETCP0
     C                   ENDIF
 
     C                   ENDSR
     C********************************************************************
      /SPACE 5
      *********************************************************************
      * *INZSR - Initial subroutine called automatically at program start
      ********************************************************************
     C     *INZSR        BEGSR
 
      * Set up constants
 
     C                   MOVEL     'A'           I#EXTT            1
 
 
      **  Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
 
      * Get extract control data
 
     C     *DTAARA       DEFINE                  MXEXPCTL
     C     *LOCK         IN        MXEXPCTL
     C                   OUT       MXEXPCTL
 
 
      * If no save data is required then end
      * (If frequency is 'NEVER'  or
      *  if frequency is 'MONTHLY' but it is not the start of the month)
 
     C     SDFQRE        IFEQ      'N'
     C     SDFQRE        OREQ      'M'
     C     S_O_Month     ANDNE     'Y'
     C                   SETON                                        LR
     C                   RETURN
     C                   ENDIF
 
 
      * Load branches for export
 
     C                   MOVE      'L'           I#LD
     C                   EXSR      BRCA_FLT
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *********************************************************************
      * B R A N C H   F I L T E R
      /COPY MXCPYSRC,MXFLTBRCA
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY MXCPYSRC,MXPSSR
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
