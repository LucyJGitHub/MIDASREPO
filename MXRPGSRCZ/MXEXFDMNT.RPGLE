     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MX Export Format Details Maintenance')
      *****************************************************************
      *                                                               *
      *  Midas - Meridian Export Module                               *
      *                                                               *
      *  MXEXFDMNT - Export Format Details Maintenance                *
      *                                                               *
      *  Function:  This module maintains export format details       *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CMX013             Date 29Jun06               *
      *  Prev Amend No. CAAA03             Date 12Mar04               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CMX003             Date 05Nov00               *
      *                 CMX001  *CREATE    Data 01Jan00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CMX013 - Allow Additonal Members                             *
      *  CAAA03 - Webfacing Changes                                   *
      *  CMX003 - Meridian Export Enhancements - Phase 2              *
      *  CMX001 - Meridian Export                                     *
      *                                                               *
      *****************************************************************
 
     FMXEXFDMDD CF   E             WORKSTN
     F                                     SFILE(SUBFLREC:SUBF_RRN)
     FMXEXFDPD  IF   E           K DISK
     FMXEXFDL1  UF A E           K DISK
     F                                     RENAME(MXEXFDP0:MXEXFDUPD)
     F                                     PREFIX(P_)
     FMXEXFDL2  IF   E           K DISK
     F                                     RENAME(MXEXFDP0:MXEXFDALT)
     FMXEXFFPD  IF   E           K DISK
     FMXEXFSPD  IF   E           K DISK
 
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
 
     D MXEXFD        E DS                  EXTNAME(MXEXFDPD)
      * Export Format Details
     D P_MXEXFD      E DS                  EXTNAME(MXEXFDPD)
     D                                     PREFIX(P_)
      * Export Format Details
 
     D MXEXFF        E DS                  EXTNAME(MXEXFFPD)
      * Export Format Fields
 
 
      * Field Attributes
     D                 DS
     D DDATRB                  1     11
     D DDLEN                   1      3
     D DDTYP                   4      4
     D DDOPNB                  6      6
     D DDDIG                   7      8
     D DDCOMA                  9      9
     D DDDEC                  10     10
     D DDCLOB                 11     11
 
 
     D #_DSP           S              1    DIM(90) CTDATA PERRCD(65)
     D*#_SQN***********S              1    DIM(10) CTDATA PERRCD(10)            CMX003
     D #_SQN           S              1    DIM(36) CTDATA PERRCD(36)            CMX003
     D #_CHKF          S              1    DIM(47) CTDATA PERRCD(47)
     D #_CHKM          S              1    DIM(49) CTDATA PERRCD(49)
     D #_ACSP          S              1    DIM(6)  CTDATA PERRCD(6)
     D #_CPY           S              1    DIM(90) CTDATA PERRCD(55)
 
 
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           30
     C                   PARM                    I#MODE            1
     C                   PARM                    MXEXFD
     C                   PARM                    @INKC             1
     C                   PARM                    @INKL             1
 
      * Get Export Format Details
 
     C                   EXSR      GET_EXFD
 
      * Display subfile screen until F3, F6, F10 or F12 taken
 
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
      * Display subfile screen
      *****************************************************************
     C     DSPLAY_SCN    BEGSR
 
      * Fill current subfile page
     C     *IN05         IFEQ      '1'
     C     *IN06         OREQ      '1'
     C     SUBF_RRN      OREQ      *ZERO
     C  N50              EXSR      FILL_SUBF
     C                   ENDIF
 
      * Write subfile control and foooter
 
     C                   TIME                    DDTIME
     C                   WRITE     MSGSUBCT
     C**********         WRITE     SUBFLCTL                                                   CAAA03
     C                   WRITE     FOOTER
 
      * Read subfile control
 
     C                   WRITE     SUBFLCTL                                                   CAAA03
     C                   READ      SUBFLCTL                               99    *
 
      ** Clear the message queue & init error indicators
 
     C                   EXSR      CLR_MSGQ
 
      ** If F3 and F12 were not taken
 
     C     *INKC         IFEQ      '0'
     C     *INKL         ANDEQ     '0'
 
      * Rolldown requested
 
     C     *IN05         CASEQ     '1'           ROLLDOWN
 
      * Delete the primary record
 
     C     *INKJ         CASEQ     '1'           DEL_PrmREC
 
      * Toggle Name/Text
 
     C     *INKQ         CASEQ     '1'           TOG_NT
 
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
     C                   MOVEA     '0000000000'  *IN(20)
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *****************************************************************
      * Validate the screen
      *****************************************************************
     C     VALID_SCN     BEGSR
 
      *  Validate File
 
     C     EXFILE        IFEQ      *BLANK
     C                   MOVEL     'MX00500'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN10
     C                   ELSE
     C                   MOVEA     EXFILE        #_CHKF(12)
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
 
      *  Validate File Sequence
 
     C     EXFSQN        IFEQ      *BLANK
     C                   MOVEL     'MX00501'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN11
     C                   ELSE
     C     EXFSQN        LOOKUP    #_SQN                                  99    *
     C     *in99         IFEQ      '0'
     C                   MOVEL     'MX00501'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN11
     C                   ENDIF
     C                   ENDIF
 
      * If add required, check that record does not already exist
 
     C     *IN60         IFEQ      '1'
     C                   MOVEL     MXEXFD        P_MXEXFD
     C     MXEXFDK       CHAIN     MXEXFDP0                           99        *
     C     *in99         IFEQ      '0'
     C                   MOVEL     P_MXEXFD      MXEXFD
     C                   MOVEL     'MX00517'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN10
     C                   MOVE      '1'           *IN11
     C                   ENDIF
     C                   ENDIF
 
      * Validate description
      * It must be entered
 
     C     EXDESC        IFEQ      *BLANK
     C                   MOVEL     'MX00502'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN12
     C                   ENDIF
 
      *  Validate Format
 
     C     EXFMT         IFEQ      *BLANK
     C                   MOVEL     'MX00503'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN13
     C                   ELSE
      * Check makeup
     C                   EVAL      ZFD2BV  = EXFMT
     C                   EVAL      ZFDLC   = 'N'
     C                   EVAL      ZFDUC   = 'Y'
     C                   EVAL      ZFDNM   = 'Y'
     C                   EVAL      ZFDOTHC = '          '
     C                   EXSR      VAL_FDMU
     C     ZFDError      IFEQ      'Y'
     C                   MOVEL     'MX00503'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN13
     C                   ENDIF
     C                   ENDIF
 
      * If add required, check that format does not already exist
 
     C     *IN60         IFEQ      '1'
     C                   MOVEL     MXEXFD        P_MXEXFD
     C     MXEXFDKAL     CHAIN     MXEXFDALT                          99        *
     C     *in99         IFEQ      '0'
     C                   MOVEL     P_MXEXFD      MXEXFD
     C                   MOVEL     'MX00518'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN13
     C                   ENDIF
     C                   ENDIF
 
      * Check makeup of message queue name
 
     C     EXMSGQ        IFNE      *BLANK
     C                   EVAL      ZFD2BV  = EXMSGQ
     C                   EVAL      ZFDLC   = 'N'
     C                   EVAL      ZFDUC   = 'Y'
     C                   EVAL      ZFDNM   = 'Y'
     C                   EVAL      ZFDOTHC = '._/       '
     C                   EXSR      VAL_FDMU
     C     ZFDError      IFEQ      'Y'
     C                   MOVEL     'MX00504'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN14
     C                   ENDIF
     C                   ENDIF
 
      *  Validate 'Drip-feed'
 
     C     EXDRIP        IFEQ      ' '
     C                   MOVE      'N'           EXDRIP
     C                   ENDIF
     C     EXDRIP        IFNE      'Y'
     C     EXDRIP        ANDNE     'N'
     C                   MOVEL     'MX00505'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN15
     C                   ENDIF
 
      * Validate records per MQ message
      * It must be 1 or 999
 
     C                   MOVEL     *BLANK        ZFIELD
     C                   MOVEL     DDRECM        ZFIELD
     C                   CALLB     'ZALIGN'
     C                   PARM                    ZALIGNok          1
     C                   PARM                    ZFIELD           16
     C                   PARM      0             ZADEC             1 0
     C                   PARM      3             ZADIG             2 0
     C     ZALIGNok      IFNE      'Y'
     C                   MOVEL     'MX00506'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN16
     C                   ELSE
     C                   MOVE      ZFIELD        EXRECM
     C     EXRECM        IFNE      1
     C     EXRECM        ANDNE     999
     C                   MOVEL     'MX00506'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN16
     C                   ENDIF
     C                   ENDIF
 
      * Validate log performance
      * It must be 'Y'  or 'N'
 
     C     EXLOGP        IFEQ      *BLANK
     C                   MOVE      'N'           EXLOGP
     C                   ENDIF
     C     EXLOGP        IFNE      'Y'
     C     EXLOGP        ANDNE     'N'
     C                   MOVEL     'MX00507'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN17
     C                   ENDIF
 
      * Validate message transmission report type
      * It must be 'F' (full), 'S' (sample) 'A' (audit) or blank (no report)
 
     C     EXMTRT        IFNE      'F'
     C     EXMTRT        ANDNE     'S'
     C     EXMTRT        ANDNE     'A'
     C     EXMTRT        ANDNE     ' '
     C                   MOVEL     'MX00508'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN18
     C                   ENDIF
 
      * Validate export frequency
      * It must be daily, weekly, monthly or last calendar day in month
      * or on request
 
     C     EXEXFQ        IFNE      'D'
     C     EXEXFQ        ANDNE     'W'
     C     EXEXFQ        ANDNE     'M'
     C     EXEXFQ        ANDNE     'L'
     C     EXEXFQ        ANDNE     'Z'
     C                   MOVEL     'MX00509'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN19
     C                   ENDIF
 
      * Validate export day in month
 
     C                   MOVEL     *BLANK        ZFIELD
     C                   MOVEL     DDEXDY        ZFIELD
     C                   CALLB     'ZALIGN'
     C                   PARM                    ZALIGNok          1
     C                   PARM                    ZFIELD           16
     C                   PARM      0             ZADEC             1 0
     C                   PARM      2             ZADIG             2 0
     C     ZALIGNok      IFNE      'Y'
     C                   MOVEL     'MX00510'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN20
     C                   ELSE
 
     C                   MOVE      ZFIELD        EXEXDY
      * daily
      * weekly
      * last calendar day in month
      * on request
     C     EXEXFQ        IFEQ      'D'
     C     EXEXDY        ANDNE     *ZERO
     C     EXEXFQ        OREQ      'W'
     C     EXEXDY        ANDNE     *ZERO
     C     EXEXFQ        OREQ      'L'
     C     EXEXDY        ANDNE     *ZERO
     C     EXEXFQ        OREQ      'Z'
     C     EXEXDY        ANDNE     *ZERO
     C                   MOVEL     'MX00510'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN20
     C                   ENDIF
      * monthly
     C     EXEXFQ        IFEQ      'M'
     C     EXEXDY        ANDLT     1
     C     EXEXFQ        OREQ      'M'
     C     EXEXDY        ANDGT     31
     C                   MOVEL     'MX00510'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN20
     C                   ENDIF
 
     C                   ENDIF
 
      * Validate next export date
      * If export frequency is Z it must not be entered
      * Otherwise it must be entered and must be <= run date
 
      * If Z
     C     EXEXFQ        IFEQ      'Z'
 
     C     DDEXND        IFNE      *BLANK
     C                   MOVEL     'MX00511'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN21
     C                   ELSE
     C                   Z-ADD     *ZERO         EXEXND
     C                   ENDIF
 
      * If NOT Z
     C                   ELSE
 
     C                   MOVEL     *BLANK        ZFIELD
     C                   MOVEL     DDEXND        ZFIELD
     C                   CALLB     'ZALIGN'
     C                   PARM                    ZALIGNok          1
     C                   PARM                    ZFIELD           16
     C                   PARM      0             ZADEC             1 0
     C                   PARM      6             ZADIG             2 0
     C     ZALIGNok      IFNE      'Y'
     C                   MOVEL     'MX00511'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN21
     C                   ELSE
 
     C                   MOVE      ZFIELD        ZDATE
 
     C                   CALLB     'ZDATE1'
     C                   PARM                    ZDATE             6
     C                   PARM                    ZDAYNO            5 0
     C                   PARM                    BJDFIN
     C                   PARM                    ErrorFlag         1
 
     C     ErrorFlag     IFEQ      'Y'
     C     ZDAYNO        ORLT      BJRDNB
     C                   MOVEL     'MX00511'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN21
     C                   ELSE
     C                   Z-ADD     ZDAYNO        EXEXND
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
 
      * Validate export member
      * It must start with a 'C' and end in a number between 1 and 60.
 
     C                   MOVEL     DDXMEM        Check_1A          1
     C                   MOVE      DDXMEM        Check_4A          4
 
     C     Check_1A      IFNE      'C'
     C**********         MOVEL     'MX00022'     ZAMSID                                       CMX013
     C**********         EXSR      ZASNMS                                                     CMX013
     C                   MOVE      '1'           *IN22
     C                   ENDIF
     C                   TESTN                   Check_4A             9898
     C     *IN98         IFEQ      '0'
     C**********         MOVEL     'MX00022'     ZAMSID                                       CMX013
     C**********         EXSR      ZASNMS                                                     CMX013
     C                   MOVE      '1'           *IN22
     C                   ELSE
     C                   MOVEL     Check_4A      Check_4N          4 0
     C     Check_4N      IFLT      1
     C     Check_4N      ORGT      60
     C**********         MOVEL     'MX00022'     ZAMSID                                       CMX013
     C**********         EXSR      ZASNMS                                                     CMX013
     C                   MOVE      '1'           *IN22
     C                   ELSE
     C                   MOVE      Check_4N      DDXMEM
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CMX013
      * If member standard (C0001 to C0060) set off Add Member flag, else validate            CMX013
      *                                                                                       CMX013
     C     *IN22         IFEQ      '0'                                                        CMX013
     C                   MOVE      'N'           W#ADDMBR          1                          CMX013
     C                   ELSE                                                                 CMX013
     C                   MOVE      '0'           *IN22                                        CMX013
     C                   MOVE      'Y'           W#ADDMBR                                     CMX013
      *                                                                                       CMX013
      * Format should be one character followed by either characters or digits.               CMX013
      *                                                                                       CMX013
     C                   IF        NOT(                                                       CMX013
     C                             (%Subst(DDXMEM:1:1) >= 'A' AND                             CMX013
     C                              %Subst(DDXMEM:1:1) <= 'Z'))                               CMX013
     C                   MOVE      '1'           *IN22                                        CMX013
     C                   ENDIF                                                                CMX013
      *                                                                                       CMX013
     C                   IF        NOT(                                                       CMX013
     C                             (%Subst(DDXMEM:2:1) >= 'A' AND                             CMX013
     C                              %Subst(DDXMEM:2:1) <= 'Z') OR                             CMX013
     C                             (%Subst(DDXMEM:2:1) >= '0' AND                             CMX013
     C                              %Subst(DDXMEM:2:1) <= '9'))                               CMX013
     C                   MOVE      '1'           *IN22                                        CMX013
     C                   ENDIF                                                                CMX013
      *                                                                                       CMX013
     C                   IF        NOT(                                                       CMX013
     C                             (%Subst(DDXMEM:3:1) >= 'A' AND                             CMX013
     C                              %Subst(DDXMEM:3:1) <= 'Z') OR                             CMX013
     C                             (%Subst(DDXMEM:3:1) >= '0' AND                             CMX013
     C                              %Subst(DDXMEM:3:1) <= '9'))                               CMX013
     C                   MOVE      '1'           *IN22                                        CMX013
     C                   ENDIF                                                                CMX013
      *                                                                                       CMX013
     C                   IF        NOT(                                                       CMX013
     C                             (%Subst(DDXMEM:4:1) >= 'A' AND                             CMX013
     C                              %Subst(DDXMEM:4:1) <= 'Z') OR                             CMX013
     C                             (%Subst(DDXMEM:4:1) >= '0' AND                             CMX013
     C                              %Subst(DDXMEM:4:1) <= '9'))                               CMX013
     C                   MOVE      '1'           *IN22                                        CMX013
     C                   ENDIF                                                                CMX013
      *                                                                                       CMX013
     C                   IF        NOT(                                                       CMX013
     C                             (%Subst(DDXMEM:5:1) >= 'A' AND                             CMX013
     C                              %Subst(DDXMEM:5:1) <= 'Z') OR                             CMX013
     C                             (%Subst(DDXMEM:5:1) >= '0' AND                             CMX013
     C                              %Subst(DDXMEM:5:1) <= '9'))                               CMX013
     C                   MOVE      '1'           *IN22                                        CMX013
     C                   ENDIF                                                                CMX013
      *                                                                                       CMX013
     C                   IF        *IN22 = '1'                                                CMX013
     C                   MOVEL     'MX00022'     ZAMSID                                       CMX013
     C                   EXSR      ZASNMS                                                     CMX013
     C                   ENDIF                                                                CMX013
      *                                                                                       CMX013
     C                   ENDIF                                                                CMX013
      *                                                                                       CMX013
     C                   MOVEL     DDXMEM        EXXMEM
 
      *  Validate Access Module (if defined)
 
     C     EXACSM        IFNE      *BLANK
     C                   MOVEA     EXACSM        #_CHKM(12)
     C                   Z-ADD     49            #MesLen          15 5
     C                   CALL      'QCMDEXC'                            9999    *
     C                   PARM                    #_CHKM
     C                   PARM                    #MesLen
     C     *IN99         IFEQ      '1'
     C                   MOVEL     'MX00512'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN23
     C                   ENDIF
     C                   ENDIF
 
      *  Validate Access Number of Parameters
 
     C     EXACSM        IFNE      *BLANK
     C     DDACSP        LOOKUP    #_ACSP                                 99    *
     C     *in99         IFEQ      '0'
     C                   MOVEL     'MX00513'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN24
     C                   ELSE
     C                   MOVEL     DDACSP        EXACSP
     C                   ENDIF
     C                   ELSE
     C                   MOVEL     '0'           DDACSP
     C                   Z-ADD     *ZERO         EXACSP
     C                   ENDIF
 
      *  Validate Access Multiple
 
     C     EXACSM        IFNE      *BLANK
     C     EXACSX        IFNE      'Y'
     C     EXACSX        ANDNE     'N'
     C                   MOVEL     'MX00514'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN25
     C                   ENDIF
     C                   ELSE
     C                   MOVEL     'N'           EXACSX
     C                   ENDIF
 
      *  Validate Access Through
 
     C     EXACSM        IFNE      *BLANK
     C     EXACST        ANDEQ     *BLANK
     C                   MOVEL     'MX00515'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN26
     C                   ENDIF
 
      *  Validate 'Create Fields'
 
     C     DDCRFD        IFNE      'Y'
     C     DDCRFD        ANDNE     'N'
     C                   MOVEL     'MX00516'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN27
     C                   ENDIF
 
      * If any fields are in error
      *  Disable F6 (if it was taken)
 
     C     *in50         IFEQ      '1'
     C                   MOVE      '0'           *INKF
 
      * Otherwise
 
     C                   ELSE
 
      * Update the primary record
 
     C     *INKF         CASEQ     '1'           UPD_PrmREC
 
      * Selection criteria maintenance requested
 
     C     *INKH         CASEQ     '1'           SELECT_MNT
 
      * Check for a record selected from the subfile
 
     C     *IN(04)       CASEQ     '0'           CHK_SUBF
     C                   END
 
     C                   ENDIF
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *****************************************************************
      * Update the primary record
      ********************************************************************
     C     UPD_PrmREC    BEGSR
 
     C     MXEXFDK       CHAIN     MXEXFDUPD                          99        *
     C                   MOVEL     MXEXFD        P_MXEXFD
     C     *in99         IFEQ      '1'
     C                   MOVEL     'Y'           P_EXENAB
     C                   WRITE     MXEXFDUPD                                    *
     C                   ELSE
     C                   UPDATE    MXEXFDUPD                                    *
     C                   ENDIF
 
      * If 'create fields' requested
 
     C     DDCRFD        IFEQ      'Y'
 
      * Lock record
 
     C     MXEXFDK       CHAIN     MXEXFDUPD                          98        *
 
      * Do DSPFFD of file fields
 
     C                   MOVEA     EXFILE        #_DSP(13)
     C                   Z-ADD     88            #MesLen          15 5
     C                   CALL      'QCMDEXC'                            9999    *
     C                   PARM                    #_DSP
     C                   PARM                    #MesLen
     C     *IN99         IFEQ      '1'
     C                   EVAL      I#ERMS = 'ERROR IN DSPFFD OF FILE'
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * CPYF the data into MXEXFFZZ
 
     C                   Z-ADD     90            #MesLen          15 5
     C                   CALL      'QCMDEXC'                            9999    *
     C                   PARM                    #_CPY
     C                   PARM                    #MesLen
     C     *IN99         IFEQ      '1'
     C                   EVAL      I#ERMS = 'ERROR IN CPYF TO MXEXFFZZ'
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * Create export format file fields
 
     C                   CALL      'MXEXFFCRT'
     C                   PARM      *BLANK        W#RTCD            7
     C                   PARM      *BLANK        W#ERMS           30
     C                   PARM                    EXFILE
     C                   PARM                    EXFSQN
 
      * Error
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO MXEXFFCRT'
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * Meridian Field Name Duplicate Check
 
     C                   CALL      'MXMFNMDPC'
     C                   PARM      *BLANK        W#RTCD            7
     C                   PARM      *BLANK        W#ERMS           30
     C                   PARM                    EXFILE
     C                   PARM                    EXFSQN
 
      * Error
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO MXMFNMDPC'
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * Release record
 
     C  N98              MOVEL     'Y'           P_EXFDCR
     C  N98              UPDATE    MXEXFDUPD                                    *
     C                   ENDIF
      *                                                                                       CMX013
      * If member entered is non-standard, call program to add member to files                CMX013
      *                                                                                       CMX013
     C     W#ADDMBR      IFEQ      'Y'                                                        CMX013
     C                   CALL      'MXC0460'                                                  CMX013
     C                   PARM      *BLANKS       W#RTCD                                       CMX013
     C                   PARM                    EXXMEM                                       CMX013
      *                                                                                       CMX013
      * Error                                                                                 CMX013
     C     W#RTCD        IFEQ      '*ERROR'                                                   CMX013
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO MXC0460'                        CMX013
     C                   EXSR      *PSSR                                                      CMX013
     C                   ENDIF                                                                CMX013
      *                                                                                       CMX013
     C                   ENDIF                                                                CMX013
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Delete the primary record
      ********************************************************************
     C     DEL_PrmREC    BEGSR
 
     C     MXEXFDK       CHAIN     MXEXFDUPD                          99        *
     C     *in99         IFEQ      '0'
     C                   DELETE    MXEXFDUPD                                    *
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Check for a record selected from the subfile
      *****************************************************************
     C     CHK_SUBF      BEGSR
 
     C                   READC     SUBFLREC                               99    *RECORD CHANGED
 
      * Do until all records processed
 
     C     *IN99         DOWEQ     '0'
 
      * If an action code is specified
      *   Maintain the record in the subfile
 
     C     DDACTN        IFNE      *BLANK
     C                   EXSR      MNT_SflREC
     C                   ELSE
     C                   MOVE      '0'           @INKC
     C                   ENDIF
 
      * Return to top of subfile page
 
     C                   Z-ADD     ToP_IBO       WHIBO
     C                   Z-ADD     ToP_FOBO      WHFOBO
     C                   Z-ADD     *ZERO         SUBF_RRN
 
      * Read next if F3 not requested
 
     C     @INKC         IFEQ      '0'
     C                   READC     SUBFLREC                               99    *RECORD CHANGED
     C                   ELSE
     C                   MOVE      '1'           *IN99
     C                   MOVE      @INKC         *INKC
     C                   END
 
     C                   ENDDO
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *****************************************************************
      * Toggle Name/Text
      *****************************************************************
     C     TOG_NT        BEGSR
 
     C     Name_Text     IFEQ      'T'
     C                   MOVEL     'N'           Name_Text
     C                   ELSE
     C                   MOVEL     'T'           Name_Text
     C                   ENDIF
 
 
      * Return to top of subfile page
 
     C                   Z-ADD     ToP_IBO       WHIBO
     C                   Z-ADD     ToP_FOBO      WHFOBO
     C                   Z-ADD     *ZERO         SUBF_RRN
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *****************************************************************
      * Fill subfile
      *****************************************************************
     C     FILL_SUBF     BEGSR
 
     C                   MOVEA     '000'         *IN(1)
     C                   MOVEA     '1'           *IN(4)
     C                   Z-ADD     *ZERO         SUBF_RRN
 
      * Write subfile control
 
     C                   WRITE     SUBFLCTL                                     *
 
      * Get first record
 
     C     MXEXFFK       SETLL     MXEXFFP0
     C     MXEXFDK       READE     MXEXFFP0                               99    *
 
      * If not end of file
 
     C     *IN99         IFEQ      '0'
     C                   Z-ADD     WHIBO         ToP_IBO           5 0
     C                   Z-ADD     WHFOBO        ToP_FOBO          5 0
     C                   ELSE
     C                   Z-ADD     *ZERO         ToP_IBO
     C                   Z-ADD     *ZERO         ToP_FOBO
     C                   Z-ADD     *ZERO         WHIBO
     C                   Z-ADD     *ZERO         WHFOBO
 
      * Else, if end of file
      * Issue message
 
     C                   MOVEL     'MX00001'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
 
      * Do while not end of file
 
     C     *IN99         DOWEQ     '0'
 
     C                   ADD       1             SUBF_RRN          4 0    04    *
 
      * Format data for output
 
     C                   EXSR      FMT_DATA
 
      * Write a record to the subfile
 
     C                   WRITE     SUBFLREC
     C     SUBF_RRN      IFEQ      NumPerPag
     C     MXEXFDK       READE     MXEXFFP0                               99    *
     C     *IN99         IFEQ      '1'
     C                   Z-ADD     *ZERO         WHIBO
     C                   Z-ADD     *ZERO         WHFOBO
     C                   MOVEL     'MX00001'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ELSE
     C                   SETON                                            99    *
     C                   END
     C                   ELSE
     C     MXEXFDK       READE     MXEXFFP0                               99    *
     C     *IN99         IFEQ      '1'
     C                   Z-ADD     *ZERO         WHIBO
     C                   Z-ADD     *ZERO         WHFOBO
     C                   MOVEL     'MX00001'     ZAMSID
     C                   EXSR      ZASNMS
     C                   END
     C                   END
 
     C                   ENDDO
 
      * Set on subfile control indicators
 
     C     *IN(4)        IFEQ      '1'
     C                   MOVEA     '010'         *IN(1)
     C                   ELSE
     C                   MOVEA     '111'         *IN(1)
     C                   END
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *****************************************************************
      * Maintain a record on the subfile
      ********************************************************************
     C     MNT_SflREC    BEGSR
 
     C                   CALL      'MXEXFFMNT'
     C                   PARM      *BLANK        W#RTCD            7
     C                   PARM      *BLANK        W#ERMS           30
     C                   PARM      I#MODE        W#MODE            1
     C                   PARM                    MXEXFF
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKL             1
 
      * Error
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO MXEXFFMNT'
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * Return to top of subfile page
 
     C                   Z-ADD     ToP_IBO       WHIBO
     C                   Z-ADD     ToP_FOBO      WHFOBO
     C                   Z-ADD     *ZERO         SUBF_RRN
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *****************************************************************
      * Get Export Format Details
      ********************************************************************
     C     GET_EXFD      BEGSR
 
     C     MXEXFDK       CHAIN     MXEXFDP0                           60        *
     C     *IN60         IFEQ      '1'
     C                   CLEAR                   MXEXFD
     C                   ENDIF
 
      * Set up fields for display
 
      * Recs Per MQ Message
     C                   MOVEL     *BLANK        ZFIELD
     C                   MOVE      EXRECM        ZFIELD
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD
     C                   PARM      0             ZADEC
     C                   MOVE      ZFIELD        DDRECM
      * Export Day
     C                   MOVEL     *BLANK        ZFIELD
     C                   MOVE      EXEXDY        ZFIELD
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD
     C                   PARM      0             ZADEC
     C                   MOVE      ZFIELD        DDEXDY
      * Next Export Date
     C                   CALLB     'ZDATE2'
     C                   PARM      EXEXND        ZDAYNO            5 0
     C                   PARM                    BJDFIN
     C                   PARM                    ZDATEN            6 0
     C                   PARM                    ZADATE            7
     C     ZDATEN        IFNE      *ZERO
     C                   MOVEL     ZDATEN        DDEXND
     C                   ELSE
     C                   MOVEL     *BLANK        DDEXND
     C                   ENDIF
      * Export Member
     C                   MOVEL     EXXMEM        DDXMEM
 
      * Number of parameters
 
     C                   MOVE      EXACSP        DDACSP
 
      * Initialize 'create fields' indicator
 
     C     *IN60         IFEQ      '1'
     C                   MOVEL     'Y'           DDCRFD
     C                   ELSE
     C                   MOVEL     'N'           DDCRFD
     C                   ENDIF
 
      * Check if selection criteria exist
 
     C     MXEXFSK       CHAIN     MXEXFSP0                           99        *
     C     *IN99         IFEQ      '0'
     C                   MOVEL     'SELECTION'   DDSELC
     C                   ELSE
     C                   MOVEL     *BLANK        DDSELC
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Format data for output
      ********************************************************************
     C     FMT_DATA      BEGSR
 
      * Include In Export
     C     WHINEX        IFEQ      'Y'
     C                   MOVE      '1'           *IN62
     C                   ELSE
     C                   MOVE      '0'           *IN62
     C                   ENDIF
 
      * Field
     C                   MOVEL     WHFLDI        DDFLDI
     C                   MOVE      WHSREF        DDFLDI
 
     C                   MOVEL     *BLANK        DDMFNM
      * Field Name/text
     C     Name_Text     IFEQ      'N'
     C                   MOVEL     WHMFNM        DDMFNM
     C                   ELSE
     C                   MOVEL     WHFTXT        DDMFNM
     C                   ENDIF
 
      * Field attributes
     C                   MOVEL     *BLANK        DDATRB
 
      * Set field length
 
     C                   MOVEL     *BLANK        ZFIELD
     C     WHFLDT        IFEQ      'S'
     C     WHFLDT        OREQ      'P'
     C                   MOVE      WHFLDD        ZFIELD
     C                   ELSE
     C                   MOVE      WHFLDB        ZFIELD
     C                   ENDIF
 
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD           16
     C                   PARM      0             ZADEC             1 0
     C                   MOVE      ZFIELD        DDLEN
 
      * Set field type
 
     C     WHFLDT        IFEQ      'S'
     C     WHFLDT        OREQ      'P'
     C                   MOVE      'N'           DDTYP
     C                   ELSE
     C                   MOVE      'A'           DDTYP
     C                   ENDIF
 
      * Set field number of digits and decimal places
 
     C     WHFLDT        IFEQ      'S'
     C     WHFLDT        OREQ      'P'
     C                   MOVEL     '('           DDOPNB
     C                   MOVEL     *BLANK        ZFIELD
     C                   MOVE      WHFLDD        ZFIELD
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD
     C                   PARM      0             ZADEC
     C                   MOVE      ZFIELD        DDDIG
     C                   MOVEL     ','           DDCOMA
     C                   MOVE      WHFLDP        DDDEC
     C                   MOVEL     ')'           DDCLOB
     C                   ENDIF
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *****************************************************************
      * Rolldown
      ********************************************************************
     C     ROLLDOWN      BEGSR
 
     C                   Z-ADD     *ZERO         SUBF_RRN
     C                   Z-ADD     ToP_IBO       WHIBO
     C                   Z-ADD     ToP_FOBO      WHFOBO
 
     C     MXEXFFK       SETGT     MXEXFFP0
     C     MXEXFDK       READPE    MXEXFFP0                               99    *
 
      * Read previous
      * until count matches count of records previous read
 
     C     *IN99         DOWEQ     '0'
     C     SUBF_RRN      ANDLT     NumPerPag
     C     MXEXFDK       READPE    MXEXFFP0                               99    *
     C                   ADD       1             SUBF_RRN
     C                   ENDDO
 
      * Issue start of file message
 
     C     *IN99         IFEQ      '1'
     C                   Z-ADD     *ZERO         WHIBO
     C                   Z-ADD     *ZERO         WHFOBO
     C                   MOVEL     'MX00002'     ZAMSID
     C                   EXSR      ZASNMS
     C                   END
 
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
      * Selection criteria maintenance
      *****************************************************************
     C     SELECT_MNT    BEGSR
 
     C                   CALL      'MXEXFSMNT'
     C                   PARM      *BLANK        W#RTCD            7
     C                   PARM      *BLANK        W#ERMS           30
     C                   PARM      I#MODE        W#MODE            1
     C                   PARM                    EXFILE           10
     C                   PARM                    EXFSQN            1
     C                   PARM                    EXFMT            10
     C                   PARM                    EXDESC           42
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKL             1
 
      * Error
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO MXEXFSMNT'
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * Check returned function keys
 
     C                   MOVE      @INKC         *INKC
 
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
     C                   MOVEL     'MXEXFDMNT'   DDPGM
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
 
      * Initialize constants
 
     C                   Z-ADD     8             NumPerPag         2 0
 
      * Initialize pointer
 
     C                   Z-ADD     *ZERO         WHIBO
     C                   Z-ADD     *ZERO         WHFOBO
 
      * Initialize toggle
 
     C                   MOVEL     'N'           Name_Text         1
 
      * Mode (U = Allow updates)
 
     C     I#MODE        IFEQ      'U'
     C                   MOVE      '1'           *IN61
     C                   ENDIF
 
      * Key lists
 
     C     MXEXFDK       KLIST
     C                   KFLD                    EXFILE
     C                   KFLD                    EXFSQN
     C     MXEXFFK       KLIST
     C                   KFLD                    EXFILE
     C                   KFLD                    EXFSQN
     C                   KFLD                    WHIBO
     C                   KFLD                    WHFOBO
     C     MXEXFDKAL     KLIST
     C                   KFLD                    EXFMT
     C     MXEXFSK       KLIST
     C                   KFLD                    EXFILE
     C                   KFLD                    EXFSQN
 
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
** #_DSP
DSPFFD FILE(          ) OUTPUT(*OUTFILE) OUTFILE(QTEMP/QWHDRFFD)
OUTMBR(*FIRST *REPLACE)
** #_SQN
0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ
** #_CHKF
CHKOBJ OBJ(          ) OBJTYPE(*FILE) AUT(*USE)
** #_CHKM
CHKOBJ OBJ(          ) OBJTYPE(*MODULE) AUT(*USE)
** #_ACSP
123456
** #_CPY
CPYF FROMFILE(QTEMP/QWHDRFFD) TOFILE(QTEMP/MXEXFFZZ)
MBROPT(*REPLACE) FMTOPT(*MAP *DROP)
