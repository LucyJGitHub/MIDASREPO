     H DEBUG
/*XBIF*: OVRDBF FILE(MXEXFFZZ) TOFILE(MXEXFFPD) SHARE(*NO)          : *
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MX Link Fields Selection')
      *****************************************************************
      *                                                               *
      *  Midas - Meridian Export Module                               *
      *                                                               *
      *  MXLFLDSEL - Link Fields Selection                            *
      *                                                               *
      *  Function:  This module allows selection and enquiry          *
      *             of link fields                                    *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. 251519             Date 20Nov07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CMX001  *CREATE    Date 01Jan00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  251519 - Moved SUBFLCTL record format after FOOTER to prevent*
      *           WF0092 application error from occurring in the      *
      *           webface screen. Patterned after CAAA03. Also, moved *
      *           MSGSUBCT to display message subfile on screen.      *
      *  CMX001 - Meridian Export                                     *
      *                                                               *
      *****************************************************************
 
     FMXLFLDSDD CF   E             WORKSTN
     F                                     SFILE(SUBFLREC:SUBF_RRN)
     FMXEXFDL2  IF   E           K DISK
     F                                     RENAME(MXEXFDP0:MXEXFDALT)
     FMXEXFFPD  IF   E           K DISK
     FMXEXFFZZ  UF A E           K DISK
     F                                     RENAME(MXEXFFP0:MXEXFFZ0)
 
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
 
 
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           30
     C                   PARM                    I#MODE            1
     C                   PARM                    MXCOMF
     C                   PARM                    DDDESC
     C                   PARM                    DDACST
     C                   PARM                    @INKC             1
     C                   PARM                    @INKF             1
     C                   PARM                    @INKL             1
 
      * Get Export Format Details
 
     C                   EXSR      GET_EXFD
 
      * Display subfile screen until F3, F6, or F12 taken
 
     C     *INKC         DOWEQ     '0'
     C     *INKF         ANDEQ     '0'
     C     *INKL         ANDEQ     '0'
     C                   EXSR      DSPLAY_SCN
     C                   END
 
      * Pass back function keys taken
 
     C                   MOVE      *INKC         @INKC
     C                   MOVE      *INKF         @INKF
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
     C**********         WRITE     SUBFLCTL                                                   251519
     C                   WRITE     FOOTER
 
      * Read subfile control
 
     C                   WRITE     MSGSUBCT                                                   251519
     C                   WRITE     SUBFLCTL                                                   251519
     C                   READ      SUBFLCTL                               99    *
 
      ** Clear the message queue & init error indicators
 
     C                   EXSR      CLR_MSGQ
 
      ** If F3 and F12 were not taken
 
     C     *INKC         IFEQ      '0'
     C     *INKL         ANDEQ     '0'
 
      * Rolldown requested
 
     C     *IN05         CASEQ     '1'           ROLLDOWN
 
      * Update the primary record
 
     C     *INKF         CASEQ     '1'           UPD_PrmREC
 
      * Check for a record selected from the subfile
 
     C     *IN(04)       CASEQ     '0'           CHK_SUBF
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
      * Update the primary record
      ********************************************************************
     C     UPD_PrmREC    BEGSR
 
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
 
      * Read workfile
 
     C     MXEXFDK       SETLL     MXEXFFZ0                                     *
     C     MXEXFDK       READE     MXEXFFZ0                               99    *
     C     *IN99         DOWEQ     '0'
     C                   SELECT
     C     WHLSEQ        WHENEQ    '1'
     C     CFLBP1        ANDEQ     *ZERO
     C                   Z-ADD     WHFOBO        CFLBP1
     C                   Z-ADD     WHFLDB        CFLLN1
     C     WHLSEQ        WHENEQ    '2'
     C     CFLBP2        ANDEQ     *ZERO
     C                   Z-ADD     WHFOBO        CFLBP2
     C                   Z-ADD     WHFLDB        CFLLN2
     C     WHLSEQ        WHENEQ    '3'
     C     CFLBP3        ANDEQ     *ZERO
     C                   Z-ADD     WHFOBO        CFLBP3
     C                   Z-ADD     WHFLDB        CFLLN3
     C     WHLSEQ        WHENEQ    '4'
     C     CFLBP4        ANDEQ     *ZERO
     C                   Z-ADD     WHFOBO        CFLBP4
     C                   Z-ADD     WHFLDB        CFLLN4
     C     WHLSEQ        WHENEQ    '5'
     C     CFLBP5        ANDEQ     *ZERO
     C                   Z-ADD     WHFOBO        CFLBP5
     C                   Z-ADD     WHFLDB        CFLLN5
     C     WHLSEQ        WHENEQ    '6'
     C     CFLBP6        ANDEQ     *ZERO
     C                   Z-ADD     WHFOBO        CFLBP6
     C                   Z-ADD     WHFLDB        CFLLN6
     C                   ENDSL
     C     MXEXFDK       READE     MXEXFFZ0                               99    *
     C                   ENDDO
 
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
 
      * Maintain the record in the subfile
 
     C                   EXSR      MNT_SflREC
 
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
      * Fill subfile
      *****************************************************************
     C     FILL_SUBF     BEGSR
 
     C                   MOVEA     '000'         *IN(1)
     C                   MOVEA     '1'           *IN(4)
     C                   Z-ADD     *ZERO         SUBF_RRN
 
      * Write subfile control
 
     C                   WRITE     SUBFLCTL                                     *
 
      * Get first record
 
     C     MXEXFFK       SETLL     MXEXFFZ0
     C     MXEXFDK       READE     MXEXFFZ0                               99    *
 
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
     C     MXEXFDK       READE     MXEXFFZ0                               99    *
     C     *IN99         IFEQ      '1'
     C                   Z-ADD     *ZERO         WHIBO
     C                   Z-ADD     *ZERO         WHFOBO
     C                   MOVEL     'MX00001'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ELSE
     C                   SETON                                            99    *
     C                   END
     C                   ELSE
     C     MXEXFDK       READE     MXEXFFZ0                               99    *
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
 
      * Update sequence on record
 
     C     MXEXFFK       CHAIN     MXEXFFZ0                           99        *
     C     *IN99         IFEQ      '0'
     C                   MOVEL     DDACTN        WHLSEQ
     C                   UPDATE    MXEXFFZ0
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
 
     C     CFLFMT        IFEQ      '*DRIVER   '
     C     MXEXFDKAL1    CHAIN     MXEXFDALT                          60        *
     C                   ELSE
     C     MXEXFDKAL2    CHAIN     MXEXFDALT                          60        *
     C                   ENDIF
     C     *IN60         IFEQ      '1'
     C                   EVAL      I#ERMS = 'ERROR IN LINK-TO FORMAT'
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * Clear workfile
 
     C     MXEXFDK       SETLL     MXEXFFZ0                                     *
     C     MXEXFDK       READE     MXEXFFZ0                               99    *
     C     *IN99         DOWEQ     '0'
     C                   DELETE    MXEXFFZ0
     C     MXEXFDK       READE     MXEXFFZ0                               99    *
     C                   ENDDO
 
      * Load workfile
 
     C     MXEXFDK       SETLL     MXEXFFP0                                     *
     C     MXEXFDK       READE     MXEXFFP0                               99    *
     C     *IN99         DOWEQ     '0'
     C                   SELECT
     C     WHFOBO        WHENEQ    CFLBP1
     C                   MOVE      '1'           WHLSEQ
     C     WHFOBO        WHENEQ    CFLBP2
     C                   MOVE      '2'           WHLSEQ
     C     WHFOBO        WHENEQ    CFLBP3
     C                   MOVE      '3'           WHLSEQ
     C     WHFOBO        WHENEQ    CFLBP4
     C                   MOVE      '4'           WHLSEQ
     C     WHFOBO        WHENEQ    CFLBP5
     C                   MOVE      '5'           WHLSEQ
     C     WHFOBO        WHENEQ    CFLBP6
     C                   MOVE      '6'           WHLSEQ
     C                   ENDSL
     C                   WRITE     MXEXFFZ0
     C     MXEXFDK       READE     MXEXFFP0                               99    *
     C                   ENDDO
 
      * Initialize pointer
 
     C                   Z-ADD     *ZERO         WHIBO
     C                   Z-ADD     *ZERO         WHFOBO
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Format data for output
      ********************************************************************
     C     FMT_DATA      BEGSR
 
     C                   MOVEL     WHLSEQ        DDACTN
 
      * Include In Export
     C     WHINEX        IFEQ      'Y'
     C                   MOVE      '1'           *IN62
     C                   ELSE
     C                   MOVE      '0'           *IN62
     C                   ENDIF
 
      * Link field selection
     C     WHLSEQ        IFNE      *BLANK
     C                   MOVE      '1'           *IN63
     C                   ELSE
     C                   MOVE      '0'           *IN63
     C                   ENDIF
 
      * Field
     C                   MOVEL     WHFLDI        DDFLDI
 
      * Field Name
     C                   MOVEL     WHMFNM        DDMFNM
 
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
 
     C     MXEXFFK       SETGT     MXEXFFZ0
     C     MXEXFDK       READPE    MXEXFFZ0                               99    *
 
      * Read previous
      * until count matches count of records previous read
 
     C     *IN99         DOWEQ     '0'
     C     SUBF_RRN      ANDLT     NumPerPag
     C     MXEXFDK       READPE    MXEXFFZ0                               99    *
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
     C                   MOVEL     'MXLFLDSEL'   DDPGM
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
     C     MXEXFDKAL1    KLIST
     C                   KFLD                    CFFMT
     C     MXEXFDKAL2    KLIST
     C                   KFLD                    CFLFMT
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY MXCPYSRC,MXPSSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2001
