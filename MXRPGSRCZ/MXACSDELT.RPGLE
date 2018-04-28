     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2014')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MX TI Calendar Access Object for Deletion')      *
      *****************************************************************
      *                                                               *
      *  Midas - Meridian Export Module                               *
      *                                                               *
      *  MXACSDELT - TI Calendar Access Object for Deletion           *
      *                                                               *
      *  Function:  This module exports calendar for deletion         *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2014            *
      *                                                               *
      *  Last Amend No. CTI006  *CREATE    Date 31Mar14               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CTI006 - Trade Finance BF Midas 2.2 Interface                *
      *                                                               *
      *****************************************************************
 
     FSDBRCHPD  IF   E             DISK    INFSR(*PSSR)
     FSDCTRYL6  IF   E           K DISK    INFSR(*PSSR)
     FSDHOLPD   IF   E             DISK    INFSR(*PSSR)
     FSDHOLL1   IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(HH:2)
 
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
 
     D TIDELF        E DS                  EXTNAME(TIDELFPD)
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D DSFDY         E DS                  EXTNAME(DSFDY)
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ********************************************************************
      *
     C     *ENTRY        PLIST
     C/COPY MXCPYSRC,MXACSPRMI
      *
      ** Use input link-to field
      *
     C                   MOVEL     I#LFD1        GFFNME           10
     C                   MOVEL     I#LFD2        GLFKEY           20
      *
     C                   IF        W_Process = *BLANKS
     C                   Z-ADD     *ZERO         Num_ExtRcs        5 0
     C                   MOVEL     *BLANKS       W_CCY             1
     C                   MOVEL     *BLANKS       W_CTRY            1
     C                   MOVEL     *BLANKS       W_BRCA            1
      ** Get key fields
     C                   EVAL      W_Key1 = %SUBST(GLFKEY:1:3)
     C                   EVAL      W_Key2 = %SUBST(GLFKEY:4:3)
     C                   EVAL      W_Key3 = %SUBST(GLFKEY:7:4)
     C                   ENDIF
      *
      ** CASE 01: Country Calendar delete where SDCTRYPD is the driving file
      *
     C                   IF        GFFNME = 'SDCTRYPD'
      *
     C                   IF        W_Process = *BLANKS
     C                   MOVEL     'Y'           W_Process         1
     C     1             SETLL     SDHOLD0
     C                   ENDIF
      *
     C     READNXT       TAG
     C                   READ      SDHOLD0                                99
     C     *IN99         IFEQ      '1'
     C                   MOVEL     '*EODATA'     I#RTCD
     C                   MOVEL     *BLANKS       W_Process
     C                   Z-ADD     *ZERO         Num_ExtRcs
     C                   GOTO      SREND
     C                   ELSE
     C                   IF        DGLCCD = '***'
     C                   ADD       1             Num_ExtRcs
     C                   MOVEL     'COUNTRY   '  TICALT
     C                   MOVEL     W_Key1        TICODE
     C                   MOVEL     DGYRNB        TIYRNB
     C                   Z-ADD     Num_ExtRcs    TIMULT
     C                   ELSE
     C                   GOTO      READNXT
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** CASE 02: Branch Calendar delete where SDBRCHPD is the driving file
      *
     C                   IF        GFFNME = 'SDBRCHPD'
      *
     C                   IF        W_Process = *BLANKS
     C                   MOVEL     'Y'           W_Process         1
     C     1             SETLL     SDHOLD0
     C                   ENDIF
      *
     C                   READ      SDHOLD0                                99
     C     *IN99         IFEQ      '1'
     C                   MOVEL     '*EODATA'     I#RTCD
     C                   MOVEL     *BLANKS       W_Process
     C                   Z-ADD     *ZERO         Num_ExtRcs
     C                   GOTO      SREND
     C                   ELSE
     C                   ADD       1             Num_ExtRcs
     C                   MOVEL     'BRANCH    '  TICALT
     C                   MOVEL     W_Key1        TICODE
     C                   MOVEL     DGYRNB        TIYRNB
     C                   Z-ADD     Num_ExtRcs    TIMULT
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** CASE 03: All 3 Calendar delete where SDHOLPD is the driving file
      *
     C                   IF        GFFNME = 'SDHOLPD'
     C
      ** Branch
     C                   IF        W_BRCA <> 'Y'
     C                   EXSR      SRBranch
     C                   ENDIF
      ** Country
     C     XCOUNTRY      TAG
     C                   IF        W_CTRY <> 'Y'
     C                   EXSR      SRCtry
     C                   ENDIF
      ** Currency
     C                   IF        W_CCY <> 'Y'
     C                   EXSR      SRCurr
     C                   ENDIF
      *
     C                   IF        W_CCY = 'Y'
     C                   MOVEL     '*EODATA'     I#RTCD
     C                   MOVEL     *BLANKS       W_Process
     C                   Z-ADD     *ZERO         Num_ExtRcs
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Set up output data
      *
     C     SREND         TAG
     C                   EVAL      InData = TIDELF
     C                   RETURN
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * SRBranch - Subroutine for BRANCH Driving File 02 DELETE
      ********************************************************************
     C     SRBranch      BEGSR
      *
      *
     C                   IF        W_Process = *BLANKS
     C                   MOVEL     W_Key1        HolCCY            3
     C                   MOVEL     W_Key2        HolLoc            3
     C                   MOVEL     W_Key3        HolYear           4
     C                   MOVEL     BJSLCD        SysLoc            3
     C                   MOVEL     BJLCCY        LocCCY            3
     C                   MOVEL     'Y'           W_Process
     C     1             SETLL     SDBRCHD0
     C                   ENDIF
      *
      ** Access branch file
      *
     C     READNXTB      TAG
     C                   READ      SDBRCHD0                               99
     C                   MOVE      *BLANKS       W_Exprt
      *
     C     *IN99         IFEQ      '1'
     C                   MOVEL     'Y'           W_BRCA
     C     HolCCY        SETLL     SDCTRYD0
     C                   GOTO      XCOUNTRY
     C                   ENDIF
      *
     C                   SELECT
     C                   WHEN      HolLoc <> '***'
      ** Branch Case 1
     C                   IF        A8LCCD <> *BLANKS AND
     C                             A8LCCD = HolLoc
     C                   MOVEL     'Y'           W_Exprt
     C                   ADD       1             Num_ExtRcs
     C                   MOVEL     'BRANCH    '  TICALT
     C                   MOVEL     A8BRCD        TICODE
     C                   MOVEL     W_Key3        TIYRNB
     C                   Z-ADD     Num_ExtRcs    TIMULT
     C                   GOTO      SREND
     C                   ENDIF
      ** Branch Case 2
     C                   IF        A8LCCD = *BLANKS AND
     C                             SysLoc = HolLoc
     C                   MOVEL     'Y'           W_Exprt
     C                   ADD       1             Num_ExtRcs
     C                   MOVEL     'BRANCH    '  TICALT
     C                   MOVEL     A8BRCD        TICODE
     C                   MOVEL     W_Key3        TIYRNB
     C                   Z-ADD     Num_ExtRcs    TIMULT
     C                   GOTO      SREND
     C                   ENDIF
      *
     C                   IF        W_Exprt <> 'Y'
     C                   GOTO      READNXTB
     C                   ENDIF
      *
     C                   WHEN      HolLoc =  '***'
      ** Branch Case 3
     C                   IF        A8LCCD  = *BLANKS AND
     C                             SysLoc  = *BLANKS
     C                   MOVEL     'Y'           W_Exprt
     C                   ADD       1             Num_ExtRcs
     C                   MOVEL     'BRANCH    '  TICALT
     C                   MOVEL     A8BRCD        TICODE
     C                   MOVEL     W_Key3        TIYRNB
     C                   Z-ADD     Num_ExtRcs    TIMULT
     C                   GOTO      SREND
     C                   ENDIF
      ** Branch Case 4
     C                   IF        A8LCCD <> *BLANKS
     C                   MOVEL     LocCCY        k_CurCode
     C                   MOVEL     A8LCCD        k_LocCode
     C                   MOVEL     HolYear       k_Year
     C     K_Holi        CHAIN     SDHOLL1                            80
      *
     C     *IN80         IFEQ      '1'
     C                   MOVEL     'Y'           W_Exprt
     C                   ADD       1             Num_ExtRcs
     C                   MOVEL     'BRANCH    '  TICALT
     C                   MOVEL     A8BRCD        TICODE
     C                   MOVEL     W_Key3        TIYRNB
     C                   Z-ADD     Num_ExtRcs    TIMULT
     C                   GOTO      SREND
     C                   ENDIF
     C                   ENDIF
      ** Branch Case 5
     C                   IF        A8LCCD = *BLANKS AND
     C                             SysLoc <> *BLANKS
     C                   MOVEL     LocCCY        k_CurCode
     C                   MOVEL     SysLoc        k_LocCode
     C                   MOVEL     HolYear       k_Year
     C     K_Holi        CHAIN     SDHOLL1                            80
      *
     C     *IN80         IFEQ      '1'
     C                   MOVEL     'Y'           W_Exprt
     C                   ADD       1             Num_ExtRcs
     C                   MOVEL     'BRANCH    '  TICALT
     C                   MOVEL     A8BRCD        TICODE
     C                   MOVEL     W_Key3        TIYRNB
     C                   Z-ADD     Num_ExtRcs    TIMULT
     C                   GOTO      SREND
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF        W_Exprt <> 'Y'
     C                   GOTO      READNXTB
     C                   ENDIF
      *
     C                   ENDSL
      *
     C                   ENDSR
      *
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * SRCtry - Subroutine for COUNTRY Driving File 02 DELETE
      ********************************************************************
     C     SRCtry        BEGSR
      *
      ** Only if location code is default '***'
      *
     C                   IF        W_Key2 = '***'
     C     HolCCY        READE     SDCTRYD0                               99
      *
     C     *IN99         IFEQ      '1'
     C                   MOVEL     'Y'           W_CTRY
     C                   ELSE
     C                   ADD       1             Num_ExtRcs
     C                   MOVEL     'COUNTRY   '  TICALT
     C                   MOVEL     *BLANKS       TICODE
     C                   MOVEL     A4CNCD        TICODE
     C                   MOVEL     W_Key3        TIYRNB
     C                   Z-ADD     Num_ExtRcs    TIMULT
     C                   GOTO      SREND
     C                   ENDIF
      *
     C                   ELSE
     C                   IF        W_CTRY <> 'Y'
     C                   MOVEL     'Y'           W_CTRY
     C                   ENDIF
     C                   ENDIF
     C
      *
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * SRCurr - Subroutine for CURRENCY Driving File 02 DELETE
      ********************************************************************
     C     SRCurr        BEGSR
      *
      ** Only if location code is default '***'
      *
     C                   IF        W_Key2 = '***'
      *
     C                   MOVEL     'Y'           W_CCY
     C                   ADD       1             Num_ExtRcs
     C                   MOVEL     'CURRENCY  '  TICALT
     C                   MOVEL     W_Key1        TICODE
     C                   MOVEL     W_Key3        TIYRNB
     C                   Z-ADD     Num_ExtRcs    TIMULT
     C                   GOTO      SREND
      *
     C                   ELSE
     C                   MOVEL     'Y'           W_CCY
     C                   ENDIF
      *
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * *INZSR --- INITIAL PROCESSING
      ********************************************************************
     C     *INZSR        BEGSR
      *
     C                   MOVEL     *BLANKS       W_Key1            3
     C                   MOVEL     *BLANKS       W_Key2            3
     C                   MOVEL     *BLANKS       W_Key3            4
     C                   MOVEL     *BLANKS       W_Process         1
     C                   MOVEL     *BLANKS       W_Exprt           1
     C                   CLEAR                   TIDELF
      *
     C     K_Holi        KLIST
     C                   KFLD                    k_CurCode         3
     C                   KFLD                    k_LocCode         3
     C                   KFLD                    k_Year            4
      *
      **  Access Bank Details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C                   ENDSR
      *
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY MXCPYSRC,MXPSSR
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2014
