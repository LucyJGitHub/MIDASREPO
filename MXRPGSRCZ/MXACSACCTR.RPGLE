     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MX Access Accounts - Retail Interest & Charg')   *
      *****************************************************************
      *                                                               *
      *  Midas - Meridian Export Module                               *
      *                                                               *
      *  MXACSACCTR - Access Accounts - Retail Interest & Charges     *
      *                                                               *
      *  Function:  This module accesses account details from REIACD. *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CER049             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CMX001  *CREATE    Data 01Jan00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CER049 - Stamp Tax (Recompile)                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CMX001 - Meridian Export                                     *
      *                                                               *
      *****************************************************************
 
     FREIAC     IF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(REIACAF: REIACZF)
 
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
 
 
      * Account - Retail Interest & Charges
     D ACCTR         E DS                  EXTNAME(REIACD)
 
 
      ** External DS for BANK details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
     D A_ACOD          S             10A                                                      CGL029
 
     C     *ENTRY        PLIST
     C/COPY MXCPYSRC,MXACSPRMI
 
 
      * Use input link-to fields
 
     C                   MOVEL     I#LFD1        A_BRCA            3
     C                   MOVEL     I#LFD2        A_CNUM            6
     C                   MOVEL     I#LFD3        A_CCY             3
     C**********         MOVEL     I#LFD4        A_ACOD            4                          CGL029
     C                   MOVEL     I#LFD4        A_ACOD                                       CGL029
     C                   MOVEL     I#LFD5        A_ACSQ            2
     C                   MOVEL     I#LFD6        A_ATYP            1
 
      * Error if no branch is supplied
 
     C     A_BRCA        IFEQ      *BLANK
     C                   EVAL      I#ERMS = 'BLANK BRANCH'
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * Error if no customer number is supplied
 
     C     A_CNUM        IFEQ      *BLANK
     C     A_CNUM        OREQ      '000000'
     C                   EVAL      I#ERMS = 'BLANK CUSTOMER'
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * Error if no currency is supplied
 
     C     A_CCY         IFEQ      *BLANK
     C                   EVAL      I#ERMS = 'BLANK CURRENCY'
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * Error if no account code is supplied
 
     C     A_ACOD        IFEQ      *BLANK
     C*****A_ACOD        OREQ      '0000'                                                     CGL029
     C     A_ACOD        OREQ      '0000000000'                                               CGL029
     C                   EVAL      I#ERMS = 'BLANK ACCOUNT CODE'
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * Error if no account sequence is supplied
 
     C     A_ACSQ        IFEQ      *BLANK
     C     A_ACSQ        OREQ      '00'
     C                   EVAL      I#ERMS = 'BLANK ACCOUNT SEQUENCE'
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * Error if no account type is supplied
 
     C     A_ATYP        IFEQ      *BLANK
     C                   EVAL      I#ERMS = 'BLANK ACCOUNT TYPE'
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * If the account type is 'R' (for retail)
 
     C     A_ATYP        IFEQ      'R'
 
      * Get the account's details on REIACD
 
     C                   MOVEL     A_BRCA        BRCA
     C                   MOVEL     A_CNUM        CNUM
     C                   MOVEL     A_CCY         CCY
     C                   MOVEL     A_ACOD        ACOD
     C                   MOVEL     A_ACSQ        ACSQ
     C     ACIDKY        CHAIN     REIACDF                            99        *
 
      * If the account's details aren't found
      * and this is a current extract
      * it is an error
 
     C     *IN99         IFEQ      '1'
     C     I#EXTT        ANDEQ     'C'
     C                   EVAL      I#ERMS = 'BAD ACCOUNT:'
     C                             + A_BRCA + A_CNUM + A_CCY + A_ACOD
     C                             + A_ACSQ
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * If the account details aren't on REIACD
 
     C     *IN99         IFEQ      '1'
     C                   CLEAR                   ACCTR
     C                   MOVEL     A_BRCA        BRCA
     C                   MOVEL     A_CNUM        CNUM
     C                   MOVEL     A_CCY         CCY
     C                   MOVEL     A_ACOD        ACOD
     C                   MOVEL     A_ACSQ        ACSQ
     C                   ENDIF
 
      * If the account details aren't available
      * and this is a driver format
      *  Indicate that the account is not to be extracted
 
     C     *IN99         IFEQ      '1'
     C     CFLFMT        ANDEQ     '*DRIVER   '
     C                   MOVEL     '*NOEXT '     I#RTCD
     C                   ENDIF
 
      * Otherwise, pass back a blank format
 
     C                   ELSE
 
     C                   CLEAR                   ACCTR
     C                   MOVEL     A_BRCA        BRCA
     C                   MOVEL     A_CNUM        CNUM
     C                   MOVEL     A_CCY         CCY
     C                   MOVEL     A_ACOD        ACOD
     C                   MOVEL     A_ACSQ        ACSQ
 
     C                   ENDIF
 
      * Set up output data
 
     C                   EVAL      InData = ACCTR
 
 
      * Return
 
     C                   RETURN
      *
     C/SPACE 5
      ********************************************************************
      * *INZSR --- INITIAL PROCESSING
      ********************************************************************
     C     *INZSR        BEGSR
      *
      **  Access Bank Details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
      * Key list
 
     C     ACIDKY        KLIST
     C                   KFLD                    CNUM
     C                   KFLD                    CCY
     C                   KFLD                    ACOD
     C                   KFLD                    ACSQ
     C                   KFLD                    BRCA
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY MXCPYSRC,MXPSSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2001
