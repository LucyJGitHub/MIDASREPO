     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MX Access retail teller transaction details')
      *****************************************************************
      *                                                               *
      *  Midas - Meridian Export Module                               *
      *                                                               *
      *  MXACSRETR - Access Saved Retail Transaction Teller Details   *
      *                                                               *
      *  Function:  This module filters records                       *
      *             from MXSRETRPD.                                   *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *  Last Amend No. CMX003  *CREATE    Date 22Dec00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CMX003 - Meridian Export Enhancements - Phase 2              *
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
 
 
      * Saved Retail Teller Transaction Details
     D SRETR         E DS                  EXTNAME(MXSRETRPD)
 
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for BANK details
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
 
     C     *ENTRY        PLIST
     C/COPY MXCPYSRC,MXACSPRMI
 
      * If this is a driver format
 
     C     CFLFMT        IFEQ      '*DRIVER   '
 
      * Set up input data
 
     C                   EVAL      SRETR = InData
 
      * Determine if transaction types are to be included in the export
 
     C                   MOVEL     'N'           Exp_RTTY1         1
     C                   MOVEL     'N'           Exp_RTTY2         1
     C     TTP1          IFNE      *ZERO
     C                   MOVE      'D'           I#LD
     C                   MOVEL     TTP1          I#RTTY
     C                   EXSR      RETT_FLT
     C                   MOVEL     Exp_RTTY      Exp_RTTY1
     C                   ENDIF
     C     TTP2          IFNE      *ZERO
     C                   MOVE      'D'           I#LD
     C                   MOVEL     TTP2          I#RTTY
     C                   EXSR      RETT_FLT
     C                   MOVEL     Exp_RTTY      Exp_RTTY2
     C                   ENDIF
 
      * If the transaction types are NOT for export
      *  Indicate that record is not to be extracted
 
     C     Exp_RTTY1     IFNE      'Y'
     C     Exp_RTTY2     ANDNE     'Y'
     C                   MOVEL     '*NOEXT '     I#RTCD
     C                   ENDIF
 
     C                   ELSE
     C                   EVAL      I#ERMS = 'MXSRETRPD FILE +
     C                             MUST BE THE DRIVER'
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * Set up output data
 
     C                   EVAL      InData = SRETR
 
 
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
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY MXCPYSRC,MXPSSR
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
