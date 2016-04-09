     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*XBIF*: OVRDBF FILE(MXEXFDL2X) TOFILE(MXEXFDL2) SHARE(*NO)         : *
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MX Bulk Transmission to flat files')
      *****************************************************************
      *                                                               *
      *  Midas - Meridian Export Module                               *
      *                                                               *
      *  MXBULKTRX - Bulk Transmission to flat files                  *
      *                                                               *
      *  Function:  This module writes data to flat files             *
      *             for transfer to Meridian.                         *
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
      *                 CMX010  *CREATE    Data 18Jan01               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  BUG17937 - SEC3300 is Failing with an error.  Applied fix    *
      *             245268 (Recompile)                                *
      *  CMX010 - Flat file export from Midas Export module.          *
      *                                                               *
      *****************************************************************
 
     FMXEXFDL2  IF   E           K DISK    INFSR(*PSSR)
      * Export Format Details
 
     FMXEXFDL2X UF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(MXEXFDP0:MXEXFDUPD)
     F                                     PREFIX(U_)
      * Export Format Details
 
     FMXCOMDPD  IF   E           K DISK    INFSR(*PSSR)
      * Composite Message Details
 
     FMXCOMDL1  UF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(MXCOMDP0:MXCOMDUPD)
     F                                     PREFIX(U_)
      * Composite Message Details
 
     FMXMQDLL1  IP A E           K DISK    INFSR(*PSSR)
     FMXMQDML1  IS A E           K DISK    INFSR(*PSSR)
     FMXMQDSL1  IS A E           K DISK    INFSR(*PSSR)
     FMXMQDVL1  IS A E           K DISK    INFSR(*PSSR)
     FMXMQDXL1  IS A E           K DISK    INFSR(*PSSR)
      * Meridian Export MQ series data
 
     FMXFLFLPD  O    E             DISK    INFSR(*PSSR)
      * Meridian Export Flat file
 
     FMXBULKTAU O    E             PRINTER INFSR(*PSSR)  USROPN
      * Bulk Transmission Audit Report
 
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
 
 
      * R E F O R M A T   D A T A
     D/COPY MXCPYSRC,MXRFMDD
 
     D                 DS
     D  p@msgbuf               1  32000
     D  a@msgbuf               1  32000
     D                                     DIM(32000)
 
     D                 DS
     D  p@refbuf               1  32000
     D  a@refbuf               1  32000
     D                                     DIM(32000)
 
 
     D #_FMT           S             10    DIM(99)
     D #_EPOS          S              4S 0 DIM(99)
     D #_OCUR          S              4S 0 DIM(99)
 
 
      * Composite Message Formats
     D MXCOMF        E DS                  EXTNAME(MXCOMFPD)
      * Transmission Header
     D MXTRMH        E DS                  EXTNAME(MXTRMHPD)
 
 
     D MXEXPCTL      E DS                  EXTNAME(MXEXPCTL)
      ** Export Control Data
 
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for BANK details
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
 
     IMXMQDLP0      01
     I                                          MQREF         L1M3
     I                                          MQREFS        L1M2
     I                                          MQSEQM          M1
     IMXMQDMP0      02
     I                                          MQREF         L1M3
     I                                          MQREFS        L1M2
     I                                          MQSEQM          M1
     IMXMQDSP0      03
     I                                          MQREF         L1M3
     I                                          MQREFS        L1M2
     I                                          MQSEQM          M1
     IMXMQDVP0      04
     I                                          MQREF         L1M3
     I                                          MQREFS        L1M2
     I                                          MQSEQM          M1
     IMXMQDXP0      05
     I                                          MQREF         L1M3
     I                                          MQREFS        L1M2
     I                                          MQSEQM          M1
 
 
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           30
      * INPUT
      * Mode
      * Composite ID
      * Extract Type
      * Format
      * Transmission Member
 
     C                   PARM                    I#MODE            1
     C                   PARM                    I#COMI            8
     C                   PARM                    I#EXTT            1
     C                   PARM                    I#FMT            10
 
      * Add 1 to count of records read
 
     C                   add       1             rec_cnt
 
      * Store formats if this is is first composite reference
 
     C     COM_cnt       IFEQ      0
     C                   EXSR      STOR_FMT
     C                   ENDIF
 
      * Set up outbound data and end position of this data
 
     C     MQEPOS        SUB       1             OutPos
     C   01              Eval      OutData = MQMDTL
     C   02              Eval      OutData = MQMDTM
     C   03              Eval      OutData = MQMDTS
     C   04              Eval      OutData = MQMDTV
     C   05              Eval      OutData = MQMDTX
 
      * Add outbound data to the reference buffer
 
     C                   movea     OutData       a@refbuf(eoRp)
     C                   add       OutPos        eoRp
 
      * Error if 32000 byte limit exceeded
 
     C     eoRp          IFGT      32000
     C                   EVAL      I#ERMS = 'MESSAGE LIMIT EXCEEDED'
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * On change of reference
      * (if any records have actually been read)
      * Determine if the message should be 'put' to the MQ Series queue
 
     CL1   rec_cnt       ifgt      *ZERO
     CL1                 EXSR      PUT_MSG
     CL1                 ENDIF
 
      * At the end of the program
      * wirte any remaining message to file MXFLFLPD
 
     CLR                 EXSR      PUT_REMMSG
 
      *******************************************************************
     C/SPACE 5
      ********************************************************************
      * Store formats
      ********************************************************************
     C     STOR_FMT      begsr
 
     C                   Z-ADD     1             @FN               3 0
     C     MQFMT         LOOKUP    #_FMT(@FN)                             99    *
     C     *in99         IFEQ      '0'
     C     *BLANK        LOOKUP    #_FMT(@FN)                             99    *
     C                   MOVEL     MQFMT         #_FMT(@FN)
     C     MQEPOS        SUB       1             #_EPOS(@FN)
     C                   Z-ADD     1             #_OCUR(@FN)
     C                   ELSE
     C                   ADD       1             #_OCUR(@FN)
     C                   ENDIF
 
     C                   endsr
      *********************************************************************
     C/SPACE 5
      ********************************************************************
      * Determine if the message should be 'put' to the MQ Series queue
      ********************************************************************
     C     PUT_MSG       begsr
 
      * Report the reference transmitted
      * if message trans. report type is audit
 
     C     CDMTRT        IFEQ      'A'
     C                   EXSR      RPT_REFT
     C                   endif
 
      * Increment the end of message pointer by the end of reference pointer
      * to see whether message buffer is due to be filled.
 
     C     eoMp          add       eoRp          chkptr            6 0
     C                   sub       1             chkptr
 
      * If the end of message buffer is due to exceed the maximum allowed
      * or if there is one composite per MQ message and a message is present
 
     C     chkptr        ifge      32000
     C     CDCOMM        oreq      1
     C     eoMp          andgt     TRMH_Eps
 
      * Update the count of COMs/Message in the message buffer
 
     C     PsTM          ifeq      141
     C                   movel     APCOMMC       A_APCOMMC         5
     C                   movea     A_APCOMMC     a@msgbuf(PsTM)
     C                   endif
 
      * Write the existing message to MXFLFLPD
 
     C                   movel     p@msgbuf      MSGBUF
     C                   WRITE     MXFLFLPF
     C                   add       1             MSG_cnt
 
      * If this is the first message written
      * Update the transmission control total on MXCOMDPD
 
     C     MSG_cnt       IFEQ      1
     C     I#COMI        IFEQ      '*NONE   '
     C                   EXSR      UPD_FMT
     C                   ELSE
     C                   EXSR      UPD_COM
     C                   ENDIF
     C                   ENDIF
 
      * Report the message transmitted
      * if message trans. report type is full
      * or message trans. report type is sample and no message printed yet
 
     C     CDMTRT        IFEQ      'F'
     C     CDMTRT        OREQ      'S'
     C     smp_cnt       ANDLT     sample_num
     C                   EXSR      RPT_MSGT
     C                   endif
 
      * Reset the message buffer and end of message pointer
 
     C                   clear                   p@msgbuf
     C                   z-add     1             eoMp
 
      * Add transmission header to message buffer
 
     C                   movea     MXTRMH_O      a@msgbuf(eoMp)
     C                   add       TRMH_Len      eoMp
 
      * Reset the count of Composites/Message
 
     C                   Z-ADD     *ZERO         APCOMMC
 
     C                   endif
 
      * Add the reference buffer to the message buffer
      * and add the end of message pointer to the end of reference pointer
 
     C                   movea     a@refbuf      a@msgbuf(eoMp)
     C                   add       eoRp          eoMp
     C                   sub       1             eoMp
 
      * Reset the reference buffer and end of reference pointer
 
     C                   clear                   p@refbuf
     C                   z-add     1             eoRp
 
      * Write Performance Log data
 
     C     CDLOGP        IFEQ      'Y'
     C                   MOVEL     'T'           I#FUNC
     C                   MOVEL     MQREF         L_MQREF
     C                   EXSR      WRT_PLOG
     C                   endif
 
      * Add 1 to the count of composites
 
     C                   ADD       1             COM_cnt
 
      * Add 1 to the count of composites/message
 
     C                   ADD       1             APCOMMC
 
     C                   endsr
     C*********************************************************************
     C/SPACE 5
      ********************************************************************
      * 'Put' the remaining message to the MQ Series queue
      ********************************************************************
     C     PUT_REMMSG    begsr
 
      * If the end of message buffer has been set
 
     C     eoMp          ifgt      TRMH_Eps
 
      * Update the count of Composites/Message in the message buffer
 
     C     PsTM          ifeq      141
     C                   movel     APCOMMC       A_APCOMMC
     C                   movea     A_APCOMMC     a@msgbuf(PsTM)
     C                   endif
 
      * Write the existing message to MXFLFLPD
 
     C                   movel     p@msgbuf      MSGBUF
     C                   WRITE     MXFLFLPF
     C                   add       1             MSG_cnt
 
      * Report the message transmitted
      * if message trans. report type is full
      * or message trans. report type is sample and no message printed yet
 
     C     CDMTRT        IFEQ      'F'
     C     CDMTRT        OREQ      'S'
     C     smp_cnt       ANDLT     sample_num
     C                   EXSR      RPT_MSGT
     C                   endif
 
     C                   endif
 
      * Output end of report totals
 
     C                   Z-ADD     10            CHLINE            3 0
     C                   EXSR      PAG
     C                   WRITE     ENDOFREP
 
     C                   endsr
     C*********************************************************************
     C/SPACE 5
      ********************************************************************
      *********************************************************************
     C/SPACE 5
      ********************************************************************
      * Report the reference transmitted
      ********************************************************************
     C     RPT_REFT      BEGSR
 
     C                   Z-ADD     1             CHLINE            3 0
     C                   EXSR      PAG
     C                   WRITE     REFER
 
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * Report the message transmitted
      ********************************************************************
     C     RPT_MSGT      BEGSR
 
      * Output message to report in 100 byte chunks
 
     C                   z-add     1             ctr               6 0
 
     C     ctr           DOUGT     eoMp
 
     C                   movel     *BLANK        MSGDTA          100
     C                   movea     a@msgbuf(ctr) MSGDTA
     C                   add       100           ctr
 
     C     ctr           sub       1             prt_epos          6 0
 
     C                   Z-ADD     1             CHLINE            3 0
     C                   EXSR      PAG
     C                   WRITE     MSG
 
     C                   ENDDO
 
      * Add 1 to the count of samples
 
     C                   ADD       1             smp_cnt           6 0
 
      * Output end of message line
 
     C                   Z-ADD     1             CHLINE
     C                   EXSR      PAG
     C                   WRITE     ENDOFMSG
 
      * If message trans. report type is sample
      * and this is the first sample
      * report stored formats of first composite reference
 
     C     CDMTRT        IFEQ      'S'
     C     smp_cnt       ANDEQ     1
 
      * Output start of formats line
 
     C                   Z-ADD     1             CHLINE
     C                   EXSR      PAG
     C                   WRITE     STROFFMT
 
      * Report Transmission Header as first of formats used
 
     C                   z-add     TRMH_Len      cum_epos          6 0
     C                   MOVEL     'MXTRMHPD  '  #FMT
     C                   Z-ADD     TRMH_Len      #EPOS
     C                   Z-ADD     1             #OCUR
 
     C                   Z-ADD     1             CHLINE
     C                   EXSR      PAG
     C                   WRITE     FMT
 
      * If extract type is 'C' do the following processing
      * as many times as there are composites in the message.
      * If extract type is 'A' the following processing will be done once.
 
     C                   z-add     1             totctr            6 0
 
     C     totctr        DOUGT     COM_cnt
     C     I#EXTT        OREQ      'A'
 
      * Output a space
 
     C                   Z-ADD     1             CHLINE
     C                   EXSR      PAG
     C                   WRITE     SPACEFMT
 
      * Do until all the formats have been printed
 
     C                   z-add     1             ctr
 
     C     ctr           DOWLE     99
     C     #_FMT(ctr)    ANDNE     *BLANK
 
     C                   DO        #_OCUR(ctr)
     C                   add       #_EPOS(ctr)   cum_epos
     C                   ENDDO
 
      * Set output fields
 
     C                   MOVEL     #_FMT(ctr)    #FMT
     C                   MOVEL     #_EPOS(ctr)   #EPOS
     C                   MOVEL     #_OCUR(ctr)   #OCUR
 
     C                   Z-ADD     1             CHLINE
     C                   EXSR      PAG
     C                   WRITE     FMT
 
     C                   add       1             ctr
     C                   ENDDO
 
     C                   add       1             totctr
     C                   ENDDO
 
      * Output end of formats line
 
     C                   Z-ADD     1             CHLINE
     C                   EXSR      PAG
     C                   WRITE     ENDOFFMT
 
     C                   endif
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * Throw page headings (if required)
      *****************************************************d**************
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
      ********************************************************************
      * Update transmission control indicator on MXEXFDPD
      ********************************************************************
     C     UPD_FMT       BEGSR
 
      * One is added to the transmission control total
      * after the first message has been written to the MQ/SERIES queue.
 
     C     I#FMT         CHAIN     MXEXFDUPD                          99        *
     C     *in99         IFEQ      '0'
     C                   ADD       1             U_EXTCTL
     C                   UPDATE    MXEXFDUPD
     C                   ENDIF
 
     C                   ENDSR
     C********************************************************************
      /SPACE 5
      ********************************************************************
      * Update transmission control indicator on MXCOMDPD
      ********************************************************************
     C     UPD_COM       BEGSR
 
      * One is added to the transmission control total
      * after the first message has been written to the MQ/SERIES queue.
 
     C     MXCOMDK       CHAIN     MXCOMDUPD                          99        *
     C     *in99         IFEQ      '0'
     C                   ADD       1             U_CDTCTL
     C                   UPDATE    MXCOMDUPD
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
 
      * ERROR if the extract control indicator is not 2.
      * This means either:
      * (If 0) the extract has NOT been been run
      * (If 1) the extract failed to complete normally.
 
     C     EXXCTL        IFNE      2
     C     EXXCTL        IFEQ      0
     C                   EVAL      I#ERMS = 'THE EXTRACT HAS NOT BEEN RUN'
     C                   ELSE
     C                   EVAL      I#ERMS = 'THE EXTRACT FAILED TO COMPLETE'
     C                   ENDIF
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * INITIALIZE:
      * Message Type
      * Message Queue Name
      * COMs(/Recs) Per MQ Msg
      * Log Performance Y/N
      * Message Trans. Report Type
 
     C                   MOVEL     EXFMT         CDMSGT
     C                   MOVEL     EXMSGQ        CDMSGQ
     C                   MOVEL     EXRECM        CDCOMM
     C                   MOVEL     EXLOGP        CDLOGP
     C                   MOVEL     EXMTRT        CDMTRT
 
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
 
      * ERROR if the extract control indicator is not 2.
      * This means either:
      * (If 0) the extract has NOT been been run
      * (If 1) the extract failed to complete normally.
 
     C     CDXCTL        IFNE      2
     C     CDXCTL        IFEQ      0
     C                   EVAL      I#ERMS = 'THE EXTRACT HAS NOT BEEN RUN'
     C                   ELSE
     C                   EVAL      I#ERMS = 'THE EXTRACT FAILED TO COMPLETE'
     C                   ENDIF
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * Set the report description
 
     C                   MOVEL     CDDESC        ZZDESC
 
     C                   ENDSR
     C********************************************************************
     C/SPACE 5
      ********************************************************************
      * *INZSR --- INITIAL PROCESSING
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
 
 
      * Access single format details or access composite details
 
     C     I#COMI        IFEQ      '*NONE   '
     C                   EXSR      ACS_FMT
     C                   ELSE
     C                   EXSR      ACS_COM
     C                   ENDIF
 
      * Full trace
 
     C     TRACBT        COMP      'Y'                                    60    *
     C   60              MOVEL     'F'           CDMTRT
 
 
      * Open the printer file
 
     C                   OPEN      MXBULKTAU
 
      * Initialize time
 
     C                   TIME                    #TIME
 
      * Output audit report page headings
 
     C     I#EXTT        COMP      'A'                                    50    *
     C                   Z-ADD     *ZERO         CHLINE
     C                   Z-ADD     99            LINENO
     C                   EXSR      PAG
 
      * Reset the reference buffer and end of reference pointer
 
     C                   clear                   p@refbuf
     C                   z-add     1             eoRp              6 0
 
      * Reset the message buffer and end of message pointer
 
     C                   clear                   p@msgbuf
     C                   z-add     1             eoMp              6 0
 
      ** Set Up Transmission Header
 
     C                   MOVEL     CDMSGT        APTGTTYPE
     C                   Z-ADD     *ZERO         APCOMMC
     C                   EVAL      APTGTSYS = 'MidasExp'
     C                   EVAL      APSRCSYS = 'MidasExp'
 
     C                   CALLB     'MXFMTDATA'
     C                   PARM      *BLANK        W#RTCD            7
     C                   PARM      *BLANK        W#ERMS           30
      * INPUT
     C                   PARM      *BLANK        W#MODE            1
     C                   PARM      '*NONE   '    W#COMI            8
     C                   PARM      *BLANK        W#EXTT            1
     C                   PARM      *BLANK        W#SEQM            2
     C                   PARM      'MXTRMHPD  '  W#FMT            10
     C                   PARM      MXTRMH        InData         4000
      * OUTPUT
      * Composite Message Format
     C                   PARM                    MXCOMF
      * Out Position
      * Outbound Data
     C                   PARM                    OutPos
     C                   PARM                    MXTRMH_O       4000
      * Reference ID
      * Select For Export
     C                   PARM                    ReferID
     C                   PARM                    Select_EXP
 
      * Error
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO MXFMTDATA'
     C                   EXSR      *PSSR
     C                   ENDIF
 
 
      * Set end position of transmission header
      * and length of transmission header
      * and position of Composites/Message Count
 
     C                   z-add     OutPos        TRMH_Eps          4 0
     C     OutPos        sub       1             TRMH_Len          4 0
     C     OutPos        sub       5             PsTM              4 0
 
      * Add transmission header to message buffer
 
     C                   movea     MXTRMH_O      a@msgbuf(eoMp)
     C                   add       TRMH_Len      eoMp
 
      * Set the sample number
 
     C                   Z-ADD     10            sample_num        6 0
 
      * Zeroize count of records read
      * Zeroize count of composites
      * Zeroize count of messages
 
     C                   Z-ADD     *ZERO         rec_cnt           6 0
     C                   Z-ADD     *ZERO         COM_cnt           6 0
     C                   Z-ADD     *ZERO         MSG_cnt           6 0
 
      * Key lists
 
     C     MXCOMDK       KLIST
     C                   KFLD                    I#COMI            8
     C                   KFLD                    I#EXTT            1
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * W R I T E   P E R F O R M A N C E   L O G   D A T A
      /COPY MXCPYSRC,MXWRTPLOG
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY MXCPYSRC,MXPSSR
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
