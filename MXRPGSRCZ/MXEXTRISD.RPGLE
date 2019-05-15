     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MX Extract Retail Interest Statement Details')
/*XBIF*: OVRDBF FILE(REHISLX) TOFILE(REHISL) SHARE(*NO)             : *
      *****************************************************************
      *                                                               *
      *  Midas - Meridian Export Module                               *
      *                                                               *
      *  MXEXTRISD - Extract Retail Interest Statement Details        *
      *                                                               *
      *  Function:  This module extracts retail interest statements   *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 BUG6417            Date 28Mar05               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CMX001  *CREATE    Data 01Jan00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG6417- Cash management components are missing in MidasPlus *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CMX003 - Meridian Export Enhancements - Phase 2              *
      *                                                               *
      *****************************************************************
 
     FMXEXTRIDD CF   E             WORKSTN INFSR(*PSSR)
     F                                     USROPN
     FACCRACJ   IF   E           K DISK    INFSR(*PSSR)
     FREHISLX   IF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(REHISPMF: REHISPPF)
     FMXRISDPD  O    E             DISK    INFSR(*PSSR)
 
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
     D SDRETL        E DS                  EXTNAME(SDRETLPD)
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
     D RISDX         E DS                  EXTNAME(MXRISDPD)
 
     D*P_ACOD**********S             10S 0                                            CGL029 BUG6417
 
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           30
     C                   PARM                    I#MODE            1
 
      * Read all retail accounts
 
     C                   READ      ACCRACJ                                99    *
     C     *in99         DOWEQ     '0'
 
     C                   MOVE      'N'           CR_Out            1
     C                   MOVE      'N'           DR_Out            1
 
     C     I#MODE        IFEQ      'R'
     C                   EXSR      REQUEST
     C                   ELSE
     C                   EXSR      DUETODAY
     C                   ENDIF
 
     C                   READ      ACCRACJ                                99    *
     C                   ENDDO
 
     C                   SETON                                        LR
     C                   RETURN
 
      ********************************************************************
      /SPACE 5
      ********************************************************************
     C     REQUEST       BEGSR
 
      * Request statements as at a particular date
 
     C     BMLDAI        IFEQ      'Y'
     C                   Z-ADD     ZDAYNO        Stmt_Dat
     C                   ELSE
     C     ZDAYNO        ADD       1             Stmt_Dat
     C                   ENDIF
 
     C     klistSDAT     SETLL     REHISPSF
     C     klistSDAT     READE     REHISPSF                               99    *
 
     C     *in99         DOWEQ     '0'
     C     CR_Out        ANDNE     'Y'
     C     DR_Out        ANDNE     'Y'
 
     C     SDICI         IFNE      ' '
     C     DR_Out        ANDNE     'Y'
     C                   MOVEL     'D'           DRCRIN
     C                   EXSR      EXT_LINES
     C                   EXSR      EXT_DETAIL
     C                   MOVE      'Y'           DR_Out
     C                   ENDIF
 
     C     SCICI         IFNE      ' '
     C     CR_Out        ANDNE     'Y'
     C                   MOVEL     'C'           DRCRIN
     C                   EXSR      EXT_LINES
     C                   EXSR      EXT_DETAIL
     C                   MOVE      'Y'           CR_Out
     C                   ENDIF
 
     C     klistSDAT     READE     REHISPSF                               99    *
     C                   ENDDO
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
     C     DUETODAY      BEGSR
 
      * Get today's statements
 
     C     BMLDAI        IFEQ      'Y'
     C                   Z-ADD     BJRDNB        Stmt_Dat
     C                   ELSE
     C     BJRDNB        ADD       1             Stmt_Dat
     C                   ENDIF
 
     C     klistSDAT     SETLL     REHISPSF
     C     klist         READE     REHISPSF                               99    *
 
     C     *in99         DOWEQ     '0'
     C     CR_Out        ANDNE     'Y'
     C     DR_Out        ANDNE     'Y'
 
     C     SDICI         IFNE      ' '
     C     DR_Out        ANDNE     'Y'
     C                   MOVEL     'D'           DRCRIN
     C                   EXSR      EXT_LINES
     C                   EXSR      EXT_DETAIL
     C                   MOVE      'Y'           DR_Out
     C                   ENDIF
 
     C     SCICI         IFNE      ' '
     C     CR_Out        ANDNE     'Y'
     C                   MOVEL     'C'           DRCRIN
     C                   EXSR      EXT_LINES
     C                   EXSR      EXT_DETAIL
     C                   MOVE      'Y'           CR_Out
     C                   ENDIF
 
     C     klist         READE     REHISPSF                               99    *
     C                   ENDDO
 
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
     C     EXT_LINES     BEGSR
 
     C                   CALLB     'MXEXTRISL'
     C                   PARM      *BLANK        W#RTCD            7
     C                   PARM      *BLANK        W#ERMS           30
 
     C                   PARM      BRCA          P_BRCA            3
     C**********         PARM      CNUM          P_CNUM            6 0                        CSD027
     C                   PARM      CNUM          P_CNUM            6                          CSD027
     C                   PARM      CCY           P_CCY             3
     C**********         PARM      ACOD          P_ACOD            4 0                        CGL029
     C**********         PARM      ACOD          P_ACOD                               CGL029 BUG6417
     C                   PARM      ACOD          P_ACOD           10 0                       BUG6417
     C                   PARM      ACSQ          P_ACSQ            2 0
 
     C                   PARM      DACO          P_DACO            5 0
     C                   PARM      HISD          P_HISD            5 0
 
     C                   PARM                    DRCRIN            1
      * credit
     C                   PARM      PCID          P_LCID            5 0
     C                   PARM      CAIC          P_CAIC           15 0
     C                   PARM      CRIP          P_CRIP           15 0
     C                   PARM      CRIS          P_CRIS           15 0
     C                   PARM      TMACI         P_TMACI          15 0
     C                   PARM      PMACI         P_PMACI          15 0
     C                   PARM      *ZERO         P_CTNODYS         5 0
     C                   PARM      *ZERO         P_CTINT          15 0
      * debit
     C                   PARM      PDID          P_LDID            5 0
     C                   PARM      DAIC          P_DAIC           15 0
     C                   PARM      DRIP          P_DRIP           15 0
     C                   PARM      DRIS          P_DRIS           15 0
     C                   PARM      TMADI         P_TMADI          15 0
     C                   PARM      PMADI         P_PMADI          15 0
     C                   PARM      *ZERO         P_DTNODYS         5 0
     C                   PARM      *ZERO         P_DTINT          15 0
 
     C                   PARM      *ZERO         P_SEQN            5 0
 
      * Error
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO MXEXTRISL'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
     C     EXT_DETAIL    BEGSR
 
     C                   Z-ADD     P_HISD        PCAPDT
     C     DRCRIN        IFEQ      'D'
     C                   Z-ADD     P_LDID        LCAPDT
     C                   Z-ADD     P_DTNODYS     TNODYS
     C                   Z-ADD     P_DTINT       TINT
     C                   ELSE
     C                   Z-ADD     P_LCID        LCAPDT
     C                   Z-ADD     P_CTNODYS     TNODYS
     C                   Z-ADD     P_CTINT       TINT
     C                   ENDIF
 
     C     BMLDAI        IFNE      'Y'
     C                   SUB       1             PCAPDT
     C                   SUB       1             LCAPDT
     C                   ENDIF
 
     C                   Z-SUB     199           S_SEQN            5 0
     C                   Z-ADD     *ZERO         E_SEQN            5 0
     C     E_SEQN        DOWLT     P_SEQN
     C                   ADD       200           S_SEQN
     C                   ADD       200           E_SEQN
     C     E_SEQN        IFGT      P_SEQN
     C                   Z-ADD     P_SEQN        E_SEQN
     C                   ENDIF
     C                   MOVEL     DRCRIN        DCSEQN
     C                   MOVE      S_SEQN        DCSEQN
     C                   WRITE     MXRISDP0
     C                   ENDDO
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
     C     *INZSR        BEGSR
 
      **  KLIST TO ACCESS REHISPS
 
     C     klist         KLIST
     C                   KFLD                    BRCA
     C                   KFLD                    CNUM
     C                   KFLD                    CCY
     C                   KFLD                    ACOD
     C                   KFLD                    ACSQ
     C     klistSDAT     KLIST
     C                   KFLD                    BRCA
     C                   KFLD                    CNUM
     C                   KFLD                    CCY
     C                   KFLD                    ACOD
     C                   KFLD                    ACSQ
     C                   KFLD                    Stmt_Dat          5 0
 
 
      ** GET BANK DETAILS
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** GET RETAIL DETAILS
 
     C                   CALL      'AORETLR0'
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDRETL        PARM      SDRETL        DSFDY
 
      * If On-Request
 
     C     I#MODE        IFEQ      'R'
 
      **  Loop until CK/3 taken or no validation errors
 
     C     *INKC         DOUEQ     '1'
     C     *IN50         OREQ      '0'
     C                   EXSR      SCREEN
     C                   ENDDO
 
     C     *INKC         IFEQ      '1'
     C                   SETON                                        LR
     C                   RETURN
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *****************************************************************
     C     SCREEN        BEGSR
 
     C                   OPEN      MXEXTRIDD
      *
      ** Initialize program name
      *
     C                   MOVEL     'MXEXTRISD'   DDPGM
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
 
      ** Selection screen
 
     C                   TIME                    DDTIME
     C                   WRITE     MXEXTRIS0
     C                   WRITE     MXEXTRIP1
     C                   WRITE     MXEXTRIF1
     C                   READ      MXEXTRIP1                              99
 
      ** Validate screen input as long as F3 is not taken
 
     C     *INKC         IFEQ      '0'
     C                   EXSR      VALSIN
     C                   ENDIF
 
     C                   CLOSE     MXEXTRIDD
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * VALSIN   - VALIDATE SCREEN INPUT
      *****************************************************************
     C     VALSIN        BEGSR
      *
      ** Clear the message queue & init error indicators
      *
     C                   CALL      'Y2CLMSC'
     C                   PARM      DDPGM         ZAPGMQ           10
     C                   PARM      '*SAME'       ZAPGRL            5
     C                   MOVE      '0'           *IN50
     C                   MOVEA     '0'           *IN(10)
 
      * Date
 
     C                   MOVEL     *BLANK        ZFIELD
     C                   MOVEL     DDDATE        ZFIELD
     C                   CALLB     'ZALIGN'
     C                   PARM                    ZALIGNok          1
     C                   PARM                    ZFIELD           16
     C                   PARM      0             ZADEC             1 0
     C                   PARM      6             ZADIG             2 0
     C     ZALIGNok      IFNE      'Y'
     C                   MOVEL     'MX00800'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN10
     C                   MOVE      '1'           *IN50
     C                   ELSE
     C                   MOVE      ZFIELD        ZDATE
     C                   CALLB     'ZDATE1'
     C                   PARM                    ZDATE             6
     C                   PARM                    ZDAYNO            5 0
     C                   PARM                    BJDFIN
     C                   PARM                    ErrorFlag         1
     C     ErrorFlag     IFEQ      'Y'
     C     ZDAYNO        ORGT      BJRDNB
     C                   MOVEL     'MX00801'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN10
     C                   MOVE      '1'           *IN50
     C                   ENDIF
     C                   ENDIF
                                                                                CDE002
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * ZASNMS - SEND A MESSAGE
      *****************************************************************
     C     ZASNMS        BEGSR
 
     C                   CALL      'Y2SNMGC'                            9999    *
     C                   PARM      DDPGM         ZAPGMQ           10
     C                   PARM                    ZAPGRL            5
     C                   PARM                    ZAMSID            7
     C                   PARM      'MIDAS'       ZAMSGF           10
     C                   PARM                    ZAMSDA          132
     C                   PARM                    ZAMSTP            7
 
      * Error encountered
 
     C                   MOVE      '1'           *IN50
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY MXCPYSRC,MXPSSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2001
