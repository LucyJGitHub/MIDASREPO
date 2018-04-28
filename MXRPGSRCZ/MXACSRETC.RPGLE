     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MX Access retail teller transaction charges')
      *****************************************************************
      *                                                               *
      *  Midas - Meridian Export Module                               *
      *                                                               *
      *  MXACSRETC - Access retail teller transaction charges.        *
      *                                                               *
      *  Function:  This module accesses teller transaction charges   *
      *             from the saved data file MXSRETCPD.               *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *  Last Amend No. CMX002  *CREATE    Data 26Sep00               *
      *  Prev Amend No.                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CMX002 - Meridian Export Enhancements - Phase 1              *
      *                                                               *
      *****************************************************************
 
     FMXSRETCPD IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(TTCHGPDF: MXSRETCP0)
      * Saved Teller Transaction Charges
 
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
 
 
      * Saved Teller Transaction Charges
     D RETC          E DS                  EXTNAME(MXSRETCPD)
 
 
     D                 DS
     D A_TBTN5A                1      5A
     D                 DS
     D A_TBTN3A                1      3A
     D A_TBTN5P                1     03P 0
 
 
      ** External DS for BANK details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
 
     C     *ENTRY        PLIST
     C/COPY MXCPYSRC,MXACSPRMI
 
 
      * Use input link-to field
 
     C                   MOVEL     I#LFD1        A_TTGEND          5
     C                   MOVEL     I#LFD2        A_TBID            3
     C                   MOVEL     I#LFD3        A_TBTN5A          5
     C                   MOVEL     I#LFD3        A_TBTN3A          3
 
      * Error if no generation date is supplied
 
     C     A_TTGEND      IFEQ      *BLANK
     C     A_TTGEND      OREQ      '00000'
     C                   EVAL      I#ERMS = 'INVALID GENERATION DATE:'
     C                             + A_TTGEND
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * Error if no teller ID/batch number is supplied
 
     C     A_TBID        IFEQ      *BLANK
     C                   EVAL      I#ERMS = 'INVALID TELLER ID:'
     C                             + A_TBID
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * Error if no teller/batch transaction number is supplied
 
     C     A_TBTN5A      IFEQ      *BLANK
     C                   EVAL      I#ERMS = 'INVALID TRANS NUMBER:'
     C                             + A_TBTN5A
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * Get the transaction charge from MXSRETCPD
 
     C                   CLEAR                   RETC
     C                   MOVEL     BJCYCD        CCY3
     C                   MOVEL     A_TTGEND      TTGEND
     C                   MOVEL     A_TBID        TBID
     C                   TESTN                   A_TBTN5A             9898
     C     *IN98         IFEQ      '1'
     C                   MOVEL     A_TBTN5A      TBTN
     C                   ELSE
     C                   Z-ADD     A_TBTN5P      TBTN
     C                   ENDIF
     C     TRETCK        CHAIN     MXSRETCP0                          99        *
 
      * Set up output data
 
     C                   EVAL      InData = RETC
 
 
      * Return
 
     C                   RETURN
      *
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
 
      * Key list
 
     C     TRETCK        KLIST
     C                   KFLD                    TTGEND
     C                   KFLD                    TBID
     C                   KFLD                    TBTN
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY MXCPYSRC,MXPSSR
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
