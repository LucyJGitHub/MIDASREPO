     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MX Access Balances - DEALING Module')
      *****************************************************************
      *                                                               *
      *  Midas - Meridian Export Module                               *
      *                                                               *
      *  MXACSBLDL - Access Balances - DEALING module                 *
      *                                                               *
      *  Function:  This module accesses deal balances from MXBLDLPD  *
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
 
     FMXBLDLL1  IF   E           K DISK    INFSR(*PSSR)
 
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
 
 
      * Balances - Dealing Module
     D BLDL          E DS                  EXTNAME(MXBLDLPD)
 
 
     C     *ENTRY        PLIST
     C/COPY MXCPYSRC,MXACSPRMI
 
 
      * Use input link-to fields
 
     C                   MOVEL     I#LFD1        A_DLNO            6
 
      * Error if no deal number is supplied
 
     C     A_DLNO        IFEQ      *BLANK
     C     A_DLNO        OREQ      '000000'
     C                   EVAL      I#ERMS = 'INVALID DEAL NUMBER: '
     C                             + A_DLNO
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * If a new deal number, re-position the file pointer
 
     C                   MOVEL     A_DLNO        DLNO              6 0
     C     DLNO          IFNE      P_DLNO
     C                   Z-ADD     DLNO          P_DLNO
     C                   CLEAR                   BLDL
     C                   Z-ADD     *ZERO         Num_BalRcs        5 0
     C     DEALKY        SETLL     MXBLDLP0
     C                   ENDIF
 
      * Get a balance record for the deal
 
     C     DEALKY        READE     MXBLDLP0                               99     *
 
      * No more balance records
 
     C     *IN99         IFEQ      '1'
     C                   MOVEL     '*EODATA'     I#RTCD
     C                   ELSE
     C                   ADD       1             Num_BalRcs
     C                   Z-ADD     Num_BalRcs    CNTM
     C                   ENDIF
 
 
      * Set up output data
 
     C                   EVAL      InData = BLDL
 
 
      * Return
 
     C                   RETURN
      *
     C/SPACE 5
      ********************************************************************
      * *INZSR --- INITIAL PROCESSING
      ********************************************************************
     C     *INZSR        BEGSR
 
     C                   Z-ADD     *ZERO         P_DLNO            6 0
 
      * Key list
 
     C     DEALKY        KLIST
     C                   KFLD                    P_DLNO
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY MXCPYSRC,MXPSSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2001
