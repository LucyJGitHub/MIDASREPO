     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MX Drip-Feed Extract')                           *
      *****************************************************************
      *                                                               *
      *  Midas - Data Export module                                   *
      *                                                               *
      *  MXDRIPEXT - Drip-Feed Extract                                *
      *                                                               *
      *  Function:  This module receives journal images and calls     *
      *             the appropriate extract module.                   *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CTI006             Date 31Mar14               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                         *CREATE    Date                       *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CTI006 - Trade Finance BF Midas 2.2 Interface                *
      *  CMX001 - Meridian Export                                     *
      *                                                               *
      *****************************************************************
 
     FMXEXFDL2  IF   E           K DISK    INFSR(*PSSR)
      * Meridian Export Format Details
 
     FMXCOMFPD  IF   E           K DISK    INFSR(*PSSR)
      * Composite Message Details
 
     FMXCOMDPD  IF   E           K DISK    INFSR(*PSSR)                                       CTI006
     FMXOLEJPD  UF   E             DISK    COMMIT INFSR(*PSSR)
     FMXTRIGPD  O    E             DISK    COMMIT INFSR(*PSSR)
 
     FMXDRIPXAU O    E             PRINTER INFSR(*PSSR)  USROPN
      * Drip-Feed Extract Audit Report
 
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
 
 
      * Composite Message Formats
     D MXCOMF        E DS                  EXTNAME(MXCOMFPD)
 
 
      * Maximum number of formats
     D MaxNoFmts       C                   CONST(200)
 
      * FILE ARRAY
     D #_FILE          S             10    DIM(MaxNoFmts)
      * FILE SEQUENCE ARRAY
     D #_FSQN          S              1    DIM(MaxNoFmts)
      * COMPOSITE MESSAGE ID ARRAY
     D*#_COMI***       S              8    DIM(MaxNoFmts)                                     CTI006
     D #_COMI          S              9    DIM(MaxNoFmts)                                     CTI006
      * SEQUENCE IN MESSAGE ARRAY
     D #_SEQM          S              2    DIM(MaxNoFmts)
      * FORMAT ARRAY
     D #_FMT           S             10    DIM(MaxNoFmts)
 
 
      * KEY ARRAY
     D #_KEY           S             15    DIM(MaxNoFmts)
      * RECORD ARRAY
     D #_RCD           S           4000    DIM(MaxNoFmts)
 
 
     D JournalEnt      DS
      * Standard fields on all journal entries
     D  Filler01                      5A
     D  JrnSeqn                      10A
     D  JrnCode                       1A
     D  JrnEntType                    2A
     D  Filler02                     38A
     D  Program                      10A
     D  File_Name                    10A
     D  Library                      10A
     D  Member                       10A
     D  RelRecNum                    10A
     D  Filler03                     19A
      * Fields specific to the journal entry
     D  Record                     4000A
 
     D ControlInf      DS
     D  CTRLInfo1                     1
     D  CTRLInfo2                     1
 
 
      * M Q   S E R I E S   D A T A
     D/COPY MXCPYSRC,MXMQDAD
 
 
     D MXEXPCTL      E DS                  EXTNAME(MXEXPCTL)
      ** Export Control Data
 
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for BANK details
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
 
     C     *ENTRY        PLIST
     C                   PARM                    JournalEnt
     C                   PARM                    ControlInf
 
 
      * If the first byte of Control Information is 0, no data has been
      *  passed so simply return
 
     C                   IF        CTRLInfo1 = '0'
     C                   RETURN
     C                   ENDIF
 
      * If 'stop' (XE) or 'pause' (XJ) requested,
      * Update the last journal sequence number processed on MXOLEJPD
      * and end this program
 
     C     JrnEntType    IFEQ      'XE'
     C     JrnEntType    OREQ      'XJ'
     C                   MOVEL     Record        CTRL_TXT          3
     C     CTRL_TXT      IFEQ      'EXT'
     C                   EVAL      CTRLInfo1 = '9'
     C                   EXSR      UPD_MXOLEJ
     C                   COMMIT
     C                   SETON                                        LR
     C                   RETURN
     C                   ENDIF
     C                   ENDIF
 
 
      * Look for a reference to the file
 
     C                   Z-ADD     1             @T
     C     File_Name     LOOKUP    #_FILE(@T)                             99    *
 
      * If a reference to the file is found
 
     C     *IN99         IFEQ      '1'
 
      * If Trace Drip-Feed Extract is YES
      * Report details of the update
 
     C     TRACDX        IFEQ      'Y'
     C                   TIME                    #TIME
     C                   MOVEL     JrnSeqn       #JRNS
     C                   MOVEL     JrnEntType    #JRNET
     C                   MOVEL     File_Name     #FILE
     C                   MOVEL     Record        #RECD
     C                   Z-ADD     1             CHLINE
     C                   EXSR      PAG
     C                   WRITE     RCDUPDATE
     C                   ENDIF
 
      * Update the last journal sequence number processed on MXOLEJPD
 
     C                   EXSR      UPD_MXOLEJ
     C                   ENDIF
 
      * Process all references to the file
 
     C     *IN99         DOWEQ     '1'
 
     C                   MOVEL     #_COMI(@T)    Comp_ID           8
     C                   MOVE      #_COMI(@T)    ExtractType       1                          CTI006
     C                   MOVEL     #_SEQM(@T)    SeqinMsg          2
     C                   MOVEL     #_FMT(@T)     Format           10
     C                   MOVE      #_FSQN(@T)    File_Seq          1
 
      * Format Data function
 
     C                   MOVEL     'D'           I#MODE            1
     C                   MOVEL     Comp_ID       I#COMI            8
     C**********         MOVEL     'A'           I#EXTT            1                          CTI006
     C                   MOVEL     ExtractType   I#EXTT            1                          CTI006
     C                   MOVEL     SeqinMsg      L_MQSEQM
     C                   MOVEL     Format        L_MQFMT
     C                   EVAL      InData = Record
     C                   EXSR      FMT_DATA
 
      * Process a single format or process a composite
 
     C                   MOVEL     'N'           Wrt_MXTRIG        1
 
     C     Comp_ID       IFEQ      '*NONE   '
     C                   EXSR      PROC_FMT
     C                   ELSE
     C                   EXSR      PROC_COM
     C                   ENDIF
 
      * If a write to the transmission trigger file is required
 
     C     Wrt_MXTRIG    IFEQ      'Y'
 
      * Write to the transmission trigger file
 
     C                   EVAL      TGJRNS = JrnSeqn
     C                   EVAL      TGCOMI = I#COMI
     C                   WRITE     MXTRIGP0
 
      * If Trace Drip-Feed Extract is YES
      * Report details of the extract
 
     C     TRACDX        IFEQ      'Y'
     C                   TIME                    #TIME
     C                   MOVEL     JrnSeqn       #JRNS
     C                   MOVEL     Comp_ID       #COMI
     C                   MOVEL     File_Name     #FILE
     C                   MOVEL     File_Seq      #FSQN
     C                   MOVEL     Format        #FMT
     C                   Z-ADD     1             CHLINE
     C                   EXSR      PAG
     C                   WRITE     EXTRACTED
     C                   ENDIF
     C                   ENDIF
 
 
      * Look for a reference to the file
 
     C                   ADD       1             @T
     C     File_Name     LOOKUP    #_FILE(@T)                             99    *
     C                   ENDDO
 
      * Commit the updates
 
     C                   COMMIT
 
 
      * 'Normal' return
 
     C                   RETURN
 
      *********************************************************************
      /SPACE 5
      *********************************************************************
      * Process a single format
      *********************************************************************
     C     PROC_FMT      BEGSR
 
      * Set up Message ID fields
 
     C                   MOVEL     RelRecNum     L_MQREF
     C                   MOVEL     JrnSeqn       L_MQREFS
 
      * If this is an UPDATE
 
     C     JrnEntType    IFEQ      'UB'
     C     JrnEntType    OREQ      'UP'
 
      * Check if the record has changed
 
     C                   EXSR      CHK_CHGREC
 
      * If the record has changed and it is selected for export
      * extract it
 
     C     Chg_Record    IFEQ      'Y'
     C     Select_EXP    ANDEQ     'Y'
     C                   EXSR      WRT_MQDT
     C                   MOVEL     'Y'           Wrt_MXTRIG
     C                   ENDIF
     C                   ENDIF
 
      * If this is a WRITE
      * and the record is selected for export
      * extract it
 
     C     JrnEntType    IFEQ      'PT'
     C     Select_EXP    ANDEQ     'Y'
     C                   EXSR      WRT_MQDT
     C                   MOVEL     'Y'           Wrt_MXTRIG
     C                   ENDIF
 
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      *********************************************************************
      * Process a composite
      *********************************************************************
     C     PROC_COM      BEGSR
 
      * If this is an UPDATE
 
     C     JrnEntType    IFEQ      'UB'
     C     JrnEntType    OREQ      'UP'
 
      * Check if the record has changed
 
     C                   EXSR      CHK_CHGREC
 
      * If the record has changed, extract it
      * then write it (if the driving record is selected for export)
 
     C     Chg_Record    IFEQ      'Y'
     C                   EXSR      EXT_COMI
     C     Select_EXP    IFEQ      'Y'
     C                   MOVEL     'Y'           Wrt_MXTRIG
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
      * If this is a WRITE
 
     C     JrnEntType    IFEQ      'PT'
 
      * Extract the record
      * then write it (if the driving record is selected for export)
 
     C                   EXSR      EXT_COMI
     C     Select_EXP    IFEQ      'Y'
     C                   MOVEL     'Y'           Wrt_MXTRIG
     C                   ENDIF
     C                   ENDIF
 
     C     EPROC_COM     ENDSR
      *********************************************************************
      /SPACE 5
      *********************************************************************
      * Extract a composite
      *********************************************************************
     C     EXT_COMI      BEGSR
 
     C                   CALL      'MXEXTCOMI'
     C                   PARM      *BLANK        W#RTCD            7
     C                   PARM      *BLANK        W#ERMS           30
      * inputs
     C                   PARM                    I#MODE            1
     C                   PARM                    I#COMI            8
     C                   PARM                    I#EXTT            1
     C                   PARM      JrnSeqn       I#REFS           10
     C                   PARM      Record        DRV_InData     4000
      * outputs
     C                   PARM      *BLANK        ReferID          40
     C                   PARM      'N'           Select_EXP        1
 
      * Error
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO MXEXTCOMI'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      *********************************************************************
      * Check For Changed Record
      *********************************************************************
     C     CHK_CHGREC    BEGSR
 
      * Set Record Key
 
     C                   MOVEL     RelRecNum     Record_Key       15
     C                   MOVE      @T            Record_Key
 
      * Reset 'Changed Record' indicator
 
     C                   MOVEL     'N'           Chg_Record        1
 
      * Check if record has previously been maintained
 
     C                   Z-ADD     1             @K                2 0
     C     Record_Key    LOOKUP    #_KEY(@K)                              99
 
      * The record has previously been maintained
 
     C     *IN99         IFEQ      '1'
 
      * Check if record has changed
 
     C     #_RCD(@K)     IFNE      L_MQMDTL
     C                   MOVEL     'Y'           Chg_Record
     C                   ENDIF
 
     C                   MOVEL     *BLANK        #_KEY(@K)
     C                   MOVEL     *BLANK        #_RCD(@K)
 
     C                   ELSE
 
     C                   Z-ADD     1             @K
     C     *BLANK        LOOKUP    #_KEY(@K)                              99    *
     C                   MOVEL     Record_Key    #_KEY(@K)
     C                   MOVEL     L_MQMDTL      #_RCD(@K)
     C                   ENDIF
 
     C                   ENDSR
      *********************************************************************
     C/SPACE 5
      ********************************************************************
      * Update the last journal sequence number processed on MXOLEJPD
      ********************************************************************
     C     UPD_MXOLEJ    BEGSR
 
     C     1             CHAIN     MXOLEJPD                           6060
     C     *IN60         IFEQ      '0'
     C                   EVAL      I#LASTSEQ = JrnSeqn
     C                   UPDATE    MXOLEJP0
     C                   ELSE
     C                   EVAL      I#ERMS   = 'ERROR ON CHAIN TO MXOLEJPD'
     C                   EXSR      *PSSR
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
      * Load all COMPOSITE formats for drip-feed
      *********************************************************************
     C     LOAD_COM      BEGSR
 
      * Read all composite formats for activity extracts
 
     C     *LOVAL        SETLL     MXCOMFP0
     C                   READ      MXCOMFP0                               99    *
     C     *IN99         DOWEQ     '0'
                                                                                              CTI006
      * Access composite message                                                              CTI006
                                                                                              CTI006
     C     MXCOMDK       CHAIN     MXCOMDP0                           99                      CTI006
 
      * Store each 'driver' file within an activity extract
      * that is to be dripfed
 
     C*****CFEXTT        IFEQ      'A'                                                        CTI006
     C*****CFLFMT        ANDEQ     '*DRIVER   '                                               CTI006
     C     CFLFMT        IFEQ      '*DRIVER   '                                               CTI006
     C     *IN99         ANDEQ     '0'                                                        CTI006
     C     CDMSGQ        ANDNE     *BLANK                                                     CTI006
     C     CDENAB        ANDNE     'N'                                                        CTI006
 
     C     CFFMT         CHAIN     MXEXFDP0                           99        *
     C     *IN99         IFEQ      '0'
     C     EXDRIP        ANDEQ     'Y'
     C     EXFDCR        ANDEQ     'Y'
     C                   MOVEL     CFCOMI        #_COMI(@T)
     C                   MOVE      CFEXTT        #_COMI(@T)                                   CTI006
     C                   MOVEL     EXFILE        #_FILE(@T)
     C                   MOVEL     EXFSQN        #_FSQN(@T)
     C                   MOVEL     CFSEQM        #_SEQM(@T)
     C                   MOVEL     CFFMT         #_FMT(@T)
     C                   ADD       1             @T
     C                   ENDIF
 
     C                   ENDIF
 
     C                   READ      MXCOMFP0                               99    *
     C                   ENDDO
 
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      *********************************************************************
      * Load all SINGLE FILE formats for drip-feed
      *********************************************************************
     C     LOAD_FIL      BEGSR
 
      * Read all export formats
 
     C     *LOVAL        SETLL     MXEXFDP0
     C                   READ      MXEXFDP0                               99    *
     C     *IN99         DOWEQ     '0'
 
      * Store each format within the export formats
      * that is to be dripfed and if an MQ/SERIES QUEUE is specified
 
     C     EXDRIP        IFEQ      'Y'
     C     EXFDCR        ANDEQ     'Y'
     C     EXMSGQ        ANDNE     *BLANK
     C     EXENAB        ANDNE     'N'                                                        CTI006
     C                   MOVEL     '*NONE   '    #_COMI(@T)
     C                   MOVEL     EXFILE        #_FILE(@T)
     C                   MOVEL     EXFSQN        #_FSQN(@T)
     C                   MOVEL     EXFMT         #_FMT(@T)
     C                   ADD       1             @T
     C                   ENDIF
 
     C                   READ      MXEXFDP0                               99    *
     C                   ENDDO
 
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      ********************************************************************
      * Report all COMPOSITES and SINGLE FILES being drip-fed
      ********************************************************************
     C     REPORT        BEGSR
 
      * Open the printer file
 
     C                   OPEN      MXDRIPXAU
 
      * Output audit report page headings
 
     C                   Z-ADD     *ZERO         CHLINE            3 0
     C                   Z-ADD     99            LINENO
     C                   EXSR      PAG
 
      * Output start of COMPOSITES line
 
     C                   Z-ADD     2             CHLINE
     C                   EXSR      PAG
     C                   WRITE     STROFCOM
 
      * Print all the COMPOSITES
 
     C                   z-add     1             @T
     C     @T            DOWLE     MaxNoFmts
     C     #_COMI(@T)    ANDNE     *BLANK
 
     C     #_COMI(@T)    IFNE      '*NONE   '
     C                   MOVEL     #_COMI(@T)    #COMI
     C                   MOVE      #_COMI(@T)    #EXTT                                        CTI006
     C                   MOVEL     #_FILE(@T)    #FILE
     C                   MOVEL     #_FSQN(@T)    #FSQN
     C                   MOVEL     #_FMT(@T)     #FMT
     C                   Z-ADD     1             CHLINE
     C                   EXSR      PAG
     C                   WRITE     COMFMT
     C                   ENDIF
 
     C                   add       1             @T
     C                   ENDDO
 
      * Output start of SINGLE FILES line
 
     C                   Z-ADD     2             CHLINE
     C                   EXSR      PAG
     C                   WRITE     STROFFIL
 
      * Print all the SINGLE FILES
 
     C                   z-add     1             @T
     C     @T            DOWLE     MaxNoFmts
     C     #_COMI(@T)    ANDNE     *BLANK
 
     C     #_COMI(@T)    IFEQ      '*NONE   '
     C                   MOVEL     #_FILE(@T)    #FILE
     C                   MOVEL     #_FSQN(@T)    #FSQN
     C                   MOVEL     #_FMT(@T)     #FMT
     C                   Z-ADD     1             CHLINE
     C                   EXSR      PAG
     C                   WRITE     FILFMT
     C                   ENDIF
 
     C                   add       1             @T
     C                   ENDDO
 
      * Output end of report line
 
     C                   Z-ADD     2             CHLINE
     C                   EXSR      PAG
     C                   WRITE     ENDOFREP
 
      * Close the printer file
 
     C                   CLOSE     MXDRIPXAU
 
     C                   ENDSR
      *********************************************************************
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
 
 
      * Load all COMPOSITE formats for drip-feed
 
     C                   Z-ADD     1             @T                3 0
 
     C                   EXSR      LOAD_COM
 
      * Load all SINGLE FILE formats for drip-feed
 
     C                   EXSR      LOAD_FIL
 
      * Report all COMPOSITES and SINGLE FILES being drip-fed
 
     C                   EXSR      REPORT
 
     C                   MOVEL     *BLANK        I#RTCD            7
     C                   MOVEL     *BLANK        I#ERMS           30
 
     C                   MOVE      '1'           *IN50
 
      * If Trace Drip-Feed Extract is YES
 
     C     TRACDX        IFEQ      'Y'
 
      * Open the printer file
 
     C                   OPEN      MXDRIPXAU
 
      * Output audit report page headings
 
     C                   Z-ADD     *ZERO         CHLINE            3 0
     C                   Z-ADD     99            LINENO
     C                   EXSR      PAG
 
     C                   ENDIF
 
      * Initialize time
 
     C                   TIME                    #TIME
 
     C     MXCOMDK       KLIST                                                                CTI006
     C                   KFLD                    CFCOMI                                       CTI006
     C                   KFLD                    CFEXTT                                       CTI006
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
      *****************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY MXCPYSRC,MXPSSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2001
