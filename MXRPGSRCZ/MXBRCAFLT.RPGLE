     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MX Branch Filter (For Export)')
      *****************************************************************
      *                                                               *
      *  Midas - Meridian Export Module                               *
      *                                                               *
      *  MXBRCAFLT - Branch Filter (For Export)                       *
      *                                                               *
      *  Function:  This module identifies those branches             *
      *             that are marked for export.                       *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. 257335             Date 22Oct08               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 190783             Date 15Apr01               *
      *                 CMX003             Date 05Nov00               *
      *                 CMX001  *CREATE    Data 01Jan00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  257335 - COB: Component MXC0480 failed with array index      *
      *           error in MXBRCAFLT (apply fix 250079)               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  190783 - Allow definition of a default 'include indicator'   *
      *  CMX003 - Meridian Export Enhancements - Phase 2              *
      *  CMX001 - Meridian Export                                     *
      *                                                               *
      *****************************************************************
 
     FSDBRCHL0  IF   E           K DISK    INFSR(*PSSR)
     FMXBREXL0  IF   E           K DISK    INFSR(*PSSR)
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
 
 
      * Maximum number of branches
     D***MaxNoBchs       C                   CONST(100)                                       257335
     D MaxNoBchs       C                   CONST(500)                                         257335
 
      * Branches for export
     D #_BRCD          S              3    DIM(MaxNoBchs)
      * Analysis codes of branches for export
     D #_ANC1          S              4    DIM(MaxNoBchs)
     D #_ANC2          S              4    DIM(MaxNoBchs)
 
 
 
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
      * Branch
     C                   PARM                    I#BRCA            3
      * Export Branch
     C                   PARM                    Exp_BRCA          1
      * Analysis Code 1
     C                   PARM                    A8ANC1            4
      * Analysis Code 2
     C                   PARM                    A8ANC2            4
 
      * Load branches for export
 
     C     I#LD          IFEQ      'L'
     C                   EXSR      LOAD_BRCD
     C                   ELSE
 
      * Determine if branch is to be included in the export
 
     C     I#LD          IFEQ      'D'
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
      * Load branches for export
      ********************************************************************
     C     LOAD_BRCD     BEGSR
 
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
     C                   MOVEL     'BR'          DIFLTT                         190783
     C                   MOVEL     I#COMI        DICOMI                         190783
     C     MXDINCK       CHAIN     MXDINCP0                           99        190783
     C   99              MOVEL     'Y'           DIDINC                         190783
     C                   ENDIF                                                  190783
 
 
     C                   Z-ADD     1             @I
     C                   READ      @A8REB1                                99
     C     *IN99         DOWEQ     '0'
 
     C*****A8BRCD********CHAIN     MXBREXP0                           99        CMX003
     C*******************MOVEL     *BLANK        A8COMI                  CMX003 190783
     C*****MXBREXK*******CHAIN     MXBREXP0                           99 CMX003 190783
     C******IN99*********IFEQ      '1'                                          190783
     C******IN99*********OREQ      '0'                                   CMX003 190783
     C*****A8ICUR********ANDEQ     'Y'                                   CMX003 190783
     C*****A8IACT********ANDEQ     'Y'                                   CMX003 190783
     C*******************MOVEL     I#COMI        A8COMI                  CMX003 190783
     C*****MXBREXK*******CHAIN     MXBREXP0                           98 CMX003 190783
     C******IN98*********IFEQ      '1'                                   CMX003 190783
     C******IN99*********ANDEQ     '1'                                   CMX003 190783
     C*******************MOVEL     'Y'           A8ICUR                         190783
     C*******************MOVEL     'Y'           A8IACT                         190783
     C*******************MOVEL     *BLANK        A8ANC1                         190783
     C*******************MOVEL     *BLANK        A8ANC2                         190783
     C*******************ENDIF                                           CMX003 190783
     C*******************ENDIF                                                  190783
 
     C*****I#AC**********IFEQ      'C'                                          190783
     C*****A8ICUR********ANDEQ     'Y'                                          190783
     C*****I#AC**********OREQ      'A'                                          190783
     C*****A8IACT********ANDEQ     'Y'                                          190783
                                                                                190783
     C                   MOVEL     'Y'           Select_Rcd        1            190783
     C                   MOVEL     *BLANK        A8ANC1                         190783
     C                   MOVEL     *BLANK        A8ANC2                         190783
                                                                                190783
      * Check 'global' level. Look for omitted records.                         190783
                                                                                190783
     C                   MOVEL     *BLANK        A8COMI                         190783
     C     MXBREXK       CHAIN     MXBREXP0                           99        190783
     C     *IN99         IFEQ      '0'                                          190783
     C     I#AC          IFEQ      'C'                                          190783
     C     A8ICUR        ANDEQ     'N'                                          190783
     C     I#AC          OREQ      'A'                                          190783
     C     A8IACT        ANDEQ     'N'                                          190783
     C                   MOVEL     'N'           Select_Rcd                     190783
     C                   ENDIF                                                  190783
     C                   ENDIF                                                  190783
                                                                                190783
      * Check 'composite' level. Look for omitted records.                      190783
                                                                                190783
     C     Select_Rcd    IFEQ      'Y'                                          190783
     C     I#COMI        ANDNE     *BLANK                                       190783
     C                   MOVEL     I#COMI        A8COMI                         190783
     C     MXBREXK       CHAIN     MXBREXP0                           99        190783
     C     *in99         IFEQ      '1'                                          190783
     C                   MOVEL     DIDINC        A8ICUR                         190783
     C                   MOVEL     DIDINC        A8IACT                         190783
     C                   ENDIF                                                  190783
     C     I#AC          IFEQ      'C'                                          190783
     C     A8ICUR        ANDEQ     'N'                                          190783
     C     I#AC          OREQ      'A'                                          190783
     C     A8IACT        ANDEQ     'N'                                          190783
     C                   MOVEL     'N'           Select_Rcd                     190783
     C                   ENDIF                                                  190783
     C                   ENDIF                                                  190783
                                                                                190783
     C     Select_Rcd    IFEQ      'Y'                                          190783
     C                   MOVEL     A8BRCD        #_BRCD(@I)                     *
     C                   MOVEL     A8ANC1        #_ANC1(@I)                     *
     C                   MOVEL     A8ANC2        #_ANC2(@I)                     *
     C                   ADD       1             @I
     C                   ENDIF
     C                   READ      @A8REB1                                99
     C                   ENDDO
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *********************************************************************
      * Determine if branch is to be included in the export
      ********************************************************************
     C     DET_EXP       BEGSR
 
      * Look for branch in list of branches for export
 
     C                   Z-ADD     1             @I                6 0
     C     I#BRCA        LOOKUP    #_BRCD(@I)                             99    *
 
     C     *IN99         IFEQ      '1'
     C                   MOVEL     'Y'           Exp_BRCA
     C                   MOVEL     #_ANC1(@I)    A8ANC1                         *
     C                   MOVEL     #_ANC2(@I)    A8ANC2                         *
     C                   ELSE
     C                   MOVEL     'N'           Exp_BRCA
     C                   ENDIF
                                                                                CMX003
      * Key Lists                                                               CMX003
                                                                                CMX003
     C     MXBREXK       KLIST                                                  CMX003
     C                   KFLD                    A8BRCD                         CMX003
     C                   KFLD                    A8COMI                         CMX003
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
(c) Finastra International Limited 2001
