     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MX Composite Message Details Maintenance')
      *****************************************************************
      *                                                               *
      *  Midas - Meridian Export Module                               *
      *                                                               *
      *  MXCOMDMNT - Composite Message Details Maintenance            *
      *                                                               *
      *  Function:  This module maintains composite message details   *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Last Amend No. 256564             Date 17Sep08               *
      *  Prev Amend No. BUG17937           Date 24Apr08               *
      *                 251519             Date 20Nov07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CMX013             Date 29Jun06               *
      *                 CAAA03             Date 12Mar04               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CMX001  *CREATE    Data 01Jan00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  BUG17937 - SEC3300 is Failing with an error.  Applied fix    *
      *             245268                                            *
      *  251519 - Moved 'write MSGSUBCT' after FOOTER to display      *
      *           message subfile on screen.                          *
      *  CMX013 - Allow Additional Members                            *
      *  CAAA03 - Webfacing Changes                                   *
      *  CMX001 - Meridian Export                                     *
      *                                                               *
      *****************************************************************
 
     FMXCOMDMDD CF   E             WORKSTN
     F                                     SFILE(SUBFLREC:SUBF_RRN)
     FMXCOMDPD  IF   E           K DISK
     FMXCOMDL1  UF A E           K DISK
     F                                     RENAME(MXCOMDP0:MXCOMDUPD)
     F                                     PREFIX(P_)
     FMXCOMFL2  IF   E           K DISK
     FMXDGDTL1  IF   E           K DISK
 
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
 
     D MXCOMD        E DS                  EXTNAME(MXCOMDPD)
      * Composite Message Details
     D P_MXCOMD      E DS                  EXTNAME(MXCOMDPD)
     D                                     PREFIX(P_)
      * Composite Message Details
 
     D MXCOMF        E DS                  EXTNAME(MXCOMFPD)
      * Composite Message Formats
 
 
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           30
     C                   PARM                    I#MODE            1
     C                   PARM                    MXCOMD
     C                   PARM                    @INKC             1
     C                   PARM                    @INKL             1
 
      * Get Composite Message Details
 
     C                   EXSR      GET_COMD
 
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
     C**********         WRITE     MSGSUBCT                                                   251519
     C**********         WRITE     SUBFLCTL                                                   CAAA03
     C                   WRITE     FOOTER
 
      * Read subfile control
 
     C                   WRITE     MSGSUBCT                                                   251519
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
 
      *  Validate Composite ID
 
     C     CDCOMI        IFEQ      *BLANK
     C                   MOVEL     'MX00010'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN10
     C                   ELSE
      * Check makeup
     C                   EVAL      ZFD2BV  = CDCOMI
     C                   EVAL      ZFDLC   = 'N'
     C                   EVAL      ZFDUC   = 'Y'
     C                   EVAL      ZFDNM   = 'Y'
     C                   EVAL      ZFDOTHC = '._        '
     C                   EXSR      VAL_FDMU
     C     ZFDError      IFEQ      'Y'
     C                   MOVEL     'MX00010'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN10
     C                   ENDIF
     C                   ENDIF
 
      * Validate extract type
      * It must be 'C' for current or 'A' for activity
 
     C     CDEXTT        IFNE      'C'
     C     CDEXTT        ANDNE     'A'
     C                   MOVEL     'MX00011'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN11
     C                   ENDIF
 
      * If add required, check that record does not already exist
 
     C     *IN60         IFEQ      '1'
     C                   MOVEL     MXCOMD        P_MXCOMD
     C     MXCOMDK       CHAIN     MXCOMDP0                           99        *
     C     *in99         IFEQ      '0'
     C                   MOVEL     P_MXCOMD      MXCOMD
     C                   MOVEL     'MX00025'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN10
     C                   MOVE      '1'           *IN11
     C                   ENDIF
     C                   ENDIF
 
      * Validate description
      * It must be entered
 
     C     CDDESC        IFEQ      *BLANK
     C                   MOVEL     'MX00012'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN12
     C                   ENDIF
 
      * Validate data group (if extract type is 'A')
      * It must be entered and must exist
 
     C     CDEXTT        IFEQ      'A'
 
     C     CDDTAG        IFEQ      *BLANK
     C                   MOVEL     'MX00021'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN13
     C                   ELSE
     C     CDDTAG        CHAIN     MXDGDTP0                           99        *
     C     *in99         IFEQ      '1'
     C                   MOVEL     'MX00021'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN13
     C                   ENDIF
     C                   ENDIF
 
     C                   ELSE
 
     C     CDDTAG        IFNE      *BLANK
     C                   MOVEL     'MX00021'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN13
     C                   ENDIF
 
     C                   ENDIF
 
      * Validate message type
      * It must be entered
 
     C     CDMSGT        IFEQ      *BLANK
     C                   MOVEL     'MX00013'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN14
     C                   ELSE
      * Check makeup
     C                   EVAL      ZFD2BV  = CDMSGT
     C                   EVAL      ZFDLC   = 'N'
     C                   EVAL      ZFDUC   = 'Y'
     C                   EVAL      ZFDNM   = 'Y'
     C                   EVAL      ZFDOTHC = '_         '
     C                   EXSR      VAL_FDMU
     C     ZFDError      IFEQ      'Y'
     C                   MOVEL     'MX00013'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN14
     C                   ENDIF
     C                   ENDIF
 
      * Validate message queue
      * It must be entered
 
     C     CDMSGQ        IFEQ      *BLANK
     C                   MOVEL     'MX00014'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN15
     C                   ELSE
      * Check makeup
     C                   EVAL      ZFD2BV  = CDMSGQ
     C                   EVAL      ZFDLC   = 'N'
     C                   EVAL      ZFDUC   = 'Y'
     C                   EVAL      ZFDNM   = 'Y'
     C                   EVAL      ZFDOTHC = '._/       '
     C                   EXSR      VAL_FDMU
     C     ZFDError      IFEQ      'Y'
     C                   MOVEL     'MX00014'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN15
     C                   ENDIF
     C                   ENDIF
 
      * Validate composites per MQ message
      * It must be 1 or 999
 
     C                   MOVEL     *BLANK        ZFIELD
     C                   MOVEL     DDCOMM        ZFIELD
     C                   CALLB     'ZALIGN'
     C                   PARM                    ZALIGNok          1
     C                   PARM                    ZFIELD           16
     C                   PARM      0             ZADEC             1 0
     C                   PARM      3             ZADIG             2 0
     C     ZALIGNok      IFNE      'Y'
     C                   MOVEL     'MX00015'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN16
     C                   ELSE
     C                   MOVE      ZFIELD        CDCOMM
     C     CDCOMM        IFNE      1
     C     CDCOMM        ANDNE     999
     C                   MOVEL     'MX00015'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN16
     C                   ENDIF
     C                   ENDIF
 
      * Validate log performance
      * It must be 'Y'  or 'N'
 
     C     CDLOGP        IFEQ      *BLANK
     C                   MOVE      'N'           CDLOGP
     C                   ENDIF
     C     CDLOGP        IFNE      'Y'
     C     CDLOGP        ANDNE     'N'
     C                   MOVEL     'MX00016'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN17
     C                   ENDIF
 
      * Validate message transmission report type
      * It must be 'F' (full), 'S' (sample) 'A' (audit) or blank (no report)
 
     C     CDMTRT        IFNE      'F'
     C     CDMTRT        ANDNE     'S'
     C     CDMTRT        ANDNE     'A'
     C     CDMTRT        ANDNE     ' '
     C                   MOVEL     'MX00017'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN18
     C                   ENDIF
 
      * Validate export frequency
      * It must be daily, weekly, monthly or last calendar day in month
      * or on request
 
     C     CDEXFQ        IFNE      'D'
     C     CDEXFQ        ANDNE     'W'
     C     CDEXFQ        ANDNE     'M'
     C     CDEXFQ        ANDNE     'L'
     C     CDEXFQ        ANDNE     'Z'
     C                   MOVEL     'MX00018'     ZAMSID
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
     C                   MOVEL     'MX00019'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN20
     C                   ELSE
 
     C                   MOVE      ZFIELD        CDEXDY
      * daily
      * weekly
      * last calendar day in month
      * on request
     C     CDEXFQ        IFEQ      'D'
     C     CDEXDY        ANDNE     *ZERO
     C     CDEXFQ        OREQ      'W'
     C     CDEXDY        ANDNE     *ZERO
     C     CDEXFQ        OREQ      'L'
     C     CDEXDY        ANDNE     *ZERO
     C     CDEXFQ        OREQ      'Z'
     C     CDEXDY        ANDNE     *ZERO
     C                   MOVEL     'MX00019'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN20
     C                   ENDIF
      * monthly
     C     CDEXFQ        IFEQ      'M'
     C     CDEXDY        ANDLT     1
     C     CDEXFQ        OREQ      'M'
     C     CDEXDY        ANDGT     31
     C                   MOVEL     'MX00019'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN20
     C                   ENDIF
 
     C                   ENDIF
 
      * Validate next export date
      * If export frequency is Z it must not be entered
      * Otherwise it must be entered and must be <= run date
 
      * If Z
     C     CDEXFQ        IFEQ      'Z'
 
     C     DDEXND        IFNE      *BLANK
     C                   MOVEL     'MX00020'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN21
     C                   ELSE
     C                   Z-ADD     *ZERO         CDEXND
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
     C                   MOVEL     'MX00020'     ZAMSID
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
     C                   MOVEL     'MX00020'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN21
     C                   ELSE
     C                   Z-ADD     ZDAYNO        CDEXND
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
     C                   TESTN                   Check_4A             9898      CAP013
     C     *IN98         IFEQ      '0'                                          CAP013
     C**********         MOVEL     'MX00022'     ZAMSID                                       CMX013
     C**********         EXSR      ZASNMS                                                     CMX013
     C                   MOVE      '1'           *IN22
     C                   ELSE
     C                   MOVEL     Check_4A      Check_4N          4 0
     C     Check_4N      IFLT      1                                            CAP013
     C     Check_4N      ORGT      60                                           CAP013
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
     C                   MOVEL     DDXMEM        CDXMEM
 
      * If any fields are in error
      *  Disable F6 (if it was taken)
 
     C     *in50         IFEQ      '1'
     C                   MOVE      '0'           *INKF
 
      * Otherwise
 
     C                   ELSE
 
      * Update the primary record
 
     C     *INKF         CASEQ     '1'           UPD_PrmREC
 
      * Add a record to the subfile
 
     C     *INKI         CASEQ     '1'           MNT_SflREC
 
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
 
     C     MXCOMDK       CHAIN     MXCOMDUPD                          99        *
     C                   MOVEL     MXCOMD        P_MXCOMD
     C     *in99         IFEQ      '1'
     C                   MOVEL     'Y'           P_CDENAB
     C                   WRITE     MXCOMDUPD                                    *
     C                   ELSE
     C                   UPDATE    MXCOMDUPD                                    *
     C                   ENDIF
      *                                                                                       CMX013
      * If member entered is non-standard, call program to add member to files                CMX013
      *                                                                                       CMX013
     C     W#ADDMBR      IFEQ      'Y'                                                        CMX013
     C                   CALL      'MXC0460'                                                  CMX013
     C                   PARM      *BLANKS       W#RTCD                                       CMX013
     C                   PARM                    CDXMEM                                       CMX013
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
 
     C     MXCOMDK       CHAIN     MXCOMDUPD                          99        *
     C     *in99         IFEQ      '0'
     C                   DELETE    MXCOMDUPD                                    *
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
 
     C                   MOVEL     ToP_SEQM      CFSEQM
     C                   Z-ADD     *ZERO         SUBF_RRN
 
      * Read next if F3 not requested
 
     C     @INKC         IFEQ      '0'
     C                   READC     SUBFLREC                               99    *RECORD CHANGED
     C                   ELSE
     C                   MOVE      '1'           *IN99
     C                   END
 
     C                   ENDDO
 
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
 
     C     MXCOMFK       SETLL     MXCOMFP0
     C     MXCOMDK       READE     MXCOMFP0                               99    *
 
      * If not end of file
 
     C     *IN99         IFEQ      '0'
     C                   MOVEL     CFSEQM        ToP_SEQM          2
     C                   ELSE
     C                   MOVEL     *BLANK        ToP_SEQM
     C                   MOVEL     *BLANK        CFSEQM
 
      * Else, if end of file
      * Issue message
 
     C                   MOVEL     'MX00001'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
 
      * Do while not end of file
 
     C     *IN99         DOWEQ     '0'
 
     C                   ADD       1             SUBF_RRN          4 0    04    *
 
      * Export?
     C     CFEXPT        IFEQ      'Y'
     C                   MOVEL     'YES'         DDEXPT
     C                   ELSE
     C                   MOVEL     ' NO'         DDEXPT
     C                   ENDIF
 
      * Write a record to the subfile
 
     C                   WRITE     SUBFLREC
     C     SUBF_RRN      IFEQ      NumPerPag
     C     MXCOMDK       READE     MXCOMFP0                               99    *
     C     *IN99         IFEQ      '1'
     C                   MOVEL     *BLANK        CFSEQM
     C                   MOVEL     'MX00001'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ELSE
     C                   SETON                                            99    *
     C                   END
     C                   ELSE
     C     MXCOMDK       READE     MXCOMFP0                               99    *
     C     *IN99         IFEQ      '1'
     C                   MOVEL     *BLANK        CFSEQM
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
 
     C   KI              MOVEL     *BLANK        CFSEQM
 
     C                   CALL      'MXCOMFMNT'
     C                   PARM      *BLANK        W#RTCD            7
     C                   PARM      *BLANK        W#ERMS           30
     C                   PARM      I#MODE        W#MODE            1
     C                   PARM                    MXCOMF
     C                   PARM                    MXCOMD
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKL             1
 
      * Error
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO MXCOMFMNT'
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * Pass back F3 function key
 
     C                   MOVE      @INKC         *INKC
 
      * Return to top of subfile page
 
     C                   MOVEL     ToP_SEQM      CFSEQM
     C                   Z-ADD     *ZERO         SUBF_RRN
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *****************************************************************
      * Get Composite Message Details
      ********************************************************************
     C     GET_COMD      BEGSR
 
     C     MXCOMDK       CHAIN     MXCOMDP0                           60        *
     C     *IN60         IFEQ      '1'
     C                   CLEAR                   MXCOMD
     C                   ENDIF
 
      * Set up fields for display
 
      * COMs Per MQ Message
     C                   MOVEL     *BLANK        ZFIELD
     C                   MOVE      CDCOMM        ZFIELD
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD
     C                   PARM      0             ZADEC
     C                   MOVE      ZFIELD        DDCOMM
      * Export Day
     C                   MOVEL     *BLANK        ZFIELD
     C                   MOVE      CDEXDY        ZFIELD
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD
     C                   PARM      0             ZADEC
     C                   MOVE      ZFIELD        DDEXDY
      * Next Export Date
     C                   CALLB     'ZDATE2'
     C                   PARM      CDEXND        ZDAYNO            5 0
     C                   PARM                    BJDFIN
     C                   PARM                    ZDATEN            6 0
     C                   PARM                    ZADATE            7
     C     ZDATEN        IFNE      *ZERO
     C                   MOVEL     ZDATEN        DDEXND
     C                   ELSE
     C                   MOVEL     *BLANK        DDEXND
     C                   ENDIF
      * Export Member
     C                   MOVEL     CDXMEM        DDXMEM
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Rolldown
      ********************************************************************
     C     ROLLDOWN      BEGSR
 
     C                   Z-ADD     *ZERO         SUBF_RRN
     C                   MOVEL     ToP_SEQM      CFSEQM
 
     C     MXCOMFK       SETGT     MXCOMFP0
     C     MXCOMDK       READPE    MXCOMFP0                               99    *
 
      * Read previous
      * until count matches count of records previous read
 
     C     *IN99         DOWEQ     '0'
     C     SUBF_RRN      ANDLT     NumPerPag
     C     MXCOMDK       READPE    MXCOMFP0                               99    *
     C                   ADD       1             SUBF_RRN
     C                   ENDDO
 
      * Issue start of file message
 
     C     *IN99         IFEQ      '1'
     C                   MOVEL     *BLANK        CFSEQM
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
      * *INZSR - Initial subroutine called automatically at program start
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** Initialize program name
      *
     C                   MOVEL     'MXCOMDMNT'   DDPGM
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
 
     C**********         Z-ADD     9             NumPerPag         2 0                      BUG17937
     C                   Z-ADD     8             NumPerPag         2 0                      BUG17937
 
      * Mode (U = Allow updates, L = Allow Limited Updates)
 
     C     I#MODE        IFEQ      'U'
     C                   MOVE      '1'           *IN61
     C                   MOVE      '1'           *IN62
     C                   ENDIF
     C     I#MODE        IFEQ      'L'
     C                   MOVE      '1'           *IN62
     C                   ENDIF
 
      * If extract type is current, protect/non-display certain fields
 
     C     CDEXTT        IFEQ      'C'
     C                   MOVE      '1'           *IN63
     C                   ENDIF
 
      * Key lists
 
     C     MXCOMDK       KLIST
     C                   KFLD                    CDCOMI
     C                   KFLD                    CDEXTT
     C     MXCOMFK       KLIST
     C                   KFLD                    CDCOMI
     C                   KFLD                    CDEXTT
     C                   KFLD                    CFSEQM
 
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
