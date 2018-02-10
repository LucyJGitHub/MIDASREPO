     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2014')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MX Access Country for Country Calendar')         *
      *****************************************************************
      *                                                               *
      *  Midas - Meridian Export Module                               *
      *                                                               *
      *  MXACSCTR2 - Access Country File for Country Calendar         *
      *                                                               *
      *  Function:  This module accesses countries.                   *
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
 
     FSDCTRYL6  IF   E           K DISK    INFSR(*PSSR)
 
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
 
      * Country Details
     D TICTRY        E DS                  EXTNAME(SDCTRYPD)
 
 
     C     *ENTRY        PLIST
     C/COPY MXCPYSRC,MXACSPRMI
 
 
      ** Use input link-to field
 
     C                   MOVEL     I#LFD1        INCCY             3
 
      ** If no associate currency, then pass back a blank format
 
     C     INCCY         IFEQ      *BLANK
     C                   CLEAR                   TICTRY
     C                   ELSE
 
      ** Access the country file
 
     C     INCCY         IFNE      PrvCCY
     C                   MOVEL     INCCY         PrvCCY            3
     C                   Z-ADD     *ZERO         Num_ExtRcs        5 0
     C     INCCY         SETLL     SDCTRYD0
     C                   ENDIF
 
     C     INCCY         READE     SDCTRYD0                               99
     C     *IN99         IFEQ      '1'
     C                   MOVEL     '*EODATA'     I#RTCD
     C                   MOVEL     *BLANKS       PrvCCY
     C                   Z-ADD     *ZERO         Num_ExtRcs
     C                   ELSE
     C                   ADD       1             Num_ExtRcs
     C                   Z-ADD     Num_ExtRcs    A4EACC
     C                   ENDIF
     C                   ENDIF
 
      ** Set up output data
 
     C                   EVAL      InData = TICTRY
 
      ** Return
 
     C                   RETURN
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * *INZSR --- INITIAL PROCESSING
      ********************************************************************
     C     *INZSR        BEGSR
 
     C                   MOVEL     *BLANKS       PrvCCY
 
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
