     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/******  OVRDBF FILE(MXEXFDPDX) TOFILE(MXEXFDPD) SHARE(*NO)           *          MD056612
/******  OVRDBF FILE(MXEXFFL1X) TOFILE(MXEXFFL1) SHARE(*NO)           *          MD056612
/**** *  RPGBASEMOD                                                   *          MD056612
/*STD *  RPGSQLMOD                                                    *          MD056612
/*EXI *  CLOSQLCSR(*ENDMOD)                                           *          MD056612
/*EXI *  TEXT('Midas MX Export Format Fields Copy')
      *****************************************************************
      *                                                               *
      *  Midas - Meridian Export Module                               *
      *                                                               *
      *  MXEXFDCPY - Export Format Fields Copy                        *
      *                                                               *
      *  Function:  This module copies export format fields           *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD056612           Date 12Sep20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CMX003             Date 05Nov00               *
      *                         *CREATE    Date                       *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD056612 - Deliverable Data Split for MX group               *
      *  MD046248 - Finastra Rebranding                               *
      *  CMX003 - Meridian Export Enhancements - Phase 2              *
      *  CMX001 - Meridian Export                                     *
      *                                                               *
      *****************************************************************

     FMXEXFDCDD CF   E             WORKSTN
     F*MXEXFDPD* IF   E           K DISK                                                    MD056612
     F*MXEXFDL2* IF   E           K DISK                                                    MD056612
     F**********                           RENAME(MXEXFDP0:MXEXFDALT)                       MD056612
     F*MXEXFDPDX O    E           K DISK                                                    MD056612
     F**********                           RENAME(MXEXFDP0:MXEXFDWRT)                       MD056612
     F*MXEXFFL1* IF A E           K DISK                                                    MD056612
     F*MXEXFFL1X UF A E           K DISK                                                    MD056612
     F**********                           RENAME(MXEXFFP0:MXEXFFUPD)                       MD056612

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


     D*#_SQN***********S              1    DIM(10) CTDATA PERRCD(10)            CMX003
     D #_SQN           S              1    DIM(36) CTDATA PERRCD(36)            CMX003
     D #_CHKF          S              1    DIM(47) CTDATA PERRCD(47)


     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for BANK details
     D DSFDY         E DS                  EXTNAME(DSFDY)


     D*MXEXFD***     E DS                  EXTNAME(MXEXFDPD)                                MD056612
     D MXEXFD        E DS                  EXTNAME(MXEXDJW0)                                MD056612
      * Export Format Details
     D*P_MXEXFD*     E DS                  EXTNAME(MXEXFDPD)                                MD056612
     D P_MXEXFD      E DS                  EXTNAME(MXEXDJW0)                                MD056612
     D                                     PREFIX(P_)
      * Export Format Details
     D*MXEXFF***     E DS                  EXTNAME(MXEXFFPD)                                MD056612
     D MXEXFF        E DS                  EXTNAME(MXEXFJW0)                                MD056612
      * Export Format Fields

     D*P_MXEXFF*     E DS                  EXTNAME(MXEXFFPD)                                MD056612
     D P_MXEXFF      E DS                  EXTNAME(MXEXFJW0)                                MD056612
     D                                     PREFIX(P_)
      * Export Format Fields



     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           30
     C                   PARM                    DDFFIL           10
     C                   PARM                    DDFFSQ            1
     C                   PARM                    DDFFMT           10
     C                   PARM                    @INKC             1
     C                   PARM                    @INKL             1

      * To File is From File

     C                   MOVEL     DDFFIL        DDTFIL

      * Display screen until F3, F6, or F12 taken

     C     *INKC         DOWEQ     '0'
     C     *INKF         ANDEQ     '0'
     C     *INKL         ANDEQ     '0'
     C                   EXSR      DSPLAY_SCN
     C                   END

      * Pass back function keys taken

     C                   MOVE      *INKC         @INKC
     C                   MOVE      *INKL         @INKL

      * End of program

     C                   SETON                                        LR

      /SPACE 5
      *****************************************************************
      * Display screen
      *****************************************************************
     C     DSPLAY_SCN    BEGSR

      * Write detail screen and foooter

     C                   TIME                    DDTIME
     C                   WRITE     MSGSUBCT
     C                   WRITE     DETAILS
     C                   WRITE     FOOTER

      * Read detail screen

     C                   READ      DETAILS                                99    *

      ** Clear the message queue & init error indicators

     C                   EXSR      CLR_MSGQ

      ** If F3 and F12 were not taken

     C     *INKC         IFEQ      '0'
     C     *INKL         ANDEQ     '0'

      * Validate the screen

     C                   CAS                     VALID_SCN
     C                   END

     C                   ENDIF

     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *****************************************************************
      ** Clear the message queue & init error indicators
      *****************************************************************
     C     CLR_MSGQ      BEGSR

     C                   CALL      'Y2CLMSC'
     C                   PARM      DDPGM         ZAPGMQ           10
     C                   PARM      '*SAME'       ZAPGRL            5

     C                   MOVEA     '0'           *IN(50)
     C                   MOVEA     '0000000000'  *IN(10)

     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *****************************************************************
      * Validate the screen
      *****************************************************************
     C     VALID_SCN     BEGSR

      *  Validate To File

     C     DDTFIL        IFEQ      *BLANK
     C                   MOVEL     'MX00500'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN10
     C                   ELSE
     C                   MOVEA     DDTFIL        #_CHKF(12)
     C                   Z-ADD     47            #MesLen          15 5
     C                   CALL      'QCMDEXC'                            9999    *
     C                   PARM                    #_CHKF
     C                   PARM                    #MesLen
     C     *IN99         IFEQ      '1'
     C                   MOVEL     'MX00500'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN10
     C                   ENDIF
     C                   ENDIF

      *  Validate To File Sequence

     C     DDTFSQ        IFEQ      *BLANK
     C     DDTFSQ        OREQ      DDFFSQ
     C                   MOVEL     'MX00501'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN11
     C                   ELSE
     C     DDTFSQ        LOOKUP    #_SQN                                  99    *
     C     *in99         IFEQ      '0'
     C                   MOVEL     'MX00501'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN11
     C                   ENDIF
     C                   ENDIF

      * Check that file and sequence do not already exist

     C*****MXEXFDK       CHAIN     MXEXFDP0                           99        *           MD056612
     C/EXEC SQL                                                                             MD056612
     C+ SELECT *                                                                            MD056612
     C+ into :MXEXFD                                                                        MD056612
     C+ from MXEXDJW0                                                                       MD056612
     C+ where EXFILE = :DDTFIL  and EXFSQN = :DDTFSQ                                        MD056612
     C/END-EXEC                                                                             MD056612
     C******in99         IFEQ      '0'                                                      MD056612
     C     SQLCODE       IFEQ      0                                                        MD056612
     C                   MOVEL     'MX00517'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN11
     C                   ENDIF

      *  Validate To Format

     C     DDTFMT        IFEQ      *BLANK
     C                   MOVEL     'MX00503'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN12
     C                   ELSE
      * Check makeup
     C                   EVAL      ZFD2BV  = DDTFMT
     C                   EVAL      ZFDLC   = 'N'
     C                   EVAL      ZFDUC   = 'Y'
     C                   EVAL      ZFDNM   = 'Y'
     C                   EVAL      ZFDOTHC = '          '
     C                   EXSR      VAL_FDMU
     C     ZFDError      IFEQ      'Y'
     C                   MOVEL     'MX00503'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN12
     C                   ENDIF
     C                   ENDIF

      * Check that to format does not already exist

     C*****MXEXFDKAL     CHAIN     MXEXFDALT                          99        *           MD056612
     C/EXEC SQL                                                                             MD056612
     C+ SELECT *                                                                            MD056612
     C+ into :MXEXFD                                                                        MD056612
     C+ from MXEXDJW0                                                                       MD056612
     C+ where EXFMT  = :DDTFMT                                                              MD056612
     C/END-EXEC                                                                             MD056612
     C******in99         IFEQ      '0'                                                      MD056612
     C     SQLCODE       IFEQ      0                                                        MD056612
     C                   MOVEL     'MX00518'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN12
     C                   ENDIF

      * If any fields are in error, set off F6 if it was taken
      * (i.e. updates can't be done)

     C     *in50         IFEQ      '1'
     C                   MOVE      '0'           *INKF
     C                   ENDIF

      * Do file updates

     C     *INKF         CASEQ     '1'           UPD_FIL
     C                   END

     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *****************************************************************
      * File Updates
      ********************************************************************
     C     UPD_FIL       BEGSR

      * Add an export format details record

     C*****MXEXFDK_F     CHAIN     MXEXFDP0                           99                    MD056612
     C/EXEC SQL                                                                             MD056612
     C+ SELECT *                                                                            MD056612
     C+ into :MXEXFD                                                                        MD056612
     C+ from MXEXDJW0                                                                       MD056612
     C+ where EXFILE = :DDFFIL  and EXFSQN = :DDFFSQ                                        MD056612
     C/END-EXEC                                                                             MD056612
     C******in99         IFEQ      '0'                                                      MD056612
     C     SQLCODE       IFEQ      0                                                        MD056612
     C                   MOVEL     MXEXFD        P_MXEXFD
     C                   MOVEL     DDTFIL        P_EXFILE
     C                   MOVEL     DDTFSQ        P_EXFSQN
     C                   MOVEL     DDTFMT        P_EXFMT
     C*****MXEXFDK       CHAIN     MXEXFDP0                           99                    MD056612
     C/EXEC SQL                                                                             MD056612
     C+ SELECT *                                                                            MD056612
     C+ into :P_MXEXFD                                                                      MD056612
     C+ from MXEXDJW0                                                                       MD056612
     C+ where EXFILE = :DDTFIL  and EXFSQN = :DDTFSQ                                        MD056612
     C/END-EXEC                                                                             MD056612
     C******in99         IFEQ      '1'                                                      MD056612
     C     SQLCODE       IFEQ      100                                                      MD056612
     C                   MOVEL     P_MXEXFD      MXEXFD
     C**********         WRITE     MXEXFDWRT                                                MD056612
     C/exec SQL                                                                             MD056612
     C+ insert into MXEXDBTD                                                                MD056612
     C+ (                                                                                   MD056612
     C+   EXFILE                                                                            MD056612
     C+  ,EXFSQN                                                                            MD056612
     C+  ,EXDESC                                                                            MD056612
     C+  ,EXFMT                                                                             MD056612
     C+  ,EXMSGQ                                                                            MD056612
     C+  ,EXDRIP                                                                            MD056612
     C+  ,EXRECM                                                                            MD056612
     C+  ,EXLOGP                                                                            MD056612
     C+  ,EXMTRT                                                                            MD056612
     C+  ,EXEXFQ                                                                            MD056612
     C+  ,EXEXDY                                                                            MD056612
     C+  ,EXEXND                                                                            MD056612
     C+  ,EXACSM                                                                            MD056612
     C+  ,EXACSP                                                                            MD056612
     C+  ,EXACSX                                                                            MD056612
     C+  ,EXACST                                                                            MD056612
     C+  ,EXFDCR                                                                            MD056612
     C+  ,EXENAB                                                                            MD056612
     C+  ,EXLDTX                                                                            MD056612
     C+  ,EXLSTX                                                                            MD056612
     C+  ,EXLETX                                                                            MD056612
     C+  ,EXNOTX                                                                            MD056612
     C+  ,EXNTSX                                                                            MD056612
     C+  ,EXXCTL                                                                            MD056612
     C+  ,EXXMEM                                                                            MD056612
     C+  ,EXLDTT                                                                            MD056612
     C+  ,EXLSTT                                                                            MD056612
     C+  ,EXLETT                                                                            MD056612
     C+  ,EXNOTT                                                                            MD056612
     C+  ,EXNTST                                                                            MD056612
     C+  ,EXTCTL                                                                            MD056612
     C+  ,EXMODE                                                                            MD056612
     C+ )                                                                                   MD056612
     C+ values                                                                              MD056612
     C+ (                                                                                   MD056612
     C+   :EXFILE                                                                           MD056612
     C+  ,:EXFSQN                                                                           MD056612
     C+  ,:EXDESC                                                                           MD056612
     C+  ,:EXFMT                                                                            MD056612
     C+  ,:EXMSGQ                                                                           MD056612
     C+  ,:EXDRIP                                                                           MD056612
     C+  ,:EXRECM                                                                           MD056612
     C+  ,:EXLOGP                                                                           MD056612
     C+  ,:EXMTRT                                                                           MD056612
     C+  ,:EXEXFQ                                                                           MD056612
     C+  ,:EXEXDY                                                                           MD056612
     C+  ,:EXEXND                                                                           MD056612
     C+  ,:EXACSM                                                                           MD056612
     C+  ,:EXACSP                                                                           MD056612
     C+  ,:EXACSX                                                                           MD056612
     C+  ,:EXACST                                                                           MD056612
     C+  ,:EXFDCR                                                                           MD056612
     C+  ,:EXENAB                                                                           MD056612
     C+  ,:EXLDTX                                                                           MD056612
     C+  ,:EXLSTX                                                                           MD056612
     C+  ,:EXLETX                                                                           MD056612
     C+  ,:EXNOTX                                                                           MD056612
     C+  ,:EXNTSX                                                                           MD056612
     C+  ,:EXXCTL                                                                           MD056612
     C+  ,:EXXMEM                                                                           MD056612
     C+  ,:EXLDTT                                                                           MD056612
     C+  ,:EXLSTT                                                                           MD056612
     C+  ,:EXLETT                                                                           MD056612
     C+  ,:EXNOTT                                                                           MD056612
     C+  ,:EXNTST                                                                           MD056612
     C+  ,:EXTCTL                                                                           MD056612
     C+  ,'B'                                                                               MD056612
     C+ )                                                                                   MD056612
     C/end-exec                                                                             MD056612
     C/exec SQL                                                                             MD056612
     C+ insert into MXEXDXTD                                                                MD056612
     C+ (                                                                                   MD056612
     C+   EXFILE                                                                            MD056612
     C+  ,EXFSQN                                                                            MD056612
     C+  ,EXDESC                                                                            MD056612
     C+  ,EXFMT                                                                             MD056612
     C+  ,EXMSGQ                                                                            MD056612
     C+  ,EXDRIP                                                                            MD056612
     C+  ,EXRECM                                                                            MD056612
     C+  ,EXLOGP                                                                            MD056612
     C+  ,EXMTRT                                                                            MD056612
     C+  ,EXEXFQ                                                                            MD056612
     C+  ,EXEXDY                                                                            MD056612
     C+  ,EXEXND                                                                            MD056612
     C+  ,EXACSM                                                                            MD056612
     C+  ,EXACSP                                                                            MD056612
     C+  ,EXACSX                                                                            MD056612
     C+  ,EXACST                                                                            MD056612
     C+  ,EXFDCR                                                                            MD056612
     C+  ,EXENAB                                                                            MD056612
     C+  ,EXLDTX                                                                            MD056612
     C+  ,EXLSTX                                                                            MD056612
     C+  ,EXLETX                                                                            MD056612
     C+  ,EXNOTX                                                                            MD056612
     C+  ,EXNTSX                                                                            MD056612
     C+  ,EXXCTL                                                                            MD056612
     C+  ,EXXMEM                                                                            MD056612
     C+  ,EXLDTT                                                                            MD056612
     C+  ,EXLSTT                                                                            MD056612
     C+  ,EXLETT                                                                            MD056612
     C+  ,EXNOTT                                                                            MD056612
     C+  ,EXNTST                                                                            MD056612
     C+  ,EXTCTL                                                                            MD056612
     C+  ,EXMODE                                                                            MD056612
     C+ )                                                                                   MD056612
     C+ values                                                                              MD056612
     C+ (                                                                                   MD056612
     C+   :EXFILE                                                                           MD056612
     C+  ,:EXFSQN                                                                           MD056612
     C+  ,:EXDESC                                                                           MD056612
     C+  ,:EXFMT                                                                            MD056612
     C+  ,:EXMSGQ                                                                           MD056612
     C+  ,:EXDRIP                                                                           MD056612
     C+  ,:EXRECM                                                                           MD056612
     C+  ,:EXLOGP                                                                           MD056612
     C+  ,:EXMTRT                                                                           MD056612
     C+  ,:EXEXFQ                                                                           MD056612
     C+  ,:EXEXDY                                                                           MD056612
     C+  ,:EXEXND                                                                           MD056612
     C+  ,:EXACSM                                                                           MD056612
     C+  ,:EXACSP                                                                           MD056612
     C+  ,:EXACSX                                                                           MD056612
     C+  ,:EXACST                                                                           MD056612
     C+  ,:EXFDCR                                                                           MD056612
     C+  ,:EXENAB                                                                           MD056612
     C+  ,:EXLDTX                                                                           MD056612
     C+  ,:EXLSTX                                                                           MD056612
     C+  ,:EXLETX                                                                           MD056612
     C+  ,:EXNOTX                                                                           MD056612
     C+  ,:EXNTSX                                                                           MD056612
     C+  ,:EXXCTL                                                                           MD056612
     C+  ,:EXXMEM                                                                           MD056612
     C+  ,:EXLDTT                                                                           MD056612
     C+  ,:EXLSTT                                                                           MD056612
     C+  ,:EXLETT                                                                           MD056612
     C+  ,:EXNOTT                                                                           MD056612
     C+  ,:EXNTST                                                                           MD056612
     C+  ,:EXTCTL                                                                           MD056612
     C+  ,'B'                                                                               MD056612
     C+ )                                                                                   MD056612
     C/end-exec                                                                             MD056612
     C                   ENDIF
     C                   ENDIF

      * Add export format field records

     C     MXEXFDK_F     KLIST
     C                   KFLD                    DDFFIL
     C                   KFLD                    DDFFSQ
     C     MXEXFFK       KLIST
     C                   KFLD                    P_WHFILE
     C                   KFLD                    P_WHFSQN
     C                   KFLD                    P_WHFOBO
     C*****MXEXFDK_F     SETLL     MXEXFFP0                                                 MD056612
     C*****MXEXFDK_F     READE     MXEXFFP0                               99                MD056612
     C/EXEC SQL                                                                             MD056612
     C+ declare GCursor insensitive scroll cursor for                                       MD056612
     C+ select * from MXEXFJW0                                                              MD056612
     C+ where WHFILE = :DDFFIL and WHFSQN = :DDFFSQ                                         MD056612
     C+ order by WHFILE, WHFSQN, WHFOBO                                                     MD056612
     C/END-EXEC                                                                             MD056612
                                                                                            MD056612
     C/EXEC SQL                                                                             MD056612
     C+ open GCursor                                                                        MD056612
     C/END-EXEC                                                                             MD056612
                                                                                            MD056612
     C/EXEC SQL                                                                             MD056612
     C+ fetch next from GCursor into :MXEXFF                                                MD056612
     C/END-EXEC                                                                             MD056612
                                                                                            MD056612
     C******IN99         DOWEQ     '0'                                                      MD056612
     C     SQLCODE       DOWEQ     0                                                        MD056612
     C                   MOVEL     MXEXFF        P_MXEXFF
     C                   MOVEL     DDTFIL        P_WHFILE
     C                   MOVEL     DDTFSQ        P_WHFSQN
     C*****MXEXFFK       CHAIN     MXEXFFUPD                          99                    MD056612
     C/EXEC SQL                                                                             MD056612
     C+ SELECT *                                                                            MD056612
     C+ into :P_MXEXFF                                                                      MD056612
     C+ from MXEXFJW0                                                                       MD056612
     C+ where WHFILE = :P_WHFILE and WHFSQN = :P_WHFSQN and WHFOBO = :P_WHFOBO              MD056612
     C/END-EXEC                                                                             MD056612
     C                   MOVEL     P_MXEXFF      MXEXFF
     C******in99         IFEQ      '1'                                                      MD056612
     C     SQLCODE       IFEQ      100                                                      MD056612
     C**********         WRITE     MXEXFFUPD                                                MD056612
     C/exec SQL                                                                             MD056612
     C+ insert into MXEXFBTD                                                                MD056612
     C+ (                                                                                   MD056612
     C+   WHFILE                                                                            MD056612
     C+  ,WHFSQN                                                                            MD056612
     C+  ,WHFTYP                                                                            MD056612
     C+  ,WHFLDI                                                                            MD056612
     C+  ,WHFOBO                                                                            MD056612
     C+  ,WHIBO                                                                             MD056612
     C+  ,WHFLDB                                                                            MD056612
     C+  ,WHFLDD                                                                            MD056612
     C+  ,WHFLDP                                                                            MD056612
     C+  ,WHFTXT                                                                            MD056612
     C+  ,WHFLDT                                                                            MD056612
     C+  ,WHINEX                                                                            MD056612
     C+  ,WHMFNM                                                                            MD056612
     C+  ,WHDS01                                                                            MD056612
     C+  ,WHDS02                                                                            MD056612
     C+  ,WHDS03                                                                            MD056612
     C+  ,WHDS04                                                                            MD056612
     C+  ,WHDS05                                                                            MD056612
     C+  ,WHDS06                                                                            MD056612
     C+  ,WHDS07                                                                            MD056612
     C+  ,WHDS08                                                                            MD056612
     C+  ,WHDS09                                                                            MD056612
     C+  ,WHDS10                                                                            MD056612
     C+  ,WHDS11                                                                            MD056612
     C+  ,WHLSEQ                                                                            MD056612
     C+  ,WHSREF                                                                            MD056612
     C+  ,WHMODE                                                                            MD056612
     C+ )                                                                                   MD056612
     C+ values                                                                              MD056612
     C+ (                                                                                   MD056612
     C+   :WHFILE                                                                           MD056612
     C+  ,:WHFSQN                                                                           MD056612
     C+  ,:WHFTYP                                                                           MD056612
     C+  ,:WHFLDI                                                                           MD056612
     C+  ,:WHFOBO                                                                           MD056612
     C+  ,:WHIBO                                                                            MD056612
     C+  ,:WHFLDB                                                                           MD056612
     C+  ,:WHFLDD                                                                           MD056612
     C+  ,:WHFLDP                                                                           MD056612
     C+  ,:WHFTXT                                                                           MD056612
     C+  ,:WHFLDT                                                                           MD056612
     C+  ,:WHINEX                                                                           MD056612
     C+  ,:WHMFNM                                                                           MD056612
     C+  ,:WHDS01                                                                           MD056612
     C+  ,:WHDS02                                                                           MD056612
     C+  ,:WHDS03                                                                           MD056612
     C+  ,:WHDS04                                                                           MD056612
     C+  ,:WHDS05                                                                           MD056612
     C+  ,:WHDS06                                                                           MD056612
     C+  ,:WHDS07                                                                           MD056612
     C+  ,:WHDS08                                                                           MD056612
     C+  ,:WHDS09                                                                           MD056612
     C+  ,:WHDS10                                                                           MD056612
     C+  ,:WHDS11                                                                           MD056612
     C+  ,:WHLSEQ                                                                           MD056612
     C+  ,:WHSREF                                                                           MD056612
     C+  ,'B'                                                                               MD056612
     C+ )                                                                                   MD056612
     C/end-exec                                                                             MD056612
     C/exec SQL                                                                             MD056612
     C+ insert into MXEXFXTD                                                                MD056612
     C+ (                                                                                   MD056612
     C+   WHFILE                                                                           MD0566122
     C+  ,WHFSQN                                                                           MD0566122
     C+  ,WHFTYP                                                                           MD0566122
     C+  ,WHFLDI                                                                           MD0566122
     C+  ,WHFOBO                                                                           MD0566122
     C+  ,WHIBO                                                                            MD0566122
     C+  ,WHFLDB                                                                           MD0566122
     C+  ,WHFLDD                                                                           MD0566122
     C+  ,WHFLDP                                                                           MD0566122
     C+  ,WHFTXT                                                                           MD0566122
     C+  ,WHFLDT                                                                           MD0566122
     C+  ,WHINEX                                                                           MD0566122
     C+  ,WHMFNM                                                                           MD0566122
     C+  ,WHDS01                                                                           MD0566122
     C+  ,WHDS02                                                                           MD0566122
     C+  ,WHDS03                                                                           MD0566122
     C+  ,WHDS04                                                                           MD0566122
     C+  ,WHDS05                                                                           MD0566122
     C+  ,WHDS06                                                                           MD0566122
     C+  ,WHDS07                                                                           MD0566122
     C+  ,WHDS08                                                                           MD0566122
     C+  ,WHDS09                                                                           MD0566122
     C+  ,WHDS10                                                                           MD0566122
     C+  ,WHDS11                                                                           MD0566122
     C+  ,WHLSEQ                                                                           MD0566122
     C+  ,WHSREF                                                                           MD0566122
     C+  ,WHMODE                                                                           MD0566122
     C+ )                                                                                   MD056612
     C+ values                                                                              MD056612
     C+ (                                                                                   MD056612
     C+   :WHFILE                                                                           MD056612
     C+  ,:WHFSQN                                                                           MD056612
     C+  ,:WHFTYP                                                                           MD056612
     C+  ,:WHFLDI                                                                           MD056612
     C+  ,:WHFOBO                                                                           MD056612
     C+  ,:WHIBO                                                                            MD056612
     C+  ,:WHFLDB                                                                           MD056612
     C+  ,:WHFLDD                                                                           MD056612
     C+  ,:WHFLDP                                                                           MD056612
     C+  ,:WHFTXT                                                                           MD056612
     C+  ,:WHFLDT                                                                           MD056612
     C+  ,:WHINEX                                                                           MD056612
     C+  ,:WHMFNM                                                                           MD056612
     C+  ,:WHDS01                                                                           MD056612
     C+  ,:WHDS02                                                                           MD056612
     C+  ,:WHDS03                                                                           MD056612
     C+  ,:WHDS04                                                                           MD056612
     C+  ,:WHDS05                                                                           MD056612
     C+  ,:WHDS06                                                                           MD056612
     C+  ,:WHDS07                                                                           MD056612
     C+  ,:WHDS08                                                                           MD056612
     C+  ,:WHDS09                                                                           MD056612
     C+  ,:WHDS10                                                                           MD056612
     C+  ,:WHDS11                                                                           MD056612
     C+  ,:WHLSEQ                                                                           MD056612
     C+  ,:WHSREF                                                                           MD056612
     C+  ,'B'                                                                               MD056612
     C+ )                                                                                   MD056612
     C/end-exec                                                                             MD056612
     C                   ELSE
     C**********         UPDATE    MXEXFFUPD                                                MD056612
     C                   ENDIF
     C*****MXEXFDK_F     READE     MXEXFFP0                               99                MD056612
     C/EXEC SQL                                                                             MD056612
     C+ fetch next from GCursor into :MXEXFF                                                MD056612
     C/END-EXEC                                                                             MD056612
     C                   ENDDO

     C/EXEC SQL                                                                             MD056612
     C+ close GCursor                                                                       MD056612
     C/END-EXEC                                                                             MD056612
                                                                                            MD056612
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * ZASNMS - SEND A MESSAGE
      *****************************************************************
     C     ZASNMS        BEGSR

     C                   CALL      'Y2SNMGC'                            0909    *
     C                   PARM      DDPGM         ZAPGMQ           10
     C                   PARM                    ZAPGRL            5
     C                   PARM                    ZAMSID            7
     C                   PARM      'MIDAS'       ZAMSGF           10
     C                   PARM                    ZAMSDA          132
     C                   PARM                    ZAMSTP            7

      * Error encountered

     C     ZAMSID        IFNE      'MX00001'
     C     ZAMSID        ANDNE     'MX00002'
     C                   MOVE      '1'           *IN50
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      ********************************************************************
      * Meridian Field Name Construction
      ********************************************************************
     C     CON_MFNM      BEGSR

     C                   CALLB     'MXMFNMCON'
     C                   PARM      *BLANK        W#RTCD            7
     C                   PARM      *BLANK        W#ERMS           30
      * INPUTS
     C                   PARM                    I#CV              1
     C                   PARM                    I#FTXT           50
     C                   PARM                    I#MFNM           29
      * OUTPUTS
     C                   PARM                    O#MFNM           29

     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO MXMFNMCON'
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *****************************************************************
      * *INZSR - Initial subroutine called automatically at program start
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** Initialize program name
      *
     C                   MOVEL     'MXEXFDCPY'   DDPGM
      *
      ** Set up subfile message queue information
      *
     C                   MOVEL     '*'           DDPGMQ
     C                   MOVE      '1'           *IN40
      *
      ** Set up standard screen fields.
      *
     C                   MOVEL     PsJobName     DDJOB
     C                   MOVEL     PsUser        DDUSR

      *  Access Bank Details

     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY

      * Key lists

     C     MXEXFDK       KLIST
     C                   KFLD                    DDTFIL
     C                   KFLD                    DDTFSQ
     C     MXEXFDKAL     KLIST
     C                   KFLD                    DDTFMT
     C*****MXEXFDK_F     KLIST                                                              MD056612
     C**********         KFLD                    DDFFIL                                     MD056612
     C**********         KFLD                    DDFFSQ                                     MD056612
     C*****MXEXFFK       KLIST                                                              MD056612
     C**********         KFLD                    P_WHFILE                                   MD056612
     C**********         KFLD                    P_WHFSQN                                   MD056612
     C**********         KFLD                    P_WHFOBO                                   MD056612

     C                   ENDSR
      *****************************************************************
      /SPACE 5
      ********************************************************************
      * V A L I D A T E   F I E L D   M A K E U P
     C/COPY MXCPYSRC,MXVALFDMU
      *****************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY MXCPYSRC,MXPSSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2001
** #_SQN
0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ
** #_CHKF
CHKOBJ OBJ(          ) OBJTYPE(*FILE) AUT(*USE)
