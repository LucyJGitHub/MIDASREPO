     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*XBIF*: OVRDBF FILE(MXEXFFL1X) TOFILE(MXEXFFL1) SHARE(*NO)         : *
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MX Export Format Fields Maintenance')
      *****************************************************************
      *                                                               *
      *  Midas - Meridian Export Module                               *
      *                                                               *
      *  MXEXFFMNT - Export Format Fields Maintenance                 *
      *                                                               *
      *  Function:  This module maintains export format fields        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CAAA03             Date 12Mar04               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *  Prev Amend No. CMX001  *CREATE    Data 01Jan00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CAAA03 - Webfacing Changes                                   *
      *  CMX001 - Meridian Export                                     *
      *                                                               *
      *****************************************************************
 
     FMXEXFFMDD CF   E             WORKSTN
     FMXEXFFL1  IF   E           K DISK
     FMXEXFFL1X UF   E           K DISK
     F                                     RENAME(MXEXFFP0:MXEXFFUPD)
     F                                     PREFIX(P_)
     FMXEXFFL2  IF   E           K DISK
     F                                     RENAME(MXEXFFP0:MXEXFFALT)
 
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
 
     D MXEXFF        E DS                  EXTNAME(MXEXFFPD)
      * Export Format Fields
 
     D P_MXEXFF      E DS                  EXTNAME(MXEXFFPD)
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
     C     MXEXFFKAL     CHAIN     MXEXFFALT                          99        *
     C     *in99         IFEQ      '0'
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
 
     C     MXEXFFK       CHAIN     MXEXFFUPD                          99        *
     C                   MOVEL     MXEXFF        P_MXEXFF
     C     *in99         IFEQ      '0'
     C                   UPDATE    MXEXFFUPD                                    *
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Get Export Format Field
      ********************************************************************
     C     GET_EXFF      BEGSR
 
     C     MXEXFFK       CHAIN     MXEXFFP0                           60        *
     C     *IN60         IFEQ      '1'
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
(c) Misys International Banking Systems Ltd. 2001
** #_SREF
 123456789
