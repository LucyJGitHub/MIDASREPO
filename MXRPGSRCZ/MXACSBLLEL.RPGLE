     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MX Access Balances - LENDING Loans')             *
      *****************************************************************
      *                                                               *
      *  Midas - Meridian Export Module                               *
      *                                                               *
      *  MXACSBLLEL - Access Balances - LENDING Loans                 *
      *                                                               *
      *  Function:  This module accesses loan balances from MXBLLELPD *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CLE148             Date 23Jul12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                         *CREATE    Date                       *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE148 - Alpha Loan Reference                                *
      *  CMX001 - Meridian Export                                     *
      *                                                               *
      *****************************************************************
 
     FMXBLLELL1 IF   E           K DISK    INFSR(*PSSR)
 
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
 
 
      * Balances - Lending Loans
     D BLLEL         E DS                  EXTNAME(MXBLLELPD)
 
     D P_LNNO          S              6A                                                      CLE148
 
     C     *ENTRY        PLIST
     C/COPY MXCPYSRC,MXACSPRMI
 
 
      * Use input link-to fields
 
     C                   MOVEL     I#LFD1        A_LNNO            6
 
      * Error if no loan number is supplied
 
     C     A_LNNO        IFEQ      *BLANK
     C*****A_LNNO        OREQ      '000000'                                                   CLE148
     C                   EVAL      I#ERMS = 'INVALID LOAN NUMBER: '
     C                             + A_LNNO
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * If a new loan number, re-position the file pointer
 
     C**********         MOVEL     A_LNNO        LNNO              6 0                        CLE148
     C                   MOVEL     A_LNNO        LNNO                                         CLE148
     C     LNNO          IFNE      P_LNNO
     C**********         Z-ADD     LNNO          P_LNNO                                       CLE148
     C                   MOVEL     LNNO          P_LNNO                                       CLE148
     C                   CLEAR                   BLLEL
     C                   Z-ADD     *ZERO         Num_BalRcs        5 0
     C     LOANKY        SETLL     MXBLLELP0
     C                   ENDIF
 
      * Get a balance record for the loan
 
     C     LOANKY        READE     MXBLLELP0                              99      *
 
      * No more balance records
 
     C     *IN99         IFEQ      '1'
     C                   MOVEL     '*EODATA'     I#RTCD
     C                   ELSE
     C                   ADD       1             Num_BalRcs
     C                   Z-ADD     Num_BalRcs    CNTM
     C                   ENDIF
 
 
      * Set up output data
 
     C                   EVAL      InData = BLLEL
 
 
      * Return
 
     C                   RETURN
      *
     C/SPACE 5
      ********************************************************************
      * *INZSR --- INITIAL PROCESSING
      ********************************************************************
     C     *INZSR        BEGSR
 
     C**********         Z-ADD     *ZERO         P_LNNO            6 0                        CLE148
     C                   MOVEL     *BLANKS       P_LNNO                                       CLE148
 
      * Key list
 
     C     LOANKY        KLIST
     C                   KFLD                    P_LNNO
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY MXCPYSRC,MXPSSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2001
