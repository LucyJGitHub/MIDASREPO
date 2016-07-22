     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2009')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MX Access Additional Customers')                 *
      *****************************************************************
      *                                                               *
      *  Midas - Meridian Export Module                               *
      *                                                               *
      *  MXACSACUS - Access Additional Customers                      *
      *                                                               *
      *  Function:  This module accesses additional customers         *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2009            *
      *                                                               *
      *  Last Amend No. CER071             Date 01Aug16               *
      *  Prev Amend No. MD031229           Date 24Nov14               *
      *                 CER070             Date 19Aug14               *
      *                 CLE134             Date 01Aug12               *
      *                 CER059             Date 19Jul10               *
      *                 CER045   *CREATE   Date 20Jul09               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER071 - BAIS - Legal Form field (Recompile)                 *
      *  MD031229 - Branch export fails when no additional customer   *
      *             details were defined in the system                *
      *  CER070 - BuBa Reporting / BAIS V.1.16.0 (Recompile)          *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER045 - German Features - Reporting Bundesbank              *
      *                                                               *
      *****************************************************************

     FSDACUSL1  IF   E           K DISK    INFSR(*PSSR)

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

      * Maximum number of customer numbers
     D MaxNoCsts       C                   CONST(100)

      * Customers
     D #_ACUS          S              6    DIM(MaxNoCsts)
      * Additional Customer Details
     D #_ACUSDT        S           1500    DIM(MaxNoCsts)
      * Counter variable
     D @CIX            S              6S 0

      * Additional Customer Details
     D SDACUS        E DS                  EXTNAME(SDACUSPD)

     C     *ENTRY        PLIST
     C/COPY MXCPYSRC,MXACSPRMI

      * Use input link-to field

     C                   MOVEL     I#LFD1        E5CUST

      * If no customer number is supplied
      * pass back a blank format

     C                   IF        E5CUST = *BLANKS OR E5CUST = '000000'
     C                   CLEAR                   SDACUS
     C                   ELSE

      * If the customer number was previously accessed,
      * use that customer's details

     C                   Z-ADD     1             @IX               6 0
     C     E5CUST        LOOKUP    #_ACUS(@IX)                            99
     C                   IF        *IN99  = '1'
     C                   MOVEL     #_ACUSDT(@IX) SDACUS
     C                   ELSE

      * Access the customer

     C     E5CUST        CHAIN     @ACUSL1                            99

      * Error if the customer number was not found

     C                   IF        *IN99  = '1'
     C**********         EVAL      I#ERMS = 'INVALID CUSTOMER:' + E5CUST                    MD031229
     C**********         EXSR      *PSSR                                                    MD031229
     C**********         ENDIF                                                              MD031229
     C                   CLEAR                   SDACUS                                     MD031229
     C                   ELSE                                                               MD031229

      * Save the additional customer's details

     C                   Z-ADD     1             @IX
     C     *BLANK        LOOKUP    #_ACUS(@IX)                            99
     C                   IF        *IN99  = '1'
     C                   EVAL      #_ACUS(@IX) = E5CUST
     C                   EVAL      #_ACUSDT(@IX) = SDACUS
     C                   ELSE
     C                   ADD       1             @CIX
     C                   EVAL      #_ACUS(@CIX) = E5CUST
     C                   EVAL      #_ACUSDT(@CIX) = SDACUS
     C                   IF        @CIX   = MaxNoCsts
     C                   Z-ADD     *ZERO         @CIX
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF                                                              MD031229

     C                   ENDIF
     C                   ENDIF

      * Set up output data

     C                   EVAL      InData = SDACUS

      * Return

     C                   RETURN
      *
     C/SPACE 5
      ********************************************************************
      * *INZSR --- INITIAL PROCESSING
      ********************************************************************
     C     *INZSR        BEGSR

     C                   Z-ADD     *ZERO         @CIX

     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY MXCPYSRC,MXPSSR
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2009
