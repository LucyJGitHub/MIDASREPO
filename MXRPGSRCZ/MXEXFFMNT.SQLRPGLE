     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/******: OVRDBF FILE(MXEXFFL1X) TOFILE(MXEXFFL1) SHARE(*NO)         : *          MD056612
/**** *  RPGBASEMOD                                                   *          MD056612
/*STD *  RPGSQLMOD                                                    *          MD056612
/*EXI *  CLOSQLCSR(*ENDMOD)                                           *          MD056612
/*EXI *  TEXT('Midas MX Export Format Fields Maintenance')
      *****************************************************************
      *                                                               *
      *  Midas - Meridian Export Module                               *
      *                                                               *
      *  MXEXFFMNT - Export Format Fields Maintenance                 *
      *                                                               *
      *  Function:  This module maintains export format fields        *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD062186           Date 18Dec23               *
      *  Prev Amend No. MD056612           Date 12Sep20               *
      *                 MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CAAA03             Date 12Mar04               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                         *CREATE    Date                       *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD062186 - Sequence field is not updated                     *
      *  MD056612 - Deliverable Data Split for MX group               *
      *  MD046248 - Finastra Rebranding                               *
      *  CAAA03 - Webfacing Changes                                   *
      *  CMX001 - Meridian Export                                     *
      *                                                               *
      *****************************************************************

     FMXEXFFMDD CF   E             WORKSTN
     F*MXEXFFL1* IF   E           K DISK                                                    MD056612
     F*MXEXFFL1X UF   E           K DISK                                                    MD056612
     F**********                           RENAME(MXEXFFP0:MXEXFFUPD)                       MD056612
     F**********                           PREFIX(P_)                                       MD056612
     F*MXEXFFL2* IF   E           K DISK                                                    MD056612
     F**********                           RENAME(MXEXFFP0:MXEXFFALT)                       MD056612

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


     D #_SREF          S              1    DIM(10) CTDATA PERRCD(10)


     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for BANK details
     D DSFDY         E DS                  EXTNAME(DSFDY)

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
     C                   PARM                    I#MODE            1
     C                   PARM                    MXEXFF
     C                   PARM                    @INKC             1
     C                   PARM                    @INKL             1

      * Get Export Format Field

     C                   EXSR      GET_EXFF

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
     C**********         WRITE     DETAILS                                                    CAAA03
     C                   WRITE     FOOTER

      * Read detail screen

     C                   WRITE     DETAILS                                                    CAAA03
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

      * Meridian Field Name Construction

     C     DDMFNM        IFEQ      *BLANK
     C                   MOVEL     'C'           I#CV
     C                   MOVEL     WHFTXT        I#FTXT
     C                   ELSE
     C                   MOVEL     'V'           I#CV
     C                   MOVEL     DDMFNM        I#MFNM
     C                   ENDIF
     C                   EXSR      CON_MFNM
     C                   MOVEL     O#MFNM        DDMFNM
     C                   MOVEL     O#MFNM        WHMFNM

      * Validate Meridian Field Name
      * It must be unique within the format

     C                   MOVEL     MXEXFF        P_MXEXFF
     C*****MXEXFFKAL     CHAIN     MXEXFFALT                          99        *           MD056612
     C/EXEC SQL                                                                             MD056612
     C+ SELECT *                                                                            MD056612
     C+ into :MXEXFF                                                                        MD056612
     C+ from MXEXFJW0                                                                       MD056612
     C+ where WHFILE = :WHFILE and WHFSQN = :WHFSQN and WHMFNM = :WHMFNM                    MD056612
     C/END-EXEC                                                                             MD056612
     C******in99         IFEQ      '0'                                                      MD056612
     C     SQLCODE       IFEQ      0                                                        MD056612
     C     WHFOBO        IFNE      P_WHFOBO
     C                   MOVEL     'MX00602'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN11
     C                   ENDIF
     C                   MOVEL     P_MXEXFF      MXEXFF
     C                   ENDIF

      * Validate include in export
      * It must be 'Y' or 'N'

     C     WHINEX        IFNE      'Y'
     C     WHINEX        ANDNE     'N'
     C                   MOVEL     'MX00600'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN12
     C                   ENDIF

      * Sequence
      * It must be 1 to 99999 or 'RESET'

     C     DDIBO         IFEQ      'RESET'
     C                   MOVE      WHFOBO        DDIBO
     C                   ENDIF

     C                   MOVEL     *BLANK        ZFIELD
     C                   MOVEL     DDIBO         ZFIELD
     C                   CALLB     'ZALIGN'
     C                   PARM                    ZALIGNok          1
     C                   PARM                    ZFIELD           16
     C                   PARM      0             ZADEC             1 0
     C                   PARM      5             ZADIG             2 0
     C     ZALIGNok      IFNE      'Y'
     C                   MOVEL     'MX00601'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN13
     C                   ELSE
     C                   MOVE      ZFIELD        WHIBO
     C     WHIBO         IFLT      1
     C     WHIBO         ANDGT     99999
     C                   MOVEL     'MX00601'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN13
     C                   ENDIF
     C                   ENDIF

      * Validate sequence in reference
      * It must be ' ' or '1' to '9'

     C     WHSREF        LOOKUP    #_SREF                                 99    *
     C     *IN99         IFEQ      '0'
     C                   MOVEL     'MX00603'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN14
     C                   ENDIF

      * If any fields are in error, set off F6 if it was taken
      * (i.e. updates can't be done)

     C     *in50         IFEQ      '1'
     C                   MOVE      '0'           *INKF
     C                   ENDIF

      * Update the primary record

     C     *INKF         CASEQ     '1'           UPD_PrmREC
     C                   END

     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *****************************************************************
      * Update the primary record
      ********************************************************************
     C     UPD_PrmREC    BEGSR

     C*****MXEXFFK       CHAIN     MXEXFFUPD                          99        *           MD056612
     C/EXEC SQL                                                                             MD056612
     C+ SELECT *                                                                            MD056612
     C+ into :P_MXEXFF                                                                      MD056612
     C+ from MXEXFJW0                                                                       MD056612
     C+ where WHFILE = :WHFILE and WHFSQN = :WHFSQN and WHFOBO = :WHFOBO                    MD056612
     C/END-EXEC                                                                             MD056612
     C                   MOVEL     MXEXFF        P_MXEXFF
     C******in99         IFEQ      '0'                                                      MD056612
     C     SQLCODE       IFEQ      0                                                        MD056612
     C**********         UPDATE    MXEXFFUPD                                    *           MD056612
     C/exec SQL                                                                             MD056612
     C+ update MXEXFXTD                                                                     MD056612
     C+ set                                                                                 MD056612
     C+   WHINEX = :P_WHINEX                                                                MD056612
     C+  ,WHMFNM = :P_WHMFNM                                                                MD056612
     C+  ,WHFOBO = :P_WHFOBO                                                                MD056612
     C+  ,WHIBO  = :P_WHIBO                                                                 MD062186
     C+  ,WHSREF = :P_WHSREF                                                                MD056612
     C+  ,WHDS01 = :P_WHDS01                                                                MD056612
     C+  ,WHDS02 = :P_WHDS02                                                                MD056612
     C+  ,WHDS03 = :P_WHDS03                                                                MD056612
     C+  ,WHDS04 = :P_WHDS04                                                                MD056612
     C+  ,WHDS05 = :P_WHDS05                                                                MD056612
     C+  ,WHDS06 = :P_WHDS06                                                                MD056612
     C+  ,WHDS07 = :P_WHDS07                                                                MD056612
     C+  ,WHDS08 = :P_WHDS08                                                                MD056612
     C+  ,WHDS09 = :P_WHDS09                                                                MD056612
     C+  ,WHDS10 = :P_WHDS10                                                                MD056612
     C+  ,WHDS11 = :P_WHDS11                                                                MD056612
     C+ where WHFILE = :WHFILE and WHFSQN = :WHFSQN and WHFOBO = :WHFOBO                    MD056612
     C/end-exec                                                                             MD056612
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Get Export Format Field
      ********************************************************************
     C     GET_EXFF      BEGSR

     C*****MXEXFFK       CHAIN     MXEXFFP0                           60        *           MD056612
     C/EXEC SQL                                                                             MD056612
     C+ SELECT *                                                                            MD056612
     C+ into :MXEXFF                                                                        MD056612
     C+ from MXEXFJW0                                                                       MD056612
     C+ where WHFILE = :WHFILE and WHFSQN = :WHFSQN and WHFOBO = :WHFOBO                    MD056612
     C/END-EXEC                                                                             MD056612
     C******IN60         IFEQ      '1'                                                      MD056612
     C     SQLCODE       IFEQ      100                                                      MD056612
     C                   EVAL      I#ERMS = 'MISSING RECORD ON MXEXFFPD'
     C                   EXSR      *PSSR
     C                   ENDIF

      * Set up fields for display

      * Meridian Field Name
     C                   MOVEL     WHMFNM        DDMFNM

      * Sequence
     C                   MOVE      WHIBO         DDIBO

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
     C                   MOVEL     'MXEXFFMNT'   DDPGM
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

      * Mode (U = Allow updates)

     C     I#MODE        IFEQ      'U'
     C                   MOVE      '1'           *IN61
     C                   ENDIF

      * Key lists

     C     MXEXFFK       KLIST
     C                   KFLD                    WHFILE
     C                   KFLD                    WHFSQN
     C                   KFLD                    WHFOBO
     C     MXEXFFKAL     KLIST
     C                   KFLD                    WHFILE
     C                   KFLD                    WHFSQN
     C                   KFLD                    WHMFNM

     C                   ENDSR
      *****************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY MXCPYSRC,MXPSSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2001
** #_SREF
 123456789
