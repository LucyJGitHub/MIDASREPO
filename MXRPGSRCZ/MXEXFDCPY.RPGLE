     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*XBIA*  OVRDBF FILE(MXEXFDPDX) TOFILE(MXEXFDPD) SHARE(*NO)           *
/*XBIB*  OVRDBF FILE(MXEXFFL1X) TOFILE(MXEXFFL1) SHARE(*NO)           *
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MX Export Format Fields Copy')
      *****************************************************************
      *                                                               *
      *  Midas - Meridian Export Module                               *
      *                                                               *
      *  MXEXFDCPY - Export Format Fields Copy                        *
      *                                                               *
      *  Function:  This module copies export format fields           *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *  Last Amend No. CMX003             Date 05Nov00               *
      *  Prev Amend No. CMX001  *CREATE    Data 01Jan00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CMX003 - Meridian Export Enhancements - Phase 2              *
      *  CMX001 - Meridian Export                                     *
      *                                                               *
      *****************************************************************
 
     FMXEXFDCDD CF   E             WORKSTN
     FMXEXFDPD  IF   E           K DISK
     FMXEXFDL2  IF   E           K DISK
     F                                     RENAME(MXEXFDP0:MXEXFDALT)
     FMXEXFDPDX O    E           K DISK
     F                                     RENAME(MXEXFDP0:MXEXFDWRT)
     FMXEXFFL1  IF A E           K DISK
     FMXEXFFL1X UF A E           K DISK
     F                                     RENAME(MXEXFFP0:MXEXFFUPD)
 
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
 
 
     D MXEXFD        E DS                  EXTNAME(MXEXFDPD)
      * Export Format Details
     D P_MXEXFD      E DS                  EXTNAME(MXEXFDPD)
     D                                     PREFIX(P_)
      * Export Format Details
     D MXEXFF        E DS                  EXTNAME(MXEXFFPD)
      * Export Format Fields
 
     D P_MXEXFF      E DS                  EXTNAME(MXEXFFPD)
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
 
     C     MXEXFDK       CHAIN     MXEXFDP0                           99        *
     C     *in99         IFEQ      '0'
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
 
     C     MXEXFDKAL     CHAIN     MXEXFDALT                          99        *
     C     *in99         IFEQ      '0'
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
 
     C     MXEXFDK_F     CHAIN     MXEXFDP0                           99
     C     *in99         IFEQ      '0'
     C                   MOVEL     MXEXFD        P_MXEXFD
     C                   MOVEL     DDTFIL        P_EXFILE
     C                   MOVEL     DDTFSQ        P_EXFSQN
     C                   MOVEL     DDTFMT        P_EXFMT
     C     MXEXFDK       CHAIN     MXEXFDP0                           99
     C     *in99         IFEQ      '1'
     C                   MOVEL     P_MXEXFD      MXEXFD
     C                   WRITE     MXEXFDWRT
     C                   ENDIF
     C                   ENDIF
 
      * Add export format field records
 
     C     MXEXFDK_F     SETLL     MXEXFFP0
     C     MXEXFDK_F     READE     MXEXFFP0                               99
     C     *IN99         DOWEQ     '0'
 
     C                   MOVEL     MXEXFF        P_MXEXFF
     C                   MOVEL     DDTFIL        P_WHFILE
     C                   MOVEL     DDTFSQ        P_WHFSQN
     C     MXEXFFK       CHAIN     MXEXFFUPD                          99
     C                   MOVEL     P_MXEXFF      MXEXFF
     C     *in99         IFEQ      '1'
     C                   WRITE     MXEXFFUPD
     C                   ELSE
     C                   UPDATE    MXEXFFUPD
     C                   ENDIF
     C     MXEXFDK_F     READE     MXEXFFP0                               99
     C                   ENDDO
 
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
     C     MXEXFDK_F     KLIST
     C                   KFLD                    DDFFIL
     C                   KFLD                    DDFFSQ
     C     MXEXFFK       KLIST
     C                   KFLD                    P_WHFILE
     C                   KFLD                    P_WHFSQN
     C                   KFLD                    P_WHFOBO
 
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
(c) Misys International Banking Systems Ltd. 2001
** #_SQN
0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ
** #_CHKF
CHKOBJ OBJ(          ) OBJTYPE(*FILE) AUT(*USE)
