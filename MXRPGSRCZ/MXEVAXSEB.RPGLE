     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MX Events Activity Ext. - SECURITIES Bk Pos')
      *****************************************************************
      *                                                               *
      *  Midas - Meridian Export Module                               *
      *                                                               *
      *  MXEVAXSEB - Events Activity Extract - SECURITIES Book Positions
      *                                                               *
      *  Function:  This module identifies those book positions that  *
      *             have had events activity. Details of those positions
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
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CMX003  *CREATE    Date 05Nov00               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  BUG17937 - SEC3300 is Failing with an error.  Applied fix    *
      *             245268 (Recompile)                                *
      *  CMX003 - Meridian Export Enhancements - Phase 2              *
      *                                                               *
      *****************************************************************
 
     FMXCOMDPD  UF   E           K DISK    INFSR(*PSSR)
      * Composite Message Details
 
     FMXDESEBL1 IF   E           K DISK    INFSR(*PSSR)  USROPN
     F                                     PREFIX(E_)
      * Daily Events - Securities Book Positions
 
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
 
      * Daily Events - Securities Book Positions
     D MXDESEB       E DS                  EXTNAME(MXDESEBPD)
     D                                     PREFIX(E_)
 
     D MXEXPCTL      E DS                  EXTNAME(MXEXPCTL)
      ** Export Control Data
 
 
     D                 DS
     D  Record                 1     18
     D  R_BHSC                 2     11
     D  R_BHBA                12     14
     D  R_BHBK                15     16
     D  R_BHMK                17     17
     D  R_BHTV                18     18
 
 
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
 
      * Initialize previous position key
 
     C                   MOVEL     *BLANK        Prev_BHBA         3
     C                   MOVEL     *BLANK        Prev_BHBK         2
     C                   MOVEL     *BLANK        Prev_BHSC        10
     C                   MOVEL     *BLANK        Prev_BHMK         1
     C                   MOVEL     *BLANK        Prev_BHTV         1
 
      * Read each book position found on
      * the securities book positions daily events file
 
     C                   OPEN      MXDESEBL1
     C                   READ      MXDESEBP0                              99    *
 
      * Whilst book positions can be found
 
     C     *IN99         DOWEQ     '0'
 
      * On change of book position key
 
     C     E_BHBA        IFNE      Prev_BHBA
     C     E_BHBK        ORNE      Prev_BHBK
     C     E_BHSC        ORNE      Prev_BHSC
     C     E_BHMK        ORNE      Prev_BHMK
     C     E_BHTV        ORNE      Prev_BHTV
 
      * Process a composite
 
     C                   MOVEL     E_BHBA        R_BHBA
     C                   MOVEL     E_BHBK        R_BHBK
     C                   MOVEL     E_BHSC        R_BHSC
     C                   MOVEL     E_BHMK        R_BHMK
     C                   MOVEL     E_BHTV        R_BHTV
     C                   EXSR      PROC_COM
 
      * Update the previous book position key
 
     C                   MOVEL     E_BHBA        Prev_BHBA
     C                   MOVEL     E_BHBK        Prev_BHBK
     C                   MOVEL     E_BHSC        Prev_BHSC
     C                   MOVEL     E_BHMK        Prev_BHMK
     C                   MOVEL     E_BHTV        Prev_BHTV
 
     C                   ENDIF
 
      * Read the next book position
 
     C                   READ      MXDESEBP0                              99    *
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
