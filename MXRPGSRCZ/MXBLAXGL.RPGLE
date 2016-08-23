     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MX Balance Activity Ext. - GEN.LED. module')
      *****************************************************************
      *                                                               *
      *  Midas - Meridian Export Module                               *
      *                                                               *
      *  MXBLAXGL - Balance Activity Extract - GENERAL LEDGER module  *
      *                                                               *
      *  Function:  This module identifies those accounts that have   *
      *             had balance activity. Details of those accounts   *
      *             are then extracted for ultimate export to Meridian*
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Last Amend No. 256564             Date 17Sep08               *
      *  Prev Amend No. BUG17937           Date 24Apr08               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CMX001  *CREATE    Data 01Jan00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  BUG17937 - SEC3300 is Failing with an error.  Applied fix    *
      *             245268 (Recompile)                                *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CMX001 - Meridian Export                                     *
      *                                                               *
      *****************************************************************
 
     FMXCOMDPD  UF   E           K DISK    INFSR(*PSSR)
      * Composite Message Details
 
     FMXBLGLPD  IF   E           K DISK    INFSR(*PSSR)  USROPN
     F                                     PREFIX(B_)
      * Balances - General Ledger module
 
     FMXBULKXAU O    E             PRINTER INFSR(*PSSR)  USROPN
      * Bulk Extract Audit Report
 
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
 
 
      * Composite Message Details
     D MXCOMD        E DS                  EXTNAME(MXCOMDPD)
 
      * Balances - General Ledger module
     D MXBLGL        E DS                  EXTNAME(MXBLGLPD)
     D                                     PREFIX(B_)
 
     D MXEXPCTL      E DS                  EXTNAME(MXEXPCTL)
      ** Export Control Data
 
 
     D                 DS
     D***Record*                1     25                                                      CGL029
     D  Record                 1     31                                                       CGL029
     D  R_CNUM                 2      7
     D  R_CCY                  8     10
     D***R_ACOD*               11     14                                                      CGL029
     D***R_ACSQ*               15     16                                                      CGL029
     D***R_BRCA*               23     25                                                      CGL029
     D  R_ACOD                11     20                                                       CGL029
     D  R_ACSQ                21     22                                                       CGL029
     D  R_BRCA                29     31                                                       CGL029
 
 
      ** External DS for BANK details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
     D Prev_ACOD       S             10S 0                                                    CGL029
 
 
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           30
      * INPUTS
      * Mode
      * Composite ID
      * Extract Type
     C                   PARM                    I#MODE            1
     C                   PARM                    I#COMI            8
     C                   PARM                    I#EXTT            1
 
      * Initialize previous account ID
 
     C                   MOVEL     *BLANK        Prev_BRCA         3
     C**********         Z-ADD     *ZERO         Prev_CNUM         6 0                        CSD027
     C                   MOVE      *BLANKS       Prev_CNUM         6                          CSD027
     C                   MOVEL     *BLANK        Prev_CCY          3
     C**********         Z-ADD     *ZERO         Prev_ACOD         4 0                        CGL029
     C                   Z-ADD     *ZERO         Prev_ACOD                                    CGL029
     C                   Z-ADD     *ZERO         Prev_ACSQ         2 0
 
      * Read each account found on the general ledger balances file
 
     C                   OPEN      MXBLGLPD
     C                   READ      MXBLGLP0                               99    *
 
      * Whilst accounts can be found
 
     C     *IN99         DOWEQ     '0'
 
      * On change of account ID
 
     C     B_BRCA        IFNE      Prev_BRCA
     C     B_CNUM        ORNE      Prev_CNUM
     C     B_CCY         ORNE      Prev_CCY
     C     B_ACOD        ORNE      Prev_ACOD
     C     B_ACSQ        ORNE      Prev_ACSQ
 
      * Process a composite
 
     C                   MOVEL     B_BRCA        R_BRCA
     C                   MOVEL     B_CNUM        R_CNUM
     C                   MOVEL     B_CCY         R_CCY
     C                   MOVEL     B_ACOD        R_ACOD
     C                   MOVEL     B_ACSQ        R_ACSQ
     C                   EXSR      PROC_COM
 
      * Update the previous account ID
 
     C                   MOVEL     B_BRCA        Prev_BRCA
     C**********         Z-ADD     B_CNUM        Prev_CNUM                                    CSD027
     C                   EVAL      Prev_CNUM = B_CNUM                                         CSD027
     C                   MOVEL     B_CCY         Prev_CCY
     C                   Z-ADD     B_ACOD        Prev_ACOD
     C                   Z-ADD     B_ACSQ        Prev_ACSQ
 
     C                   ENDIF
 
      * Read the next account
 
     C                   READ      MXBLGLP0                               99    *
     C                   ENDDO
 
      * Output audit report totals
 
     C                   Z-ADD     10            CHLINE
     C                   EXSR      PAG
     C                   WRITE     TOTALSC
 
     C                   SETON                                        LR
     C                   RETURN
 
      ********************************************************************
     C/SPACE 5
      *********************************************************************
      * Process a composite
      *********************************************************************
     C     PROC_COM      BEGSR
 
     C                   ADD       1             RelRecNum        10 0
     C                   MOVEL     RelRecNum     I#REFS
 
     C                   CALL      'MXEXTCOMI'
     C                   PARM      *BLANK        W#RTCD            7
     C                   PARM      *BLANK        W#ERMS           30
      * inputs
     C                   PARM                    I#MODE            1
     C                   PARM                    I#COMI            8
     C                   PARM                    I#EXTT            1
     C                   PARM                    I#REFS           10
     C                   PARM      Record        DRV_InData     4000
      * outputs
     C                   PARM      *BLANK        ReferID          40
     C                   PARM      'N'           Select_EXP        1
 
      * Error
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO MXEXTCOMI'
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * If selected for export
 
     C     Select_EXP    IFEQ      'Y'
 
      * Add 1 to the count of COMs
 
     C                   ADD       1             COM_cnt           6 0
 
      * If Trace Bulk Extract is YES
      * Report details of the extract
 
     C     TRACBX        IFEQ      'Y'
     C                   MOVEL     ReferID       #ID
     C                   MOVEL     DRV_InData    #RECD
     C                   Z-ADD     1             CHLINE
     C                   EXSR      PAG
     C                   WRITE     EXTRACTEDC
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      ********************************************************************
      * Throw page headings (if required)
      ********************************************************************
     C     PAG           BEGSR
 
     C                   ADD       CHLINE        LINENO
     C     LINENO        IFGT      59
     C                   ADD       1             PAGNUM
     C                   WRITE     PAGEHEAD
     C     4             ADD       CHLINE        LINENO            3 0
     C                   ENDIF
 
     C                   ENDSR
     C********************************************************************
     C/SPACE 5
      ********************************************************************
      * *INZSR - Initial subroutine called automatically at program start
      ********************************************************************
     C     *INZSR        BEGSR
 
      *  Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
      * Get export control details on data-area
 
     C     *DTAARA       DEFINE                  MXEXPCTL
     C                   IN        MXEXPCTL
     C     TRACBX        COMP      'Y'                                    60    *
 
 
      * Get Composite Message Details
 
     C     MXCOMDK       CHAIN     MXCOMDP0                           99        *
     C     *in99         IFEQ      '1'
     C                   EVAL      I#ERMS = 'MISSING COMPOSITE:'
     C                             + I#COMI + I#EXTT
     C                   EXSR      *PSSR
     C                   ENDIF
 
 
      * If the message is not enabled, then end immediately
 
     C     CDENAB        IFNE      'Y'
     C                   SETON                                        U6LR
     C                   RETURN
     C                   ENDIF
 
      * Reset the extract control indicator to 1
 
     C                   Z-ADD     1             CDXCTL
     C                   UPDATE    MXCOMDP0
 
      * Set the report description
 
     C                   MOVEL     CDDESC        ZZDESC
 
 
      * Open the printer file
 
     C                   OPEN      MXBULKXAU
 
      * Initialize time
 
     C                   TIME                    #TIME
 
      * Output audit report page headings
 
     C     I#EXTT        COMP      'A'                                    50    *
     C                   Z-ADD     *ZERO         CHLINE            3 0
     C                   Z-ADD     99            LINENO
     C                   EXSR      PAG
 
      * If the extract is not due
      * then report that no extract took place and end
 
     C     CDEXND        IFGE      BJDNWD
     C     CDEXND        OREQ      *ZERO
 
     C                   WRITE     NOEXTRACT
     C                   SETON                                        LR
     C                   RETURN
 
     C                   ENDIF
 
      * Key lists
 
     C     MXCOMDK       KLIST
     C                   KFLD                    I#COMI
     C                   KFLD                    I#EXTT
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY MXCPYSRC,MXPSSR
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
