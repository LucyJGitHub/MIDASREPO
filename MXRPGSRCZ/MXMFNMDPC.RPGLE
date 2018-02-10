     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*XBIF*: OVRDBF FILE(MXEXFFL1X) TOFILE(MXEXFFL1) SHARE(*NO)         : *
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MX Meridian Field Name Duplicate Check')
      *****************************************************************
      *                                                               *
      *  Midas - Meridian Export Module                               *
      *                                                               *
      *  MXMFNMDPC - Meridian Field Name Duplicate Check              *
      *                                                               *
      *  Function:  This module checks Meridian field names within    *
      *             a format for duplicates.                          *
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
 
     FMXEXFFL1X UF   E           K DISK    INFSR(*PSSR)
 
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
 
 
 
     D MFNM            S             29    DIM(1000)
 
 
 
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           30
      * INPUTS
     C                   PARM                    I#FILE           10
     C                   PARM                    I#FSQN            1
 
 
 
      * Read the export format fields file
 
     C     MXEXFFK       KLIST
     C                   KFLD                    I#FILE
     C                   KFLD                    I#FSQN
 
     C     MXEXFFK       SETLL     MXEXFFP0
     C     MXEXFFK       READE     MXEXFFP0                               99    *
 
      * Read until EOF
 
     C     *IN99         DOWEQ     '0'
 
      * Meridian Field Name Duplicate Check
 
     C                   EXSR      MFNM_DPC
 
      * Update Meridian Field Name
 
     C                   EXCEPT
 
     C     MXEXFFK       READE     MXEXFFP0                               99    *
     C                   ENDDO
 
      * Return
 
     C                   SETON                                        LR
     C                   RETURN
      *
     C/SPACE 5
      ********************************************************************
      * Meridian Field Name Duplicate Check
      ********************************************************************
     C     MFNM_DPC      BEGSR
 
     C                   Z-ADD     1             @I                4 0
     C     WHMFNM        LOOKUP    MFNM(@I)                               99    *
 
      * If already present
      * turn name into non-duplicate
 
     C     *IN99         IFEQ      '1'
     C                   ADD       1             @DUP              4 0
     C                   MOVE      @DUP          WHMFNM
     C                   MOVEL     *BLANK        WHFTXT
     C                   MOVEL     WHMFNM        WHFTXT
     C                   EXSR      CON_MFNM
     C                   ENDIF
 
      * Add to array
 
     C                   Z-ADD     1             @I
     C     *BLANK        LOOKUP    MFNM(@I)                               99
     C     *IN99         IFEQ      '0'
     C                   EVAL      I#ERMS = 'ARRAY FULL IN MXMFNMDPC'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   MOVEL     WHMFNM        MFNM(@I)
 
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * Meridian Field Name Construction
      ********************************************************************
     C     CON_MFNM      BEGSR
 
     C                   CALLB     'MXMFNMCON'
     C                   PARM      *BLANK        W#RTCD            7
     C                   PARM      *BLANK        W#ERMS           30
      * INPUTS
     C                   PARM      'C'           I#CV              1
     C                   PARM                    WHFTXT
     C                   PARM      *BLANK        I#MFNM           29
      * OUTPUTS
     C                   PARM                    WHMFNM
 
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO MXMFNMCON'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY MXCPYSRC,MXPSSR
      *****************************************************************
     OMXEXFFP0  E
     O                       WHMFNM
**  CPY@
(c) Finastra International Limited 2001
