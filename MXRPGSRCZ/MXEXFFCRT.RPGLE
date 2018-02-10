     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*XBIA*  OVRDBF FILE(MXEXFFZZ) TOFILE(MXEXFFPD) SHARE(*NO)            *
/*XBIB*  OVRDBF FILE(MXEXFFL1Y) TOFILE(MXEXFFL1) SHARE(*NO)           *
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MX Export Format Fields Creation')
      *****************************************************************
      *                                                               *
      *  Midas - Meridian Export Module                               *
      *                                                               *
      *  MXEXFFCRT - Export Format Fields Creation                    *
      *                                                               *
      *  Function:  This module creates export format fields          *
      *             for a specified format                            *
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
 
     FMXEXFFZZ  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(MXEXFFP0:MXEXFFZZF)
     FMXEXFFL1Y IF A E           K DISK    INFSR(*PSSR)
 
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
 
 
      *
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           30
      * INPUTS
     C                   PARM                    I#FILE           10
     C                   PARM                    I#FSQN            1
 
 
      * Read the export format fields file
 
     C     MXEXFFPK      KLIST
     C                   KFLD                    I#FILE
     C     MXEXFFK       KLIST
     C                   KFLD                    WHFILE
     C                   KFLD                    WHFSQN
     C                   KFLD                    WHFOBO
 
     C     MXEXFFPK      SETLL     MXEXFFZZF
     C     MXEXFFPK      READE     MXEXFFZZF                              99    *
 
      * Read until EOF
 
     C     *IN99         DOWEQ     '0'
 
      * Create the Meridian Field Name
 
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
 
      * If the field does not exist already
      * Write it to the export format fields file
 
     C                   MOVE      I#FSQN        WHFSQN
     C     MXEXFFK       CHAIN     MXEXFFP0                           99        *
     C     *IN99         IFEQ      '1'
     C                   WRITE     MXEXFFP0
     C                   ENDIF
 
     C     MXEXFFPK      READE     MXEXFFZZF                              99    *
     C                   ENDDO
 
      * Return
 
     C                   SETON                                        LR
     C                   RETURN
      *
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY MXCPYSRC,MXPSSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2001
