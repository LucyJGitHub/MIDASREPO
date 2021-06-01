     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*XBIA*  OVRDBF FILE(MXEXFFZZ) TOFILE(MXEXFFPD) SHARE(*NO)            *
/******  OVRDBF FILE(MXEXFFL1Y) TOFILE(MXEXFFL1) SHARE(*NO)           *          MD056612
/**** *  RPGBASEMOD                                                   *          MD056612
/*STD *  RPGSQLMOD                                                    *          MD056612
/*EXI *  CLOSQLCSR(*ENDMOD)                                           *          MD056612
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
      *  Last Amend No. MD056612           Date 12Sep20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CMX001  *CREATE    Data 01Jan00               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD056612 - Deliverable Data Split for MX group               *
      *  MD046248 - Finastra Rebranding                               *
      *  CMX001 - Meridian Export                                     *
      *                                                               *
      *****************************************************************

     FMXEXFFZZ  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(MXEXFFP0:MXEXFFZZF)
     F*MXEXFFL1Y IF A E           K DISK    INFSR(*PSSR)                                    MD056612

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
     D MXEXFF        E DS                  EXTNAME(MXEXFJW0)                                MD056612
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
     C*****MXEXFFK       CHAIN     MXEXFFP0                           99        *           MD056612
     C/EXEC SQL                                                                             MD056612
     C+ SELECT *                                                                            MD056612
     C+ into :MXEXFF                                                                        MD056612
     C+ from MXEXFJW0                                                                       MD056612
     C+ where WHFILE = :WHFILE and WHFSQN = :WHFSQN and WHFOBO = :WHFOBO                    MD056612
     C/END-EXEC                                                                             MD056612
     C******IN99         IFEQ      '1'                                                      MD056612
     C     SQLCODE       IFEQ      100                                                      MD056612
     C***********        WRITE     MXEXFFP0                                                 MD056612
     C/exec SQL                                                                             MD056612
     C+ insert into MXEXFBTD                                                                MD056612
     C+ (                                                                                   MD056612
     C+   WHFILE                                                                            MD056612
     C+  ,WHFSQN                                                                            MD056612
     C+  ,WHFTYP                                                                            MD056612
     C+  ,WHFLDI                                                                            MD056612
     C+  ,WHFOBO                                                                            MD056612
     C+  ,WHIBO                                                                             MD056612
     C+  ,WHFLDB                                                                            MD056612
     C+  ,WHFLDD                                                                            MD056612
     C+  ,WHFLDP                                                                            MD056612
     C+  ,WHFTXT                                                                            MD056612
     C+  ,WHFLDT                                                                            MD056612
     C+  ,WHINEX                                                                            MD056612
     C+  ,WHMFNM                                                                            MD056612
     C+  ,WHDS01                                                                            MD056612
     C+  ,WHDS02                                                                            MD056612
     C+  ,WHDS03                                                                            MD056612
     C+  ,WHDS04                                                                            MD056612
     C+  ,WHDS05                                                                            MD056612
     C+  ,WHDS06                                                                            MD056612
     C+  ,WHDS07                                                                            MD056612
     C+  ,WHDS08                                                                            MD056612
     C+  ,WHDS09                                                                            MD056612
     C+  ,WHDS10                                                                            MD056612
     C+  ,WHDS11                                                                            MD056612
     C+  ,WHLSEQ                                                                            MD056612
     C+  ,WHSREF                                                                            MD056612
     C+  ,WHMODE                                                                            MD056612
     C+ )                                                                                   MD056612
     C+ values                                                                              MD056612
     C+ (                                                                                   MD056612
     C+   :WHFILE                                                                           MD056612
     C+  ,:WHFSQN                                                                           MD056612
     C+  ,:WHFTYP                                                                           MD056612
     C+  ,:WHFLDI                                                                           MD056612
     C+  ,:WHFOBO                                                                           MD056612
     C+  ,:WHIBO                                                                            MD056612
     C+  ,:WHFLDB                                                                           MD056612
     C+  ,:WHFLDD                                                                           MD056612
     C+  ,:WHFLDP                                                                           MD056612
     C+  ,:WHFTXT                                                                           MD056612
     C+  ,:WHFLDT                                                                           MD056612
     C+  ,:WHINEX                                                                           MD056612
     C+  ,:WHMFNM                                                                           MD056612
     C+  ,:WHDS01                                                                           MD056612
     C+  ,:WHDS02                                                                           MD056612
     C+  ,:WHDS03                                                                           MD056612
     C+  ,:WHDS04                                                                           MD056612
     C+  ,:WHDS05                                                                           MD056612
     C+  ,:WHDS06                                                                           MD056612
     C+  ,:WHDS07                                                                           MD056612
     C+  ,:WHDS08                                                                           MD056612
     C+  ,:WHDS09                                                                           MD056612
     C+  ,:WHDS10                                                                           MD056612
     C+  ,:WHDS11                                                                           MD056612
     C+  ,:WHLSEQ                                                                           MD056612
     C+  ,:WHSREF                                                                           MD056612
     C+  ,'B'                                                                               MD056612
     C+ )                                                                                   MD056612
     C/end-exec                                                                             MD056612
     C/exec SQL                                                                             MD056612
     C+ insert into MXEXFXTD                                                                MD056612
     C+ (                                                                                   MD056612
     C+   WHFILE                                                                           MD0566122
     C+  ,WHFSQN                                                                           MD0566122
     C+  ,WHFTYP                                                                           MD0566122
     C+  ,WHFLDI                                                                           MD0566122
     C+  ,WHFOBO                                                                           MD0566122
     C+  ,WHIBO                                                                            MD0566122
     C+  ,WHFLDB                                                                           MD0566122
     C+  ,WHFLDD                                                                           MD0566122
     C+  ,WHFLDP                                                                           MD0566122
     C+  ,WHFTXT                                                                           MD0566122
     C+  ,WHFLDT                                                                           MD0566122
     C+  ,WHINEX                                                                           MD0566122
     C+  ,WHMFNM                                                                           MD0566122
     C+  ,WHDS01                                                                           MD0566122
     C+  ,WHDS02                                                                           MD0566122
     C+  ,WHDS03                                                                           MD0566122
     C+  ,WHDS04                                                                           MD0566122
     C+  ,WHDS05                                                                           MD0566122
     C+  ,WHDS06                                                                           MD0566122
     C+  ,WHDS07                                                                           MD0566122
     C+  ,WHDS08                                                                           MD0566122
     C+  ,WHDS09                                                                           MD0566122
     C+  ,WHDS10                                                                           MD0566122
     C+  ,WHDS11                                                                           MD0566122
     C+  ,WHLSEQ                                                                           MD0566122
     C+  ,WHSREF                                                                           MD0566122
     C+  ,WHMODE                                                                           MD0566122
     C+ )                                                                                   MD056612
     C+ values                                                                              MD056612
     C+ (                                                                                   MD056612
     C+   :WHFILE                                                                           MD056612
     C+  ,:WHFSQN                                                                           MD056612
     C+  ,:WHFTYP                                                                           MD056612
     C+  ,:WHFLDI                                                                           MD056612
     C+  ,:WHFOBO                                                                           MD056612
     C+  ,:WHIBO                                                                            MD056612
     C+  ,:WHFLDB                                                                           MD056612
     C+  ,:WHFLDD                                                                           MD056612
     C+  ,:WHFLDP                                                                           MD056612
     C+  ,:WHFTXT                                                                           MD056612
     C+  ,:WHFLDT                                                                           MD056612
     C+  ,:WHINEX                                                                           MD056612
     C+  ,:WHMFNM                                                                           MD056612
     C+  ,:WHDS01                                                                           MD056612
     C+  ,:WHDS02                                                                           MD056612
     C+  ,:WHDS03                                                                           MD056612
     C+  ,:WHDS04                                                                           MD056612
     C+  ,:WHDS05                                                                           MD056612
     C+  ,:WHDS06                                                                           MD056612
     C+  ,:WHDS07                                                                           MD056612
     C+  ,:WHDS08                                                                           MD056612
     C+  ,:WHDS09                                                                           MD056612
     C+  ,:WHDS10                                                                           MD056612
     C+  ,:WHDS11                                                                           MD056612
     C+  ,:WHLSEQ                                                                           MD056612
     C+  ,:WHSREF                                                                           MD056612
     C+  ,'B'                                                                               MD056612
     C+ )                                                                                   MD056612
     C/end-exec                                                                             MD056612
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
