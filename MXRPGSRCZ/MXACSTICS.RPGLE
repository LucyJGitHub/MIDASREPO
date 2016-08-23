     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2014')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MX Access Trade Innovation Customer Details')    *
      *****************************************************************
      *                                                               *
      *  Midas - Meridian Export Module                               *
      *                                                               *
      *  MXACSTICS - Access TI Customer Details                       *
      *                                                               *
      *  Function:  This module accesses TI Customer Details          *
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
 
     FSDTICSL1  IF   E           K DISK    INFSR(*PSSR)
 
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
     D SDTICS        E DS                  EXTNAME(SDTICSPD)
 
     C     *ENTRY        PLIST
     C/COPY MXCPYSRC,MXACSPRMI
 
      * Use input link-to field
 
     C                   MOVEL     I#LFD1        TCCUST
 
      * If no customer number is supplied
      * pass back a blank format
 
     C                   IF        TCCUST = *BLANKS
     C                   CLEAR                   SDTICS
     C                   ELSE
 
      * Access the TI Customer
 
     C     TCCUST        CHAIN     @TICSL1                            99
 
      * Error if the TI Customer was not found
 
     C                   IF        NOT %FOUND
     C                   CLEAR                   SDTICS
     C                   ENDIF
 
     C                   ENDIF
 
      * Set up output data
 
     C                   EVAL      InData = SDTICS
 
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
(c) Misys International Banking Systems Ltd. 2014
