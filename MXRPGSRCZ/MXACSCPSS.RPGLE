     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MX Access Customer Posting Summary')
      *****************************************************************
      *                                                               *
      *  Midas - Meridian Export Module                               *
      *                                                               *
      *  MXACSCPSS - Access Customer Posting Summary                  *
      *                                                               *
      *  Function:  This module accesses customer posting             *
      *             summary records from MXCPSSPD.                    *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD027             Date 09Dec05               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 187908             Date 20Dec00               *
      *                 CMX003  *CREATE    Date 05Nov00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
/*    *  187908 - Truncation on total field BCEQ in CPYFRMQRYF        *
      *           RECOMPILE                                           *
      *  CMX003 - Meridian Export Enhancements - Phase 2              *
      *                                                               *
      *****************************************************************
 
     FMXCPSSL0  IF   E           K DISK    INFSR(*PSSR)
 
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
 
 
      * Customer Posting Summary Details
     D CPSS          E DS                  EXTNAME(MXCPSSPD)
 
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for BANK details
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
 
     C     *ENTRY        PLIST
     C/COPY MXCPYSRC,MXACSPRMI
 
 
      * Use input link-to fields
 
     C                   MOVEL     I#LFD1        A_CNUM            6
     C                   MOVEL     I#LFD2        A_TRATA           5
 
      * Get the customer posting summary record from MXCPSSPD
 
     C                   MOVEL     A_CNUM        CNUM
     C                   MOVEL     A_TRATA       TRATA
     C     MXCPSSK       CHAIN     MXCPSSP0                           99        *
 
      * If the record isn't found
      * and this is a current extract
      * it is an error
 
     C     *IN99         IFEQ      '1'
     C     I#EXTT        ANDEQ     'C'
     C                   EVAL      I#ERMS = 'BAD MXCPSSPD:'
     C                             + A_CNUM + A_TRATA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * If the record isn't on MXCPSSPD
 
     C     *IN99         IFEQ      '1'
     C                   CLEAR                   CPSS
     C                   MOVEL     A_CNUM        CNUM
     C                   MOVEL     A_TRATA       TRATA
     C                   ENDIF
 
      * If this is a driver format
 
     C     CFLFMT        IFEQ      '*DRIVER   '
 
      * Determine if transaction type is to be included in the export
 
     C                   MOVE      'D'           I#LD
     C                   MOVEL     TRATA         I#RTTY
     C                   EXSR      RETT_FLT
 
      * If the transaction type is NOT for export
      *  Indicate that record is not to be extracted
 
     C     Exp_RTTY      IFNE      'Y'
     C                   MOVEL     '*NOEXT '     I#RTCD
     C                   ENDIF
     C                   ENDIF
 
      * Set up output data
 
     C                   EVAL      InData = CPSS
 
 
      * Return
 
     C                   RETURN
      *
      /SPACE 5
      *********************************************************************
      * R E T A I L  T R A N S A C T I O N   T Y P E   F I L T E R
      /COPY MXCPYSRC,MXFLTRETT
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * *INZSR --- INITIAL PROCESSING
      ********************************************************************
     C     *INZSR        BEGSR
 
      **  Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
      * Load retail transaction types for export
 
     C                   MOVE      'L'           I#LD
     C                   EXSR      RETT_FLT
 
      * Key list
 
     C     MXCPSSK       KLIST
     C                   KFLD                    CNUM
     C                   KFLD                    TRATA
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY MXCPYSRC,MXPSSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2001
