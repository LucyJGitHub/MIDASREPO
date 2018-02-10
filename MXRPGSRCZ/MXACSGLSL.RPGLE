     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MX Access General Ledger Statement Lines')
      *****************************************************************
      *                                                               *
      *  Midas - Meridian Export Module                               *
      *                                                               *
      *  MXACSGLSL - Access General Ledger Statement Lines            *
      *                                                               *
      *  Function:  This module accesses general ledger statement     *
      *             lines from MXGLSLPD.                              *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CMX001  *CREATE    Data 01Jan00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CMX003 - Meridian Export Enhancements - Phase 2              *
      *                                                               *
      *****************************************************************
 
     FMXGLSLPD  IF   E           K DISK    INFSR(*PSSR)
 
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
 
 
      * General Ledger Statement Lines
     D GLSLX         E DS                  EXTNAME(MXGLSLPD)
 
     D A_ACOD          S             10A                                                      CGL029
     D P_ACOD          S             10S 0                                                    CGL029
 
     C     *ENTRY        PLIST
     C/COPY MXCPYSRC,MXACSPRMI
 
 
      * Use input link-to fields
 
     C                   MOVEL     I#LFD1        A_BRCA            3
     C                   MOVEL     I#LFD2        A_CNUM            6
     C                   MOVEL     I#LFD3        A_CCY             3
     C**********         MOVEL     I#LFD4        A_ACOD            4                          CGL029
     C                   MOVEL     I#LFD4        A_ACOD                                       CGL029
     C                   MOVEL     I#LFD5        A_ACSQ            2
     C                   MOVEL     I#LFD6        A_SEQN            5
 
      * Error if no branch is supplied
 
     C     A_BRCA        IFEQ      *BLANK
     C                   EVAL      I#ERMS = 'BLANK BRANCH'
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * Error if no customer number is supplied
 
     C     A_CNUM        IFEQ      *BLANK
     C     A_CNUM        OREQ      '000000'
     C                   EVAL      I#ERMS = 'BLANK CUSTOMER'
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * Error if no currency is supplied
 
     C     A_CCY         IFEQ      *BLANK
     C                   EVAL      I#ERMS = 'BLANK CURRENCY'
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * Error if no account code is supplied
 
     C     A_ACOD        IFEQ      *BLANK
     C*****A_ACOD        OREQ      '0000'                                                     CGL029
     C     A_ACOD        OREQ      '0000000000'                                               CGL029
     C                   EVAL      I#ERMS = 'BLANK ACCOUNT CODE'
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * Error if no account sequence is supplied
 
     C     A_ACSQ        IFEQ      *BLANK
     C     A_ACSQ        OREQ      '00'
     C                   EVAL      I#ERMS = 'BLANK ACCOUNT SEQUENCE'
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * Error if no sequence is supplied
 
     C     A_SEQN        IFEQ      *BLANK
     C                   EVAL      I#ERMS = 'BLANK SEQUENCE'
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * If a new account ID, re-position the file pointer
 
     C                   MOVEL     A_BRCA        BRCA
     C                   MOVEL     A_CNUM        CNUM
     C                   MOVEL     A_CCY         CCY
     C                   MOVEL     A_ACOD        ACOD
     C                   MOVEL     A_ACSQ        ACSQ
     C                   MOVE      A_SEQN        Seqn_Num
     C     BRCA          IFNE      P_BRCA
     C     CNUM          ORNE      P_CNUM
     C     CCY           ORNE      P_CCY
     C     ACOD          ORNE      P_ACOD
     C     ACSQ          ORNE      P_ACSQ
     C     Seqn_Num      ORNE      P_SEQN
     C                   MOVEL     BRCA          P_BRCA
     C**********         Z-ADD     CNUM          P_CNUM                                       CSD027
     C                   EVAL      P_CNUM = CNUM                                              CSD027
     C                   MOVEL     CCY           P_CCY
     C                   Z-ADD     ACOD          P_ACOD
     C                   Z-ADD     ACSQ          P_ACSQ
     C                   Z-ADD     Seqn_Num      P_SEQN
     C                   CLEAR                   GLSLX
     C                   Z-ADD     *ZERO         Num_ExtRcs        5 0
     C     GLSLKYF       SETLL     MXGLSLP0
     C                   ENDIF
 
      * Get a posting record for the account
 
     C     GLSLKYP       READE     MXGLSLP0                               99     *
 
      * No more posting records
 
     C     *IN99         IFEQ      '1'
     C     Num_ExtRcs    OREQ      200
     C                   MOVEL     '*EODATA'     I#RTCD
     C                   ELSE
     C                   ADD       1             Num_ExtRcs
     C                   Z-ADD     Num_ExtRcs    CNTM
     C                   ENDIF
 
 
      * Set up output data
 
     C                   EVAL      InData = GLSLX
 
 
      * Return
 
     C                   RETURN
      *
     C/SPACE 5
      ********************************************************************
      * *INZSR --- INITIAL PROCESSING
      ********************************************************************
     C     *INZSR        BEGSR
 
     C                   MOVEL     *BLANK        P_BRCA            3
     C**********         Z-ADD     *ZERO         P_CNUM            6 0                        CSD027
     C                   MOVE      *BLANKS       P_CNUM            6                          CSD027
     C                   MOVEL     *BLANK        P_CCY             3
     C**********         Z-ADD     *ZERO         P_ACOD            4 0                        CGL029
     C                   Z-ADD     *ZERO         P_ACOD                                       CGL029
     C                   Z-ADD     *ZERO         P_ACSQ            2 0
     C                   Z-ADD     *ZERO         P_SEQN            5 0
 
      * Key lists
 
     C     GLSLKYF       KLIST
     C                   KFLD                    P_BRCA
     C                   KFLD                    P_CNUM
     C                   KFLD                    P_CCY
     C                   KFLD                    P_ACOD
     C                   KFLD                    P_ACSQ
     C                   KFLD                    Seqn_Num          5 0
     C     GLSLKYP       KLIST
     C                   KFLD                    P_BRCA
     C                   KFLD                    P_CNUM
     C                   KFLD                    P_CCY
     C                   KFLD                    P_ACOD
     C                   KFLD                    P_ACSQ
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY MXCPYSRC,MXPSSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2001
