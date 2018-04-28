     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MX Events Activity Ext. - SECURITIES trades')
      *****************************************************************
      *                                                               *
      *  Midas - Meridian Export Module                               *
      *                                                               *
      *  MXEVAXSET - Events Activity Extract - SECURITIES trades      *
      *                                                               *
      *  Function:  This module identifies those trades that have had *
      *             events activity. Details of those trades are      *
      *             then extracted for ultimate export to Meridian.   *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Last Amend No. 256564             Date 17Sep08               *
      *  Prev Amend No. BUG17937           Date 24Apr08               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CMX001  *CREATE    Data 01Jan00               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  BUG17937 - SEC3300 is Failing with an error.  Applied fix    *
      *             245268 (Recompile)                                *
      *  CMX001 - Meridian Export                                     *
      *                                                               *
      *****************************************************************
 
     FMXCOMDPD  UF   E           K DISK    INFSR(*PSSR)
      * Composite Message Details
 
     FMXDESETL1 IF   E           K DISK    INFSR(*PSSR)  USROPN
     F                                     PREFIX(E_)
      * Daily Events - Securities trades
 
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
 
      * Daily Events - Securities trades
     D MXDESET       E DS                  EXTNAME(MXDESETPD)
     D                                     PREFIX(E_)
 
     D MXEXPCTL      E DS                  EXTNAME(MXEXPCTL)
      ** Export Control Data
 
 
      ** External DS for BANK details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
 
 
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
 
      * Initialize previous trade reference
 
     C                   Z-ADD     *ZERO         Prev_TRFR         6 0
 
      * Read each trade found on the securities trade daily events file
 
     C                   OPEN      MXDESETL1
     C                   READ      MXDESETP0                              99    *
 
      * Whilst trades can be found
 
     C     *IN99         DOWEQ     '0'
 
      * On change of trade reference
 
     C     E_TRFR        IFNE      Prev_TRFR
 
      * Process a composite
 
     C                   MOVE      E_TRFR        Record            7
     C                   EXSR      PROC_COM
 
      * Update the previous trade reference
 
     C                   Z-ADD     E_TRFR        Prev_TRFR
 
     C                   ENDIF
 
      * Read the next trade
 
     C                   READ      MXDESETP0                              99    *
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
