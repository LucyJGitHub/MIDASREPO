     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MX Get Export Format Fields')                    *
      *****************************************************************
      *                                                               *
      *  Midas - Meridian Export Module                               *
      *                                                               *
      *  MXGETEXFF - Get Export Format Fields                         *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CTI006             Date 31Mar14               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                         *CREATE    Date                       *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CTI006 - Trade Finance BF Midas 2.2 Interface (Recompile)    *
      *  CMX001 - Meridian Export                                     *
      *                                                               *
      *****************************************************************
 
     FMXEXFDL2  IF   E           K DISK
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
 
 
      * G E T   F O R M A T   F I E L D S
     D/COPY MXCPYSRC,MXGTFF
 
 
     D MXEXPCTL      E DS                  EXTNAME(MXEXPCTL)
      * Extract Control Data
 
 
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           30
      * INPUT
      * Format
     C                   PARM                    InFmt            10
      * Export Control Data
     C                   PARM                    MXEXPCTL
      * OUTPUT
      * Field Data
     C                   PARM                    #_FLDD
      * Fields For Selection
     C                   PARM                    #_FLDS
      * Selection Criteria
     C                   PARM                    #_SELC
 
      * Clear field data, fields for selection and selection criteria arrays
 
     C                   MOVE      *BLANK        #_FLDD
     C                   MOVE      *BLANK        #_FLDS
     C                   MOVE      *BLANK        #_SELC
 
 
      * Error if the format is not supplied
 
     C     InFmt         IFEQ      *BLANK
     C                   EVAL      I#ERMS = 'NO FORMAT'
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * Get file name of format
 
     C     InFmt         CHAIN     MXEXFDP0                           99        *
     C     *in99         IFEQ      '1'
     C                   EVAL      I#ERMS = 'BAD FORMAT: + InFmt            '
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Set up selection criteria data
 
     C                   Z-ADD     1             SC                5 0
     C     MXEXFFK       SETLL     MXEXFSPD
     C     MXEXFFK       READE     MXEXFSPD                               90
     C     *IN90         DOWEQ     '0'
     C                   Z-ADD     ESFOBO        #_FLDS(SC)
     C                   EXSR      CNV_DTSELC
     C                   MOVEL     SELC          #_SELC(SC)
     C                   ADD       1             SC
     C     MXEXFFK       READE     MXEXFSPD                               90
     C                   ENDDO
 
      ** Set up field data
 
     C                   Z-ADD     1             FD                5 0
     C     MXEXFFK       SETLL     MXEXFFPD
     C     MXEXFFK       READE     MXEXFFPD                               90
     C     *IN90         DOWEQ     '0'
     C     WHINEX        IFEQ      'Y'
     C     #_FLDS(1)     ifne      *ZERO
     C     WHFOBO        LOOKUP    #_FLDS                                 99
     C     *in99         ifeq      '1'
     C                   MOVEL     'Y'           Fld_4_Sel
     C                   ELSE
     C                   MOVEL     'N'           Fld_4_Sel
     C                   endif
     C                   else
     C                   MOVEL     'N'           Fld_4_Sel
     C                   endif
     C                   MOVEL     FLDD          #_FLDD(FD)
     C                   ADD       1             FD
     C                   ENDIF
     C     MXEXFFK       READE     MXEXFFPD                               90
     C                   ENDDO
 
      * Error if no data was found
 
     C     #_FLDD(1)     IFEQ      *BLANK
     C                   EVAL      I#ERMS = 'BAD FORMAT: + InFmt            '
     C                   EXSR      *PSSR
     C                   ENDIF
 
 
      * Return
 
     C                   RETURN
      *
     C/SPACE 5
      ********************************************************************
      * Convert Date Selection Code
      ********************************************************************
     C     CNV_DTSELC    BEGSR
     C                   SELECT
     C     ESSCPV        WHENEQ    '*CUREOM   '
     C                   MOVEL     *BLANK        ESSCPV
     C                   MOVEL     CUREOM        ESSCPV
     C     ESSCPV        WHENEQ    '*CURSOM   '
     C                   MOVEL     *BLANK        ESSCPV
     C                   MOVEL     CURSOM        ESSCPV
     C     ESSCPV        WHENEQ    '*PRVSOM   '
     C                   MOVEL     *BLANK        ESSCPV
     C                   MOVEL     PRVSOM        ESSCPV
     C     ESSCPV        WHENEQ    '*CURRUN   '
     C                   MOVEL     *BLANK        ESSCPV
     C                   MOVEL     CURRUN        ESSCPV
     C     ESSCPV        WHENEQ    '*CURNWD   '
     C                   MOVEL     *BLANK        ESSCPV
     C                   MOVEL     CURNWD        ESSCPV
     C     ESSCPV        WHENEQ    '*PRVRUN   '
     C                   MOVEL     *BLANK        ESSCPV
     C                   MOVEL     PRVRUN        ESSCPV
     C                   ENDSL
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * *INZSR --- INITIAL PROCESSING
      ********************************************************************
     C     *INZSR        BEGSR
 
      * Key lists
 
     C     MXEXFFK       KLIST
     C                   KFLD                    EXFILE
     C                   KFLD                    EXFSQN
 
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY MXCPYSRC,MXPSSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2001
