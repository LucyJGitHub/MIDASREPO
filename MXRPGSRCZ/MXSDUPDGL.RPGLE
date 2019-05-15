     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MX Saved Data Update - GEN.LED module')          *
      *****************************************************************
      *                                                               *
      *  Midas - Meridian Export Module                               *
      *                                                               *
      *  MXSDUPDGL - Saved Data Update - GENERAL LEDGER Module        *
      *                                                               *
      *  Function:  This module updates the general ledger saved data *
      *             files.                                            *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CRE073             Date 06Dec10               *
      *                 CRE075             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER047             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 242925             Date 10Oct06               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CMX003             Date 05Nov00               *
      *                 CMX001  *CREATE    Data 01Jan00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER047 - German Features LF037-00 Reporting §24c KWG         *
      *           (Recompile)                                         *
      *  242925 - Increase Account Code to 10 digits Signed (not P)   *
      *           Amend hook MXCPYSRC/MXFLTACOD and recompiled        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CMX003 - Meridian Export Enhancements - Phase 2              *
      *           (RE-COMPILE OVER CHANGED /COPY)                     *
      *  CMX001 - Meridian Export                                     *
      *                                                               *
      *****************************************************************
 
     FAUACNTV1  IP   E             DISK    INFSR(*PSSR) PREFIX(A_)
     FMXSGLACPD UF A E           K DISK    RENAME(ACCNTABF:MXSGLACP0)
     F                                     INFSR(*PSSR) PREFIX(PA_)
     FMXBLGLPD  O    E             DISK    INFSR(*PSSR)
 
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
 
 
      * ACCNTAB
     D ACCNT         E DS                  EXTNAME(ACCNTAB)
     D                                     PREFIX(A_)
     D P_ACCNT       E DS                  EXTNAME(MXSGLACPD)
     D                                     PREFIX(PA_)
 
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for BANK details
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
 
     D MXEXPCTL      E DS                  EXTNAME(MXEXPCTL)
 
     D Prev_ACOD       S             10S 0                                                    CGL029
 
     D I#ACOD          S             10S 0                                                    242925
                                                                                              242925
     IACCNTABF      01
 
 
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           30
      * INPUT
      * Start of Month (Y/N)
     C                   PARM                    S_O_Month         1
 
      * If a live account
 
     C     *in01         IFEQ      '1'
     C     A_RECI        ANDEQ     'D'
     C                   MOVEL     A_BRCA        I#BRCA
     C                   Z-ADD     A_ACOD        I#ACOD
     C                   EXSR      FILTER
 
      * If account is for export
      * and account type is NOT retail
      *  Update Saved ACCNTAB details
      *  Write Start of Month Balance for ACCNTAB
 
     C     Exp_BRCA      IFEQ      'Y'
     C     Exp_ACOD      ANDEQ     'Y'
     C     Acc_Type      ANDNE     'R'
     C                   EXSR      UPD_AC
     C     S_O_Month     IFEQ      'Y'
     C                   EXSR      WRTSOM_AC
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
      *
      /SPACE 5
      ********************************************************************
      * Filter Accounts
      ********************************************************************
     C     FILTER        BEGSR
 
      * On change of branch
      * Determine if branch is to be included in the export
 
     C     I#BRCA        IFNE      Prev_BRCA
     C                   MOVE      'D'           I#LD
     C                   EXSR      BRCA_FLT
     C                   MOVEL     I#BRCA        Prev_BRCA         3
     C                   ENDIF
 
      * On change of account code
      * Determine if account code is to be included in the export
 
     C     I#ACOD        IFNE      Prev_ACOD
     C                   MOVE      'D'           I#LD
     C                   EXSR      ACOD_FLT
     C**********         MOVEL     I#ACOD        Prev_ACOD         4 0                        CGL029
     C                   MOVEL     I#ACOD        Prev_ACOD                                    CGL029
     C                   ENDIF
 
     C                   ENDSR
     C********************************************************************
      /SPACE 5
      ********************************************************************
      * Update Saved ACCNTAB details
      ********************************************************************
     C     UPD_AC        BEGSR
 
     C     ACIDKY        CHAIN     MXSGLACP0                          99        *
     C                   EVAL      P_ACCNT = ACCNT
     C                   EVAL      PA_LCD  = CURSOM
     C                   EVAL      PA_ENOC = 0
     C                   EVAL      PA_EPNO = 0
     C                   EVAL      PA_ECFB = 0
     C                   EVAL      PA_LTAC = 0
     C                   EVAL      PA_LTAS = 0
     C                   EVAL      PA_HCFB = 0
     C     *IN99         IFEQ      '1'
     C                   WRITE     MXSGLACP0
     C                   ELSE
     C                   UPDATE    MXSGLACP0
     C                   ENDIF
 
     C                   ENDSR
     C********************************************************************
      /SPACE 5
      ********************************************************************
      * Write Start of Month Balance for ACCNTAB
      ********************************************************************
     C     WRTSOM_AC     BEGSR
 
     C     A_DACO        IFLT      CURSOM
 
     C                   MOVEL     A_BRCA        BRCA
     C**********         Z-ADD     A_CNUM        CNUM                                         CSD027
     C                   EVAL      CNUM = A_CNUM                                              CSD027
     C                   MOVEL     A_CCY         CCY
     C                   Z-ADD     A_ACOD        ACOD
     C                   Z-ADD     A_ACSQ        ACSQ
     C                   Z-ADD     CURSOM        DATE
     C                   Z-ADD     A_LDBL        BAL
     C                   WRITE     MXBLGLP0
 
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
 
     C     SDFQGL        IFEQ      'N'
     C     SDFQGL        OREQ      'M'
     C     S_O_Month     ANDNE     'Y'
     C                   SETON                                        LR
     C                   RETURN
     C                   ENDIF
 
 
      * Load branches for export
 
     C                   MOVE      'L'           I#LD
     C                   EXSR      BRCA_FLT
 
      * Load account codes for export
 
     C                   MOVE      'L'           I#LD
     C                   Z-ADD     *ZERO         I#ACOD
     C                   EXSR      ACOD_FLT
 
      * Key list
 
     C     ACIDKY        KLIST
     C                   KFLD                    A_BRCA
     C                   KFLD                    A_CNUM
     C                   KFLD                    A_CCY
     C                   KFLD                    A_ACOD
     C                   KFLD                    A_ACSQ
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *********************************************************************
      * B R A N C H   F I L T E R
      /COPY MXCPYSRC,MXFLTBRCA
      ********************************************************************
      /SPACE 5
      *********************************************************************
      * A C C O U N T   C O D E   F I L T E R
      /COPY MXCPYSRC,MXFLTACOD
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY MXCPYSRC,MXPSSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2001
