     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*XBIF*: OVRDBF FILE(MXCOMFL2X) TOFILE(MXCOMFL2) SHARE(*NO)         : *
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MX Composite Message Formats Maintenance')
      *****************************************************************
      *                                                               *
      *  Midas - Meridian Export Module                               *
      *                                                               *
      *  MXCOMFMNT - Composite Message Formats Maintenance            *
      *                                                               *
      *  Function:  This module maintains composite message formats   *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. 256564             Date 17Sep08               *
      *                 251519             Date 20Nov07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CAAA03             Date 12Mar04               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CMX001  *CREATE    Data 01Jan00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  251519 - Moved 'write MSGSUBCT' after FOOTER to display      *
      *           message subfile on screen.                          *
      *  CAAA03 - Webfacing Changes                                   *
      *  CMX001 - Meridian Export                                     *
      *                                                               *
      *****************************************************************
 
     FMXCOMFMDD CF   E             WORKSTN
     F                                     SFILE(SUBFLREC:SUBF_RRN)
     FMXCOMFL2  IF   E           K DISK
     FMXCOMFL1  IF   E           K DISK
     F                                     RENAME(MXCOMFP0:MXCOMFALT)
     FMXCOMFL2X UF A E           K DISK
     F                                     RENAME(MXCOMFP0:MXCOMFUPD)
     F                                     PREFIX(P_)
     FMXEXFDL3  IF   E           K DISK
     FMXEXFFPD  IF   E           K DISK
 
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
 
     D MXCOMF        E DS                  EXTNAME(MXCOMFPD)
      * Composite Message Formats
     D P_MXCOMF      E DS                  EXTNAME(MXCOMFPD)
     D                                     PREFIX(P_)
      * Composite Message Formats
 
     D MXCOMD        E DS                  EXTNAME(MXCOMDPD)
      * Composite Message Details
 
 
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
 
 
     D #_SEQ           S              2    DIM(20) CTDATA PERRCD(20)
 
 
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           30
     C                   PARM                    I#MODE            1
     C                   PARM                    MXCOMF
     C                   PARM                    MXCOMD
     C                   PARM                    @INKC             1
     C                   PARM                    @INKL             1
 
      * Get Composite Message Format
 
     C                   EXSR      GET_COMF
 
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
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *****************************************************************
      * Validate the screen
      *****************************************************************
     C     VALID_SCN     BEGSR
 
      * Validate sequence in message
      * ----------------------------
 
     C     CFSEQM        IFNE      *BLANK
     C     CFSEQM        LOOKUP    #_SEQ                                  99    *
     C     *in99         IFEQ      '0'
     C                   MOVEL     'MX00110'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN10
     C                   ENDIF
     C                   ELSE
     C                   MOVEL     'MX00110'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN10
     C                   ENDIF
 
      * If add required, check that record does not already exist
      * ---------------------------------------------------------
 
     C     *IN60         IFEQ      '1'
     C                   MOVEL     MXCOMF        P_MXCOMF
     C     MXCOMFK       CHAIN     MXCOMFP0                           99        *
     C     *in99         IFEQ      '0'
     C                   MOVEL     P_MXCOMF      MXCOMF
     C                   MOVEL     'MX00121'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN10
     C                   ENDIF
     C                   ENDIF
 
      * Validate format
      * ---------------
 
      * Export format details selection
 
     C     CFFMT         IFEQ      '?'
     C                   EXSR      EXFD_SEL
     C                   ENDIF
 
      * It must be entered
 
     C     CFFMT         IFEQ      *BLANK
     C                   MOVEL     'MX00111'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN11
     C                   ELSE
 
      * It must exist as a format on MXEXFDPD
 
     C     CFFMT         CHAIN     MXEXFDP0                           99        *
     C     *in99         IFEQ      '1'
     C                   MOVEL     'MX00111'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN11
     C                   ELSE
     C                   MOVEL     EXACST        DDACST
 
      * It must have an access method if this is an activity extract
      * or if this is a current extract and NOT the driver.
 
     C     EXACSM        IFEQ      *BLANK
     C     CFEXTT        ANDEQ     'A'
     C     EXACSM        OREQ      *BLANK
     C     CFEXTT        ANDEQ     'C'
     C     CFPRSQ        ANDNE     '01'
     C     CFPRSQ        ANDNE     '  '
     C                   MOVEL     'MX00111'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN11
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
      * Validate processing sequence
      * ----------------------------
 
      * The processing sequence must be defined
 
     C     CFPRSQ        IFEQ      *BLANK
     C                   MOVEL     'MX00112'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN12
     C                   ELSE
 
      * The processing sequence must be a number from 01 to 20
 
     C     CFPRSQ        LOOKUP    #_SEQ                                  99    *
     C     *in99         IFEQ      '0'
     C                   MOVEL     'MX00112'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN12
     C                   ENDIF
     C                   ENDIF
 
      * If add required, check that processing sequence is not already used
      * -------------------------------------------------------------------
 
     C     *IN60         IFEQ      '1'
     C                   MOVEL     MXCOMF        P_MXCOMF
     C     MXCOMFKAP     CHAIN     MXCOMFALT                          99        *
     C     *in99         IFEQ      '0'
     C                   MOVEL     P_MXCOMF      MXCOMF
     C                   MOVEL     'MX00122'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN12
     C                   ENDIF
     C                   ENDIF
 
      * Validate description
      * --------------------
 
      * It must be entered
      * (Default to format description)
 
     C     *IN11         IFEQ      '0'
     C     CFDESC        ANDEQ     *BLANK
     C                   MOVEL     EXDESC        CFDESC
     C                   ENDIF
     C     CFDESC        IFEQ      *BLANK
     C                   MOVEL     'MX00113'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN13
     C                   ENDIF
 
      * Default multiple to that on the format
      * --------------------------------------
 
     C                   MOVE      EXACSX        CFMULT
     C     CFMULT        IFNE      'Y'
     C                   MOVE      'N'           CFMULT
     C                   ENDIF
 
      * Validate export
      * ---------------
 
      * It must be Y or N
      * (Default to Y)
 
     C     CFEXPT        IFEQ      ' '
     C                   MOVE      'Y'           CFEXPT
     C                   ENDIF
     C     CFEXPT        IFNE      'Y'
     C     CFEXPT        ANDNE     'N'
     C                   MOVEL     'MX00115'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN15
     C                   ENDIF
 
      * Validate MQ series file type
      * ----------------------------
 
      * It must be L, M ,S, V or X
      * (Default to L)
 
     C     CFFILT        IFEQ      ' '
     C                   MOVE      'L'           CFFILT
     C                   ENDIF
     C     CFFILT        IFNE      'L'
     C     CFFILT        ANDNE     'M'
     C     CFFILT        ANDNE     'S'
     C     CFFILT        ANDNE     'V'
     C     CFFILT        ANDNE     'X'
     C                   MOVEL     'MX00116'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN16
     C                   ENDIF
 
      * Validate optimize file type
      * ---------------------------
 
      * It must be Y or N
      * (Default to Y)
 
     C     CFOPTF        IFEQ      ' '
     C                   MOVE      'Y'           CFOPTF
     C                   ENDIF
     C     CFOPTF        IFNE      'Y'
     C     CFOPTF        ANDNE     'N'
     C                   MOVEL     'MX00117'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN17
     C                   ENDIF
 
      * If processing sequence is valid
 
     C     *IN12         IFEQ      '0'
 
      * Composite format selection for link-to processing sequence
 
     C     CFLPRS        IFEQ      '?'
     C                   EXSR      COMF_SEL
     C                   ENDIF
 
      * Validate link-to processing sequence
      * ------------------------------------
 
      * If this format is linked to itself
 
     C     CFLPRS        IFEQ      CFPRSQ
 
      * Only the driver can be linked to itself
 
     C     CFPRSQ        IFNE      '01'
     C                   MOVEL     'MX00118'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN18
     C                   ELSE
 
      * Multiples are not allowed as drivers
 
     C     CFMULT        IFEQ      'Y'
     C                   MOVEL     'MX00118'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN18
     C                   ELSE
 
      * Mark this format as a driver
 
     C                   MOVEL     CFDESC        DDDESC
     C                   MOVEL     '*DRIVER     'CFLFMT
     C                   ENDIF
     C                   ENDIF
 
      * If this format is NOT linked to itself
 
     C                   ELSE
 
      * The link-to processing sequence must point to an existing format
 
     C                   MOVEL     MXCOMF        P_MXCOMF
     C     MXCOMFKAL     CHAIN     MXCOMFALT                          99        *
     C     *in99         IFEQ      '1'
     C                   MOVEL     'MX00118'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN18
     C                   ELSE
     C                   MOVEL     CFDESC        DDDESC
     C                   MOVEL     CFFMT         P_CFLFMT
     C                   MOVEL     P_MXCOMF      MXCOMF
 
      * The link-to processing sequence
      * must be prior to the processing sequence
 
     C                   MOVEL     CFLPRS        @LPRS             2 0
     C                   MOVEL     CFPRSQ        @PRSQ             2 0
     C     @LPRS         IFGT      @PRSQ
     C                   MOVEL     'MX00118'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN18
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
      * Validate show link-to fields
 
     C     DDSHLF        IFNE      'Y'
     C     DDSHLF        ANDNE     'N'
     C                   MOVEL     'MX00119'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN19
     C                   ENDIF
 
      * If no access module is present
 
     C     EXACSM        IFEQ      *BLANK
 
      * If the format and processing sequences are not in error
      * zeroize the link-to buffer positions
 
     C     *IN11         IFEQ      '0'
     C     *IN12         ANDEQ     '0'
     C     *IN18         ANDEQ     '0'
     C                   Z-ADD     *ZERO         CFLBP1
     C                   Z-ADD     *ZERO         CFLBP2
     C                   Z-ADD     *ZERO         CFLBP3
     C                   Z-ADD     *ZERO         CFLBP4
     C                   Z-ADD     *ZERO         CFLBP5
     C                   Z-ADD     *ZERO         CFLBP6
     C                   Z-ADD     *ZERO         CFLLN1
     C                   Z-ADD     *ZERO         CFLLN2
     C                   Z-ADD     *ZERO         CFLLN3
     C                   Z-ADD     *ZERO         CFLLN4
     C                   Z-ADD     *ZERO         CFLLN5
     C                   Z-ADD     *ZERO         CFLLN6
     C                   ENDIF
 
      * If an access module is present
 
     C                   ELSE
 
      * Call link-to field selection function
 
     C     DDSHLF        IFEQ      'Y'
     C     *IN11         ANDEQ     '0'
     C     *IN12         ANDEQ     '0'
     C     *IN18         ANDEQ     '0'
     C                   EXSR      LFLD_SEL
     C                   ENDIF
 
      * Validate link-to fields
 
     C                   EXSR      VAL_LNKTF
     C     LnkTfERR      IFEQ      'Y'
     C                   MOVEL     'MX00120'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN19
     C                   ENDIF
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
      * Validate link-to fields
      ********************************************************************
     C     VAL_LNKTF     BEGSR
 
     C                   MOVEL     'N'           LnkTfERR          1
 
      * There must be at least one link field defined
 
     C     CFLBP1        IFEQ      *ZERO
     C                   MOVEL     'Y'           LnkTfERR
     C                   ELSE
 
      * Validate against number of access parameters 1 to 6
 
     C                   SELECT
      * #1
     C     EXACSP        WHENEQ    1
 
     C     CFLBP2        IFNE      *ZERO
     C     CFLBP3        ORNE      *ZERO
     C     CFLBP4        ORNE      *ZERO
     C     CFLBP5        ORNE      *ZERO
     C     CFLBP6        ORNE      *ZERO
     C                   MOVEL     'Y'           LnkTfERR
     C                   ENDIF
      * #2
     C     EXACSP        WHENEQ    2
 
     C     CFLBP2        IFEQ      *ZERO
     C     CFLBP3        ORNE      *ZERO
     C     CFLBP4        ORNE      *ZERO
     C     CFLBP5        ORNE      *ZERO
     C     CFLBP6        ORNE      *ZERO
     C                   MOVEL     'Y'           LnkTfERR
     C                   ENDIF
      * #3
     C     EXACSP        WHENEQ    3
 
     C     CFLBP2        IFEQ      *ZERO
     C     CFLBP3        OREQ      *ZERO
     C     CFLBP4        ORNE      *ZERO
     C     CFLBP5        ORNE      *ZERO
     C     CFLBP6        ORNE      *ZERO
     C                   MOVEL     'Y'           LnkTfERR
     C                   ENDIF
      * #4
     C     EXACSP        WHENEQ    4
 
     C     CFLBP2        IFEQ      *ZERO
     C     CFLBP3        OREQ      *ZERO
     C     CFLBP4        OREQ      *ZERO
     C     CFLBP5        ORNE      *ZERO
     C     CFLBP6        ORNE      *ZERO
     C                   MOVEL     'Y'           LnkTfERR
     C                   ENDIF
      * #5
     C     EXACSP        WHENEQ    5
 
     C     CFLBP2        IFEQ      *ZERO
     C     CFLBP3        OREQ      *ZERO
     C     CFLBP4        OREQ      *ZERO
     C     CFLBP5        OREQ      *ZERO
     C     CFLBP6        ORNE      *ZERO
     C                   MOVEL     'Y'           LnkTfERR
     C                   ENDIF
      * #6
     C     EXACSP        WHENEQ    6
 
     C     CFLBP2        IFEQ      *ZERO
     C     CFLBP3        OREQ      *ZERO
     C     CFLBP4        OREQ      *ZERO
     C     CFLBP5        OREQ      *ZERO
     C     CFLBP6        OREQ      *ZERO
     C                   MOVEL     'Y'           LnkTfERR
     C                   ENDIF
 
     C                   ENDSL
 
     C                   ENDIF
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *****************************************************************
      * Link field selection
      ********************************************************************
     C     LFLD_SEL      BEGSR
 
     C                   CALL      'MXLFLDSEL'
     C                   PARM      *BLANK        W#RTCD            7
     C                   PARM      *BLANK        W#ERMS           30
     C                   PARM                    I#MODE            1
     C                   PARM                    MXCOMF
     C                   PARM                    DDDESC           42
     C                   PARM                    DDACST           60
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKF             1
     C                   PARM      '0'           @INKL             1
 
      * Error
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO MXLFLDSEL'
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * Check returned function keys
 
     C                   MOVE      @INKC         *INKC
     C     @INKF         IFEQ      '1'
     C     @INKL         OREQ      '1'
     C                   MOVE      'N'           DDSHLF
     C                   ENDIF
 
      * Return to top of subfile page
 
     C                   Z-ADD     ToP_IBO       WHIBO
     C                   Z-ADD     ToP_FOBO      WHFOBO
     C                   Z-ADD     *ZERO         SUBF_RRN
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *****************************************************************
      * Export format details selection
      ********************************************************************
     C     EXFD_SEL      BEGSR
 
     C                   CALL      'MXEXFDSEL'
     C                   PARM      *BLANK        W#RTCD            7
     C                   PARM      *BLANK        W#ERMS           30
     C                   PARM                    I#MODE            1
     C                   PARM                    CFFMT
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKL             1
 
      * Error
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO MXEXFDSEL'
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * Check returned function keys
 
     C                   MOVE      @INKC         *INKC
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *****************************************************************
      * Composite Format Selection
      ********************************************************************
     C     COMF_SEL      BEGSR
 
     C                   CALL      'MXCOMFSEL'
     C                   PARM      *BLANK        W#RTCD            7
     C                   PARM      *BLANK        W#ERMS           30
     C                   PARM                    I#MODE            1
     C                   PARM                    CDCOMI
     C                   PARM                    CDEXTT
     C                   PARM                    CFFMT
     C                   PARM                    CFPRSQ
     C                   PARM                    CFDESC
     C                   PARM                    CFLPRS
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKL             1
 
      * Error
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO MXCOMFSEL'
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * Check returned function keys
 
     C                   MOVE      @INKC         *INKC
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *****************************************************************
      * Update the primary record
      ********************************************************************
     C     UPD_PrmREC    BEGSR
 
     C     MXCOMFK       CHAIN     MXCOMFUPD                          99        *
     C                   MOVEL     MXCOMF        P_MXCOMF
     C     *in99         IFEQ      '1'
     C                   WRITE     MXCOMFUPD                                    *
     C                   ELSE
     C                   UPDATE    MXCOMFUPD                                    *
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Delete the primary record
      ********************************************************************
     C     DEL_PrmREC    BEGSR
 
     C     MXCOMFK       CHAIN     MXCOMFUPD                          99        *
     C     *in99         IFEQ      '0'
     C                   DELETE    MXCOMFUPD                                    *
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
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
     C     MXEXFFKP      READE     MXEXFFP0                               99    *
     C     *IN99         DOWEQ     '0'
     C     WHINEX        ANDNE     'Y'
     C     MXEXFFKP      READE     MXEXFFP0                               99    *
     C                   ENDDO
 
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
     C     MXEXFFKP      READE     MXEXFFP0                               99    *
     C     *IN99         DOWEQ     '0'
     C     WHINEX        ANDNE     'Y'
     C     MXEXFFKP      READE     MXEXFFP0                               99    *
     C                   ENDDO
     C     *IN99         IFEQ      '1'
     C                   Z-ADD     *ZERO         WHIBO
     C                   Z-ADD     *ZERO         WHFOBO
     C                   MOVEL     'MX00001'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ELSE
     C                   SETON                                            99    *
     C                   END
     C                   ELSE
     C     MXEXFFKP      READE     MXEXFFP0                               99    *
     C     *IN99         DOWEQ     '0'
     C     WHINEX        ANDNE     'Y'
     C     MXEXFFKP      READE     MXEXFFP0                               99    *
     C                   ENDDO
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
      * Get Composite Message Format
      ********************************************************************
     C     GET_COMF      BEGSR
 
     C     MXCOMFK       CHAIN     MXCOMFP0                           60        *
     C     *IN60         IFEQ      '1'
     C                   CLEAR                   MXCOMF
     C                   ENDIF
 
     C                   MOVEL     'Y'           DDSHLF
 
     C                   MOVEL     CDCOMI        CFCOMI
     C                   MOVEL     CDEXTT        CFEXTT
 
      * Get file name of format
 
     C     CFFMT         CHAIN     MXEXFDP0                           99        *
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Format data for output
      ********************************************************************
     C     FMT_DATA      BEGSR
 
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
     C     MXEXFFKP      READPE    MXEXFFP0                               99    *
     C     *IN99         DOWEQ     '0'
     C     WHINEX        ANDNE     'Y'
     C     MXEXFFKP      READPE    MXEXFFP0                               99    *
     C                   ENDDO
 
      * Read previous
      * until count matches count of records previous read
 
     C     *IN99         DOWEQ     '0'
     C     SUBF_RRN      ANDLT     NumPerPag
     C     MXEXFFKP      READPE    MXEXFFP0                               99    *
     C     *IN99         DOWEQ     '0'
     C     WHINEX        ANDNE     'Y'
     C     MXEXFFKP      READPE    MXEXFFP0                               99    *
     C                   ENDDO
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
      * *INZSR - Initial subroutine called automatically at program start
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** Initialize program name
      *
     C                   MOVEL     'MXCOMFMNT'   DDPGM
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
 
     C                   Z-ADD     10            NumPerPag         2 0
 
      * Initialize pointer
 
     C                   Z-ADD     *ZERO         WHIBO
     C                   Z-ADD     *ZERO         WHFOBO
 
      * Initialize toggle
 
     C                   MOVEL     'N'           Name_Text         1
 
      * Mode (U = Allow updates)
 
     C     I#MODE        IFEQ      'U'
     C                   MOVE      '1'           *IN61
     C                   ENDIF
 
      * If extract type is current, protect/non-display fields
 
     C     CDEXTT        IFEQ      'C'
     C                   MOVE      '1'           *IN63
     C                   ENDIF
 
      * Key lists
 
     C     MXCOMFK       KLIST
     C                   KFLD                    CFCOMI
     C                   KFLD                    CFEXTT
     C                   KFLD                    CFSEQM
     C     MXCOMFKAP     KLIST
     C                   KFLD                    CFCOMI
     C                   KFLD                    CFEXTT
     C                   KFLD                    CFPRSQ
     C     MXCOMFKAL     KLIST
     C                   KFLD                    CFCOMI
     C                   KFLD                    CFEXTT
     C                   KFLD                    CFLPRS
     C     MXEXFFKP      KLIST
     C                   KFLD                    EXFILE
     C                   KFLD                    EXFSQN
     C     MXEXFFK       KLIST
     C                   KFLD                    EXFILE
     C                   KFLD                    EXFSQN
     C                   KFLD                    WHIBO
     C                   KFLD                    WHFOBO
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY MXCPYSRC,MXPSSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2001
** #_SEQ
0102030405060708091011121314151617181920
