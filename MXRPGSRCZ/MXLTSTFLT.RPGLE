     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MX Loan Type/Sub Type Filter (For Export)')      *
      *****************************************************************
      *                                                               *
      *  Midas - Meridian Export Module                               *
      *                                                               *
      *  MXLTSTFLT - Loan Type/Sub Type Filter (For Export)           *
      *                                                               *
      *  Function:  This module identifies those loan types/          *
      *             sub-types that are marked for export.             *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CLE134             Date 01Aug12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *  Prev Amend No. CLE042             Date 06Sep05               *
      *                 190783             Date 15Apr01               *
      *                 CMX003             Date 05Nov00               *
      *                 CMX001  *CREATE    Data 01Jan00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  190783 - Allow definition of a default 'include indicator'   *
      *  CMX003 - Meridian Export Enhancements - Phase 2              *
      *  CMX001 - Meridian Export                                     *
      *                                                               *
      *****************************************************************
 
     FSDLOANL0  IF   E           K DISK    INFSR(*PSSR)
     FMXLTEXL0  IF   E           K DISK    INFSR(*PSSR)
     FMXDINCPD  IF   E           K DISK    INFSR(*PSSR)                         190783
 
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
 
 
      * Maximum number of loan type/sub types
     D MaxNoLTST       C                   CONST(2000)
 
      * Loan type/sub types for export
     D #_LTST          S              4    DIM(MaxNoLTST)
      * Analysis codes of loan type/sub types for export
     D #_ANC1          S              4    DIM(MaxNoLTST)
     D #_ANC2          S              4    DIM(MaxNoLTST)
      * Processing types of loan type/sub types for export
     D #_PT            S              2    DIM(MaxNoLTST)
 
 
 
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           30
      * INPUTS
      * L=Load or D=Determine
     C                   PARM                    I#LD              1
      * Composite ID                                                            CMX003
     C                   PARM                    I#COMI            8            CMX003
      * A=Activity C=Current
     C                   PARM                    I#AC              1
      * Loan Type
     C                   PARM                    I#LNTY            2
      * Loan Sub-Type
     C                   PARM                    I#LNST            2
      * Export Loan Type/Sub-Type
     C                   PARM                    Exp_LTST          1
      * Analysis Code 1
     C                   PARM                    AYANC1            4
      * Analysis Code 2
     C                   PARM                    AYANC2            4
      * Processing Type
     C                   PARM                    Proc_Type         2
 
      * Load loan type/sub types for export
 
     C     I#LD          IFEQ      'L'
     C                   EXSR      LOAD_LTST
     C                   ELSE
 
      * Determine if loan type/sub type is to be included in the export
 
     C     I#LD          IFEQ      'D'
     C                   MOVEL     I#LNTY        LTST              4
     C                   MOVE      I#LNST        LTST
     C                   EXSR      DET_EXP
     C                   ELSE
 
      * Error
 
     C                   EVAL      I#ERMS = 'NOT LOAD OR DETERMINE'
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
 
 
      * Return
 
     C                   RETURN
      *
      ********************************************************************
      /SPACE 5
      *********************************************************************
      * Load loan type/sub types for export
      ********************************************************************
     C     LOAD_LTST     BEGSR
 
      * Error
 
     C     I#AC          IFNE      'C'
     C     I#AC          ANDNE     'A'
     C                   EVAL      I#ERMS = 'NOT CURRENT OR ACTIVITY'
     C                   EXSR      *PSSR
     C                   ENDIF
                                                                                190783
                                                                                190783
      ** Access default include indicator                                       190783
                                                                                190783
     C     I#COMI        IFNE      *BLANK                                       190783
     C                   MOVEL     'LT'          DIFLTT                         190783
     C                   MOVEL     I#COMI        DICOMI                         190783
     C     MXDINCK       CHAIN     MXDINCP0                           99        190783
     C   99              MOVEL     'Y'           DIDINC                         190783
     C                   ENDIF                                                  190783
 
 
     C                   Z-ADD     1             @I
     C                   READ      @AYRECK                                99
     C     *IN99         DOWEQ     '0'
 
     C*****MXLTEXK*******KLIST                                                  190783
     C*******************KFLD                    AYLNTY                         190783
     C*******************KFLD                    AYLNST                         190783
     C*******************KFLD                    AYCOMI                  CMX003 190783
     C*******************MOVEL     *BLANK        AYCOMI                  CMX003 190783
     C*****MXLTEXK*******CHAIN     MXLTEXP0                           99        190783
     C******IN99*********IFEQ      '1'                                          190783
     C******IN99*********OREQ      '0'                                   CMX003 190783
     C*****AYICUR********ANDEQ     'Y'                                   CMX003 190783
     C*****AYIACT********ANDEQ     'Y'                                   CMX003 190783
     C*******************MOVEL     I#COMI        AYCOMI                  CMX003 190783
     C*****MXLTEXK*******CHAIN     MXLTEXP0                           98 CMX003 190783
     C******IN98*********IFEQ      '1'                                   CMX003 190783
     C******IN99*********ANDEQ     '1'                                   CMX003 190783
     C*******************MOVEL     'Y'           AYICUR                         190783
     C*******************MOVEL     'Y'           AYIACT                         190783
     C*******************MOVEL     *BLANK        AYANC1                         190783
     C*******************MOVEL     *BLANK        AYANC2                         190783
     C*******************ENDIF                                           CMX003 190783
     C*******************ENDIF                                                  190783
 
     C*****I#AC**********IFEQ      'C'                                          190783
     C*****AYICUR********ANDEQ     'Y'                                          190783
     C*****I#AC**********OREQ      'A'                                          190783
     C*****AYIACT********ANDEQ     'Y'                                          190783
                                                                                190783
     C                   MOVEL     'Y'           Select_Rcd        1            190783
     C                   MOVEL     *BLANK        AYANC1                         190783
     C                   MOVEL     *BLANK        AYANC2                         190783
                                                                                190783
      * Check 'global' level. Look for omitted records.                         190783
                                                                                190783
     C                   MOVEL     *BLANK        AYCOMI                         190783
     C     MXLTEXK       CHAIN     MXLTEXP0                           99        190783
     C     *IN99         IFEQ      '0'                                          190783
     C     I#AC          IFEQ      'C'                                          190783
     C     AYICUR        ANDEQ     'N'                                          190783
     C     I#AC          OREQ      'A'                                          190783
     C     AYIACT        ANDEQ     'N'                                          190783
     C                   MOVEL     'N'           Select_Rcd                     190783
     C                   ENDIF                                                  190783
     C                   ENDIF                                                  190783
                                                                                190783
      * Check 'composite' level. Look for omitted records.                      190783
                                                                                190783
     C     Select_Rcd    IFEQ      'Y'                                          190783
     C     I#COMI        ANDNE     *BLANK                                       190783
     C                   MOVEL     I#COMI        AYCOMI                         190783
     C     MXLTEXK       CHAIN     MXLTEXP0                           99        190783
     C     *in99         IFEQ      '1'                                          190783
     C                   MOVEL     DIDINC        AYICUR                         190783
     C                   MOVEL     DIDINC        AYIACT                         190783
     C                   ENDIF                                                  190783
     C     I#AC          IFEQ      'C'                                          190783
     C     AYICUR        ANDEQ     'N'                                          190783
     C     I#AC          OREQ      'A'                                          190783
     C     AYIACT        ANDEQ     'N'                                          190783
     C                   MOVEL     'N'           Select_Rcd                     190783
     C                   ENDIF                                                  190783
     C                   ENDIF                                                  190783
                                                                                190783
     C     Select_Rcd    IFEQ      'Y'                                          190783
     C                   MOVEL     AYLNTY        #_LTST(@I)                     *
     C                   MOVE      AYLNST        #_LTST(@I)                     *
     C                   MOVEL     AYANC1        #_ANC1(@I)                     *
     C                   MOVEL     AYANC2        #_ANC2(@I)                     *
     C                   MOVEL     AYLNPT        #_PT(@I)                       *
     C                   ADD       1             @I
     C                   ENDIF
     C                   READ      @AYRECK                                99
     C                   ENDDO
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *********************************************************************
      * Determine if loan type/sub type is to be included in the export
      ********************************************************************
     C     DET_EXP       BEGSR
 
      * Look for loan type/sub type in list of those for export
 
     C                   Z-ADD     1             @I                6 0
     C     LTST          LOOKUP    #_LTST(@I)                             99    *
 
     C     *IN99         IFEQ      '1'
     C                   MOVEL     'Y'           Exp_LTST
     C                   MOVEL     #_ANC1(@I)    AYANC1                         *
     C                   MOVEL     #_ANC2(@I)    AYANC2                         *
     C                   MOVEL     #_PT(@I)      Proc_Type                      *
     C                   ELSE
     C                   MOVEL     'N'           Exp_LTST
     C                   ENDIF
                                                                                190783
      * Key Lists                                                               190783
                                                                                190783
     C     MXLTEXK       KLIST                                                  190783
     C                   KFLD                    AYLNTY                         190783
     C                   KFLD                    AYLNST                         190783
     C                   KFLD                    AYCOMI                         190783
     C     MXDINCK       KLIST                                                  190783
     C                   KFLD                    DIFLTT                         190783
     C                   KFLD                    DICOMI                         190783
 
     C                   ENDSR
     C********************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY MXCPYSRC,MXPSSR
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
