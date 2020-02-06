     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2014')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MX Access Correspondent Details')                *
      *****************************************************************
      *                                                               *
      *  Midas - Meridian Export Module                               *
      *                                                               *
      *  MXACSCORR - Access Correspondent Details                     *
      *                                                               *
      *  Function:  This module accesses Correspondent Details        *
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
 
     FCGCORRL4  IF   E           K DISK    INFSR(*PSSR)
 
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
 
      * Additional Correspondent Details
     D CGCORR        E DS                  EXTNAME(CGCORRPD)
 
     C     *ENTRY        PLIST
     C/COPY MXCPYSRC,MXACSPRMI
 
      * Use input link-to field
 
     C                   MOVEL     I#LFD1        CDCUST
 
      * If no customer number is supplied
      * pass back a blank format
 
     C                   IF        CDCUST = *BLANKS
     C                   CLEAR                   CGCORR
     C                   ELSE
 
      * Access the correspondent
 
     C     CDCUST        CHAIN     @CORRL4                            99
 
      * Error if the correspondent was not found
 
     C                   IF        NOT %FOUND
     C                   CLEAR                   CGCORR
     C                   ENDIF
 
     C                   ENDIF
 
      * Set up output data
 
     C                   EVAL      InData = CGCORR
 
      * Return
 
     C                   RETURN
      *
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY MXCPYSRC,MXPSSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2014
