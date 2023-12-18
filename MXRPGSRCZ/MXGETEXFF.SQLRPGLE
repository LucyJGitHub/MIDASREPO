     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/**** *  RPGBASEMOD                                                   *          MD056612
/*STD *  RPGSQLMOD                                                    *          MD056612
/*EXI *  CLOSQLCSR(*ENDMOD)                                           *          MD056612
/*EXI *  TEXT('Midas MX Get Export Format Fields')                    *
      *****************************************************************
      *                                                               *
      *  Midas - Meridian Export Module                               *
      *                                                               *
      *  MXGETEXFF - Get Export Format Fields                         *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD062059           Date 27Nov23               *
      *  Prev Amend No. MD061958           Date 16Nov23               *
      *                 AR898711           Date 06Oct23               *
      *                 MD056612           Date 12Sep20               *
      *                 MD046248           Date 27Oct17               *
      *                 CTI006             Date 31Mar14               *
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
      *  MD062059 - NY: Midas Export extracts no data if selection    *
      *             criteria.                                         *
      *           - Use the correct field names of MXEXSJW0 file      *
      *             when converting the date of the selected codes.   *
      *  MD061958 - NY: Midas Export format extracts have fields in   *
      *             the wrong sequence.                               *
      *           - Added order by to sort MXEXFJW0 records according *
      *             to export sequence defined on file.               *
      *  AR898711 - Allow selection of date fields in the format      *
      *             yyyymmdd. (Child: AR898712)                       *
      *  MD056612 - Deliverable Data Split for MX group               *
      *  MD046248 - Finastra Rebranding                               *
      *  CTI006 - Trade Finance BF Midas 2.2 Interface (Recompile)    *
      *  CMX001 - Meridian Export                                     *
      *                                                               *
      *****************************************************************

     F*MXEXFDL2* IF   E           K DISK                                                    MD056612
     F*MXEXFFPD* IF   E           K DISK                                                    MD056612
     F*MXEXFSPD* IF   E           K DISK                                                    MD056612

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


      ** External DS for BANK details                                                       AR898711
     D SDBANK        E DS                  EXTNAME(SDBANKPD)                                AR898711
      ** Midas GP Dummy data structure                                                      AR898711
     D DSFDY         E DS                  EXTNAME(DSFDY)                                   AR898711
                                                                                            AR898711
     D MXEXPCTL      E DS                  EXTNAME(MXEXPCTL)
      * Extract Control Data

     D MXEXFD        E DS                  EXTNAME(MXEXDJW0)                                MD056612
     D MXEXFF        E DS                  EXTNAME(MXEXFJW0)                                MD056612
     D                                     PREFIX(X_)                                       MD056612
     D MXEXFS        E DS                  EXTNAME(MXEXSJW0)                                MD056612
     D                                     PREFIX(X_)                                       MD056612

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

     C*****InFmt         CHAIN     MXEXFDP0                           99        *           MD056612
     C/EXEC SQL                                                                             MD056612
     C+ SELECT *                                                                            MD056612
     C+ into :MXEXFD                                                                        MD056612
     C+ from MXEXDJW0                                                                       MD056612
     C+ where EXFMT  = :InFmt                                                               MD056612
     C/END-EXEC                                                                             MD056612
     C******in99         IFEQ      '1'                                                      MD056612
     C                   IF        SQLCODE = 100                                            MD056612
     C                   EVAL      I#ERMS = 'BAD FORMAT: + InFmt            '
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Set up selection criteria data

     C                   Z-ADD     1             SC                5 0
     C*****MXEXFFK       SETLL     MXEXFSPD                                                 MD056612
     C*****MXEXFFK       READE     MXEXFSPD                               90                MD056612
     C/EXEC SQL                                                                             MD056612
     C+ declare GCursor insensitive scroll cursor for                                       MD056612
     C+ select * from MXEXSJW0                                                              MD056612
     C+ where ESFILE = :EXFILE and ESFSQN = :EXFSQN                                         MD056612
     C+ order by ESFILE, ESFSQN, ESSELN                                                     MD056612
     C/END-EXEC                                                                             MD056612
                                                                                            MD056612
     C/EXEC SQL                                                                             MD056612
     C+ open GCursor                                                                        MD056612
     C/END-EXEC                                                                             MD056612
                                                                                            MD056612
     C/EXEC SQL                                                                             MD056612
     C+ fetch next from GCursor into :MXEXFS                                                MD056612
     C/END-EXEC                                                                             MD056612
     C******IN90         DOWEQ     '0'                                                      MD056612
     C     SQLCODE       DOWEQ     0                                                        MD056612
     C**********         Z-ADD     ESFOBO        #_FLDS(SC)                                 MD056612
     C                   Z-ADD     X_ESFOBO      #_FLDS(SC)                                 MD056612
     C                   EXSR      CNV_DTSELC
     C                   eval      ESSIAO = X_ESSIAO                                        MD056612
     C                   eval      ESSCMP = X_ESSCMP                                        MD056612
     C                   eval      ESSCPV = X_ESSCPV                                        MD056612
     C                   MOVEL     SELC          #_SELC(SC)
     C                   ADD       1             SC
     C*****MXEXFFK       READE     MXEXFSPD                               90                MD056612
     C/EXEC SQL                                                                             MD056612
     C+ fetch next from GCursor into :MXEXFS                                                MD056612
     C/END-EXEC                                                                             MD056612
     C                   ENDDO

     C/EXEC SQL                                                                             MD056612
     C+ close GCursor                                                                       MD056612
     C/END-EXEC                                                                             MD056612
      ** Set up field data

     C                   Z-ADD     1             FD                5 0
     C*****MXEXFFK       SETLL     MXEXFFPD                                                 MD056612
     C*****MXEXFFK       READE     MXEXFFPD                               90                MD056612
     C*EXEC*SQL***                                                                 MD056612 MD061958
     C**declare*FCursor insensitive scroll cursor for                              MD056612 MD061958
     C**select***from MXEXFJW0                                                     MD056612 MD061958
     C**where*WHFILE = :EXFILE and WHFSQN = :EXFSQN                                MD056612 MD061958
     C*END*EXEC***                                                                 MD056612 MD061958
                                                                                            MD061958
     C/EXEC SQL                                                                             MD061958
     C+ declare FCursor insensitive scroll cursor for                                       MD061958
     C+ select * from MXEXFJW0                                                              MD061958
     C+ where WHFILE = :EXFILE and WHFSQN = :EXFSQN                                         MD061958
     C+ order by WHFILE, WHFSQN, WHIBO, WHFOBO                                              MD061958
     C/END-EXEC                                                                             MD061958
                                                                                            MD056612
     C/EXEC SQL                                                                             MD056612
     C+ open FCursor                                                                        MD056612
     C/END-EXEC                                                                             MD056612
                                                                                            MD056612
     C/EXEC SQL                                                                             MD056612
     C+ fetch next  from FCursor into :MXEXFF                                               MD056612
     C/END-EXEC                                                                             MD056612
     C******IN90         DOWEQ     '0'                                                      MD056612
     C     SQLCODE       DOWEQ     0                                                        MD056612
     C*****WHINEX        IFEQ      'Y'                                                      MD056612
     C     X_WHINEX      IFEQ      'Y'                                                      MD056612
     C     #_FLDS(1)     ifne      *ZERO
     C*****WHFOBO        LOOKUP    #_FLDS                                 99                MD056612
     C     X_WHFOBO      LOOKUP    #_FLDS                                 99                MD056612
     C     *in99         ifeq      '1'
     C                   MOVEL     'Y'           Fld_4_Sel
     C                   ELSE
     C                   MOVEL     'N'           Fld_4_Sel
     C                   endif
     C                   else
     C                   MOVEL     'N'           Fld_4_Sel
     C                   endif
     C                   eval      WHFOBO = X_WHFOBO                                        MD056612
     C                   eval      WHFLDB = X_WHFLDB                                        MD056612
     C                   eval      WHFLDD = X_WHFLDD                                        MD056612
     C                   eval      WHFLDP = X_WHFLDP                                        MD056612
     C                   eval      WHFLDT = X_WHFLDT                                        MD056612
     C                   eval      WHSREF = X_WHSREF                                        MD056612
     C                   MOVEL     FLDD          #_FLDD(FD)
     C                   ADD       1             FD
     C                   ENDIF
     C*****MXEXFFK       READE     MXEXFFPD                               90                MD056612
     C/EXEC SQL                                                                             MD056612
     C+ fetch next  from FCursor into :MXEXFF                                               MD056612
     C/END-EXEC                                                                             MD056612
     C                   ENDDO

     C/EXEC SQL                                                                             MD056612
     C+ close FCursor                                                                       MD056612
     C/END-EXEC                                                                             MD056612
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
     C*****ESSCPV        WHENEQ    '*CUREOM   '                                             MD062059
     C**********         MOVEL     *BLANK        ESSCPV                                     MD062059
     C**********         MOVEL     CUREOM        ESSCPV                                     MD062059
     C*****ESSCPV        WHENEQ    '*CURSOM   '                                             MD062059
     C**********         MOVEL     *BLANK        ESSCPV                                     MD062059
     C**********         MOVEL     CURSOM        ESSCPV                                     MD062059
     C*****ESSCPV        WHENEQ    '*PRVSOM   '                                             MD062059
     C**********         MOVEL     *BLANK        ESSCPV                                     MD062059
     C**********         MOVEL     PRVSOM        ESSCPV                                     MD062059
     C*****ESSCPV        WHENEQ    '*CURRUN   '                                             MD062059
     C**********         MOVEL     *BLANK        ESSCPV                                     MD062059
     C**********         MOVEL     CURRUN        ESSCPV                                     MD062059
     C*****ESSCPV        WHENEQ    '*CURNWD   '                                             MD062059
     C**********         MOVEL     *BLANK        ESSCPV                                     MD062059
     C**********         MOVEL     CURNWD        ESSCPV                                     MD062059
     C*****ESSCPV        WHENEQ    '*PRVRUN   '                                             MD062059
     C**********         MOVEL     *BLANK        ESSCPV                                     MD062059
     C**********         MOVEL     PRVRUN        ESSCPV                                     MD062059
     C*****ESSCPV        WHENEQ    '*CURRUNYMD'                                    AR898711 MD062059
     C**********         MOVEL     *BLANK        ESSCPV                            AR898711 MD062059
     C**********         MOVEL     CURYMD        ESSCPV                            AR898711 MD062059
      *                                                                                     MD062059
     C     X_ESSCPV      WHENEQ    '*CUREOM   '                                             MD062059
     C                   MOVEL     *BLANK        X_ESSCPV                                   MD062059
     C                   MOVEL     CUREOM        X_ESSCPV                                   MD062059
     C     X_ESSCPV      WHENEQ    '*CURSOM   '                                             MD062059
     C                   MOVEL     *BLANK        X_ESSCPV                                   MD062059
     C                   MOVEL     CURSOM        X_ESSCPV                                   MD062059
     C     X_ESSCPV      WHENEQ    '*PRVSOM   '                                             MD062059
     C                   MOVEL     *BLANK        X_ESSCPV                                   MD062059
     C                   MOVEL     PRVSOM        X_ESSCPV                                   MD062059
     C     X_ESSCPV      WHENEQ    '*CURRUN   '                                             MD062059
     C                   MOVEL     *BLANK        X_ESSCPV                                   MD062059
     C                   MOVEL     CURRUN        X_ESSCPV                                   MD062059
     C     X_ESSCPV      WHENEQ    '*CURNWD   '                                             MD062059
     C                   MOVEL     *BLANK        X_ESSCPV                                   MD062059
     C                   MOVEL     CURNWD        X_ESSCPV                                   MD062059
     C     X_ESSCPV      WHENEQ    '*PRVRUN   '                                             MD062059
     C                   MOVEL     *BLANK        X_ESSCPV                                   MD062059
     C                   MOVEL     PRVRUN        X_ESSCPV                                   MD062059
     C     X_ESSCPV      WHENEQ    '*CURRUNYMD'                                             MD062059
     C                   MOVEL     *BLANK        X_ESSCPV                                   MD062059
     C                   MOVEL     CURYMD        X_ESSCPV                                   MD062059
      *                                                                                     MD062059
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
                                                                                            AR898711
      ** Access Bank Details                                                                AR898711
                                                                                            AR898711
     C                   CALL      'AOBANKR0'                                               AR898711
     C                   PARM      '*DBERR  '    @RTCD             7                        AR898711
     C                   PARM      '*FIRST  '    @OPTN             7                        AR898711
     C     SDBANK        PARM      SDBANK        DSFDY                                      AR898711
                                                                                            AR898711
     C                   CALL      'ZDATE2'                                                 AR898711
     C                   PARM      BJRDNB        ZDAYNO            5 0                      AR898711
     C                   PARM      'D'           ZZDFIN            1                        AR898711
     C                   PARM      *ZERO         ZNUM6P            6 0                      AR898711
     C                   PARM      *BLANKS       ZDATE7            7                        AR898711
     C                   MOVE      ZNUM6P        ZNUM6A            6                        AR898711
     C                   MOVE      *BLANKS       CURYMD            8                        AR898711
     C                   EVAL      CURYMD = '20' + %subst(ZNUM6A: 5:2)                      AR898711
     C                                     + %subst(ZNUM6A: 3:2)                            AR898711
     C                                     + %subst(ZNUM6A: 1:2)                            AR898711

     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY MXCPYSRC,MXPSSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2001
