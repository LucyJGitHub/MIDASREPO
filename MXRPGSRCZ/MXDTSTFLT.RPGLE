     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MX Deal Type/Sub Type Filter (For Export)')      *
      *****************************************************************
      *                                                               *
      *  Midas - Meridian Export Module                               *
      *                                                               *
      *  MXDTSTFLT - Deal Type/Sub Type Filter (For Export)           *
      *                                                               *
      *  Function:  This module identifies those deal types/          *
      *             sub-types that are marked for export.             *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. LLN022A            Date 03Jun15               *
      *                 LLN022             Date 03Jun15               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CDL038             Date 10May05               *
      *                 190783             Date 15Apr01               *
      *                 CMX003             Date 05Nov00               *
      *                 CMX001  *CREATE    Data 01Jan00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  LLN022A- BOE Upgrade to MidasPlus - incorporate code from    *
      *           /COPY members and add switchability.                *
      *  LLN022 - BOE Upgrade to MidasPlus.                           *
      *           Core hook added:MXDTST0001                          *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  190783 - Allow definition of a default 'include indicator'   *
      *  CMX003 - Meridian Export Enhancements - Phase 2              *
      *  CMX001 - Meridian Export                                     *
      *                                                               *
      *****************************************************************
 
     FFDDTSTL0  IF   E           K DISK    INFSR(*PSSR)
     FMXDTEXL0  IF   E           K DISK    INFSR(*PSSR)
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
 
 
      * Maximum number of deal type/sub types
     D MaxNoDTST       C                   CONST(2000)
 
      * Deal type/sub types for export
     D #_DTST          S              4    DIM(MaxNoDTST)
      * Analysis codes of deal type/sub types for export
     D #_ANC1          S              4    DIM(MaxNoDTST)
     D #_ANC2          S              4    DIM(MaxNoDTST)
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                 LLN022A
      * External DS for SAR details                                                          LLN022A
 
     D DSFDY         E DS                  EXTNAME(DSFDY)                                    LLN022A
 
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
      * Deal Type
     C                   PARM                    I#DTYP            2
      * Deal Sub-Type
     C                   PARM                    I#DLST            2
      * Export Deal Type/Sub-Type
     C                   PARM                    Exp_DTST          1
      * Analysis Code 1
     C                   PARM                    DTANC1            4
      * Analysis Code 2
     C                   PARM                    DTANC2            4
 
      ** Access Switchable Features file to determine whether                                LLN022A
      ** LLN022 (Bank of England) processing is installed.                                   LLN022A
      *                                                                                      LLN022A
     C                   MOVE      'N'           LLN022            1                         LLN022A
     C                   CALLB     'AOSARDR0'                                                LLN022A
     C                   PARM      *BLANK        @RTCD             7                         LLN022A
     C                   PARM      '*VERIFY'     @OPTN             7                         LLN022A
     C                   PARM      'LLN022'      @SARD             6                         LLN022A
     C     SCSARD        PARM      SCSARD        DSFDY                                       LLN022A
      *                                                                                      LLN022A
     C                   IF        @RTCD = *BLANK                                            LLN022A
     C                   MOVE      'Y'           LLN022                                      LLN022A
     C                   ENDIF                                                               LLN022A
                                                                                             LLN022A
      * Load deal type/sub types for export
 
     C     I#LD          IFEQ      'L'
     C                   EXSR      LOAD_DTST
     C                   ELSE
 
      * Determine if deal type/sub type is to be included in the export
 
     C     I#LD          IFEQ      'D'
     C                   MOVEL     I#DTYP        DTST              4
     C                   MOVE      I#DLST        DTST
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
      * Load deal type/sub types for export
      ********************************************************************
     C     LOAD_DTST     BEGSR
 
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
     C                   MOVEL     'DT'          DIFLTT                         190783
     C                   MOVEL     I#COMI        DICOMI                         190783
     C     MXDINCK       CHAIN     MXDINCP0                           99        190783
     C   99              MOVEL     'Y'           DIDINC                         190783
     C                   ENDIF                                                  190783
 
 
     C                   Z-ADD     1             @I
     C                   READ      FDDTSTPD                               99
     C     *IN99         DOWEQ     '0'
 
     C*****MXDTEXK*******KLIST                                                  190783
     C*******************KFLD                    DTPE11                         190783
     C*******************KFLD                    DLST11                         190783
     C*******************KFLD                    DTCOMI                  CMX003 190783
     C*******************MOVEL     *BLANK        DTCOMI                  CMX003 190783
     C*****MXDTEXK*******CHAIN     MXDTEXP0                           99        190783
     C******IN99*********IFEQ      '1'                                          190783
     C******IN99*********OREQ      '0'                                   CMX003 190783
     C*****DTICUR********ANDEQ     'Y'                                   CMX003 190783
     C*****DTIACT********ANDEQ     'Y'                                   CMX003 190783
     C*******************MOVEL     I#COMI        DTCOMI                  CMX003 190783
     C*****MXDTEXK*******CHAIN     MXDTEXP0                           98 CMX003 190783
     C******IN98*********IFEQ      '1'                                   CMX003 190783
     C******IN99*********ANDEQ     '1'                                   CMX003 190783
     C*******************MOVEL     'Y'           DTICUR                         190783
     C*******************MOVEL     'Y'           DTIACT                         190783
     C*******************MOVEL     *BLANK        DTANC1                         190783
     C*******************MOVEL     *BLANK        DTANC2                         190783
     C*******************ENDIF                                           CMX003 190783
     C*******************ENDIF                                                  190783
 
     C*****I#AC**********IFEQ      'C'                                          190783
     C*****DTICUR********ANDEQ     'Y'                                          190783
     C*****I#AC**********OREQ      'A'                                          190783
     C*****DTIACT********ANDEQ     'Y'                                          190783
                                                                                190783
     C                   MOVEL     'Y'           Select_Rcd        1            190783
     C                   MOVEL     *BLANK        DTANC1                         190783
     C                   MOVEL     *BLANK        DTANC2                         190783
                                                                                190783
      * Check 'global' level. Look for omitted records.                         190783
                                                                                190783
     C                   MOVEL     *BLANK        DTCOMI                         190783
     C     MXDTEXK       CHAIN     MXDTEXP0                           99        190783
     C     *IN99         IFEQ      '0'                                          190783
     C     I#AC          IFEQ      'C'                                          190783
     C     DTICUR        ANDEQ     'N'                                          190783
     C     I#AC          OREQ      'A'                                          190783
     C     DTIACT        ANDEQ     'N'                                          190783
     C                   MOVEL     'N'           Select_Rcd                     190783
     C                   ENDIF                                                  190783
     C                   ENDIF                                                  190783
                                                                                190783
      * Check 'composite' level. Look for omitted records.                      190783
                                                                                190783
     C     Select_Rcd    IFEQ      'Y'                                          190783
     C     I#COMI        ANDNE     *BLANK                                       190783
     C                   MOVEL     I#COMI        DTCOMI                         190783
     C     MXDTEXK       CHAIN     MXDTEXP0                           99        190783
     C     *in99         IFEQ      '1'                                          190783
     C                   MOVEL     DIDINC        DTICUR                         190783
     C                   MOVEL     DIDINC        DTIACT                         190783
     C                   ENDIF                                                  190783
     C     I#AC          IFEQ      'C'                                          190783
     C     DTICUR        ANDEQ     'N'                                          190783
     C     I#AC          OREQ      'A'                                          190783
     C     DTIACT        ANDEQ     'N'                                          190783
     C                   MOVEL     'N'           Select_Rcd                     190783
     C                   ENDIF                                                  190783
     C                   ENDIF                                                  190783
                                                                                190783
     C     Select_Rcd    IFEQ      'Y'                                          190783
     C                   MOVEL     DTPE11        #_DTST(@I)                     *
     C                   MOVE      DLST11        #_DTST(@I)                     *
     C                   MOVEL     DTANC1        #_ANC1(@I)                     *
     C                   MOVEL     DTANC2        #_ANC2(@I)                     *
     C                   ADD       1             @I
     C                   ENDIF
     C                   READ      FDDTSTPD                               99
     C                   ENDDO
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *********************************************************************
      * Determine if deal type/sub type is to be included in the export
      ********************************************************************
     C     DET_EXP       BEGSR
 
      * Look for deal type/sub type in list of those for export
 
     C                   Z-ADD     1             @I                6 0
     C     DTST          LOOKUP    #_DTST(@I)                             99    *
 
     C     *IN99         IFEQ      '1'
     C                   MOVEL     'Y'           Exp_DTST
     C                   MOVEL     #_ANC1(@I)    DTANC1                         *
     C                   MOVEL     #_ANC2(@I)    DTANC2                         *
     C                   ELSE
     C                   MOVEL     'N'           Exp_DTST
     C                   ENDIF
                                                                                              LLN022
      /COPY WNCPYSRC,MXDTST0001                                                               LLN022
                                                                                             LLN022A
     C                   IF        LLN022 = 'Y'                                              LLN022A
     C                   MOVEL     'Y'           Exp_DTST                                    LLN022A
     C                   END                                                                 LLN022A
                                                                                190783
      * Key Lists                                                               190783
                                                                                190783
     C     MXDTEXK       KLIST                                                  190783
     C                   KFLD                    DTPE11                         190783
     C                   KFLD                    DLST11                         190783
     C                   KFLD                    DTCOMI                         190783
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
