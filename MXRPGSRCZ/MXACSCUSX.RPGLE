     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MX Access customer exchanges')                   *
      *****************************************************************
      *                                                               *
      *  Midas - Meridian Export Module                               *
      *                                                               *
      *  MXACSCUSX - Access customer exchanges                        *
      *                                                               *
      *  Function:  This module accesses customer exchanges from      *
      *             CUSEXCE.                                          *
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
      *  CMX001 - Meridian Export                                     *
      *                                                               *
      *****************************************************************
 
     FCUSEX     IF   E           K DISK    INFSR(*PSSR)
      * All Customer Exchanges
 
     FMXSRECEPD IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(CUSEXCEF: MXSRECEP0)
      * Saved Customer Exchanges
 
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** Standard D-specs
      ** ===============
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
 
 
      * Customer Exchange
     D CUSX          E DS                  EXTNAME(CUSEXCE)
 
 
      ** External DS for BANK details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
 
     C     *ENTRY        PLIST
     C/COPY MXCPYSRC,MXACSPRMI
 
 
      * Use input link-to field
 
     C                   MOVEL     I#LFD1        A_IPDN            6
 
      * Error if no input document number is supplied
 
     C     A_IPDN        IFEQ      *BLANK
     C                   EVAL      I#ERMS = 'INVALID DOCUMENT NUMBER:'
     C                             + A_IPDN
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * Get the customer exchange from CUSEXCE
 
     C                   MOVEL     A_IPDN        IPDN
     C     IPDN          CHAIN     CUSEXCEF                           99        *
 
      * If the exchange isn't on CUSEXCE
      * Get the exchange from MXSRECEPD
 
     C     *IN99         IFEQ      '1'
     C                   CLEAR                   CUSX
     C                   MOVEL     A_IPDN        IPDN
     C     IPDN          CHAIN     MXSRECEP0                          99        *
     C                   ENDIF
 
      * If the exchange isn't available
      * and this is a driver format
      *  Indicate that the exchange is not to be extracted
 
     C     *IN99         IFEQ      '1'
     C     CFLFMT        ANDEQ     '*DRIVER   '
     C                   MOVEL     '*NOEXT '     I#RTCD
     C                   ELSE
 
      * If this is a driver format
 
     C     CFLFMT        IFEQ      '*DRIVER   '
 
      * Determine if branch is to be included in the export
 
     C                   MOVE      'D'           I#LD
     C                   MOVEL     BRCA          I#BRCA
     C                   EXSR      BRCA_FLT
 
      * If the branch is NOT for export
      *  Indicate that the exchange is not to be extracted
 
     C     Exp_BRCA      IFNE      'Y'
     C                   MOVEL     '*NOEXT '     I#RTCD
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
      * Set up output data
 
     C                   EVAL      InData = CUSX
 
 
      * Return
 
     C                   RETURN
      *
      /SPACE 5
      *********************************************************************
      * B R A N C H   F I L T E R
      /COPY MXCPYSRC,MXFLTBRCA
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * *INZSR --- INITIAL PROCESSING
      ********************************************************************
     C     *INZSR        BEGSR
      *
      **  Access Bank Details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
      * Load branches for export
 
     C                   MOVE      'L'           I#LD
     C                   EXSR      BRCA_FLT
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY MXCPYSRC,MXPSSR
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
