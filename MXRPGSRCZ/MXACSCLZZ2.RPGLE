     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MX Access customer lending loans & parts')       *
      *****************************************************************
      *                                                               *
      *  Midas - Meridian Export Module                               *
      *                                                               *
      *  MXACSCLZZ2 - Access customer lending loans and participations*
      *                                                               *
      *  Function:  This module accesses loans & parts from CLOANCK.  *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 CAP074             Date 08Aug02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAS001             Date 23Nov01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 189208  *CREATE    Data 25Jan01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference                                *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CAP074 - Lending API enhancements - Loans input.             *
      *           (Recompile)                                         *
      *  CAS001 - Net Present Value (NPV) Accounting                  *
      *           (Recompile)                                         *
      *  189208 - Consolidation of Loans & participations into 1 fmt  *
      *                                                               *
      *****************************************************************
 
     FCLOAN     IF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(CLOANHHF : CLOANZ1F)
      * All Loans
 
     FMXSLECKPD IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(CLOANCKF: MXSLECKP0)
      * Saved Loans
 
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
 
 
      * Loans and Participations
     D CLZZ2         E DS                  EXTNAME(CLOANCK)
 
 
      ** External DS for BANK details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
 
     C     *ENTRY        PLIST
     C/COPY MXCPYSRC,MXACSPRMI
 
 
      * Use input link-to field
 
     C                   MOVEL     I#LFD1        A_LNRF            6
 
      * Error if no loan number is supplied
 
     C     A_LNRF        IFEQ      *BLANK
     C*****A_LNRF        OREQ      '000000'                                                   CLE148
     C                   EVAL      I#ERMS = 'INVALID LOAN NUMBER: '
     C                             + A_LNRF
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * Get the loan from CLOANCK
 
     C                   MOVEL     A_LNRF        LNRF
     C     LNRF          CHAIN     CLOANCKF                           99        *
 
      * If the loan isn't found
      * and this is a current extract
      * it is an error
 
     C     *IN99         IFEQ      '1'
     C     I#EXTT        ANDEQ     'C'
     C                   EVAL      I#ERMS = 'LOAN NOT ON CLOANCK:'
     C                             + A_LNRF
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * If the loan isn't on CLOANCK
      * Get the loan from MXSLECKPD
 
     C     *IN99         IFEQ      '1'
     C                   CLEAR                   CLZZ2
     C                   MOVEL     A_LNRF        LNRF
     C     LNRF          CHAIN     MXSLECKP0                          99        *
     C                   ENDIF
 
      * If the loan isn't available
      * and this is a driver format
      *  Indicate that loan is not to be extracted
 
     C     *IN99         IFEQ      '1'
     C     CFLFMT        ANDEQ     '*DRIVER   '
     C                   MOVEL     '*NOEXT '     I#RTCD
     C                   ENDIF
 
      * Set up output data
 
     C                   EVAL      InData = CLZZ2
 
 
      * Return
     C                   RETURN
 
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
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY MXCPYSRC,MXPSSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2001
