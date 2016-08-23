     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2014')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MX Access Nostro Code')                          *
      *****************************************************************
      *                                                               *
      *  Midas - Meridian Export Module                               *
      *                                                               *
      *  MXACSNOST - Access SD Nostro Code                            *
      *                                                               *
      *  Function:  This module accesses SD Nostro Code               *
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
 
     FSDNOSTL5  IF   E           K DISK    INFSR(*PSSR)
 
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
 
     D KCYCD           S              3A
     D KBSRC           S              2A
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      * Base Rate Code Details
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)
 
     C     *ENTRY        PLIST
     C/COPY MXCPYSRC,MXACSPRMI
 
      * Use input link-to field
 
     C                   MOVEL     I#LFD1        KNOSN            10
 
      * If key is blank
      * pass back a blank format
 
     C                   IF        KNOSN = *Blanks
     C                   CLEAR                   SDNOST
     C                   ELSE
 
      * Access the Base Rate Code
 
     C     KNOSN         CHAIN     @NOSTBK                            99
 
      * Error if the Base Rate Code was not found
 
     C                   IF        NOT %FOUND
     C                   CLEAR                   SDNOST
     C                   ENDIF
 
     C                   ENDIF
 
      * Set up output data
 
     C                   EVAL      InData = SDNOST
 
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
