     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MX Access Securities Trades Extention 2')        *
      *****************************************************************
      *                                                               *
      *  Midas - Meridian Export Module                               *
      *                                                               *
      *  MXACSSTR2 - Access Securities Trades Extended Settlements    *
      *                                                               *
      *  Function:  This module accesses securities trades            *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CSW210             Date 04May10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4.01 -------------------------------------------*
      *                                    Date                       *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CSE029  *CREATE    Data 17Jul01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSW210 - SWIFT 2010 Changes (Recompile)                      *
      *  200292 - Should only pick up 'A' records                     *
      *  CSE029 - ISO15022 Message Generation                         *
      *                                                               *
      *****************************************************************
 
     FTRADSDY2  IF   E           K DISK    INFSR(*PSSR)
 
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
 
 
      * Securities Trades Extention 1
     D TRX2          E DS                  EXTNAME(TRADSDY2)
 
 
     C     *ENTRY        PLIST
     C/COPY MXCPYSRC,MXACSPRMI
 
      * Key fields for the CHAIN                                                              200292
                                                                                              200292
     C     T2KEY         KLIST                                                                200292
     C                   KFLD                    A_TDRF            6                          200292
     C                   KFLD                    #WHEN             1                          200292
 
      * Use input link-to field
 
     C                   MOVEL     I#LFD1        A_TDRF            6
     C                   MOVEL     I#LFD2        #WHEN                                        200292
 
      * Error if no trade reference is supplied
 
     C     A_TDRF        IFEQ      *BLANK
     C     A_TDRF        OREQ      '000000'
     C                   EVAL      I#ERMS = 'INVALID TRADE REFERENCE: '
     C                             + A_TDRF
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * Get the record from TRADSDX1
 
     C                   MOVEL     A_TDRF        T2TDRF
     C*****T2TDRF********CHAIN     TRADSDY2                           99        *             200292
     C     T2KEY         CHAIN     TRADSDY2                           99        *             200292
 
      * If the trade isn't found
      * and this is a current extract
      * it is an error
 
     C     *IN99         IFEQ      '1'
     C     I#EXTT        ANDEQ     'C'
     C****************** EVAL      I#ERMS = 'TRADE NOT ON TRADSDX1:'                          200292
     C******************           + A_TDRF                                                   200292
     C                   EVAL      I#ERMS = 'TRADE NOT ON TRADSDX2:'                          200292
     C                             + A_TDRF                                                   200292
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * If the trade isn't available
      * and this is a driver format
      *  Indicate that the trade is not to be extracted
 
     C     *IN99         IFEQ      '1'
     C     CFLFMT        ANDEQ     '*DRIVER   '
     C                   MOVEL     '*NOEXT '     I#RTCD
     C                   ENDIF
 
 
      * Set up output data
 
     C                   EVAL      InData = TRX2
 
 
      * Return
 
     C                   RETURN
      *
      /SPACE 5
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * *INZSR --- INITIAL PROCESSING
      ********************************************************************
     C     *INZSR        BEGSR
      *
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY MXCPYSRC,MXPSSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2001
