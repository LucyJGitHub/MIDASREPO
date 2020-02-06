     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MX Export Format Selection Criteria Maintena')
      *****************************************************************
      *                                                               *
      *  Midas - Meridian Export Module                               *
      *                                                               *
      *  MXEXFSMNT - Export Format Selection Criteria Maintenance     *
      *                                                               *
      *  Function:  This module allows definition of export format    *
      *             selection criteria.                               *
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
 
     FMXEXFSMDD CF   E             WORKSTN
     F                                     SFILE(SUBFLRE1:SUBF_RRN1)
     F                                     SFILE(SUBFLRE2:SUBF_RRN2)
     FMXEXFFPD  IF   E           K DISK
     FMXEXFFL3  IF   E           K DISK
     F                                     RENAME(MXEXFFP0:MXEXFFZ0)
     FMXEXFSPD  IF   E           K DISK
     FMXEXFSL1  UF A E           K DISK
     F                                     RENAME(MXEXFSP0:MXEXFSUPD)
 
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
 
 
     D                 DS
     D  FilDATA                1     25
     D  ESSIAO                 1      3
     D  ESSFLD                 4     13
     D  ESSCMP                14     15
     D  ESSCPV                16     25
 
     D                 DS
     D  ScnDATA                1     25
     D  DDSIAO                 1      3
     D  DDSFLD                 4     13
     D  DDSCMP                14     15
     D  DDSCPV                16     25
 
 
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           30
     C                   PARM                    I#MODE            1
     C                   PARM                    EXFILE           10
     C                   PARM                    EXFSQN            1
     C                   PARM                    EXFMT            10
     C                   PARM                    EXDESC           42
     C                   PARM                    @INKC             1
     C                   PARM                    @INKL             1
 
      * Set up file and file sequence for MXEXFSPD
 
     C                   MOVEL     EXFILE        ESFILE
     C                   MOVEL     EXFSQN        ESFSQN
 
      * Fill both subfiles
 
     C                   EXSR      FILL_SUBF1
     C                   EXSR      FILL_SUBF2
     C                   MOVE      'Y'           Subf_Load         1
 
      * Display subfile screen until F3, F6, or F12 taken
 
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
      * Display subfile screen
      *****************************************************************
     C     DSPLAY_SCN    BEGSR
 
      * Write subfile control and foooter
 
     C                   TIME                    DDTIME
     C                   WRITE     MSGSUBCTL
     C**********         WRITE     SUBFLCT1                                                   CAAA03
     C                   WRITE     SUBFLCT2
     C                   WRITE     FOOTER
 
      * Read subfile control
 
     C                   WRITE     SUBFLCT1                                                   CAAA03
     C                   READ      SUBFLCT1                               99    *
 
      ** Clear the message queue & init error indicators
 
     C                   EXSR      CLR_MSGQ
 
      ** If F3 and F12 were not taken
 
     C     *INKC         IFEQ      '0'
     C     *INKL         ANDEQ     '0'
 
      * Rolldown requested
 
     C     *IN05         CASEQ     '1'           FILL_SUBF1
 
      * Validate the subfile
 
     C                   CAS                     VALID_SUBF1
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
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *****************************************************************
      * Fill subfile 1
      *****************************************************************
     C     FILL_SUBF1    BEGSR
 
     C                   Z-ADD     MSUBF_RRN1    SUBF_RRN1
     C                   MOVEA     '000'         *IN(1)
     C                   MOVEA     '1'           *IN(4)
     C                   MOVEA     '00000'       *IN(41)
     C                   MOVEL     *BLANK        ScnData
 
     C                   WRITE     SUBFLCT1                                     *
 
      * LOAD UP SUBFILE UNTIL END OF FILE
 
     C     *IN90         DOUEQ     '1'
 
      * DO 9 TIMES
 
     C                   DO        9
     C                   ADD       1             SUBF_RRN1         4 0    04         *
     C                   Z-ADD     SUBF_RRN1     ESSELN
     C                   MOVEL     *BLANK        FilData
     C     MXEXFSKF      CHAIN     MXEXFSP0                           90        *
     C                   MOVEL     FilData       ScnData
     C                   WRITE     SUBFLRE1
     C                   ENDDO
 
     C                   ENDDO
 
      * RESET SUBFILE
 
     C     *IN(4)        IFEQ      '1'
     C                   MOVEA     '010'         *IN(1)
     C                   ELSE
     C                   MOVEA     '111'         *IN(1)
     C                   END
 
     C     Subf_Load     IFEQ      'Y'
     C     SUBF_RRN1     SUB       6             PRRN1             4 0
     C                   ELSE
     C                   Z-ADD     1             PRRN1                                FIRST CYCLE
     C                   ENDIF
 
     C                   Z-ADD     SUBF_RRN1     MSUBF_RRN1
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *****************************************************************
      * Fill the subfile
      *****************************************************************
     C     FILL_SUBF2    BEGSR
 
     C                   MOVEA     '000'         *IN(11)
     C                   MOVEA     '1'           *IN(14)
     C                   Z-ADD     *ZERO         SUBF_RRN2
     C                   WRITE     SUBFLCT2                                     *
     C     MXEXFSKP      SETLL     MXEXFFP0
     C     MXEXFSKP      READE     MXEXFFP0                               99    *
 
      * DO WHILE NOT EOF
 
     C     *IN99         DOWEQ     '0'
 
     C     WHINEX        IFEQ      'Y'
     C                   EXSR      FMT_DATA
     C                   ADD       1             SUBF_RRN2         4 0    14    *
     C                   WRITE     SUBFLRE2
     C                   ENDIF
 
     C     MXEXFSKP      READE     MXEXFFP0                               99    *
     C                   ENDDO
 
      * RESET SUBFILE
 
     C     *IN(14)       IFEQ      '1'
     C                   MOVEA     '010'         *IN(11)
     C                   ELSE
     C                   MOVEA     '111'         *IN(11)
     C                   END
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *****************************************************************
      * Validate the subfile
      *****************************************************************
     C     VALID_SUBF1   BEGSR
 
     C                   Z-ADD     *ZERO         PRRN1
     C                   Z-ADD     1             SUBF_RRN1
     C                   Z-ADD     *ZERO         SUBF_RRN          3 0
 
      * Validate subfile details
 
     C     SUBF_RRN1     CHAIN     SUBFLRE1                           99
     C     *IN99         DOWEQ     '0'
     C                   EXSR      VALID_DET
     C                   ADD       1             SUBF_RRN1
     C     SUBF_RRN1     CHAIN     SUBFLRE1                           99
     C                   ENDDO
 
      * CK/6 TO UPDATE
 
     C     *INKF         IFEQ      '1'
     C     PRRN1         ANDEQ     *ZERO
     C                   EXSR      UPD_EXFS
     C                   ELSE
     C     PRRN1         IFEQ      *ZERO
     C                   Z-ADD     1             PRRN1
     C                   ENDIF
     C                   MOVE      '0'           *INKF
     C                   ENDIF
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *****************************************************************
      * Validate subfile details
      *****************************************************************
     C     VALID_DET     BEGSR
 
     C                   MOVEA     '00000'       *IN(41)
 
      * IF DATA DEFINED
 
     C     ScnData       IFNE      *BLANK
 
      * INCREMENT SUBFILE RECORDS READ
 
     C                   ADD       1             SUBF_RRN
 
      * IF FIRST SUBFILE RECORD READ
 
     C     SUBF_RRN      IFEQ      1
 
     C     DDSIAO        IFEQ      *BLANK
     C                   MOVEL     'IF '         DDSIAO
     C                   END
 
     C     DDSIAO        IFNE      'IF '
     C                   MOVEL     'MX00701'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN41
     C                   END
 
      * IF NOT FIRST SUBFILE RECORD READ
 
     C                   ELSE
 
     C     DDSIAO        IFEQ      'IF '
     C                   MOVEL     'MX00702'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN41
     C                   END
 
     C                   END
 
      * CHECK IF/AND/OR
 
     C     DDSIAO        IFNE      'IF '
     C     DDSIAO        ANDNE     'AND'
     C     DDSIAO        ANDNE     'OR '
     C                   MOVEL     'MX00703'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN41
     C                   END
 
      * CHECK FIELD IS ENTERED
 
     C     DDSFLD        IFEQ      *BLANK
     C                   MOVEL     'MX00704'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN42
     C                   END
 
      * CHECK FIELD EXISTS
 
     C     MXEXFFKF      CHAIN     MXEXFFZ0                           99        *
     C     *IN99         IFEQ      '1'
     C     *IN99         OREQ      '0'
     C     WHINEX        ANDNE     'Y'
     C                   MOVEL     'MX00705'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN42
     C                   ELSE
 
     C     WHFLDT        IFEQ      'S'
     C     WHFLDD        ANDGT     10
     C     WHFLDT        OREQ      'S'
     C     WHFLDP        ANDGT     0
 
     C     WHFLDT        OREQ      'P'
     C     WHFLDD        ANDGT     10
     C     WHFLDT        OREQ      'P'
     C     WHFLDP        ANDGT     0
 
     C     WHFLDT        ORNE      'S'
     C     WHFLDT        ANDNE     'P'
     C     WHFLDB        ANDGT     10
     C                   MOVEL     'MX00706'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN42
     C                   ENDIF
     C                   ENDIF
 
      * CHECK COMPARISON
 
     C     DDSCMP        IFNE      'EQ'
     C     DDSCMP        ANDNE     'NE'
     C     DDSCMP        ANDNE     'GT'
     C     DDSCMP        ANDNE     'GE'
     C     DDSCMP        ANDNE     'LT'
     C     DDSCMP        ANDNE     'LE'
     C                   MOVEL     'MX00707'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN43
     C                   END
 
      * CHECK COMPARISON VALUE IS ENTERED
      * IF THE FIELD IS A NUMBER
 
     C     DDSCPV        IFEQ      *BLANK
     C     WHFLDT        ANDNE     'A'
     C                   MOVEL     'MX00708'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN44
     C                   END
 
      * VALIDATE COMPARISON & COMPARISON VALUE, IF NO ERRORS
 
     C     *IN50         IFEQ      '0'
     C                   CALLB     'MXEXFSCVV'
     C                   PARM      *BLANK        W#RTCD            7
     C                   PARM      *BLANK        W#ERMS           30
     C                   PARM                    WHFLDT
     C                   PARM                    WHFLDD
     C                   PARM                    WHFLDB
     C                   PARM                    DDSCPV
 
      * Error
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO MXEXFSCVV'
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * Invalid code for date
     C     W#RTCD        IFEQ      'INVDAT'
     C                   MOVEL     'MX00709'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN44
     C                   END
 
      * Invalid size
     C     W#RTCD        IFEQ      'INVSIZ'
     C                   MOVEL     'MX00710'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN44
     C                   END
 
      * Invalid number
     C     W#RTCD        IFEQ      'INVNUM'
     C                   MOVEL     'MX00711'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN44
     C                   END
 
      * Invalid character(s)
     C     W#RTCD        IFEQ      'INVCHR'
     C                   MOVEL     'MX00712'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN44
     C                   END
      *
     C                   END
     C                   END
 
      * Update indicator on the subfile record.
 
     C                   UPDATE    SUBFLRE1
 
      * If this is the first error, point to the subfile record.
 
     C     *IN50         IFEQ      '1'
     C     PRRN1         ANDEQ     *ZERO
     C                   Z-ADD     SUBF_RRN1     PRRN1
     C                   END
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *****************************************************************
      * Update the primary record
      ********************************************************************
     C     UPD_EXFS      BEGSR
 
     C                   Z-ADD     *ZERO         ESSELN
     C                   Z-ADD     1             SUBF_RRN1
 
      * UPDATE records on MXEXFSPD with subfile details
 
     C     SUBF_RRN1     CHAIN     SUBFLRE1                           99
     C     *IN99         DOWEQ     '0'
     C     ScnData       IFNE      *BLANK
     C                   ADD       1             ESSELN
     C     MXEXFSKF      CHAIN     MXEXFSUPD                          90
     C                   MOVEL     ScnData       FilData
     C                   Z-ADD     WHFOBO        ESFOBO
     C   90              WRITE     MXEXFSUPD
     C  N90              UPDATE    MXEXFSUPD
     C                   END
     C                   ADD       1             SUBF_RRN1
     C     SUBF_RRN1     CHAIN     SUBFLRE1                           99
     C                   END
 
      * DELETE remaining records
 
     C     MXEXFSKF      SETGT     MXEXFSUPD
     C     MXEXFSKP      READE     MXEXFSUPD                              99    *
     C     *IN99         DOWEQ     '0'
     C                   DELETE    MXEXFSUPD
     C     MXEXFSKP      READE     MXEXFSUPD                              99    *
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Format data for output
      ********************************************************************
     C     FMT_DATA      BEGSR
 
      * Field
     C                   MOVEL     WHFLDI        DDFLDI
     C                   MOVE      WHSREF        DDFLDI
 
     C                   MOVEL     *BLANK        DDMFNM
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
     C                   MOVEL     'MXEXFSMNT'   DDPGM
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
      *
     C                   Z-ADD     *ZERO         MSUBF_RRN1        4 0
 
      * Key lists
 
     C     MXEXFSKF      KLIST
     C                   KFLD                    ESFILE
     C                   KFLD                    ESFSQN
     C                   KFLD                    ESSELN
     C     MXEXFSKP      KLIST
     C                   KFLD                    ESFILE
     C                   KFLD                    ESFSQN
     C     MXEXFFKF      KLIST
     C                   KFLD                    ESFILE
     C                   KFLD                    ESFSQN
     C                   KFLD                    DDSFLD
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY MXCPYSRC,MXPSSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2001
