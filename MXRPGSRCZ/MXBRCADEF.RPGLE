     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MX Branches For Export Definition')
/*XBIA*  OVRDBF FILE(MXBREXL1) TOFILE(MXBREXL0) SHARE(*NO)            *
      *****************************************************************
      *                                                               *
      *  Midas - Meridian Export Module                               *
      *                                                               *
      *  MXBRCADEF - Branches For Export Definition                   *
      *                                                               *
      *  Function:  This module allows definition of branches         *
      *             for export.                                       *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 CAAA03             Date 12Mar04               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 190783             Date 15Apr01               *
      *                 CMX003             Date 05Nov00               *
      *                 CMX001  *CREATE    Data 01Jan00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CAAA03 - Webfacing Changes                                   *
      *  190783 - Allow definition of a default 'include indicator'   *
      *  CMX003 - Meridian Export Enhancements - Phase 2              *
      *  CMX001 - Meridian Export                                     *
      *                                                               *
      *****************************************************************
 
     FMXBRCADDD CF   E             WORKSTN
     F                                     SFILE(SUBFLREC:SUBF_RRN)
     FSDBRCHL0  IF   E           K DISK    INFSR(*PSSR)
     FMXBREXL0  IF   E           K DISK    INFSR(*PSSR)
     FMXBREXL1  UF A E           K DISK    INFSR(*PSSR)
     F                                     RENAME(MXBREXP0:MXBREXP1)
     F                                     PREFIX(P_)
     FMXDINCPD  UF A E           K DISK    INFSR(*PSSR)                         190783
 
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
 
 
     D MXBREX        E DS                  EXTNAME(MXBREXPD)
     D P_MXBREX      E DS                  EXTNAME(MXBREXPD)
     D                                     PREFIX(P_)
 
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for BANK details
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
 
      * Current Selection Fields
     D                 DS
     D Curr_SEL                1     44
     D DPBRCD                  1      3
     D DPBRNM                  4     33
     D DPICUR                 34     34
     D DPIACT                 35     35
     D DPANC1                 36     39
     D DPANC2                 40     43
     D DPDINC                 44     44                                         190783
      * Previous Selection Fields
     D                 DS
     D Prev_SEL                1     44
     D WZBRCD                  1      3
     D WZBRNM                  4     33
     D WZICUR                 34     34
     D WZIACT                 35     35
     D WZANC1                 36     39
     D WZANC2                 40     43
     D WZDINC                 44     44                                         190783
 
 
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           30
     C                   PARM                    I#MODE            1
     C                   PARM                    I#COMI            8            CMX003
 
      * Display subfile screen until F3 taken
 
     C     *INKC         DOWEQ     '0'
     C                   EXSR      DSPLAY_SCN
     C                   END
 
      * End of program
 
     C                   SETON                                        LR
 
      /SPACE 5
      *****************************************************************
      * Display subfile screen
      *****************************************************************
     C     DSPLAY_SCN    BEGSR
 
      * Fill current subfile page
 
     C  N50              EXSR      FILL_SUBF
 
      * Save selection fields
 
     C                   MOVEL     Curr_SEL      Prev_SEL
 
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
                                                                                190783
      * Default Include indicator must be 'Y' or 'N'                            190783
                                                                                190783
     C     DPDINC        IFNE      'N'                                          190783
     C                   MOVEL     'Y'           DPDINC                         190783
     C                   ENDIF                                                  190783
                                                                                190783
      * If Default Include indicator has changed,                               190783
      * update the file it is stored on                                         190783
                                                                                190783
     C     DPDINC        IFNE      WZDINC                                       190783
     C     MXDINCK       CHAIN     MXDINCP0                           99        190783
     C  N99              MOVEL     DPDINC        DIDINC                         190783
     C  N99              UPDATE    MXDINCP0                                     190783
     C                   ENDIF                                                  190783
 
      * Return to start if selection fields have changed
      * or if enter was pressed
 
     C     Curr_SEL      IFNE      Prev_SEL
     C     *IN05         OREQ      '0'
     C     *IN06         ANDEQ     '0'
     C                   MOVEL     DPBRCD        A8BRCD
     C                   ENDIF
 
      * Rolldown requested
 
     C     *IN05         CASEQ     '1'           ROLLDOWN
 
      * Check for a record changed on the subfile
 
     C     *IN(04)       CASEQ     '0'           CHK_SUBF
     C                   END
 
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
      * Check for a record changed on the subfile
      *****************************************************************
     C     CHK_SUBF      BEGSR
 
     C                   READC     SUBFLREC                               99    *RECORD CHANGED
 
      * Do until all records processed
      * or a validation error encountered
 
     C     *IN99         DOWEQ     '0'
     C     *IN50         ANDEQ     '0'
 
      * Maintain the record in the subfile
 
     C                   EXSR      MNT_SflREC
 
      * Return to top of subfile page
 
     C                   MOVEL     ToP_BRCD      A8BRCD
 
      * Read next
 
     C  N50              READC     SUBFLREC                               99    *RECORD CHANGED
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
 
     C     A8BRCD        SETLL     @A8REB1
     C                   EXSR      SEL_REC_FWD
 
      * If not end of file
 
     C     *IN99         IFEQ      '0'
     C                   MOVEL     A8BRCD        ToP_BRCD          3
     C                   ELSE
     C                   MOVEL     *BLANK        ToP_BRCD
     C                   MOVEL     *BLANK        A8BRCD
 
      * Else, if end of file
      * Issue message
 
     C                   MOVEL     'MX00001'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
 
      * Do while not end of file
 
     C     *IN99         DOWEQ     '0'
 
     C                   ADD       1             SUBF_RRN          4 0    04    *
     C     SUBF_RRN      COMP      1                                      33
 
      * Write a record to the subfile
 
     C                   WRITE     SUBFLREC
     C     SUBF_RRN      IFEQ      NumPerPag
     C                   EXSR      SEL_REC_FWD
     C     *IN99         IFEQ      '1'
     C                   MOVEL     *BLANK        A8BRCD
     C                   MOVEL     'MX00001'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ELSE
     C                   SETON                                            99    *
     C                   END
     C                   ELSE
     C                   EXSR      SEL_REC_FWD
     C     *IN99         IFEQ      '1'
     C                   MOVEL     *BLANK        A8BRCD
     C                   MOVEL     'MX00001'     ZAMSID
     C                   EXSR      ZASNMS
     C                   END
     C                   END
 
     C                   ENDDO
 
      * Set on subfile control indicators
 
     C     *IN(4)        IFEQ      '1'
     C                   MOVEA     '110'         *IN(1)
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
      *
     C     DDICUR        IFEQ      ' '
     C*******************MOVE      'Y'           DDICUR                         190783
     C                   MOVE      DPDINC        DDICUR                         190783
     C                   ENDIF
     C     DDICUR        IFNE      'Y'
     C     DDICUR        ANDNE     'N'
     C                   MOVEL     'MX00410'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN31
     C                   UPDATE    SUBFLREC
     C                   GOTO      E_ERROR
     C                   ENDIF
      *
     C     DDIACT        IFEQ      ' '
     C*******************MOVE      'Y'           DDIACT                         190783
     C                   MOVE      DPDINC        DDIACT                         190783
     C                   ENDIF
     C     DDIACT        IFNE      'Y'
     C     DDIACT        ANDNE     'N'
     C                   MOVEL     'MX00411'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN32
     C                   UPDATE    SUBFLREC
     C                   GOTO      E_ERROR
     C                   ENDIF
      *
      ** Access record to be updated
      *
     C*****A8BRCD        CHAIN     MXBREXP1                           99        CMX003
     C     MXBREXK       CHAIN     MXBREXP1                           99        CMX003
     C     *IN99         IFEQ      '1'
     C                   CLEAR                   P_MXBREX
     C                   MOVEL     DDBRCD        P_A8BRCD
     C*******************MOVEL     'Y'           P_A8ICUR                       190783
     C*******************MOVEL     'Y'           P_A8IACT                       190783
     C                   MOVEL     DPDINC        P_A8ICUR                       190783
     C                   MOVEL     DPDINC        P_A8IACT                       190783
     C                   ENDIF
                                                                                CMX003
     C                   MOVEL     I#COMI        P_A8COMI                       CMX003
     C                   MOVEL     I#COMI        A8COMI                         CMX003
      *
      ** Check for changed record
      *
     C     P_MXBREX      IFNE      MXBREX
     C                   MOVEL     'MX00412'     ZAMSID
     C                   MOVEL     DDBRCD        ZAMSDA
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN30
     C                   UPDATE    SUBFLREC
     C                   GOTO      E_ERROR
     C                   ENDIF
      *
      ** Update or add a record
      *
     C                   MOVEL     DDICUR        P_A8ICUR
     C                   MOVEL     DDIACT        P_A8IACT
     C                   MOVEL     DDANC1        P_A8ANC1
     C                   MOVEL     DDANC2        P_A8ANC2
      *
     C     *IN99         IFEQ      '1'
     C                   WRITE     MXBREXP1
     C                   ELSE
     C                   UPDATE    MXBREXP1
     C                   ENDIF
 
      * Reset subfile record
 
     C                   UPDATE    SUBFLREC
     C                   GOTO      E_MNT
 
     C     E_ERROR       TAG
 
     C                   MOVEA     '0000'        *IN(30)
 
      * Take cursor positioning off first record
 
     C     DDBRCD        IFNE      ToP_BRCD
     C     1             CHAIN     SUBFLREC                           99        *
     C  N99              UPDATE    SUBFLREC
     C                   ENDIF
 
     C     E_MNT         ENDSR
      ********************************************************************
      /SPACE 5
      *****************************************************************
      * Rolldown
      ********************************************************************
     C     ROLLDOWN      BEGSR
 
     C                   Z-ADD     *ZERO         SUBF_RRN
     C                   MOVEL     ToP_BRCD      A8BRCD
 
     C     A8BRCD        SETGT     @A8REB1
     C                   EXSR      SEL_REC_PRV
 
      * Read previous
      * until count matches count of records previous read
 
     C     *IN99         DOWEQ     '0'
     C     SUBF_RRN      ANDLT     NumPerPag
     C                   EXSR      SEL_REC_PRV
     C                   ADD       1             SUBF_RRN
     C                   ENDDO
 
      * Issue start of file message
 
     C     *IN99         IFEQ      '1'
     C                   MOVEL     *BLANK        A8BRCD
     C                   MOVEL     'MX00002'     ZAMSID
     C                   EXSR      ZASNMS
     C                   END
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * SELECT RECORD ON READ FORWARD
      *****************************************************************
     C     SEL_REC_FWD   BEGSR
 
     C                   READ      @A8REB1                                99    *
     C  N99              EXSR      CHK_SEL
     C     *in99         DOWEQ     '0'
     C     Sel_Rec       ANDNE     'Y'
     C                   READ      @A8REB1                                99    *
     C  N99              EXSR      CHK_SEL
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * SELECT RECORD ON READ PREVIOUS
      *****************************************************************
     C     SEL_REC_PRV   BEGSR
 
     C                   READP     @A8REB1                                99    *
     C  N99              EXSR      CHK_SEL
     C     *in99         DOWEQ     '0'
     C     Sel_Rec       ANDNE     'Y'
     C                   READP     @A8REB1                                99    *
     C  N99              EXSR      CHK_SEL
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * CHECK FOR SELECTION
      *****************************************************************
     C     CHK_SEL       BEGSR
 
      * Get branch for export details
 
     C*****A8BRCD********CHAIN     MXBREXP0                           98        CMX003
     C     MXBREXK       CHAIN     MXBREXP0                           98        CMX003
     C     *IN98         IFEQ      '1'
     C*******************MOVEL     'Y'           A8ICUR                         190783
     C*******************MOVEL     'Y'           A8IACT                         190783
     C                   MOVEL     DPDINC        A8ICUR                         190783
     C                   MOVEL     DPDINC        A8IACT                         190783
     C                   MOVEL     *BLANK        A8ANC1
     C                   MOVEL     *BLANK        A8ANC2
     C                   ENDIF
 
      * Record will be selected unless determined otherwise
 
     C                   MOVEL     'Y'           Sel_Rec           1
 
      * Show branch
     C     DPBRCD        IFNE      *BLANK
     C     DPBRCD        ANDGT     A8BRCD
     C                   MOVEL     'N'           Sel_Rec
     C                   ENDIF
 
      *
     C     DPBRNM        IFNE      *BLANK
      * Scan for search string
     C                   CALL      'QCLSCAN'
     C                   PARM                    A8BRNM
      * Length
     C                   PARM      25            WQA3N             3 0
      * Start
     C                   PARM      1             WQB3N             3 0
      * Mask
     C                   PARM                    DPBRNM
      * Length
     C                   PARM      25            WQC3N             3 0
      * Translate
     C                   PARM      '1'           WQD1              1
      * Trim
     C                   PARM      '1'           WQE1              1
      * Wild
     C                   PARM      '?'           WQF1              1
      * Result
     C                   PARM                    WQG3N             3 0
     C     WQG3N         IFLT      1
     C                   MOVEL     'N'           Sel_Rec
     C                   ENDIF
     C                   ENDIF
      *
     C     DPICUR        IFNE      ' '
     C     DPICUR        ANDNE     A8ICUR
     C                   MOVEL     'N'           Sel_Rec
     C                   ENDIF
      *
     C     DPIACT        IFNE      ' '
     C     DPIACT        ANDNE     A8IACT
     C                   MOVEL     'N'           Sel_Rec
     C                   ENDIF
      *
     C     DPANC1        IFNE      '    '
     C     DPANC1        ANDNE     A8ANC1
     C                   MOVEL     'N'           Sel_Rec
     C                   ENDIF
      *
     C     DPANC2        IFNE      '    '
     C     DPANC2        ANDNE     A8ANC2
     C                   MOVEL     'N'           Sel_Rec
     C                   ENDIF
      *
     C                   MOVEL     A8BRCD        DDBRCD
     C                   MOVEL     A8BRNM        DDBRNM
     C                   MOVEL     A8ICUR        DDICUR
     C                   MOVEL     A8IACT        DDIACT
     C                   MOVEL     A8ANC1        DDANC1
     C                   MOVEL     A8ANC2        DDANC2
 
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
     C                   MOVEL     'MXBRCADEF'   DDPGM
      *
      ** Set up subfile message queue information
      *
     C                   MOVEL     '*'           DDPGMQ
     C                   MOVE      '1'           *IN40
      *                                                                         190783
      ** Set up fields for Default Include File access                          190783
      *                                                                         190783
     C                   MOVEL     'BR'          DIFLTT                         190783
     C                   MOVEL     I#COMI        DICOMI                         190783
      *                                                                         190783
      ** Set up composite ID and 'Default Include' indicator on screen          190783
      *                                                                         190783
     C     I#COMI        IFEQ      *BLANK                                       190783
     C                   MOVE      '1'           *IN20                          190783
     C                   MOVEL     '*GLOBAL '    DDCOMI                         190783
     C                   MOVEL     'Y'           DPDINC                         190783
     C                   ELSE                                                   190783
     C                   MOVE      '0'           *IN20                          190783
     C                   MOVEL     I#COMI        DDCOMI                         190783
     C     MXDINCK       CHAIN     MXDINCP0                           99        190783
     C     *in99         IFEQ      '1'                                          190783
     C                   MOVEL     'Y'           DIDINC                         190783
     C                   WRITE     MXDINCP0                                     190783
     C                   ELSE                                                   190783
     C                   UPDATE    MXDINCP0                                     190783
     C                   ENDIF                                                  190783
     C                   MOVEL     DIDINC        DPDINC                         190783
     C                   ENDIF                                                  190783
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
 
     C                   Z-ADD     14            NumPerPag         2 0
 
      * Mode (U = Allow updates)
 
     C     I#MODE        IFEQ      'U'
     C                   MOVE      '1'           *IN61
     C                   ENDIF
                                                                                CMX003
      * Key Lists                                                               CMX003
                                                                                CMX003
     C     MXBREXK       KLIST                                                  CMX003
     C                   KFLD                    A8BRCD                         CMX003
     C                   KFLD                    I#COMI                         CMX003
     C     MXDINCK       KLIST                                                  190783
     C                   KFLD                    DIFLTT                         190783
     C                   KFLD                    DICOMI                         190783
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY MXCPYSRC,MXPSSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2001
