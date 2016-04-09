     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MX Access Securities Trades')
      *****************************************************************
      *                                                               *
      *  Midas - Meridian Export Module                               *
      *                                                               *
      *  MXACSSTRD - Access Securities Trades                         *
      *                                                               *
      *  Function:  This module accesses securities trades            *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. 234300             Date 29Sep06               *
      *  Prev Amend No. CSD027             Date 09Dec05               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CMX003             Date 05Nov00               *
      *                 CMX001  *CREATE    Data 01Jan00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  234300 - Recompiled over changed in PF/HSTTRD.               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CMX003 - Meridian Export Enhancements - Phase 2              *
      *           (RE-COMPILE OVER CHANGED /COPY)                     *
      *  CMX001 - Meridian Export                                     *
      *                                                               *
      *****************************************************************
 
     FTRADHS    IF   E           K DISK    INFSR(*PSSR)
      * All Trades
 
     FMXSSETDPD IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(TRADSDF: MXSSETDP0)
      * Saved Trades
 
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
 
 
      * Securities Trade
     D STRD          E DS                  EXTNAME(TRADSD)
 
 
      ** External DS for BANK details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
 
     C     *ENTRY        PLIST
     C/COPY MXCPYSRC,MXACSPRMI
 
 
      * Use input link-to field
 
     C                   MOVEL     I#LFD1        A_TDRF            6
 
      * Error if no trade reference is supplied
 
     C     A_TDRF        IFEQ      *BLANK
     C     A_TDRF        OREQ      '000000'
     C                   EVAL      I#ERMS = 'INVALID TRADE REFERENCE: '
     C                             + A_TDRF
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * Get the trade from TRADSD
 
     C                   MOVEL     A_TDRF        TDRF
     C     TDRF          CHAIN     TRADSDF                            99        *
 
      * If the trade isn't found
      * and this is a current extract
      * it is an error
 
     C     *IN99         IFEQ      '1'
     C     I#EXTT        ANDEQ     'C'
     C                   EVAL      I#ERMS = 'TRADE NOT ON TRADSD:'
     C                             + A_TDRF
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * If the trade isn't on TRADSD
      * Get the trade from HSTTRD
 
     C     *IN99         IFEQ      '1'
     C                   CLEAR                   STRD
     C                   MOVEL     A_TDRF        TDRF
     C     TDRF          CHAIN     HSTTRDF                            99        *
     C                   ENDIF
 
      * If the trade isn't on HSTTRD
      * Get the trade from MXSSETDPD
 
     C     *IN99         IFEQ      '1'
     C                   CLEAR                   STRD
     C                   MOVEL     A_TDRF        TDRF
     C     TDRF          CHAIN     MXSSETDP0                          99        *
     C                   ENDIF
 
      * If the trade isn't available
      * and this is a driver format
      *  Indicate that the trade is not to be extracted
 
     C     *IN99         IFEQ      '1'
     C     CFLFMT        ANDEQ     '*DRIVER   '
     C                   MOVEL     '*NOEXT '     I#RTCD
     C                   ELSE
 
      * If this is a driver format
 
     C     CFLFMT        IFEQ      '*DRIVER   '
 
      * Determine if branch is to be included in the export
 
     C                   MOVE      'D'           I#LD
     C                   MOVEL     TDBA          I#BRCA
     C                   EXSR      BRCA_FLT
 
      * If the branch is NOT for export
      *  Indicate that the trade is not to be extracted
 
     C     Exp_BRCA      IFNE      'Y'
     C                   MOVEL     '*NOEXT '     I#RTCD
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
      * Set up output data
 
     C                   EVAL      InData = STRD
 
 
      * Return
 
     C                   RETURN
      *
      /SPACE 5
      *********************************************************************
      * B R A N C H   F I L T E R
      /COPY MXCPYSRC,MXFLTBRCA
      ********************************************************************
     C/SPACE 5
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
