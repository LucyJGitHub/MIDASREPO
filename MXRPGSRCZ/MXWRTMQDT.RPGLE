     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MX Write MQ Series Data')
      *****************************************************************
      *                                                               *
      *  Midas - Meridian Export Module                               *
      *                                                               *
      *  MXWRTMQDT - Write MQ Series data                             *
      *                                                               *
      *  Function:  This module is called by the data export functions*
      *             to write data to the appropriate MQ series data   *
      *             file.                                             *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *  Prev Amend No. CMX001  *CREATE    Data 01Jan00               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CMX001 - Meridian Export                                     *
      *                                                               *
      *****************************************************************
 
     FMXMQDLPD  O  A E             DISK    INFSR(*PSSR)
     F                                     PREFIX(L_)
      * MQ Series Data - LONG record
     FMXMQDMPD  O  A E             DISK    INFSR(*PSSR)
     F                                     PREFIX(M_)
      * MQ Series Data - MEDIUM record
     FMXMQDSPD  O  A E             DISK    INFSR(*PSSR)
     F                                     PREFIX(S_)
      * MQ Series Data - SHORT record
     FMXMQDVPD  O  A E             DISK    INFSR(*PSSR)
     F                                     PREFIX(V_)
      * MQ Series Data - VERY SHORT record
     FMXMQDXPD  O  A E             DISK    INFSR(*PSSR)
     F                                     PREFIX(X_)
      * MQ Series Data - EXTREMELY SHORT record
 
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
 
 
      * M Q   S E R I E S   D A T A
     D/COPY MXCPYSRC,MXMQDAD
 
 
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           30
      * INPUTS
      * Mode
     C                   PARM                    I#MODE            1
      * MQ Series File Type
     C                   PARM                    CFFILT            1
      * Optimize File Type
     C                   PARM                    CFOPTF            1
      * MQ Series Data - LONG       (4,000 bytes)
     C                   PARM                    MXMQDL
 
      * Determine File Type
 
     C                   EXSR      DET_FILT
 
      * OUTPUT DATA
 
      * extremely short
     C     ##FILT        IFEQ      'X'
     C                   EVAL      MXMQDX = MXMQDL
     C                   WRITE     MXMQDXP0
     C                   ELSE
      * very short
     C     ##FILT        IFEQ      'V'
     C                   EVAL      MXMQDV = MXMQDL
     C                   WRITE     MXMQDVP0
     C                   ELSE
      * short
     C     ##FILT        IFEQ      'S'
     C                   EVAL      MXMQDS = MXMQDL
     C                   WRITE     MXMQDSP0
     C                   ELSE
      * medium
     C     ##FILT        IFEQ      'M'
     C                   EVAL      MXMQDM = MXMQDL
     C                   WRITE     MXMQDMP0
     C                   ELSE
      * long
     C                   WRITE     MXMQDLP0
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
      * RETURN
     C                   RETURN
 
      /SPACE 5
      ********************************************************************
      * Determine File Type
      ********************************************************************
     C     DET_FILT      BEGSR
 
      * If file type to be optimized
 
     C     CFOPTF        IFEQ      'Y'
 
      * Set file type according to end position of data
 
     C     L_MQEPOS      IFLE      100
     C                   MOVE      'X'           ##FILT            1
     C                   ELSE
     C     L_MQEPOS      IFLE      500
     C                   MOVE      'V'           ##FILT
     C                   ELSE
     C     L_MQEPOS      IFLE      1000
     C                   MOVE      'S'           ##FILT
     C                   ELSE
     C     L_MQEPOS      IFLE      2000
     C                   MOVE      'M'           ##FILT
     C                   ELSE
     C                   MOVE      'L'           ##FILT
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   ELSE
 
      * Else use defined file type
 
     C                   MOVE      CFFILT        ##FILT
 
      * Override file type if end position of data is too large
 
     C     L_MQEPOS      IFGT      2000
     C                   MOVE      'L'           ##FILT
     C                   ELSE
     C     L_MQEPOS      IFGT      1000
     C     ##FILT        IFEQ      'S'
     C     ##FILT        OREQ      'V'
     C     ##FILT        OREQ      'X'
     C                   MOVE      'M'           ##FILT
     C                   ENDIF
     C                   ELSE
     C     L_MQEPOS      IFGT      500
     C     ##FILT        IFEQ      'V'
     C     ##FILT        OREQ      'X'
     C                   MOVE      'S'           ##FILT
     C                   ENDIF
     C                   ELSE
     C     L_MQEPOS      IFGT      100
     C     ##FILT        IFEQ      'X'
     C                   MOVE      'V'           ##FILT
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY MXCPYSRC,MXPSSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2001
