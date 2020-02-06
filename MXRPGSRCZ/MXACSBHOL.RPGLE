     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2014')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MX Access Holiday for Branch Calendar')          *
      *****************************************************************
      *                                                               *
      *  Midas - Meridian Export Module                               *
      *                                                               *
      *  MXACSBHOL - Access Holiday File for Branch Calendar          *
      *                                                               *
      *  Function:  This module accesses Holiday File                 *
      *                                                               *
      *  (c) Finastra International Limited 2014                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CTI006  *CREATE    Date 31Mar14               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CTI006 - Trade Finance BF Midas 2.2 Interface                *
      *                                                               *
      *****************************************************************
 
     FSDHOLL1   IF   E           K DISK    INFSR(*PSSR)
 
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
 
      ** Holiday details data structure
     D SDHOL         E DS                  EXTNAME(SDHOLPD)
 
     C     *ENTRY        PLIST
     C/COPY MXCPYSRC,MXACSPRMI
      *
      ** Use input link-to field
      *
     C                   MOVEL     I#LFD1        BrcLoc            3
     C                   MOVEL     I#LFD2        SysLoc            3
     C                   MOVEL     I#LFD3        LocCCY            3
      *
     C     K_Holi        KLIST
     C                   KFLD                    k_CurCode         3
     C                   KFLD                    k_LocCode         3
      *
     C                   IF        W_Process = *BLANKS
     C                   Z-ADD     *ZERO         Num_ExtRcs        5 0
     C                   Z-ADD     *ZERO         W_CASE
     C                   MOVEL     *BLANKS       W_NoRec
     C                   MOVEL     'Y'           W_Process
      *
     C                   SELECT
      *
      ** CASE 1: Branch and system location code are blanks
      *
     C                   WHEN      BrcLoc = *BLANKS AND
     C                             SysLoc = *BLANKS
     C                   Z-ADD     1             W_CASE
     C                   MOVEL     LocCCY        k_CurCode
     C                   MOVEL     '***'         k_LocCode
     C     K_Holi        SETLL     @HOLPHK
      *
      ** CASE 2: Branch location code is blank while system is non-blank
      *
     C                   WHEN      BrcLoc = *BLANKS AND
     C                             SysLoc <> *BLANKS
     C                   Z-ADD     2             W_CASE
     C                   MOVEL     LocCCY        k_CurCode
     C                   MOVEL     SysLoc        k_LocCode
     C     K_Holi        SETLL     @HOLPHK
      *
      ** CASE 3: Branch location code is non-blank
      *
     C                   WHEN      BrcLoc <> *BLANKS
     C                   Z-ADD     3             W_CASE
     C                   MOVEL     LocCCY        k_CurCode
     C                   MOVEL     BrcLoc        k_LocCode
     C     K_Holi        SETLL     @HOLPHK
     C                   ENDSL
      *
     C                   ENDIF
      *
      ** Access the holiday file
      *
     C     K_Holi        READE     @HOLPHK                                99
      *
      ** CASE 1
      *
     C                   IF        W_CASE = 1
     C                   IF        *IN99 = '1'
     C                   MOVEL     '*EODATA'     I#RTCD
     C                   MOVEL     *BLANKS       W_Process
     C                   Z-ADD     *ZERO         Num_ExtRcs
     C                   ELSE
     C                   ADD       1             Num_ExtRcs
     C                   Z-ADD     Num_ExtRcs    DGLCD
     C                   ENDIF
     C                   ENDIF
      *
      ** CASE 2
      *
     C                   IF        W_CASE = 2 AND W_NoRec = *BLANKS
     C                   IF        *IN99 = '1'
     C                   IF        Num_ExtRcs <> 0
     C                   MOVEL     '*EODATA'     I#RTCD
     C                   MOVEL     *BLANKS       W_Process
     C                   Z-ADD     *ZERO         Num_ExtRcs
     C                   ELSE
      *
      ** If no data from previous read, use default location code
      *
     C                   MOVEL     'Y'           W_NoRec
     C                   MOVEL     LocCCY        k_CurCode
     C                   MOVEL     '***'         k_LocCode
     C     K_Holi        SETLL     @HOLPHK
     C     K_Holi        READE     @HOLPHK                                99
     C                   ENDIF
     C                   ELSE
     C                   ADD       1             Num_ExtRcs
     C                   Z-ADD     Num_ExtRcs    DGLCD
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF        W_CASE = 2 AND W_NoRec = 'Y'
     C                   IF        *IN99 = '1'
     C                   MOVEL     '*EODATA'     I#RTCD
     C                   MOVEL     *BLANKS       W_Process
     C                   MOVEL     *BLANKS       W_NoRec
     C                   Z-ADD     *ZERO         Num_ExtRcs
     C                   ELSE
     C                   ADD       1             Num_ExtRcs
     C                   Z-ADD     Num_ExtRcs    DGLCD
     C                   ENDIF
     C                   ENDIF
      *
      ** CASE 3
      *
     C                   IF        W_CASE = 3 AND W_NoRec = *BLANKS
     C                   IF        *IN99 = '1'
     C                   IF        Num_ExtRcs <> 0
     C                   MOVEL     '*EODATA'     I#RTCD
     C                   MOVEL     *BLANKS       W_Process
     C                   Z-ADD     *ZERO         Num_ExtRcs
     C                   ELSE
      *
      ** If no data from previous read, use default location code
      *
     C                   MOVEL     'Y'           W_NoRec
     C                   MOVEL     LocCCY        k_CurCode
     C                   MOVEL     '***'         k_LocCode
     C     K_Holi        SETLL     @HOLPHK
     C     K_Holi        READE     @HOLPHK                                99
     C                   ENDIF
     C                   ELSE
     C                   ADD       1             Num_ExtRcs
     C                   Z-ADD     Num_ExtRcs    DGLCD
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF        W_CASE = 3 AND W_NoRec = 'Y'
     C                   IF        *IN99 = '1'
     C                   MOVEL     '*EODATA'     I#RTCD
     C                   MOVEL     *BLANKS       W_Process
     C                   MOVEL     *BLANKS       W_NoRec
     C                   Z-ADD     *ZERO         Num_ExtRcs
     C                   ELSE
     C                   ADD       1             Num_ExtRcs
     C                   Z-ADD     Num_ExtRcs    DGLCD
     C                   ENDIF
     C                   ENDIF
      *
      ** Set up output data
      *
     C                   EVAL      InData = SDHOL
     C                   RETURN
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * *INZSR --- INITIAL PROCESSING
      ********************************************************************
     C     *INZSR        BEGSR
      *
     C                   MOVEL     *BLANKS       W_Process         1
     C                   MOVEL     *BLANKS       W_NoRec           1
     C                   Z-ADD     *ZERO         W_CASE            1 0
     C                   CLEAR                   SDHOL
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
(c) Finastra International Limited 2014
