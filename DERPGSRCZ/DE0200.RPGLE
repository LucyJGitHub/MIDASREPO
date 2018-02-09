     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas DE Export Fiduciary Accrual A/c Keys Extract')
      *****************************************************************
      *                                                               *
      *  Midas - Data Export module                                   *
      *                                                               *
      *  DE0200 - Export Fiduciary Accrual A/c Keys Extract           *
      *                                                               *
      *  Function:  This module is called by DEC0200 and creates and  *
      *             updates records on the Fiduciary Account Keys     *
      *             file.                                             *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD027             Date 09Dec05               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CDE002  *CREATE    Date 05Dec00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDE002 - Data Export - CCRM Revenue Analysis.                *
      *                                                               *
      *****************************************************************
      ** Dealing Account Keys File
     FDKEYSDP   IF   E           K DISK
 
      ** Fiduciary Accrual Account Keys by Deal Number and Date
     FDEFAAKL0  UF   E           K DISK
 
      ** Fiduciary Accrual Account Keys Extract File
     FDEFAAKPD  O    E           K DISK    PREFIX(NW_)
     F                                     RENAME(DEFAAKP0:DEFAAKP1)
 
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
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for BANK details
 
     D**  Long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
     D**  Short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
     D**  Data Strucutre for Account Key
     D W#KEY           DS            10
     DW#KEY3                   3      3
     DW#KEY10                 10     10
 
     C                   READ      DKEYSDP                                89
 
     C                   DOW       *IN89 = *Off
      *
      ** Check if reversal indicator is on. If it is delete all records from DEFAAKL0
      ** which reLate to the deal.
     C                   IF        REVI = 1
     C                   MOVE      DLNO          K#DLNO            6 0
 
     C     K#DLNO        SETLL     DEFAAKL0                               88
     C     K#DLNO        READE     DEFAAKL0                               88
 
     C                   DOW       *IN88 = *Off
     C                   DELETE    DEFAAKP0
     C     K#DLNO        READE     DEFAAKL0                               88
     C                   ENDDO
     C
     C                   ELSE
      *
      ** If key is for a commission Accrual on a fiduciary deal write a record to
      ** DEFAAKPD
 
     C                   MOVE      AKEY          W#KEY
 
     C                   IF        W#KEY3 = 'A' and W#KEY10 = 'C'
     C                   EVAL      NW_FADLNO = DLNO
     C                   EVAL      NW_FAACDT = BJRDNB
     C                   EVAL      NW_FAACAM = EAMT
     C                   EVAL      NW_FACCY = ECCY
     C                   WRITE     DEFAAKP1
     C                   ENDIF
 
     C                   ENDIF
     C                   READ      DKEYSDP                                89
     C                   ENDDO
 
     C                   EVAL      *INLR = *On
     C                   RETURN
 
     C********************************************************************
      /SPACE 5
     C********************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           30
 
      **  Access Bank Details
 
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C                   ENDSR
      **************************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY DECPYSRC,DEPSSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2001
