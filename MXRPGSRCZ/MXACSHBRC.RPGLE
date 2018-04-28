     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2014')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MX Access Branch for Branch Calendar')           *
      *****************************************************************
      *                                                               *
      *  Midas - Meridian Export Module                               *
      *                                                               *
      *  MXACSHBRC - Access Branch for Branch Calendar                *
      *                                                               *
      *  Function:  This module accesses branch file                  *
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
 
      * Branch details data structure
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
 
     C     *ENTRY        PLIST
     C/COPY MXCPYSRC,MXACSPRMI
 
      *****************************************************************
      * I. Where holiday location code is not defaulted to '***'      *
      *****************************************************************
      * Case 1: Branch location code is not blank and equal to        *
      *         holiday location code                                 *
      * Case 2: Branch location code is blanks and system location    *
      *         code is equal to holiday location code                *
      *****************************************************************
      * II.Where holiday location code is defaulted to '***'          *
      *****************************************************************
      * Case 3: Branch location code and system location codes are    *
      *         both blanks                                           *
      * Case 4: Branch location code is not blank and not equal to    *
      *         holiday location code, and local currency is not      *
      *         equal to holiday currency                             *
      * Case 5: Branch location code is blank and system location     *
      *         code is not blank and not equal to holiday location   *
      *         code, and local currency is not equal to holiday      *
      *         currency                                              *
      *****************************************************************
      *
      ** Use input link-to field
      *
     C                   MOVEL     I#LFD1        HolLoc            3
     C                   MOVEL     I#LFD2        HolCCY            3
     C                   MOVEL     I#LFD3        HolYear           4
     C                   MOVEL     I#LFD4        SysLoc            3
     C                   MOVEL     I#LFD5        LocCCY            3
      *
     C     K_Holi        KLIST
     C                   KFLD                    k_CurCode         3
     C                   KFLD                    k_LocCode         3
     C                   KFLD                    k_Year            4
      *
     C                   IF        W_Process = *BLANKS
     C                   Z-ADD     *ZERO         Num_ExtRcs        5 0
     C                   MOVEL     'Y'           W_Process
     C     1             SETLL     SDBRCHD0
     C                   ENDIF
      *
      ** Access branch file
      *
     C     READNXT       TAG
     C                   READ      SDBRCHD0                               99
     C                   MOVE      *BLANKS       W_Exprt           1
      *
     C     *IN99         IFEQ      '1'
     C                   MOVEL     '*EODATA'     I#RTCD
     C                   MOVEL     *BLANKS       W_Process
     C                   Z-ADD     *ZERO         Num_ExtRcs
     C                   GOTO      SREND
     C                   ENDIF
      *
     C                   SELECT
     C                   WHEN      HolLoc <> '***'
      ** Case 1
     C                   IF        A8LCCD <> *BLANKS AND
     C                             A8LCCD = HolLoc
     C                   MOVEL     'Y'           W_Exprt
     C                   ADD       1             Num_ExtRcs
     C                   Z-ADD     Num_ExtRcs    A8LCD
     C                   ENDIF
      ** Case 2
     C                   IF        A8LCCD = *BLANKS AND
     C                             SysLoc = HolLoc
     C                   MOVEL     'Y'           W_Exprt
     C                   ADD       1             Num_ExtRcs
     C                   Z-ADD     Num_ExtRcs    A8LCD
     C                   ENDIF
      *
     C                   IF        W_Exprt <> 'Y'
     C                   GOTO      READNXT
     C                   ENDIF
      *
     C                   WHEN      HolLoc =  '***'
      ** Case 3
     C                   IF        A8LCCD  = *BLANKS AND
     C                             SysLoc  = *BLANKS
     C                   MOVEL     'Y'           W_Exprt
     C                   ADD       1             Num_ExtRcs
     C                   Z-ADD     Num_ExtRcs    A8LCD
     C                   ENDIF
      ** Case 4
     C                   IF        A8LCCD <> *BLANKS
     C                   MOVEL     LocCCY        k_CurCode
     C                   MOVEL     A8LCCD        k_LocCode
     C                   MOVEL     HolYear       k_Year
     C     K_Holi        CHAIN     SDHOLL1                            80
      *
     C     *IN80         IFEQ      '1'
     C                   MOVEL     'Y'           W_Exprt
     C                   ADD       1             Num_ExtRcs
     C                   Z-ADD     Num_ExtRcs    A8LCD
     C                   ENDIF
     C                   ENDIF
      ** Case 5
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
     C                   Z-ADD     Num_ExtRcs    A8LCD
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF        W_Exprt <> 'Y'
     C                   GOTO      READNXT
     C                   ENDIF
      *
     C                   ENDSL
      *
      ** Set up output data
      *
     C     SREND         TAG
     C                   EVAL      InData = SDBRCH
     C                   RETURN
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * *INZSR --- INITIAL PROCESSING
      ********************************************************************
     C     *INZSR        BEGSR
      *
     C                   MOVEL     *BLANKS       W_Process         1
     C                   CLEAR                   SDBRCH
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
