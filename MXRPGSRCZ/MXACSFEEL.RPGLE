     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MX Access lending fees - loans')                 *
      *****************************************************************
      *                                                               *
      *  Midas - Meridian Export Module                               *
      *                                                               *
      *  MXACSFEEL - Access Lending Fees - Loans                      *
      *                                                               *
      *  Function:  This module accesses loan fees from LEFEED.       *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CLE134             Date 01Aug12               *
      *  Prev Amend No. CLE148             Date 23Jul12               *
      *                 CLE139             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 204452             Date 03May02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CMX001  *CREATE    Data 01Jan00               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference                                *
      *  CLE139 - Lending Fee Capitalisation (Recompile)              *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  204452 - Recompiled due to changed PF/LEFEED.                *
      *  CMX001 - Meridian Export                                     *
      *                                                               *
      *****************************************************************
 
     FLEFEEDL2  IF   E           K DISK    INFSR(*PSSR)
 
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
 
 
      * Fee Details - Loans
     D FEEL          E DS                  EXTNAME(LEFEED)
 
     D LNNO            S              6A                                                      CLE148
     D P_LNNO          S              6A                                                      CLE148
 
     C     *ENTRY        PLIST
     C/COPY MXCPYSRC,MXACSPRMI
 
 
      * Use input link-to fields
 
     C                   MOVEL     I#LFD1        A_CNUM            6
     C                   MOVEL     I#LFD2        A_LNNO            6
 
 
      * Error if no customer number is supplied
 
     C     A_CNUM        IFEQ      *BLANK
     C*****A_CNUM        OREQ      '000000'                                                   CLE148
     C                   EVAL      I#ERMS = 'BLANK CUSTOMER'
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * Error if no loan number is supplied
 
     C     A_LNNO        IFEQ      *BLANK
     C     A_LNNO        OREQ      '000000'
     C                   EVAL      I#ERMS = 'BLANK LOAN NUMBER'
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * If a new loan, re-position the file pointer
 
     C*****              MOVEL     A_CNUM        CNUM              6 0                        CSD027
     C**********         MOVEL     A_LNNO        LNNO              6 0                        CLE148
     C                   MOVEL     A_LNNO        LNNO                                         CLE148
     C*****CNUM          IFNE      P_CNUM                                                     CSD027
     C     A_CNUM        IFNE      P_CNUM                                                     CSD027
     C     LNNO          ORNE      P_LNNO
     C*****              Z-ADD     CNUM          P_CNUM                                       CSD027
     C                   EVAL      P_CNUM = A_CNUM                                            CSD027
     C**********         Z-ADD     LNNO          P_LNNO                                       CLE148
     C                   MOVEL     LNNO          P_LNNO                                       CLE148
     C                   CLEAR                   FEEL
     C                   Z-ADD     *ZERO         Num_FeeRcs        5 0
     C     LOANKY        SETLL     LEFEEDF
     C                   ENDIF
 
      * Get a fee record for the loan
 
     C     LOANKY        READE     LEFEEDF                                99     *
 
      * No more fee records
 
     C     *IN99         IFEQ      '1'
     C                   MOVEL     '*EODATA'     I#RTCD
     C                   ELSE
     C                   ADD       1             Num_FeeRcs
     C                   Z-ADD     Num_FeeRcs    FETNLU
     C                   ENDIF
 
 
      * Set up output data
 
     C                   EVAL      InData = FEEL
 
 
      * Return
 
     C                   RETURN
      *
     C/SPACE 5
      ********************************************************************
      * *INZSR --- INITIAL PROCESSING
      ********************************************************************
     C     *INZSR        BEGSR
 
     C*****              Z-ADD     *ZERO         P_CNUM            6 0                        CSD027
     C                   MOVE      *BLANKS       P_CNUM            6                          CSD027
     C**********         Z-ADD     *ZERO         P_LNNO            6 0                        CLE148
     C                   MOVEL     *BLANKS       P_LNNO                                       CLE148
 
      * Key list
 
     C                   Z-ADD     *ZERO         P_FACL            5 0
     C     LOANKY        KLIST
     C                   KFLD                    P_CNUM
     C                   KFLD                    P_FACL
     C                   KFLD                    P_LNNO
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY MXCPYSRC,MXPSSR
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
