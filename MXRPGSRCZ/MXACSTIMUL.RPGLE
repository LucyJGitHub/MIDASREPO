     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2014')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MX Access Multiple Count Format for TI')         *
      *****************************************************************
      *                                                               *
      *  Midas - Meridian Export Module                               *
      *                                                               *
      *  MXACSTIMUL - Access Multiple Count Format for Trade Finance  *
      *                                                               *
      *  Function:  This module derives the multiple count format     *
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
 
 
      ** Multiple Count Format
     D MULT          E DS                  EXTNAME(MXMULTPD)
 
 
     D                 DS
     D Count5A                 1      5A
 
     D                 DS
     D Count3A                 1      3A
     D Count05P                1     03P 0
 
 
     C     *ENTRY        PLIST
     C/COPY MXCPYSRC,MXACSPRMI
 
 
      ** Use input link-to field
 
     C                   MOVEL     I#LFD1        Count5A
     C                   MOVEL     I#LFD1        Count3A
 
      ** Error if no count is supplied
 
     C     Count5A       IFEQ      *BLANK
     C                   MOVE      '00000'       Count5A
     C                   ENDIF
 
      ** Multiple Count
 
     C                   TESTN                   Count5A              9898
     C     *IN98         IFEQ      '1'
     C                   MOVEL     Count5A       MLMLTC
     C                   ELSE
     C                   Z-ADD     Count05P      MLMLTC
     C                   ENDIF
 
      ** Set up output data
 
     C                   EVAL      InData = MULT
 
 
      ** Return
 
     C                   RETURN
      *
     C/SPACE 5
      ********************************************************************
      * *INZSR --- INITIAL PROCESSING
      ********************************************************************
     C     *INZSR        BEGSR
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY MXCPYSRC,MXPSSR
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2014
