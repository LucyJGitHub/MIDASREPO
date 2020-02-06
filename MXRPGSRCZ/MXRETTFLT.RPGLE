     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MX Retail Trans Type Filter (For Export)')
      *****************************************************************
      *                                                               *
      *  Midas - Meridian Export Module                               *
      *                                                               *
      *  MXRETTFLT - Retail Transaction Types Filter (For Export)     *
      *                                                               *
      *  Function:  This module identifies those retail transaction   *
      *             types that are marked for export.                 *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CGL029             Date 01Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 190783             Date 15Apr01               *
      *                 CMX003  *CREATE    Date 05Nov00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  190783 - Allow definition of a default 'include indicator'   *
      *  CMX003 - Meridian Export Enhancements - Phase 2              *
      *                                                               *
      *****************************************************************
 
     FSDRETRL0  IF   E           K DISK    INFSR(*PSSR)
     FMXTTEXL0  IF   E           K DISK    INFSR(*PSSR)
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
 
 
      * Maximum number of transaction types
     D MaxNoTrts       C                   CONST(1000)
 
      * Transaction Types for export
     D #_TRTY          S              5    DIM(MaxNoTrts)
      * Analysis codes of transaction types for export
     D*#_ANC1***       S              4    DIM(MaxNoTrts)                                     CGL029
     D*#_ANC2***       S              4    DIM(MaxNoTrts)                                     CGL029
     D #_ANC1          S             10    DIM(MaxNoTrts)                                     CGL029
     D #_ANC2          S             10    DIM(MaxNoTrts)                                     CGL029
 
 
 
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           30
      * INPUTS
      * L=Load or D=Determine
     C                   PARM                    I#LD              1
      * Composite ID
     C                   PARM                    I#COMI            8
      * A=Activity C=Current
     C                   PARM                    I#AC              1
      * Transaction Type
     C                   PARM                    I#RTTY            5
      * Export Transaction Type
     C                   PARM                    Exp_RTTY          1
      * Analysis Code 1
     C**********         PARM                    A1ANC1            4                          CGL029
     C                   PARM                    A1ANC1           10                          CGL029
      * Analysis Code 2
     C**********         PARM                    A1ANC2            4                          CGL029
     C                   PARM                    A1ANC2           10                          CGL029
 
      * Load transaction types for export
 
     C     I#LD          IFEQ      'L'
     C                   EXSR      LOAD_TRTY
     C                   ELSE
 
      * Determine if transaction type is to be included in the export
 
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
      * Load transaction types for export
      ********************************************************************
     C     LOAD_TRTY     BEGSR
 
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
     C                   MOVEL     'TT'          DIFLTT                         190783
     C                   MOVEL     I#COMI        DICOMI                         190783
     C     MXDINCK       CHAIN     MXDINCP0                           99        190783
     C   99              MOVEL     'Y'           DIDINC                         190783
     C                   ENDIF                                                  190783
 
 
     C                   Z-ADD     1             @I
     C                   READ      @A1RECW                                99
     C     *IN99         DOWEQ     '0'
 
     C*******************MOVEL     *BLANK        A1COMI                         190783
     C*****MXTTEXK*******CHAIN     MXTTEXP0                           99        190783
     C******IN99*********IFEQ      '1'                                          190783
     C******IN99*********OREQ      '0'                                          190783
     C*****A1ICUR********ANDEQ     'Y'                                          190783
     C*****A1IACT********ANDEQ     'Y'                                          190783
     C*******************MOVEL     I#COMI        A1COMI                         190783
     C*****MXTTEXK*******CHAIN     MXTTEXP0                           98        190783
     C******IN98*********IFEQ      '1'                                          190783
     C******IN99*********ANDEQ     '1'                                          190783
     C*******************MOVEL     'Y'           A1ICUR                         190783
     C*******************MOVEL     'Y'           A1IACT                         190783
     C*******************MOVEL     *BLANK        A1ANC1                         190783
     C*******************MOVEL     *BLANK        A1ANC2                         190783
     C*******************ENDIF                                                  190783
     C*******************ENDIF                                                  190783
 
     C*****I#AC**********IFEQ      'C'                                          190783
     C*****A1ICUR********ANDEQ     'Y'                                          190783
     C*****I#AC**********OREQ      'A'                                          190783
     C*****A1IACT********ANDEQ     'Y'                                          190783
                                                                                190783
     C                   MOVEL     'Y'           Select_Rcd        1            190783
     C                   MOVEL     *BLANK        A1ANC1                         190783
     C                   MOVEL     *BLANK        A1ANC2                         190783
                                                                                190783
      * Check 'global' level. Look for omitted records.                         190783
                                                                                190783
     C                   MOVEL     *BLANK        A1COMI                         190783
     C     MXTTEXK       CHAIN     MXTTEXP0                           99        190783
     C     *IN99         IFEQ      '0'                                          190783
     C     I#AC          IFEQ      'C'                                          190783
     C     A1ICUR        ANDEQ     'N'                                          190783
     C     I#AC          OREQ      'A'                                          190783
     C     A1IACT        ANDEQ     'N'                                          190783
     C                   MOVEL     'N'           Select_Rcd                     190783
     C                   ENDIF                                                  190783
     C                   ENDIF                                                  190783
                                                                                190783
      * Check 'composite' level. Look for omitted records.                      190783
                                                                                190783
     C     Select_Rcd    IFEQ      'Y'                                          190783
     C     I#COMI        ANDNE     *BLANK                                       190783
     C                   MOVEL     I#COMI        A1COMI                         190783
     C     MXTTEXK       CHAIN     MXTTEXP0                           99        190783
     C     *in99         IFEQ      '1'                                          190783
     C                   MOVEL     DIDINC        A1ICUR                         190783
     C                   MOVEL     DIDINC        A1IACT                         190783
     C                   ENDIF                                                  190783
     C     I#AC          IFEQ      'C'                                          190783
     C     A1ICUR        ANDEQ     'N'                                          190783
     C     I#AC          OREQ      'A'                                          190783
     C     A1IACT        ANDEQ     'N'                                          190783
     C                   MOVEL     'N'           Select_Rcd                     190783
     C                   ENDIF                                                  190783
     C                   ENDIF                                                  190783
                                                                                190783
     C     Select_Rcd    IFEQ      'Y'                                          190783
     C                   MOVEL     A1RTTY        #_TRTY(@I)                     *
     C                   MOVEL     A1ANC1        #_ANC1(@I)                     *
     C                   MOVEL     A1ANC2        #_ANC2(@I)                     *
     C                   ADD       1             @I
     C                   ENDIF
     C                   READ      @A1RECW                                99
     C                   ENDDO
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *********************************************************************
      * Determine if transaction type is to be included in the export
      ********************************************************************
     C     DET_EXP       BEGSR
 
      * Look for transaction type in list of transaction types for export
 
     C                   Z-ADD     1             @I                6 0
     C     I#RTTY        LOOKUP    #_TRTY(@I)                             99    *
 
     C     *IN99         IFEQ      '1'
     C                   MOVEL     'Y'           Exp_RTTY
     C                   MOVEL     #_ANC1(@I)    A1ANC1                         *
     C                   MOVEL     #_ANC2(@I)    A1ANC2                         *
     C                   ELSE
     C                   MOVEL     'N'           Exp_RTTY
     C                   ENDIF
 
      * Key Lists
 
     C     MXTTEXK       KLIST
     C                   KFLD                    A1RTTY
     C                   KFLD                    A1COMI
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
