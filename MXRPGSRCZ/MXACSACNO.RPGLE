     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MX Access Retail Accounts')                      *
      *****************************************************************
      *                                                               *
      *  Midas - Meridian Export Module                               *
      *                                                               *
      *  MXACSACNO - Access Retail Account Details                    *
      *                                                               *
      *  Function:  This module accesses retail accounts from ACCNTAB *
      *                                                               *
      *  (c) Finastra International Limited 2009                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CRE075             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER045  *CREATE    Date 20Jul09               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER045 - German Features - Reporting Bundesbank              *
      *                                                               *
      *****************************************************************
 
     FACNUM     IF   E           K DISK    INFSR(*PSSR)
 
      ** All accounts
 
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
 
      ** Account - General Details
 
     D ACCTD         E DS                  EXTNAME(ACCNTAB)
 
      ** External DS for BANK details
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
     D A_ACNO          S             10A
     D PRTCD           S              7A
     D POPTN           S              7A
 
     D I#ACOD          S             10S 0
 
     C     *ENTRY        PLIST
 
     C/COPY MXCPYSRC,MXACSPRMI
 
      ** Use input link-to fields
 
     C                   MOVEL     I#LFD1        A_ACNO
 
      ** Get the account from ACCNTAB
 
     C                   MOVEL     A_ACNO        ACNO
     C     ACIDKY        CHAIN     ACCNTABF                           99        *
 
      ** If the account isn't found
      ** and not zeros,
      ** it is an error
 
     C                   IF        *IN99  ='1' AND
     C                             ACNO  <> 0
     C                   EVAL      I#ERMS = 'BAD RETAIL ACCOUNT: '
     C                             + A_ACNO
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** If the account isn't on ACCNTAB
 
     C                   IF        *IN99  = '1'
     C                   CLEAR                   ACCTD
     C                   ENDIF
 
      ** If the account isn't available
      ** and this is a driver format
      ** Indicate that the account is not to be extracted
 
     C                   IF        *IN99  = '1' AND
     C                             CFLFMT = '*DRIVER'
     C                   EVAL      I#RTCD = '*NOEXT '
     C                   ELSE
 
      ** If this is a driver format
 
     C                   IF        CFLFMT = '*DRIVER'
 
      ** Determine if branch is to be included in the export
 
     C                   EVAL      I#LD   = 'D'
     C                   EVAL      I#BRCA = BRCA
     C                   EXSR      BRCA_FLT
 
      ** Determine if account code is to be included in the export
 
     C                   EVAL      I#LD   = 'D'
     C                   EVAL      I#ACOD = ACOD
     C                   EXSR      ACOD_FLT
 
      ** If the branch and account code are NOT for export
      ** Indicate that account is not to be extracted
 
     C                   IF        Exp_BRCA <> 'Y' OR
     C                             Exp_ACOD <> 'Y'
     C                   EVAL      I#RTCD = '*NOEXT '
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
      ** Set up output data
 
     C                   EVAL      InData = ACCTD
 
      ** Return
 
     C                   RETURN
      *
      /SPACE 5
      *********************************************************************
      ** B R A N C H   F I L T E R
      /COPY MXCPYSRC,MXFLTBRCA
      ********************************************************************
      /SPACE 5
      *********************************************************************
      ** A C C O U N T   C O D E   F I L T E R
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
     C                   PARM      '*DBERR  '    PRTCD
     C                   PARM      '*FIRST  '    POPTN
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
     C                   KFLD                    ACNO
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY MXCPYSRC,MXPSSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2009
