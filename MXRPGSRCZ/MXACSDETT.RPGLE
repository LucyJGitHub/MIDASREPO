     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2009')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MX Access Transaction Type Decision Table')      *
      *****************************************************************
      *                                                               *
      *  Midas - Meridian Export Module                               *
      *                                                               *
      *  MXACSDETT - Access Transaction Type Decision Table           *
      *                                                               *
      *  Function: This module accesses transaction type decision     *
      *            table                                              *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2009            *
      *                                                               *
      *  Last Amend No. CER059             Date 19Jul10               *
      *  Prev Amend No. CER045  *CREATE    Date 20Jul09               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER045 - German Features - Reporting Bundesbank              *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Midas ER Transaction Type Decision Table
 
     FERDETTL0  IF   E           K DISK    INFSR(*PSSR)
 
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
 
     D KMMOD           S              2A
     D KTRTY           S              2A
     D KTRST           S              2A
     D KTRCL           S              4A
 
      * Midas ER Transaction Type Decision Table
 
     D ERDETT        E DS                  EXTNAME(ERDETTPD)
 
 
     C     *ENTRY        PLIST
     C/COPY MXCPYSRC,MXACSPRMI
 
 
     C     KERDETT       KLIST
     C                   KFLD                    KMMOD
     C                   KFLD                    KTRTY
     C                   KFLD                    KTRST
     C                   KFLD                    KTRCL
 
      * Use input link-to field
 
     C                   EVAL      KMMOD = 'FX'
     C                   MOVEL     I#LFD1        KTRTY
     C                   MOVEL     I#LFD2        KTRST
     C                   MOVEL     I#LFD3        KTRCL
     C
      * If key is blank
      * pass back a blank format
 
     C                   IF        KTRTY = *BLANK
     C                             OR KTRTY = '00'
     C                             OR KTRST = *BLANK
     C                             OR KTRST = '00'
     C                   CLEAR                   ERDETT
     C                   ELSE
 
      * Access the transaction type decision table details
 
     C     KERDETT       CHAIN     ERDETTL0
 
      * If the transaction type decision table was not found
      * pass back a blank format
 
     C                   IF        NOT %FOUND
     C                   CLEAR                   ERDETT
     C                   ENDIF
 
     C                   ENDIF
 
      * Set up output data
 
     C                   EVAL      InData = ERDETT
 
      * Return
 
     C                   RETURN
      *****************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY MXCPYSRC,MXPSSR
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2009
