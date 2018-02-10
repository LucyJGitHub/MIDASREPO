     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MX Loan Type/Sub Types For Export Definition')   *
/*XBIA*  OVRDBF FILE(MXLTEXL1) TOFILE(MXLTEXL0) SHARE(*NO)            *
      *****************************************************************
      *                                                               *
      *  Midas - Meridian Export Module                               *
      *                                                               *
      *  MXLTSTDEF - Loan Type/Sub Types For Export Definition        *
      *                                                               *
      *  Function:  This module allows definition of loan types/      *
      *             sub-types for export.                             *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CLE134             Date 01Aug12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CLE042             Date 06Sep05               *
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
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CAAA03 - Webfacing Changes                                   *
      *  190783 - Allow definition of a default 'include indicator'   *
      *  CMX003 - Meridian Export Enhancements - Phase 2              *
      *  CMX001 - Meridian Export                                     *
      *                                                               *
      *****************************************************************
 
     FMXLTSTDDD CF   E             WORKSTN
     F                                     SFILE(SUBFLREC:SUBF_RRN)
     FSDLOANL0  IF   E           K DISK    INFSR(*PSSR)
     FMXLTEXL0  IF   E           K DISK    INFSR(*PSSR)
     FMXLTEXL1  UF A E           K DISK    INFSR(*PSSR)
     F                                     RENAME(MXLTEXP0:MXLTEXP1)
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
 
 
     D MXLTEX        E DS                  EXTNAME(MXLTEXPD)
     D AYLTST                  1      4
     D P_MXLTEX      E DS                  EXTNAME(MXLTEXPD)
     D                                     PREFIX(P_)
 
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for BANK details
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
 
      * Current Selection Fields
     D                 DS
     D Curr_SEL                1     50
     D DPLTST                  1      4
     D DPLNTY                  1      2
     D DPLNST                  3      4
     D DPLNTD                  5     34
     D DPICUR                 35     35
     D DPIACT                 36     36
     D DPANC1                 37     40
     D DPANC2                 41     44
     D DPDINC                 45     45                                         190783
      * Previous Selection Fields
     D                 DS
     D Prev_SEL                1     50
     D WZLNTY                  1      2
     D WZLNST                  3      4
     D WZLNTD                  5     34
     D WZICUR                 35     35
     D WZIACT                 36     36
     D WZANC1                 37     40
     D WZANC2                 41     44
     D WZDINC                 45     45                                         190783
 
 
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
     C                   MOVEL     DPLNTY        AYLNTY
     C                   MOVEL     DPLNST        AYLNST
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
 
     C                   MOVEL     ToP_LNTY      AYLNTY
     C                   MOVEL     ToP_LNST      AYLNST
 
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
 
     C     SDLOANK       SETLL     @AYRECK
     C                   EXSR      SEL_REC_FWD
 
      * If not end of file
 
     C     *IN99         IFEQ      '0'
     C                   MOVEL     AYLNTY        ToP_LNTY          2
     C                   MOVEL     AYLNST        ToP_LNST          2
     C                   ELSE
     C                   MOVEL     *BLANK        ToP_LNTY
     C                   MOVEL     *BLANK        ToP_LNST
     C                   MOVEL     *BLANK        AYLNTY
     C                   MOVEL     *BLANK        AYLNST
 
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
     C                   MOVEL     *BLANK        AYLNTY
     C                   MOVEL     *BLANK        AYLNST
     C                   MOVEL     'MX00001'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ELSE
     C                   SETON                                            99    *
     C                   END
     C                   ELSE
     C                   EXSR      SEL_REC_FWD
     C     *IN99         IFEQ      '1'
     C                   MOVEL     *BLANK        AYLNTY
     C                   MOVEL     *BLANK        AYLNST
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
     C                   MOVE      DPDINC        DDICUR                         190783
     C*******************MOVE      'Y'           DDICUR                         190783
     C                   ENDIF
     C     DDICUR        IFNE      'Y'
     C     DDICUR        ANDNE     'N'
     C                   MOVEL     'MX00430'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN31
     C                   UPDATE    SUBFLREC
     C                   GOTO      E_ERROR
     C                   ENDIF
      *
     C     DDIACT        IFEQ      ' '
     C                   MOVE      DPDINC        DDIACT                         190783
     C*******************MOVE      'Y'           DDIACT                         190783
     C                   ENDIF
     C     DDIACT        IFNE      'Y'
     C     DDIACT        ANDNE     'N'
     C                   MOVEL     'MX00431'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN32
     C                   UPDATE    SUBFLREC
     C                   GOTO      E_ERROR
     C                   ENDIF
      *
      ** Access record to be updated
      *
     C*****SDLOANK*******CHAIN     MXLTEXP1                           99        CMX003
     C     SDLOANKC      CHAIN     MXLTEXP1                           99        CMX003
     C     *IN99         IFEQ      '1'
     C                   CLEAR                   P_MXLTEX
     C                   MOVEL     DDLNTY        P_AYLNTY
     C                   MOVEL     DDLNST        P_AYLNST
     C                   MOVEL     DPDINC        P_AYICUR                       190783
     C                   MOVEL     DPDINC        P_AYIACT                       190783
     C*******************MOVEL     'Y'           P_AYICUR                       190783
     C*******************MOVEL     'Y'           P_AYIACT                       190783
     C                   ENDIF
                                                                                CMX003
     C                   MOVEL     I#COMI        P_AYCOMI                       CMX003
     C                   MOVEL     I#COMI        AYCOMI                         CMX003
      *
      ** Check for changed record
      *
     C     P_MXLTEX      IFNE      MXLTEX
     C                   MOVEL     'MX00432'     ZAMSID
     C                   MOVEL     DDLNTY        WRK05             5
     C                   MOVEL     DDLNST        WRK05
     C                   MOVEL     WRK05         ZAMSDA
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN30
     C                   UPDATE    SUBFLREC
     C                   GOTO      E_ERROR
     C                   ENDIF
      *
      ** Update or add a record
      *
     C                   MOVEL     DDICUR        P_AYICUR
     C                   MOVEL     DDIACT        P_AYIACT
     C                   MOVEL     DDANC1        P_AYANC1
     C                   MOVEL     DDANC2        P_AYANC2
      *
     C     *IN99         IFEQ      '1'
     C                   WRITE     MXLTEXP1
     C                   ELSE
     C                   UPDATE    MXLTEXP1
     C                   ENDIF
 
      * Reset subfile record
 
     C                   UPDATE    SUBFLREC
     C                   GOTO      E_MNT
 
     C     E_ERROR       TAG
 
     C                   MOVEA     '0000'        *IN(30)
 
      * Take cursor positioning off first record
 
     C     DDLNTY        IFNE      ToP_LNTY
     C     DDLNST        ANDNE     ToP_LNST
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
     C                   MOVEL     ToP_LNTY      AYLNTY
     C                   MOVEL     ToP_LNST      AYLNST
 
     C     SDLOANK       SETGT     @AYRECK
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
     C                   MOVEL     *BLANK        AYLNTY
     C                   MOVEL     *BLANK        AYLNST
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
 
     C                   READ      @AYRECK                                99    *
     C  N99              EXSR      CHK_SEL
     C     *in99         DOWEQ     '0'
     C     Sel_Rec       ANDNE     'Y'
     C                   READ      @AYRECK                                99    *
     C  N99              EXSR      CHK_SEL
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * SELECT RECORD ON READ PREVIOUS
      *****************************************************************
     C     SEL_REC_PRV   BEGSR
 
     C                   READP     @AYRECK                                99    *
     C  N99              EXSR      CHK_SEL
     C     *in99         DOWEQ     '0'
     C     Sel_Rec       ANDNE     'Y'
     C                   READP     @AYRECK                                99    *
     C  N99              EXSR      CHK_SEL
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * CHECK FOR SELECTION
      *****************************************************************
     C     CHK_SEL       BEGSR
 
      * Get account for export details
 
     C*****SDLOANK*******CHAIN     MXLTEXP0                           98        CMX003
     C     SDLOANKC      CHAIN     MXLTEXP0                           98        CMX003
     C     *IN98         IFEQ      '1'
     C*******************MOVEL     'Y'           AYICUR                         190783
     C*******************MOVEL     'Y'           AYIACT                         190783
     C                   MOVEL     DPDINC        AYICUR                         190783
     C                   MOVEL     DPDINC        AYIACT                         190783
     C                   MOVEL     *BLANK        AYANC1
     C                   MOVEL     *BLANK        AYANC2
     C                   ENDIF
 
      * Record will be selected unless determined otherwise
 
     C                   MOVEL     'Y'           Sel_Rec           1
 
      * Show loan type/sub type
     C     DPLTST        IFNE      *BLANK
     C     DPLTST        ANDGT     AYLTST
     C                   MOVEL     'N'           Sel_Rec
     C                   ENDIF
 
      *
     C     DPLNTD        IFNE      *BLANK
      * Scan for search string
     C                   CALL      'QCLSCAN'
     C                   PARM                    AYLNTD
      * Length
     C                   PARM      30            WQA3N             3 0
      * Start
     C                   PARM      1             WQB3N             3 0
      * Mask
     C                   PARM                    DPLNTD
      * Length
     C                   PARM      30            WQC3N             3 0
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
     C     DPICUR        ANDNE     AYICUR
     C                   MOVEL     'N'           Sel_Rec
     C                   ENDIF
      *
     C     DPIACT        IFNE      ' '
     C     DPIACT        ANDNE     AYIACT
     C                   MOVEL     'N'           Sel_Rec
     C                   ENDIF
      *
     C     DPANC1        IFNE      '    '
     C     DPANC1        ANDNE     AYANC1
     C                   MOVEL     'N'           Sel_Rec
     C                   ENDIF
      *
     C     DPANC2        IFNE      '    '
     C     DPANC2        ANDNE     AYANC2
     C                   MOVEL     'N'           Sel_Rec
     C                   ENDIF
      *
     C                   MOVEL     AYLNTY        DDLNTY
     C                   MOVEL     AYLNST        DDLNST
     C                   MOVEL     AYLNTD        DDLNTD
     C                   MOVEL     AYICUR        DDICUR
     C                   MOVEL     AYIACT        DDIACT
     C                   MOVEL     AYANC1        DDANC1
     C                   MOVEL     AYANC2        DDANC2
 
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
     C                   MOVEL     'MXLTSTDEF'   DDPGM
      *
      ** Set up subfile message queue information
      *
     C                   MOVEL     '*'           DDPGMQ
     C                   MOVE      '1'           *IN40
      *                                                                         190783
      ** Set up fields for Default Include File access                          190783
      *                                                                         190783
     C                   MOVEL     'LT'          DIFLTT                         190783
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
 
      * Key list
 
     C     SDLOANK       KLIST
     C                   KFLD                    AYLNTY
     C                   KFLD                    AYLNST
     C     SDLOANKC      KLIST                                                  CMX003
     C                   KFLD                    AYLNTY                         CMX003
     C                   KFLD                    AYLNST                         CMX003
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
