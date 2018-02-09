     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RE Group A/c Hierarchy Header Field Conv')
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  RE100313 - Group A/c Hierarchy Header Field Conversion       *
      *                                                               *
      *  Function:  This program converts certain fields in the       *
      *             'front end' group a/c hierarchy header record     *
      *             from file to screen format.                       *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CRE008  *CREATE    Date 06Mar02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE008 - Cash Management                                     *
      *                                                               *
      *****************************************************************
 
      *****************************************************************
      * Standard D Specifications
     D/COPY ZACPYSRC,RECMSTDD
      * Program Status Data Structure
     D/COPY ZACPYSRC,PSDS
      *****************************************************************
 
 
      /SPACE 5
 
      * Edit top on balance sheet
 
     C     I_TOPB        IFEQ      'Y'
     C                   EVAL      DDTOPB = 'YES'
     C                   ELSE
     C                   EVAL      DDTOPB = 'NO '
     C                   ENDIF
 
      * Edit Link Effective At Last Capitalization Date
 
     C     I_LELC        IFEQ      'Y'
     C                   EVAL      DDLELC = 'YES'
     C                   ELSE
     C                   EVAL      DDLELC = 'NO '
     C                   ENDIF
 
      * Edit Unlink Effective At Last Capitalization Date
 
     C     I_UELC        IFEQ      'Y'
     C                   EVAL      DDUELC = 'YES'
     C                   ELSE
     C                   EVAL      DDUELC = 'NO '
     C                   ENDIF
 
 
     C                   RETURN
 
      /SPACE 5
      ********************************************************************
      * *INZSR --- INITIAL PROCESSING
      ********************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      * Return code
      * Error Message
     C                   PARM                    X_RTCD
     C                   PARM                    X_ERMS
      * INPUTS
 
      * Top on Balance Sheet
      * Link Effective At Last Capitalization Date
      * Unlink Effective At Last Capitalization Date
     C                   PARM                    I_TOPB            1
     C                   PARM                    I_LELC            1
     C                   PARM                    I_UELC            1
 
      * OUTPUTS
 
      * Top on Balance Sheet
      * Link Effective At Last Capitalization Date
      * Unlink Effective At Last Capitalization Date
     C                   PARM                    DDTOPB            3
     C                   PARM                    DDLELC            3
     C                   PARM                    DDUELC            3
 
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY ZACPYSRC,RECMPSSR
      *****************************************************************
