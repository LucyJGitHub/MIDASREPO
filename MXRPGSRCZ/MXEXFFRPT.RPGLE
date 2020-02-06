     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MX Export Format Fields Report')
      *****************************************************************
      *                                                               *
      *  Midas - Meridian Export Module                               *
      *                                                               *
      *  MXEXFFRPT - Export Format Fields Report                      *
      *                                                               *
      *  Function:  This module lists export format fields.           *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *  Prev Amend No. CMX001  *CREATE    Data 01Jan00               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CMX001 - Meridian Export                                     *
      *                                                               *
      *****************************************************************
 
     FMXEXFDL1  IF   E           K DISK    INFSR(*PSSR)
     FMXEXFFPD  IF   E           K DISK    INFSR(*PSSR)
     FMXEXFFRP1 O    E             PRINTER INFSR(*PSSR) USROPN
 
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
 
 
     D                 DS
     D WD                      1    858    DIM(11)
     D WHDS01                  1     78
     D WHDS02                 79    156
     D WHDS03                157    234
     D WHDS04                235    312
     D WHDS05                313    390
     D WHDS06                391    468
     D WHDS07                469    546
     D WHDS08                547    624
     D WHDS09                625    702
     D WHDS10                703    780
     D WHDS11                781    858
 
 
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
 
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for BANK details
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
 
      *
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           30
     C                   PARM                    I#PART            1
 
 
      * Read the export format fields file
 
 
     C                   READ      MXEXFDP0                               99    *
 
      * Read until EOF
 
     C     *IN99         DOWEQ     '0'
 
      * Print fields
 
     C                   EXSR      PRT_FLDS
 
     C                   READ      MXEXFDP0                               99    *
     C                   ENDDO
 
      * Return
 
     C                   SETON                                        LR
     C                   RETURN
      *
      /SPACE 5
      ********************************************************************
      * PRINT FIELDS
      ********************************************************************
     C     PRT_FLDS      BEGSR
 
      * Output page headings
 
     C                   Z-ADD     99            LINENO
 
      * Read the export format fields file
 
     C     MXEXFFK       KLIST
     C                   KFLD                    EXFILE
     C                   KFLD                    EXFSQN
 
     C     MXEXFFK       SETLL     MXEXFFP0                                     *
     C     MXEXFFK       READE     MXEXFFP0                               99    *
     C     I#PART        IFEQ      'Y'
     C     *IN99         DOWEQ     '0'
     C     WHINEX        ANDNE     'Y'
     C     MXEXFFK       READE     MXEXFFP0                               99    *
     C                   ENDDO
     C                   ENDIF
 
      * Read until EOF
 
     C     *IN99         DOWEQ     '0'
      * RPG Name
     C                   MOVEL     WHFLDI        RPGNAM
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
 
      * Count number of description lines
 
     C                   Z-ADD     10            NumD              2 0
     C     NumD          DOWGT     1
     C     WD(NumD)      ANDEQ     *BLANK
     C                   SUB       1             NumD
     C                   ENDDO
 
      * Print a field
 
     C     1             ADD       NumD          CHLINE            3 0
     C                   EXSR      PAG
     C                   WRITE     FLD
 
      * Print remaining descriptions
 
     C                   Z-ADD     2             @X                2 0
     C     @X            DOWLE     NumD
     C                   MOVEL     WD(@X)        WHDS
     C                   WRITE     FLDREM
     C                   ADD       1             @X
     C                   ENDDO
 
     C     MXEXFFK       READE     MXEXFFP0                               99    *
     C     I#PART        IFEQ      'Y'
     C     *IN99         DOWEQ     '0'
     C     WHINEX        ANDNE     'Y'
     C     MXEXFFK       READE     MXEXFFP0                               99    *
     C                   ENDDO
     C                   ENDIF
     C                   ENDDO
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * Throw page headings (if required)
      ********************************************************************
     C     PAG           BEGSR
 
     C                   ADD       CHLINE        LINENO
     C     LINENO        IFGT      59
     C                   ADD       1             PAGNUM
     C                   WRITE     PAGEHEAD
     C     4             ADD       CHLINE        LINENO            3 0
     C                   ENDIF
 
     C                   ENDSR
     C********************************************************************
     C/SPACE 5
      ********************************************************************
      * *INZSR --- INITIAL PROCESSING
      ********************************************************************
     C     *INZSR        BEGSR
 
      *  Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
 
      * Open the printer file
 
     C                   OPEN      MXEXFFRP1
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY MXCPYSRC,MXPSSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2001
