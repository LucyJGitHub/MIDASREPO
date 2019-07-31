     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*XBIF*: OVRDBF FILE(MXDGECL1X) TOFILE(MXDGECL1) SHARE(*NO)         : *
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MX Data Group Event Categories Maintenance')
      *****************************************************************
      *                                                               *
      *  Midas - Meridian Export Module                               *
      *                                                               *
      *  MXDGECMNT - Data Group Event Categories Maintenance          *
      *                                                               *
      *  Function:  This module maintains data group event categories *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CAAA03             Date 12Mar04               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                         *CREATE    Date                       *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CAAA03 - Webfacing Changes                                   *
      *  CMX001 - Meridian Export                                     *
      *                                                               *
      *****************************************************************
 
     FMXDGECMDD CF   E             WORKSTN
     FMXDGECL1  IF   E           K DISK
     FMXDGECL1X UF A E           K DISK
     F                                     RENAME(MXDGECP0:MXDGECUPD)
     F                                     PREFIX(P_)
 
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
 
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for BANK details
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
     D MXDGEC        E DS                  EXTNAME(MXDGECPD)
     D ACKY01                 38     38A
     D ACKY02                 39     39A
     D ACKY03                 40     40A
     D ACKY04                 41     41A
     D ACKY05                 42     42A
     D ACKY06                 43     43A
     D ACKY07                 44     44A
     D ACKY08                 45     45A
     D ACKY09                 46     46A
     D ACKY10                 47     47A
     D ACKY11                 48     48A
     D ACKY12                 49     49A
     D ACKY13                 50     50A
     D ACKY14                 51     51A
     D ACKY15                 52     52A
     D ACKY16                 53     53A
     D ACKY17                 54     54A
     D ACKY18                 55     55A
     D ACKY19                 56     56A
     D ACKY20                 57     57A
      * Data Group Event Categories
 
     D P_MXDGEC      E DS                  EXTNAME(MXDGECPD)
     D                                     PREFIX(P_)
      * Data Group Event Categories
 
     D MXDGDT        E DS                  EXTNAME(MXDGDTPD)
      * Data Group Details
 
 
     D #_CATC          S              2    DIM(100) CTDATA PERRCD(20)
 
 
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           30
     C                   PARM                    I#MODE            1
     C                   PARM                    MXDGEC
     C                   PARM                    MXDGDT
     C                   PARM                    @INKC             1
     C                   PARM                    @INKL             1
 
      * Get data group event category
 
     C                   EXSR      GET_DGEC
 
      * Display screen until F3, F6, F10 or F12 taken
 
     C     *INKC         DOWEQ     '0'
     C     *INKF         ANDEQ     '0'
     C     *INKJ         ANDEQ     '0'
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
 
      * Delete the primary record
 
     C     *INKJ         CASEQ     '1'           DEL_PrmREC
 
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
 
      *  Validate category code
 
     C     DECATC        IFNE      *BLANK
     C     DECATC        LOOKUP    #_CATC                                 99    *
     C     *in99         IFEQ      '0'
     C                   MOVEL     'MX00310'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN10
     C                   ENDIF
     C                   ELSE
     C                   MOVEL     'MX00310'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN10
     C                   ENDIF
 
      * If add required, check that record does not already exist
 
     C     *IN60         IFEQ      '1'
     C                   MOVEL     MXDGEC        P_MXDGEC
     C     MXDGECK       CHAIN     MXDGECP0                           99        *
     C     *in99         IFEQ      '0'
     C                   MOVEL     P_MXDGEC      MXDGEC
     C                   MOVEL     'MX00315'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN10
     C                   ENDIF
     C                   ENDIF
 
      * Validate description
      * It must be entered
 
     C     DEDESC        IFEQ      *BLANK
     C                   MOVEL     'MX00311'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN11
     C                   ENDIF
 
      * Validate trigger
      * It must be 'Y' or 'N'
 
     C     DETRIG        IFNE      'Y'
     C     DETRIG        ANDNE     'N'
     C                   MOVEL     'MX00312'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN12
     C                   ENDIF
 
      * Set account key template
 
     C                   EXSR      SET_ACKY_T
 
      * Validate accumulation method
      * It must be 'A' (ADD) or 'T' (TOTAL)
 
     C     DEACUM        IFEQ      ' '
     C                   MOVE      'A'           DEACUM
     C                   ENDIF
     C     DEACUM        IFNE      'A'
     C     DEACUM        ANDNE     'T'
     C                   MOVEL     'MX00314'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN16
     C                   ENDIF
 
      * Validate capital change indicator
      * It must be blank, 'I' (INCREASE) or 'D' (DECREASE)
 
     C     DECAPI        IFNE      ' '
     C     DECAPI        ANDNE     'I'
     C     DECAPI        ANDNE     'D'
     C                   MOVEL     'MX00316'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN17
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
      * Set account key template
      ********************************************************************
     C     SET_ACKY_T    BEGSR
 
     C     DGAK01        IFNE      'Y'
     C                   MOVE      '*'           ACKY01
     C                   END
     C     DGAK02        IFNE      'Y'
     C                   MOVE      '*'           ACKY02
     C                   END
     C     DGAK03        IFNE      'Y'
     C                   MOVE      '*'           ACKY03
     C                   END
     C     DGAK04        IFNE      'Y'
     C                   MOVE      '*'           ACKY04
     C                   END
     C     DGAK05        IFNE      'Y'
     C                   MOVE      '*'           ACKY05
     C                   END
     C     DGAK06        IFNE      'Y'
     C                   MOVE      '*'           ACKY06
     C                   END
     C     DGAK07        IFNE      'Y'
     C                   MOVE      '*'           ACKY07
     C                   END
     C     DGAK08        IFNE      'Y'
     C                   MOVE      '*'           ACKY08
     C                   END
     C     DGAK09        IFNE      'Y'
     C                   MOVE      '*'           ACKY09
     C                   END
     C     DGAK10        IFNE      'Y'
     C                   MOVE      '*'           ACKY10
     C                   END
     C     DGAK11        IFNE      'Y'
     C                   MOVE      '*'           ACKY11
     C                   END
     C     DGAK12        IFNE      'Y'
     C                   MOVE      '*'           ACKY12
     C                   END
     C     DGAK13        IFNE      'Y'
     C                   MOVE      '*'           ACKY13
     C                   END
     C     DGAK14        IFNE      'Y'
     C                   MOVE      '*'           ACKY14
     C                   END
     C     DGAK15        IFNE      'Y'
     C                   MOVE      '*'           ACKY15
     C                   END
     C     DGAK16        IFNE      'Y'
     C                   MOVE      '*'           ACKY16
     C                   END
     C     DGAK17        IFNE      'Y'
     C                   MOVE      '*'           ACKY17
     C                   END
     C     DGAK18        IFNE      'Y'
     C                   MOVE      '*'           ACKY18
     C                   END
     C     DGAK19        IFNE      'Y'
     C                   MOVE      '*'           ACKY19
     C                   END
     C     DGAK20        IFNE      'Y'
     C                   MOVE      '*'           ACKY20
     C                   END
 
     C     DECATC        IFEQ      '00'
     C                   MOVE      *ALL'*'       DEACKY
     C                   END
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Update the primary record
      ********************************************************************
     C     UPD_PrmREC    BEGSR
 
     C     MXDGECK       CHAIN     MXDGECUPD                          99        *
     C                   MOVEL     MXDGEC        P_MXDGEC
     C     *in99         IFEQ      '1'
     C                   WRITE     MXDGECUPD                                    *
     C                   ELSE
     C                   UPDATE    MXDGECUPD                                    *
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Delete the primary record
      ********************************************************************
     C     DEL_PrmREC    BEGSR
 
     C     MXDGECK       CHAIN     MXDGECUPD                          99        *
     C     *in99         IFEQ      '0'
     C                   DELETE    MXDGECUPD                                    *
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Get Data Group Event Category
      ********************************************************************
     C     GET_DGEC      BEGSR
 
     C     MXDGECK       CHAIN     MXDGECP0                           60        *
     C     *IN60         IFEQ      '1'
     C                   CLEAR                   MXDGEC
     C                   ENDIF
 
     C                   MOVEL     DGDTAG        DEDTAG
 
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
      /SPACE 5
      *****************************************************************
      * *INZSR - Initial subroutine called automatically at program start
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** Initialize program name
      *
     C                   MOVEL     'MXDGECMNT'   DDPGM
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
 
      * Mode (U = Allow updates, L = Allow Limited Updates)
 
     C     I#MODE        IFEQ      'U'
     C                   MOVE      '1'           *IN61
     C                   MOVE      '1'           *IN62
     C                   ENDIF
     C     I#MODE        IFEQ      'L'
     C                   MOVE      '1'           *IN62
     C                   ENDIF
 
      * Key lists
 
     C     MXDGECK       KLIST
     C                   KFLD                    DEDTAG
     C                   KFLD                    DECATC
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY MXCPYSRC,MXPSSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2001
** #_CATC
0102030405060708091011121314151617181920
2122232425262728293031323334353637383940
4142434445464748495051525354555657585960
6162636465666768697071727374757677787980
8182838485868788899091929394959697989900
