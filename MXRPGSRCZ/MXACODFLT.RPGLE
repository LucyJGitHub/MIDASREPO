     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MX Account Code Filter (For Export)')            *
      *****************************************************************
      *                                                               *
      *  Midas - Meridian Export Module                               *
      *                                                               *
      *  MXACODFLT - Account Code Filter (For Export)                 *
      *                                                               *
      *  Function:  This module identifies those account              *
      *             codes that are marked for export.                 *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. 259085             Date 27Jul12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 190783             Date 15Apr01               *
      *                 CMX003             Date 05Nov00               *
      *                 CMX001  *CREATE    Data 01Jan00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  259085 - COB Performance Improvement in M+.                  *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  190783 - Allow definition of a default 'include indicator'   *
      *  CMX003 - Meridian Export Enhancements - Phase 2              *
      *  CMX001 - Meridian Export                                     *
      *                                                               *
      *****************************************************************
 
     FSDACODL0  IF   E           K DISK    INFSR(*PSSR)
     FMXACEXL0  IF   E           K DISK    INFSR(*PSSR)
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
 
 
      * Maximum number of account codes
     D MaxNoAcds       C                   CONST(8000)
 
      * Number of account codes loaded                                                        259085
     D CurNoAcds       S             10S 0                                                    259085
      * A/C codes for export
     D***#_ACCD*         S              4S 0 DIM(MaxNoAcds)                                   CGL029
     D*#_ACCD***       S             10S 0 DIM(MaxNoAcds)                              CGL029 259085
     D #_ACCD          S             10S 0 DIM(MaxNoAcds) ASCEND                              259085
      * Analysis codes of a/c codes for export
     D #_ANC1          S              4    DIM(MaxNoAcds)
     D #_ANC2          S              4    DIM(MaxNoAcds)
      * Account types of a/c codes for export
     D #_ATYP          S              1    DIM(MaxNoAcds)
 
     D I#ACOD          S             10S 0                                                    CGL029
 
 
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
      * Account Code
     C**********         PARM                    I#ACOD            4 0                        CGL029
     C                   PARM                    I#ACOD                                       CGL029
      * Export Account Code
     C                   PARM                    Exp_ACOD          1
      * Analysis Code 1
     C                   PARM                    A5ANC1            4
      * Analysis Code 2
     C                   PARM                    A5ANC2            4
      * Account Type
     C                   PARM                    Acc_Type          1
 
      * Load account codes for export
 
     C     I#LD          IFEQ      'L'
     C                   EXSR      LOAD_ACCD
     C                   ELSE
 
      * Determine if account code is to be included in the export
 
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
      * Load account codes for export
      ********************************************************************
     C     LOAD_ACCD     BEGSR
 
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
     C                   MOVEL     'AC'          DIFLTT                         190783
     C                   MOVEL     I#COMI        DICOMI                         190783
     C     MXDINCK       CHAIN     MXDINCP0                           99        190783
     C   99              MOVEL     'Y'           DIDINC                         190783
     C                   ENDIF                                                  190783
 
 
     C                   Z-ADD     1             @I
     C                   READ      @A5UPA7                                99
     C     *IN99         DOWEQ     '0'
 
     C*****A5ACCD********CHAIN     MXACEXP0                           99        CMX003
     C*******************MOVEL     *BLANK        A5COMI                  CMX003 190783
     C*****MXACEXK*******CHAIN     MXACEXP0                           99 CMX003 190783
     C******IN99*********IFEQ      '1'                                          190783
     C******IN99*********OREQ      '0'                                   CMX003 190783
     C*****A5ICUR********ANDEQ     'Y'                                   CMX003 190783
     C*****A5IACT********ANDEQ     'Y'                                   CMX003 190783
     C*******************MOVEL     I#COMI        A5COMI                  CMX003 190783
     C*****MXACEXK*******CHAIN     MXACEXP0                           98 CMX003 190783
     C******IN98*********IFEQ      '1'                                   CMX003 190783
     C******IN99*********ANDEQ     '1'                                   CMX003 190783
     C*******************MOVEL     'Y'           A5ICUR                         190783
     C*******************MOVEL     'Y'           A5IACT                         190783
     C*******************MOVEL     *BLANK        A5ANC1                         190783
     C*******************MOVEL     *BLANK        A5ANC2                         190783
     C*******************ENDIF                                           CMX003 190783
     C*******************ENDIF                                                  190783
 
     C*****I#AC**********IFEQ      'C'                                          190783
     C*****A5ICUR********ANDEQ     'Y'                                          190783
     C*****I#AC**********OREQ      'A'                                          190783
     C*****A5IACT********ANDEQ     'Y'                                          190783
                                                                                190783
     C                   MOVEL     'Y'           Select_Rcd        1            190783
     C                   MOVEL     *BLANK        A5ANC1                         190783
     C                   MOVEL     *BLANK        A5ANC2                         190783
                                                                                190783
      * Check 'global' level. Look for omitted records.                         190783
                                                                                190783
     C                   MOVEL     *BLANK        A5COMI                         190783
     C     MXACEXK       CHAIN     MXACEXP0                           99        190783
     C     *IN99         IFEQ      '0'                                          190783
     C     I#AC          IFEQ      'C'                                          190783
     C     A5ICUR        ANDEQ     'N'                                          190783
     C     I#AC          OREQ      'A'                                          190783
     C     A5IACT        ANDEQ     'N'                                          190783
     C                   MOVEL     'N'           Select_Rcd                     190783
     C                   ENDIF                                                  190783
     C                   ENDIF                                                  190783
                                                                                190783
      * Check 'composite' level. Look for omitted records.                      190783
                                                                                190783
     C     Select_Rcd    IFEQ      'Y'                                          190783
     C     I#COMI        ANDNE     *BLANK                                       190783
     C                   MOVEL     I#COMI        A5COMI                         190783
     C     MXACEXK       CHAIN     MXACEXP0                           99        190783
     C     *in99         IFEQ      '1'                                          190783
     C                   MOVEL     DIDINC        A5ICUR                         190783
     C                   MOVEL     DIDINC        A5IACT                         190783
     C                   ENDIF                                                  190783
     C     I#AC          IFEQ      'C'                                          190783
     C     A5ICUR        ANDEQ     'N'                                          190783
     C     I#AC          OREQ      'A'                                          190783
     C     A5IACT        ANDEQ     'N'                                          190783
     C                   MOVEL     'N'           Select_Rcd                     190783
     C                   ENDIF                                                  190783
     C                   ENDIF                                                  190783
                                                                                190783
     C     Select_Rcd    IFEQ      'Y'                                          190783
     C                   MOVEL     A5ACCD        #_ACCD(@I)                     *
     C                   MOVEL     A5ANC1        #_ANC1(@I)                     *
     C                   MOVEL     A5ANC2        #_ANC2(@I)                     *
     C                   MOVEL     A5ACTY        #_ATYP(@I)                     *
     C                   ADD       1             @I
     C                   ENDIF
     C                   READ      @A5UPA7                                99
     C                   ENDDO
     C                   EVAL      CurNoAcds = @I - 1                                         259085
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *********************************************************************
      * Determine if account code is to be included in the export
      ********************************************************************
     C     DET_EXP       BEGSR
 
      * Look for account code in list of account codes for export
 
     C                   Z-ADD     1             @I                6 0
     C*****I#ACOD        LOOKUP    #_ACCD(@I)                             99    *             259085
     C                   EVAL      @I = %Lookup(I#ACOD:#_ACCD:1:CurNoAcds)                    259085
 
     C******IN99         IFEQ      '1'                                                        259085
     C                   IF        @I > 0                                                     259085
     C                   MOVEL     'Y'           Exp_ACOD
     C                   MOVEL     #_ANC1(@I)    A5ANC1                         *
     C                   MOVEL     #_ANC2(@I)    A5ANC2                         *
     C                   MOVEL     #_ATYP(@I)    Acc_Type                       *
     C                   ELSE
     C                   MOVEL     'N'           Exp_ACOD
     C                   ENDIF
                                                                                CMX003
      * Key Lists                                                               CMX003
                                                                                CMX003
     C     MXACEXK       KLIST                                                  CMX003
     C                   KFLD                    A5ACCD                         CMX003
     C                   KFLD                    A5COMI                         CMX003
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
