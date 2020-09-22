     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MX Access Accounts - General Details')           *
      *****************************************************************
      *                                                               *
      *  Midas - Meridian Export Module                               *
      *                                                               *
      *  MXACSACCTD - Access Accounts - General Details               *
      *                                                               *
      *  Function:  This module accesses accounts from ACCNTAB.       *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CRE075             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 242925             Date 10Oct06               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CMX003             Date 05Nov00               *
      *                 CMX001  *CREATE    Data 01Jan00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  242925 - Increase Account Code to 10 digits Signed (not P)   *
      *           Amend hook MXCPYSRC/MXFLTACOD and recompiled        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CMX003 - Meridian Export Enhancements - Phase 2              *
      *           (RE-COMPILE OVER CHANGED /COPY)                     *
      *  CMX001 - Meridian Export                                     *
      *                                                               *
      *****************************************************************
 
     FACCNT     IF   E           K DISK    INFSR(*PSSR)
      * All accounts
 
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
 
 
      * Account - General Details
     D ACCTD         E DS                  EXTNAME(ACCNTAB)
 
 
      ** External DS for BANK details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
     D A_ACOD          S             10A                                                      CGL029
                                                                                              242925
     D I#ACOD          S             10S 0                                                    242925
 
     C     *ENTRY        PLIST
     C/COPY MXCPYSRC,MXACSPRMI
 
 
      * Use input link-to fields
 
     C                   MOVEL     I#LFD1        A_BRCA            3
     C                   MOVEL     I#LFD2        A_CNUM            6
     C                   MOVEL     I#LFD3        A_CCY             3
     C**********         MOVEL     I#LFD4        A_ACOD            4                          CGL029
     C                   MOVEL     I#LFD4        A_ACOD                                       CGL029
     C                   MOVEL     I#LFD5        A_ACSQ            2
 
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
 
      * Get the account from ACCNTAB
 
     C                   MOVEL     A_BRCA        BRCA
     C                   MOVEL     A_CNUM        CNUM
     C                   MOVEL     A_CCY         CCY
     C                   MOVEL     A_ACOD        ACOD
     C                   MOVEL     A_ACSQ        ACSQ
     C     ACIDKY        CHAIN     ACCNTABF                           99        *
 
      * If the account isn't found
      * and this is a current extract
      * it is an error
 
     C     *IN99         IFEQ      '1'
     C     I#EXTT        ANDEQ     'C'
     C                   EVAL      I#ERMS = 'BAD ACCOUNT:'
     C                             + A_BRCA + A_CNUM + A_CCY + A_ACOD
     C                             + A_ACSQ
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * If the account isn't on ACCNTAB
 
     C     *IN99         IFEQ      '1'
     C                   CLEAR                   ACCTD
     C                   MOVEL     A_BRCA        BRCA
     C                   MOVEL     A_CNUM        CNUM
     C                   MOVEL     A_CCY         CCY
     C                   MOVEL     A_ACOD        ACOD
     C                   MOVEL     A_ACSQ        ACSQ
     C                   MOVEL     'C'           ATYP
     C                   ENDIF
 
      * If the account isn't available
      * and this is a driver format
      *  Indicate that the account is not to be extracted
 
     C     *IN99         IFEQ      '1'
     C     CFLFMT        ANDEQ     '*DRIVER   '
     C                   MOVEL     '*NOEXT '     I#RTCD
     C                   ELSE
 
      * If this is a driver format
 
     C     CFLFMT        IFEQ      '*DRIVER   '
 
      * Determine if branch is to be included in the export
 
     C                   MOVE      'D'           I#LD
     C                   MOVEL     BRCA          I#BRCA
     C                   EXSR      BRCA_FLT
 
      * Determine if account code is to be included in the export
 
     C                   MOVE      'D'           I#LD
     C                   MOVEL     ACOD          I#ACOD
     C                   EXSR      ACOD_FLT
 
      * If the branch and account code are NOT for export
      *  Indicate that account is not to be extracted
 
     C     Exp_BRCA      IFNE      'Y'
     C     Exp_ACOD      ORNE      'Y'
     C                   MOVEL     '*NOEXT '     I#RTCD
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
      * Set up output data
 
     C                   EVAL      InData = ACCTD
 
 
      * Return
 
     C                   RETURN
      *
      /SPACE 5
      *********************************************************************
      * B R A N C H   F I L T E R
      /COPY MXCPYSRC,MXFLTBRCA
      ********************************************************************
      /SPACE 5
      *********************************************************************
      * A C C O U N T   C O D E   F I L T E R
      /COPY MXCPYSRC,MXFLTACOD
      ********************************************************************
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
 
      * Load branches for export
 
     C                   MOVE      'L'           I#LD
     C                   EXSR      BRCA_FLT
 
      * Load account codes for export
 
     C                   MOVE      'L'           I#LD
     C                   Z-ADD     *ZERO         I#ACOD
     C                   EXSR      ACOD_FLT
 
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
