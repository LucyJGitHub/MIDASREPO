     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/**** *  RPGBASEMOD                                                   *                     MD056612
/*STD *  RPGSQLMOD                                                    *                     MD056612
/*EXI *  CLOSQLCSR(*ENDMOD)                                           *                     MD056612
/*EXI *  TEXT('Midas MX Data Group Details Maintenance')
      *****************************************************************
      *                                                               *
      *  Midas - Meridian Export Module                               *
      *                                                               *
      *  MXDGDTMNT - Data Group Details Maintenance                   *
      *                                                               *
      *  Function:  This module maintains data group details          *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD058367           Date 28Sep21               *
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
      *  MD058367 - Field Data Group is protected                     *
      *  MD056612 - Deliverable Data Split for MX group               *
      *  MD046248 - Finastra Rebranding                               *
      *  CAAA03 - Webfacing Changes                                   *
      *  CMX001 - Meridian Export                                     *
      *                                                               *
      *****************************************************************

     FMXDGDTMDD CF   E             WORKSTN
     F                                     SFILE(SUBFLREC:SUBF_RRN)
     F*MXDGDTPD* IF   E           K DISK                                                    MD056612
     F*MXDGDTL1* UF A E           K DISK                                                    MD056612
     F**********                           RENAME(MXDGDTP0:MXDGDTUPD)                       MD056612
     F**********                           PREFIX(P_)                                       MD056612
     F*MXDGECL1* IF   E           K DISK                                                    MD056612

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

     D*MXDGDT***     E DS                  EXTNAME(MXDGDTPD)                                MD056612
     D MXDGDT        E DS                  EXTNAME(MXDGDJW0)                                MD056612
      * Data Group Details
     D*P_MXDGDT*     E DS                  EXTNAME(MXDGDTPD)                                MD056612
     D P_MXDGDT      E DS                  EXTNAME(MXDGDJW0)                                MD056612
     D                                     PREFIX(P_)
      * Data Group Details

     D*MXDGEC***     E DS                  EXTNAME(MXDGECPD)                                MD056612
     D MXDGEC        E DS                  EXTNAME(MXDGEJW0)                                MD056612
      * Data Group Event Categories


     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           30
     C                   PARM                    I#MODE            1
     C                   PARM                    MXDGDT
     C                   PARM                    @INKC             1
     C                   PARM                    @INKL             1

      * Get Data Group Details

     C                   EXSR      GET_DGDT

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
     C                   MOVEA     '0000000000'  *IN(30)

     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *****************************************************************
      * Validate the screen
      *****************************************************************
     C     VALID_SCN     BEGSR

      *  Validate Data Group

     C     DGDTAG        IFEQ      *BLANK
     C                   MOVEL     'MX00200'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN10
     C                   ELSE
      * Check makeup
     C                   EVAL      ZFD2BV  = DGDTAG
     C                   EVAL      ZFDLC   = 'N'
     C                   EVAL      ZFDUC   = 'Y'
     C                   EVAL      ZFDNM   = 'Y'
     C                   EVAL      ZFDOTHC = '._        '
     C                   EXSR      VAL_FDMU
     C     ZFDError      IFEQ      'Y'
     C                   MOVEL     'MX00200'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN10
     C                   ENDIF
     C                   ENDIF

      * If add required, check that record does not already exist

     C     *IN60         IFEQ      '1'
     C                   MOVEL     MXDGDT        P_MXDGDT
     C*****MXDGDTK       CHAIN     MXDGDTP0                           99        *           MD056612
     C/EXEC SQL                                                                             MD056612
     C+ SELECT *                                                                            MD056612
     C+ into :MXDGDT                                                                        MD056612
     C+ from MXDGDJW0                                                                       MD056612
     C+ where DGDTAG = :DGDTAG                                                              MD056612
     C/END-EXEC                                                                             MD056612
     C******in99         IFEQ      '0'                                                      MD056612
     C                   IF        SQLCODE = 0                                              MD056612
     C                   MOVEL     P_MXDGDT      MXDGDT
     C                   MOVEL     'MX00201'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN10
     C                   ENDIF
     C                   ENDIF

      * Validate description
      * It must be entered

     C     DGDESC        IFEQ      *BLANK
     C                   MOVEL     'MX00202'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN11
     C                   ENDIF

      * Validate account key events indicator.
      * It must be 'Y' or 'N'

     C     DGAKEV        IFNE      'Y'
     C     DGAKEV        ANDNE     'N'
     C                   MOVEL     'MX00210'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN12
     C                   ENDIF

      * Validate account key positions 01 - 20
      * Each one must be 'Y'  or ' '

     C     DGAKEV        IFEQ      'Y'
     C     DGAK01        ANDNE     'Y'
     C     DGAK01        ANDNE     ' '
     C     DGAKEV        OREQ      'N'
     C     DGAK01        ANDNE     ' '
     C                   MOVEL     'MX00211'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN13
     C                   ENDIF
     C     DGAKEV        IFEQ      'Y'
     C     DGAK02        ANDNE     'Y'
     C     DGAK02        ANDNE     ' '
     C     DGAKEV        OREQ      'N'
     C     DGAK02        ANDNE     ' '
     C                   MOVEL     'MX00211'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN14
     C                   ENDIF
     C     DGAKEV        IFEQ      'Y'
     C     DGAK03        ANDNE     'Y'
     C     DGAK03        ANDNE     ' '
     C     DGAKEV        OREQ      'N'
     C     DGAK03        ANDNE     ' '
     C                   MOVEL     'MX00211'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN15
     C                   ENDIF
     C     DGAKEV        IFEQ      'Y'
     C     DGAK04        ANDNE     'Y'
     C     DGAK04        ANDNE     ' '
     C     DGAKEV        OREQ      'N'
     C     DGAK04        ANDNE     ' '
     C                   MOVEL     'MX00211'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN16
     C                   ENDIF
     C     DGAKEV        IFEQ      'Y'
     C     DGAK05        ANDNE     'Y'
     C     DGAK05        ANDNE     ' '
     C     DGAKEV        OREQ      'N'
     C     DGAK05        ANDNE     ' '
     C                   MOVEL     'MX00211'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN17
     C                   ENDIF
     C     DGAKEV        IFEQ      'Y'
     C     DGAK06        ANDNE     'Y'
     C     DGAK06        ANDNE     ' '
     C     DGAKEV        OREQ      'N'
     C     DGAK06        ANDNE     ' '
     C                   MOVEL     'MX00211'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN18
     C                   ENDIF
     C     DGAKEV        IFEQ      'Y'
     C     DGAK07        ANDNE     'Y'
     C     DGAK07        ANDNE     ' '
     C     DGAKEV        OREQ      'N'
     C     DGAK07        ANDNE     ' '
     C                   MOVEL     'MX00211'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN19
     C                   ENDIF
     C     DGAKEV        IFEQ      'Y'
     C     DGAK08        ANDNE     'Y'
     C     DGAK08        ANDNE     ' '
     C     DGAKEV        OREQ      'N'
     C     DGAK08        ANDNE     ' '
     C                   MOVEL     'MX00211'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN20
     C                   ENDIF
     C     DGAKEV        IFEQ      'Y'
     C     DGAK09        ANDNE     'Y'
     C     DGAK09        ANDNE     ' '
     C     DGAKEV        OREQ      'N'
     C     DGAK09        ANDNE     ' '
     C                   MOVEL     'MX00211'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN21
     C                   ENDIF
     C     DGAKEV        IFEQ      'Y'
     C     DGAK10        ANDNE     'Y'
     C     DGAK10        ANDNE     ' '
     C     DGAKEV        OREQ      'N'
     C     DGAK10        ANDNE     ' '
     C                   MOVEL     'MX00211'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN22
     C                   ENDIF
     C     DGAKEV        IFEQ      'Y'
     C     DGAK11        ANDNE     'Y'
     C     DGAK11        ANDNE     ' '
     C     DGAKEV        OREQ      'N'
     C     DGAK11        ANDNE     ' '
     C                   MOVEL     'MX00211'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN23
     C                   ENDIF
     C     DGAKEV        IFEQ      'Y'
     C     DGAK12        ANDNE     'Y'
     C     DGAK12        ANDNE     ' '
     C     DGAKEV        OREQ      'N'
     C     DGAK12        ANDNE     ' '
     C                   MOVEL     'MX00211'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN24
     C                   ENDIF
     C     DGAKEV        IFEQ      'Y'
     C     DGAK13        ANDNE     'Y'
     C     DGAK13        ANDNE     ' '
     C     DGAKEV        OREQ      'N'
     C     DGAK13        ANDNE     ' '
     C                   MOVEL     'MX00211'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN25
     C                   ENDIF
     C     DGAKEV        IFEQ      'Y'
     C     DGAK14        ANDNE     'Y'
     C     DGAK14        ANDNE     ' '
     C     DGAKEV        OREQ      'N'
     C     DGAK14        ANDNE     ' '
     C                   MOVEL     'MX00211'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN26
     C                   ENDIF
     C     DGAKEV        IFEQ      'Y'
     C     DGAK15        ANDNE     'Y'
     C     DGAK15        ANDNE     ' '
     C     DGAKEV        OREQ      'N'
     C     DGAK15        ANDNE     ' '
     C                   MOVEL     'MX00211'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN27
     C                   ENDIF
     C     DGAKEV        IFEQ      'Y'
     C     DGAK16        ANDNE     'Y'
     C     DGAK16        ANDNE     ' '
     C     DGAKEV        OREQ      'N'
     C     DGAK16        ANDNE     ' '
     C                   MOVEL     'MX00211'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN28
     C                   ENDIF
     C     DGAKEV        IFEQ      'Y'
     C     DGAK17        ANDNE     'Y'
     C     DGAK17        ANDNE     ' '
     C     DGAKEV        OREQ      'N'
     C     DGAK17        ANDNE     ' '
     C                   MOVEL     'MX00211'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN29
     C                   ENDIF
     C     DGAKEV        IFEQ      'Y'
     C     DGAK18        ANDNE     'Y'
     C     DGAK18        ANDNE     ' '
     C     DGAKEV        OREQ      'N'
     C     DGAK18        ANDNE     ' '
     C                   MOVEL     'MX00211'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN30
     C                   ENDIF
     C     DGAKEV        IFEQ      'Y'
     C     DGAK19        ANDNE     'Y'
     C     DGAK19        ANDNE     ' '
     C     DGAKEV        OREQ      'N'
     C     DGAK19        ANDNE     ' '
     C                   MOVEL     'MX00211'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN31
     C                   ENDIF
     C     DGAKEV        IFEQ      'Y'
     C     DGAK20        ANDNE     'Y'
     C     DGAK20        ANDNE     ' '
     C     DGAKEV        OREQ      'N'
     C     DGAK20        ANDNE     ' '
     C                   MOVEL     'MX00211'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN32
     C                   ENDIF

      * Number of Months Balances

     C     DGNOMB        IFNE      '1'
     C     DGNOMB        ANDNE     '2'
     C                   MOVEL     'MX00212'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN33
     C                   ENDIF

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

     C*****MXDGDTK       CHAIN     MXDGDTUPD                          99        *
     C/EXEC SQL                                                                             MD056612
     C+ SELECT *                                                                            MD056612
     C+ into :P_MXDGDT                                                                      MD056612
     C+ from MXDGDJW0                                                                       MD056612
     C+ where DGDTAG = :DGDTAG                                                              MD056612
     C/END-EXEC                                                                             MD056612
     C                   MOVEL     MXDGDT        P_MXDGDT
     C******in99         IFEQ      '1'                                                      MD056612
     C     SQLCODE       IFEQ      100                                                      MD056612
     C                   MOVEL     'Y'           P_DGENAB
     C**********         WRITE     MXDGDTUPD                                    *           MD056612
     C/EXEC SQL                                                                             MD056612
     C+ insert into MXDGDBTD                                                                MD056612
     C+ (                                                                                   MD056612
     C+   DGDTAG                                                                            MD056612
     C+  ,DGDESC                                                                            MD056612
     C+  ,DGAKEV                                                                            MD056612
     C+  ,DGAK01                                                                            MD056612
     C+  ,DGAK02                                                                            MD056612
     C+  ,DGAK03                                                                            MD056612
     C+  ,DGAK04                                                                            MD056612
     C+  ,DGAK05                                                                            MD056612
     C+  ,DGAK06                                                                            MD056612
     C+  ,DGAK07                                                                            MD056612
     C+  ,DGAK08                                                                            MD056612
     C+  ,DGAK09                                                                            MD056612
     C+  ,DGAK10                                                                            MD056612
     C+  ,DGAK11                                                                            MD056612
     C+  ,DGAK12                                                                            MD056612
     C+  ,DGAK13                                                                            MD056612
     C+  ,DGAK14                                                                            MD056612
     C+  ,DGAK15                                                                            MD056612
     C+  ,DGAK16                                                                            MD056612
     C+  ,DGAK17                                                                            MD056612
     C+  ,DGAK18                                                                            MD056612
     C+  ,DGAK19                                                                            MD056612
     C+  ,DGAK20                                                                            MD056612
     C+  ,DGENAB                                                                            MD056612
     C+  ,DGNOMB                                                                            MD056612
     C+  ,DGMODE                                                                            MD056612
     C+ )                                                                                   MD056612
     C+ values                                                                              MD056612
     C+ (                                                                                   MD056612
     C+   :P_DGDTAG                                                                         MD056612
     C+  ,:P_DGDESC                                                                         MD056612
     C+  ,:P_DGAKEV                                                                         MD056612
     C+  ,:P_DGAK01                                                                         MD056612
     C+  ,:P_DGAK02                                                                         MD056612
     C+  ,:P_DGAK03                                                                         MD056612
     C+  ,:P_DGAK04                                                                         MD056612
     C+  ,:P_DGAK05                                                                         MD056612
     C+  ,:P_DGAK06                                                                         MD056612
     C+  ,:P_DGAK07                                                                         MD056612
     C+  ,:P_DGAK08                                                                         MD056612
     C+  ,:P_DGAK09                                                                         MD056612
     C+  ,:P_DGAK10                                                                         MD056612
     C+  ,:P_DGAK11                                                                         MD056612
     C+  ,:P_DGAK12                                                                         MD056612
     C+  ,:P_DGAK13                                                                         MD056612
     C+  ,:P_DGAK14                                                                         MD056612
     C+  ,:P_DGAK15                                                                         MD056612
     C+  ,:P_DGAK16                                                                         MD056612
     C+  ,:P_DGAK17                                                                         MD056612
     C+  ,:P_DGAK18                                                                         MD056612
     C+  ,:P_DGAK19                                                                         MD056612
     C+  ,:P_DGAK20                                                                         MD056612
     C+  ,:P_DGENAB                                                                         MD056612
     C+  ,:P_DGNOMB                                                                         MD056612
     C+  ,'B'                                                                               MD056612
     C+ )                                                                                   MD056612
     C/end-exec                                                                             MD056612
     C/exec SQL                                                                             MD056612
     C+ insert into MXDGDXTD                                                                MD056612
     C+ (                                                                                   MD056612
     C+   DGDTAG                                                                            MD056612
     C+  ,DGDESC                                                                            MD056612
     C+  ,DGAKEV                                                                            MD056612
     C+  ,DGAK01                                                                            MD056612
     C+  ,DGAK02                                                                            MD056612
     C+  ,DGAK03                                                                            MD056612
     C+  ,DGAK04                                                                            MD056612
     C+  ,DGAK05                                                                            MD056612
     C+  ,DGAK06                                                                            MD056612
     C+  ,DGAK07                                                                            MD056612
     C+  ,DGAK08                                                                            MD056612
     C+  ,DGAK09                                                                            MD056612
     C+  ,DGAK10                                                                            MD056612
     C+  ,DGAK11                                                                            MD056612
     C+  ,DGAK12                                                                            MD056612
     C+  ,DGAK13                                                                            MD056612
     C+  ,DGAK14                                                                            MD056612
     C+  ,DGAK15                                                                            MD056612
     C+  ,DGAK16                                                                            MD056612
     C+  ,DGAK17                                                                            MD056612
     C+  ,DGAK18                                                                            MD056612
     C+  ,DGAK19                                                                            MD056612
     C+  ,DGAK20                                                                            MD056612
     C+  ,DGENAB                                                                            MD056612
     C+  ,DGNOMB                                                                            MD056612
     C+  ,DGMODE                                                                            MD056612
     C+ )                                                                                   MD056612
     C+ values                                                                              MD056612
     C+ (                                                                                   MD056612
     C+   :P_DGDTAG                                                                         MD056612
     C+  ,:P_DGDESC                                                                         MD056612
     C+  ,:P_DGAKEV                                                                         MD056612
     C+  ,:P_DGAK01                                                                         MD056612
     C+  ,:P_DGAK02                                                                         MD056612
     C+  ,:P_DGAK03                                                                         MD056612
     C+  ,:P_DGAK04                                                                         MD056612
     C+  ,:P_DGAK05                                                                         MD056612
     C+  ,:P_DGAK06                                                                         MD056612
     C+  ,:P_DGAK07                                                                         MD056612
     C+  ,:P_DGAK08                                                                         MD056612
     C+  ,:P_DGAK09                                                                         MD056612
     C+  ,:P_DGAK10                                                                         MD056612
     C+  ,:P_DGAK11                                                                         MD056612
     C+  ,:P_DGAK12                                                                         MD056612
     C+  ,:P_DGAK13                                                                         MD056612
     C+  ,:P_DGAK14                                                                         MD056612
     C+  ,:P_DGAK15                                                                         MD056612
     C+  ,:P_DGAK16                                                                         MD056612
     C+  ,:P_DGAK17                                                                         MD056612
     C+  ,:P_DGAK18                                                                         MD056612
     C+  ,:P_DGAK19                                                                         MD056612
     C+  ,:P_DGAK20                                                                         MD056612
     C+  ,:P_DGENAB                                                                         MD056612
     C+  ,:P_DGNOMB                                                                         MD056612
     C+  ,'B'                                                                               MD056612
     C+ )                                                                                   MD056612
     C/end-exec                                                                             MD056612
     C                   ELSE
     C**********         UPDATE    MXDGDTUPD                                    *           MD056612
     C/exec SQL                                                                             MD056612
     C+ update MXDGDXTD set                                                                 MD056612
     C+   DGDTAG = :P_DGDTAG                                                                MD056612
     C+  ,DGDESC = :P_DGDESC                                                                MD056612
     C+  ,DGAKEV = :P_DGAKEV                                                                MD056612
     C+  ,DGAK01 = :P_DGAK01                                                                MD056612
     C+  ,DGAK02 = :P_DGAK02                                                                MD056612
     C+  ,DGAK03 = :P_DGAK03                                                                MD056612
     C+  ,DGAK04 = :P_DGAK04                                                                MD056612
     C+  ,DGAK05 = :P_DGAK05                                                                MD056612
     C+  ,DGAK06 = :P_DGAK06                                                                MD056612
     C+  ,DGAK07 = :P_DGAK07                                                                MD056612
     C+  ,DGAK08 = :P_DGAK08                                                                MD056612
     C+  ,DGAK09 = :P_DGAK09                                                                MD056612
     C+  ,DGAK10 = :P_DGAK10                                                                MD056612
     C+  ,DGAK11 = :P_DGAK11                                                                MD056612
     C+  ,DGAK12 = :P_DGAK12                                                                MD056612
     C+  ,DGAK13 = :P_DGAK13                                                                MD056612
     C+  ,DGAK14 = :P_DGAK14                                                                MD056612
     C+  ,DGAK15 = :P_DGAK15                                                                MD056612
     C+  ,DGAK16 = :P_DGAK16                                                                MD056612
     C+  ,DGAK17 = :P_DGAK17                                                                MD056612
     C+  ,DGAK18 = :P_DGAK18                                                                MD056612
     C+  ,DGAK19 = :P_DGAK19                                                                MD056612
     C+  ,DGAK20 = :P_DGAK20                                                                MD056612
     C+  ,DGENAB = :P_DGENAB                                                                MD056612
     C+  ,DGNOMB = :P_DGNOMB                                                                MD056612
     C+ where DGDTAG = :DGDTAG                                                              MD056612
     C/end-exec                                                                             MD056612
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Delete the primary record
      ********************************************************************
     C     DEL_PrmREC    BEGSR

     C*****MXDGDTK       CHAIN     MXDGDTUPD                          99        *           MD056612
     C******in99         IFEQ      '0'                                                      MD056612
     C**********         DELETE    MXDGDTUPD                                    *           MD056612
     C**********         ENDIF                                                              MD056612
     C/EXEC SQL                                                                             MD056612
     C+ SELECT *                                                                            MD056612
     C+ into :MXDGDT                                                                        MD056612
     C+ from MXDGDJW0                                                                       MD056612
     C+ where DGDTAG = :DGDTAG                                                              MD056612
     C/END-EXEC                                                                             MD056612
     C     SQLCODE       IFEQ      0                                                        MD056612
     C     DGMODE        ANDEQ     'C'                                                      MD056612
     C                   MOVEL     'MX00026'     ZAMSID                                     MD056612
     C                   EXSR      ZASNMS                                                   MD056612
     C                   eval      *INKJ = '0'                                              MD056612
     C                   END                                                                MD056612
                                                                                            MD056612
     C     SQLCODE       IFEQ      0                                                        MD056612
     C     DGMODE        ANDEQ     'B'                                                      MD056612
     C/exec SQL                                                                             MD056612
     C+ delete MXDGDBTD                                                                     MD056612
     C+ where DGDTAG = :DGDTAG                                                              MD056612
     C/end-exec                                                                             MD056612
     C/exec SQL                                                                             MD056612
     C+ delete MXDGDXTD                                                                     MD056612
     C+ where DGDTAG = :DGDTAG                                                              MD056612
     C/end-exec                                                                             MD056612
     C                   END                                                                MD056612

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

     C                   MOVEL     ToP_CATC      DECATC
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

     C*****MXDGECK       SETLL     MXDGECP0                                                 MD056612
     C*****MXDGDTK       READE     MXDGECP0                               99    *           MD056612
     C/EXEC SQL                                                                             MD056612
     C+ declare ACursor insensitive scroll cursor for                                       MD056612
     C+ select * from MXDGEJW0                                                              MD056612
     C+ where DEDTAG = :DGDTAG and DECATC >= :DECATC                                        MD056612
     C+ order by DEDTAG, DECATC                                                             MD056612
     C/END-EXEC                                                                             MD056612
                                                                                            MD056612
     C/EXEC SQL                                                                             MD056612
     C+ open ACursor                                                                        MD056612
     C/END-EXEC                                                                             MD056612
                                                                                            MD056612
     C/EXEC SQL                                                                             MD056612
     C+ fetch next from ACursor into :MXDGEC                                                MD056612
     C/END-EXEC                                                                             MD056612

      * If not end of file

     C******IN99         IFEQ      '0'                                                      MD056612
     C     SQLCODE       IFEQ      0                                                        MD056612
     C                   MOVEL     DECATC        ToP_CATC          2
     C                   ELSE
     C                   MOVEL     *BLANK        ToP_CATC
     C                   MOVEL     *BLANK        DECATC

      * Else, if end of file
      * Issue message

     C                   MOVEL     'MX00001'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF

      * Do while not end of file

     C******IN99         DOWEQ     '0'                                                      MD056612
     C     SQLCODE       DOWEQ     0                                                        MD056612

     C                   ADD       1             SUBF_RRN          4 0    04    *


      * Write a record to the subfile

     C                   WRITE     SUBFLREC
     C     SUBF_RRN      IFEQ      NumPerPag
     C*****MXDGDTK       READE     MXDGECP0                               99    *           MD056612
     C/EXEC SQL                                                                             MD056612
     C+ fetch next from ACursor into :MXDGEC                                                MD056612
     C/END-EXEC                                                                             MD056612
     C******IN99         IFEQ      '1'                                                      MD056612
     C     SQLCODE       IFEQ      100                                                      MD056612
     C                   MOVEL     *BLANK        DECATC
     C                   MOVEL     'MX00001'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ELSE
     C**********         SETON                                            99    *           MD056612
     C                   eval      SQLCODE = 100                                            MD056612
     C                   END
     C                   ELSE
     C*****MXDGDTK       READE     MXDGECP0                               99    *           MD056612
     C/EXEC SQL                                                                             MD056612
     C+ fetch next from ACursor into :MXDGEC                                                MD056612
     C/END-EXEC                                                                             MD056612
     C******IN99         IFEQ      '1'                                                      MD056612
     C     SQLCODE       IFEQ      100                                                      MD056612
     C                   MOVEL     *BLANK        DECATC
     C                   MOVEL     'MX00001'     ZAMSID
     C                   EXSR      ZASNMS
     C                   END
     C                   END

     C                   ENDDO

     C/EXEC SQL                                                                             MD056612
     C+ close ACursor                                                                       MD056612
     C/END-EXEC                                                                             MD056612
                                                                                            MD056612
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

     C   KI              MOVEL     *BLANK        DECATC

     C                   CALL      'MXDGECMNT'
     C                   PARM      *BLANK        W#RTCD            7
     C                   PARM      *BLANK        W#ERMS           30
     C                   PARM      I#MODE        W#MODE            1
     C                   PARM                    MXDGEC
     C                   PARM                    MXDGDT
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKL             1

      * Error
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO MXDGECMNT'
     C                   EXSR      *PSSR
     C                   ENDIF

      * Pass back F3 function key

     C                   MOVE      @INKC         *INKC

      * Return to top of subfile page

     C                   MOVEL     ToP_CATC      DECATC
     C                   Z-ADD     *ZERO         SUBF_RRN

     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *****************************************************************
      * Get Data Group Details
      ********************************************************************
     C     GET_DGDT      BEGSR

     C*****MXDGDTK       CHAIN     MXDGDTP0                           60        *           MD056612
     C/EXEC SQL                                                                             MD056612
     C+ SELECT *                                                                            MD056612
     C+ into :MXDGDT                                                                        MD056612
     C+ from MXDGDJW0                                                                       MD056612
     C+ where DGDTAG = :DGDTAG                                                              MD056612
     C/END-EXEC                                                                             MD056612
     C******IN60         IFEQ      '1'                                                      MD056612
     C                   Setoff                                       60                    MD058367
     C     SQLCODE       IFEQ      100                                                      MD056612
     C                   Seton                                        60                    MD058367
     C                   CLEAR                   MXDGDT
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Rolldown
      ********************************************************************
     C     ROLLDOWN      BEGSR

     C                   Z-ADD     *ZERO         SUBF_RRN
     C                   MOVEL     ToP_CATC      DECATC

     C*****MXDGECK       SETGT     MXDGECP0                                                 MD056612
     C*****MXDGDTK       READPE    MXDGECP0                               99    *           MD056612
     C/EXEC SQL                                                                             MD056612
     C+ declare BCursor insensitive scroll cursor for                                       MD056612
     C+ select * from MXDGEJW0                                                              MD056612
     C+ where DEDTAG  = :DGDTAG and DECATC <= :DECATC                                       MD056612
     C+ order by DEDTAG, DECATC desc                                                        MD056612
     C/END-EXEC                                                                             MD056612
                                                                                            MD056612
     C/EXEC SQL                                                                             MD056612
     C+ open BCursor                                                                        MD056612
     C/END-EXEC                                                                             MD056612
                                                                                            MD056612
     C/EXEC SQL                                                                             MD056612
     C+ fetch next  from BCursor into :MXDGEC                                               MD056612
     C/END-EXEC                                                                             MD056612

      * Read previous
      * until count matches count of records previous read

     C******IN99         DOWEQ     '0'                                                      MD056612
     C     SQLCODE       DOWEQ     0                                                        MD056612
     C     SUBF_RRN      ANDLT     NumPerPag
     C*****MXDGDTK       READPE    MXDGECP0                               99    *           MD056612
     C/EXEC SQL                                                                             MD056612
     C+ fetch next  from BCursor into :MXDGEC                                               MD056612
     C/END-EXEC                                                                             MD056612
     C                   ADD       1             SUBF_RRN
     C                   ENDDO

     C/EXEC SQL                                                                             MD056612
     C+ close BCursor                                                                       MD056612
     C/END-EXEC                                                                             MD056612
                                                                                            MD056612
      * Issue start of file message

     C******IN99         IFEQ      '1'                                                      MD056612
     C     SQLCODE       IFEQ      100                                                      MD056612
     C                   MOVEL     *BLANK        DECATC
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
     C                   MOVEL     'MXDGDTMNT'   DDPGM
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

     C                   Z-ADD     11            NumPerPag         2 0

      * Mode (U = Allow updates, L = Allow Limited Updates)

     C     I#MODE        IFEQ      'U'
     C                   MOVE      '1'           *IN61
     C                   MOVE      '1'           *IN62
     C                   ENDIF
     C     I#MODE        IFEQ      'L'
     C                   MOVE      '1'           *IN62
     C                   ENDIF

      * Key lists

     C     MXDGDTK       KLIST
     C                   KFLD                    DGDTAG
     C     MXDGECK       KLIST
     C                   KFLD                    DGDTAG
     C                   KFLD                    DECATC

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
