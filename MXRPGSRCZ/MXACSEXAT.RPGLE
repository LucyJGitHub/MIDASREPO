     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MX Access Export Attributes')
      *****************************************************************
      *                                                               *
      *  Midas - Meridian Export Module                               *
      *                                                               *
      *  MXACSEXAT - Access Export Attributes                         *
      *                                                               *
      *  Function:  This module determines export attributes          *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD031             Date 10Apr06               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *  Prev Amend No. 189210             Data 25Jan01               *
      *                 CMX001  *CREATE    Data 01Jan00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  189210 - Add additional dates to Export Attributes format    *
      *  CMX001 - Meridian Export                                     *
      *                                                               *
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
 
 
      * Meridian Export Attributes
     D EXAT          E DS                  EXTNAME(MXEXATPD)
                                                                                189210
                                                                                189210
     D MXEXPCTL      E DS                  EXTNAME(MXEXPCTL)                    189210
 
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for BANK details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** External DS for CURRENCY details
     D DSFDY         E DS                  EXTNAME(DSFDY)
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
 
     C     *ENTRY        PLIST
     C/COPY MXCPYSRC,MXACSPRMI
 
 
 
      * Extract Type
     C                   MOVEL     I#EXTT        EAEXTT
 
      * Mode
     C                   MOVEL     I#MODE        EAMODE
 
      * Dates
     C                   MOVEL     BJMRDT        EAMRDT
     C                   Z-ADD     BJRDNB        EARDNB
     C                   Z-ADD     BJDNWD        EADNWD
 
      * Branch Analysis codes
     C                   MOVEL     Brn_ANC1      EABANC1
     C                   MOVEL     Brn_ANC2      EABANC2
 
      * Composite Analysis codes
     C                   MOVEL     COM_ANC1      EACANC1
     C                   MOVEL     COM_ANC2      EACANC2
 
      * Base Currency and Base Currency Decimal Places
     C                   MOVEL     BJCYCD        EABCCY
     C                   Z-ADD     BasCcyDec     EABCDP
                                                                                189210
      * Current EOM, Current SOM, Previous SOM                                  189210
     C                   Z-ADD     CUREOM        EACEOM                         189210
     C                   Z-ADD     CURSOM        EACSOM                         189210
     C                   Z-ADD     PRVSOM        EAPSOM                         189210
 
      * Set up output data
 
     C                   EVAL      InData = EXAT
 
 
      * Return
 
     C                   RETURN
      *
     C/SPACE 5
      ********************************************************************
      * *INZSR --- INITIAL PROCESSING
      ********************************************************************
     C     *INZSR        BEGSR
                                                                                189210
      * Get extract control data                                                189210
                                                                                189210
     C     *DTAARA       DEFINE                  MXEXPCTL                       189210
     C     *LOCK         IN        MXEXPCTL                                     189210
     C                   OUT       MXEXPCTL                                     189210
 
      *  Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
      *  Access Base Currency Decimal Places
 
     C                   CALL      'AOCURRR0'
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      BJCYCD        @AJCD             3
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C                   Z-ADD     A6NBDP        BasCcyDec         1 0
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY MXCPYSRC,MXPSSR
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
