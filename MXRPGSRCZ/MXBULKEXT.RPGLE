     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MX Bulk Extract')
      *****************************************************************
      *                                                               *
      *  Midas - Data Export module                                   *
      *                                                               *
      *  MXBULKEXT - Bulk Extract                                     *
      *                                                               *
      *  Function:  This program reads a 'driver' file and calls      *
      *             the appropriate extract module.                   *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. 256564             Date 17Sep08               *
      *                 BUG17937           Date 24Apr08               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CMX001  *CREATE    Data 01Jan00               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  BUG17937 - SEC3300 is Failing with an error.  Applied fix    *
      *             245268 (Recompile)                                *
      *  CMX001 - Meridian Export                                     *
      *                                                               *
      *****************************************************************
 
     FFILE      IP   F 4000        DISK    INFSR(*PSSR)
 
     FMXEXFDL2  UF   E           K DISK    INFSR(*PSSR)
      * Export Format Details
 
     FMXCOMDPD  UF   E           K DISK    INFSR(*PSSR)
      * Composite Message Details
 
     FMXBULKXAU O    E             PRINTER INFSR(*PSSR)  USROPN
      * Bulk Extract Audit Report
 
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
 
 
      * Composite Message Details
     D MXCOMD        E DS                  EXTNAME(MXCOMDPD)
      * Composite Message Formats
     D MXCOMF        E DS                  EXTNAME(MXCOMFPD)
 
 
     D MXEXPCTL      E DS                  EXTNAME(MXEXPCTL)
      ** Export Control Data
 
 
      ** External DS for BANK details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
 
      * M Q   S E R I E S   D A T A
     D/COPY MXCPYSRC,MXMQDAD
 
 
     IFILE      NS
     I                                  1 4000  Record
 
 
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           30
      * INPUT
      * Mode
      * Composite ID
      * Extract Type
      * Format
     C                   PARM                    I#MODE            1
     C                   PARM                    I#COMI            8
     C                   PARM                    I#EXTT            1
     C                   PARM                    I#FMT            10
 
     C                   ADD       1             RelRecNum        10 0
 
      * Process a single format or process a composite
 
     C     I#COMI        IFEQ      '*NONE   '
     C                   EXSR      PROC_FMT
     C                   ELSE
     C                   EXSR      PROC_COM
     C                   ENDIF
 
 
      * Output audit report totals
 
     CLR                 Z-ADD     9             CHLINE
     CLR                 EXSR      PAG
     CLR   I#COMI        IFEQ      '*NONE   '
     CLR                 WRITE     TOTALSR
     CLR                 ELSE
     CLR                 WRITE     TOTALSC
     CLR                 ENDIF
      /SPACE 5
      *********************************************************************
      * Process a single format
      *********************************************************************
     C     PROC_FMT      BEGSR
 
      * Format Data function
 
     C                   MOVEL     *BLANK        L_MQSEQM
     C                   MOVEL     I#FMT         L_MQFMT
     C                   EVAL      InData = Record
     C                   EXSR      FMT_DATA
 
      * If selected for export
 
     C     Select_EXP    IFEQ      'Y'
 
      * Set up Message ID fields
 
     C                   MOVEL     ReferID       L_MQREF
     C                   MOVEL     RelRecNum     L_MQREFS
 
      * Write MQ Series data
 
     C                   EXSR      WRT_MQDT
 
      * Write Performance Log data
 
     C     EXLOGP        IFEQ      'Y'
     C                   MOVEL     'X'           I#FUNC
     C                   EXSR      WRT_PLOG
     C                   ENDIF
 
      * Add 1 to the count of records
 
     C                   ADD       1             RCD_cnt           6 0
 
      * If Trace Bulk Extract is YES
      * Report details of the extract
 
     C     TRACBX        IFEQ      'Y'
     C                   MOVEL     ReferID       #ID
     C                   MOVEL     Record        #RECD
     C                   Z-ADD     1             CHLINE
     C                   EXSR      PAG
     C                   WRITE     EXTRACTEDR
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      *********************************************************************
      * Process a composite
      *********************************************************************
     C     PROC_COM      BEGSR
 
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
     C                   MOVEL     Record        #RECD
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
      /SPACE 5
      *********************************************************************
      * Access single format details
      *********************************************************************
     C     ACS_FMT       BEGSR
 
     C     I#FMT         CHAIN     MXEXFDP0                           99        *
     C     *in99         IFEQ      '1'
     C                   EVAL      I#ERMS = 'MISSING FORMAT:'
     C                             + I#FMT
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * If the message is not enabled, then end immediately
 
     C     EXENAB        IFNE      'Y'
     C                   SETON                                        U6LR
     C                   RETURN
     C                   ENDIF
 
      * Reset the extract control indicator to 1
 
     C                   Z-ADD     1             EXXCTL
     C                   UPDATE    MXEXFDP0
 
      * Set the report description
 
     C                   MOVEL     EXDESC        ZZDESC
 
     C                   ENDSR
     C********************************************************************
      /SPACE 5
      *********************************************************************
      * Access composite details
      *********************************************************************
     C     ACS_COM       BEGSR
 
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
 
     C                   ENDSR
     C********************************************************************
      /SPACE 5
      *********************************************************************
      * *INZSR - Initial subroutine called automatically at program start
      *********************************************************************
     C     *INZSR        BEGSR
 
      *  Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
      * Get export control details on data-area
 
     C     *DTAARA       DEFINE                  MXEXPCTL
     C                   IN        MXEXPCTL
 
 
      * Access single format details or access composite details
 
     C     I#COMI        IFEQ      '*NONE   '
     C                   EXSR      ACS_FMT
     C                   ELSE
     C                   EXSR      ACS_COM
     C                   ENDIF
 
      * Full trace
 
     C     TRACBX        COMP      'Y'                                    60    *
 
 
 
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
 
     C     I#MODE        IFEQ      'C'
 
     C     I#COMI        IFEQ      '*NONE   '
     C     EXEXND        ANDGE     BJDNWD
     C     I#COMI        OREQ      '*NONE   '
     C     EXEXND        ANDEQ     *ZERO
     C     I#COMI        ORNE      '*NONE   '
     C     CDEXND        ANDGE     BJDNWD
     C     I#COMI        ORNE      '*NONE   '
     C     CDEXND        ANDEQ     *ZERO
 
     C                   WRITE     NOEXTRACT
     C                   SETON                                        LR
     C                   RETURN
 
     C                   ENDIF
     C                   ENDIF
 
      * Key lists
 
     C     MXCOMDK       KLIST
     C                   KFLD                    I#COMI
     C                   KFLD                    I#EXTT
 
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      ********************************************************************
      * F O R M A T   D A T A
      /COPY MXCPYSRC,MXFMTDATA
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * W R I T E   M Q   S E R I E S   D A T A
      /COPY MXCPYSRC,MXWRTMQDT
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * W R I T E   P E R F O R M A N C E   L O G   D A T A
      /COPY MXCPYSRC,MXWRTPLOG
      ********************************************************************
      /SPACE 5
      *****************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY MXCPYSRC,MXPSSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2001
