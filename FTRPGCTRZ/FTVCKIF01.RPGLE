     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Checking for insufficient funds')             *
      *****************************************************************
      *                                                               *
      *  Midas - Standard subprograms                                 *
      *                                                               *
      *  FTVCKIF01  - Checking for insufficient funds                 *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CRE075             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 CSW207A            Date 08Aug07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 188775  *CREATE    Date 08Mar01               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  CSW207A - SWIFT 2007 Changes                                 *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  188775 - Checking for insufficient funds                     *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *****************************************************************
 
     FFT102HL3  IF   E           K DISK
     FFT102DL1  IF   E           K DISK
     FMEMOSL1   IF   E           K DISK
 
      *****************************************************************
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
 
      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      ** Program, procedure and module names for parameters
      ** ==================================================
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_XARRYS
      **--------------------------------------------------------------------------------------------
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      **  Ordering Customer accounts array
     D*CUSTAR***       S             18    DIM(5000)                                          CGL029
     D CUSTAR          S             24    DIM(5000)                                          CGL029
 
      **  Multiple occurrence data structure for ordering customer
      **  accounts (in GL format) and their transfer amounts
     D ACINFO          DS                  OCCURS(5000)
     D  ORDCAC                 1     24                                                       CGL029
     D  TFRAMT                25     39P 0                                                    CGL029
     D**ORDCAC**               1     18                                                       CGL029
     D**TFRAMT**              19     33P 0                                                    CGL029
 
      * DS to split account identifier into components
     D WORKACCID       DS
     D**W#CNUM**               1      6  0                                                    CSD027
     D  W#CNUM                 1      6                                                       CSD027
     D  W#CCY                  7      9
     D  W#ACOD                10     19  0                                                    CGL029
     D  W#ACSQ                20     21  0                                                    CGL029
     D  W#BRCA                22     24                                                       CGL029
     D**W#ACOD**              10     13  0                                                    CGL029
     D**W#ACSQ**              14     15  0                                                    CGL029
     D**W#BRCA**              16     18                                                       CGL029
 
      ** External data structure for access programs (short)
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** External data structure for access programs (Long)
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      * Incoming account details from access objects
     D ACCRECORD     E DS                  EXTNAME(ACCNTAB)
 
      ** External data structure for Nostro details
     D N@FMT         E DS                  EXTNAME(SDNOSTPD)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
     D CFT004          S              1
     D Y               S              4  0
     D Z               S              4  0
     D W#CHKCUST       S             34
 
      * Entry Parameters
     D WCCTID          S                   LIKE(CCTID)
 
      * Parameters for AOACCTV1
     D P@TYPE          S              7
     D PACCT           S             35
     D ACCTRETCDE      S              7
 
      * Parameters for AOIBANR2
     D IBANRETCDE      S              7
     D P@IBAN          S             34
 
      * Parameters for AOSARDR0
     D PRTCD           S              7
     D POPTN           S              7
     D PSARD           S              6
 
      * Keylist for MEMOSL1
     D K#CNUM          S                   LIKE(CNUM)
     D K#CCY           S                   LIKE(CCY)
     D K#ACOD          S                   LIKE(ACOD)
     D K#ACSQ          S                   LIKE(ACSQ)
     D K#BRCA          S                   LIKE(BRCA)
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *****************************************************************
 
      ** Serious midas error occurred, decimal data error                                    CSW207A
     C                   Clear                   ACINFO                                      CSW207A
      * Retrieve header record
     C     WCCTID        CHAIN     FT102HL3
 
      * If ordering customer or ordering institution is a valid account
      * in header record check if it has sufficient funds
     C                   IF        CUSTTH <> *BLANKS OR
     C                             ORDITP <> *BLANKS
 
     C                   IF        CUSTTH <> *BLANKS
     C                   EVAL      W#CHKCUST = TOCUS1
     C                   ELSE
     C                   EVAL      W#CHKCUST = OINST3
     C                   ENDIF
 
     C                   EXSR      VALACCNT
 
     C                   EVAL      K#CNUM = W#CNUM
     C                   EVAL      K#CCY = W#CCY
     C                   EVAL      K#ACOD = W#ACOD
     C                   EVAL      K#ACSQ = W#ACSQ
     C                   EVAL      K#BRCA = W#BRCA
 
     C     GLACC         CHAIN     MEMOSL1
 
      * Credit balance on a customers account is represented as -ve
     C                   IF        %FOUND
     C                   MULT      -1            CLBLN
 
     C                   IF        CCTAMT > CLBLN
     C                   EVAL      RETCODEIN = '*NOFUNDS'
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ELSE
 
      * If ordering customer is not in header record, read through
      * detail records and sum up amounts by ordering customer account/
      * ordering institution account
 
     C                   EVAL      Z = 0
     C                   CLEAR                   CUSTAR
 
     C     WCCTID        SETLL     FT102DL1
     C     WCCTID        READE     FT102DL1
 
     C                   DOW       NOT %EOF
 
     C                   IF        CUSTTD <> *BLANKS
     C                   EVAL      W#CHKCUST = ORDCU1
     C                   ELSE
     C                   EVAL      W#CHKCUST = ORDI35
     C                   ENDIF
 
     C                   EXSR      VALACCNT
 
      * Look up if customer exists in customer array
     C                   EVAL      Y = 1
     C     WORKACCID     LOOKUP    CUSTAR(Y)                              01
 
      * If it doesnt exist in customer array, write a record with the
      * ordering customer account and transfer amount in multiple
      * occurence ds and write a record into customer array
     C                   IF        *IN01 = *OFF
     C                   ADD       1             Z
     C     Z             OCCUR     ACINFO
     C                   EVAL      ORDCAC = WORKACCID
     C                   EVAL      TFRAMT = CCTAMT
     C                   EVAL      CUSTAR(Z) = WORKACCID
     C                   ELSE
 
      * If it does exist in customer array, retrieve record in multiple
      * occurrence ds and add the transfer amount to the existing
      * transfer amount for that customer
     C     Y             OCCUR     ACINFO
     C                   ADD       CCTAMT        TFRAMT
     C                   ENDIF
 
     C     WCCTID        READE     FT102DL1
     C                   ENDDO
 
      * Read multiple occurrence ds and check if each customer has
      * sufficient funds in their account
     C                   EVAL      Y = 1
     C                   DOW       Y <= Z
     C     Y             OCCUR     ACINFO
     C                   EVAL      WORKACCID = ORDCAC
 
     C                   EVAL      K#CNUM = W#CNUM
     C                   EVAL      K#CCY = W#CCY
     C                   EVAL      K#ACOD = W#ACOD
     C                   EVAL      K#ACSQ = W#ACSQ
     C                   EVAL      K#BRCA = W#BRCA
 
     C     GLACC         CHAIN     MEMOSL1
 
      * Credit balance on a customers account is represented as -ve
     C                   IF        %FOUND
     C                   MULT      -1            CLBLN
 
     C                   IF        TFRAMT > CLBLN
     C                   EVAL      RETCODEIN = '*NOFUNDS'
     C                   LEAVE
     C                   ENDIF
     C                   ENDIF
 
     C                   ADD       1             Y
     C                   ENDDO
 
     C                   ENDIF
 
     C                   RETURN
      /EJECT
      *****************************************************************
      *                                                               *
      * ValAccnt - Retrieve details of account entered in Ordering    *
      *            Customer/Ordering Institution field.               *
      *                                                               *
      * Called by:                                                    *
      *                                                               *
      * Calls: AOIBANR2, AOACCTV1                                     *
      *                                                               *
      *****************************************************************
      *
     C     VALACCNT      BEGSR
      *
     C                   CLEAR                   ACCRECORD
     C                   EVAL      P@TYPE = *BLANKS
 
      ** If CFT004 present, IBANs are allowed.  Else send dummy return code.
 
     C                   IF        CFT004 = 'Y'
      *
     C                   CALLB     'AOIBANR2'
     C                   PARM      *BLANKS       IBANRETCDE
     C                   PARM      W#CHKCUST     P@IBAN
     C                   PARM      *BLANKS       ACCRECORD
 
     C                   IF        IBANRETCDE =  *BLANKS
     C                   EVAL      P@TYPE = 'IBAN'
     C                   EVAL      W#CCY  = CCY
     C                   EVAL      W#ACOD = ACOD
     C                   EVAL      W#ACSQ = ACSQ
     C                   EVAL      W#BRCA = BRCA
     C                   EVAL      W#CNUM = CNUM
     C                   ENDIF
 
     C                   ENDIF
      *
     C                   IF        P@TYPE <> 'IBAN'
     C                   CALLB     'AOACCTV1'
     C                   PARM                    ACCTRETCDE
     C                   PARM                    P@TYPE
     C                   PARM      W#CHKCUST     PACCT
     C                   PARM                    DSSDY
      *
     C                   SELECT
 
     C                   WHEN      P@TYPE = '*NOSTRO'
     C                   EVAL      N@FMT = DSSDY
     C                   EVAL      W#CCY  = A7CYCD
     C                   MOVEL     A7ACCD        W#ACOD
     C                   EVAL      W#ACSQ = 01
     C                   EVAL      W#BRCA = A7BRCD
     C                   MOVEL     A7CUST        W#CNUM
 
     C                   WHEN      P@TYPE = '*RETAIL'
     C                   EVAL      ACCRECORD = DSSDY
     C                   EVAL      W#CCY  = CCY
     C                   EVAL      W#ACOD = ACOD
     C                   EVAL      W#ACSQ = ACSQ
     C                   EVAL      W#BRCA = BRCA
     C                   EVAL      W#CNUM = CNUM
 
     C                   WHEN      P@TYPE = '*LEDGER'
     C                   EVAL      ACCRECORD = DSSDY
     C                   EVAL      W#CCY  = CCY
     C                   EVAL      W#ACOD = ACOD
     C                   EVAL      W#ACSQ = ACSQ
     C                   EVAL      W#BRCA = BRCA
     C                   EVAL      W#CNUM = CNUM
     C                   ENDSL
 
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      ** INPUTS
 
     C                   PARM                    RETCODEIN
     C                   PARM                    WCCTID
 
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CFT004'      PSARD
     C                   PARM                    DSFDY
 
     C                   IF        PRTCD = *BLANKS
     C                   EVAL      CFT004 = 'Y'
     C                   ELSE
     C                   EVAL      CFT004 = 'N'
 
     C                   IF        PRTCD <> '*NRF'
     C                   EVAL      DBKEY  =  CFT004
     C                   EVAL      DBFILE = 'AOSARDR0'
     C                   EVAL      DBPGM  = PSPROCPGM
     C                   EVAL      DBASE  = 1
     C                   EVAL      DBMOD  = PSPROCMOD
     C                   EVAL      DBPROC = '*INZSR'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDIF
 
     C     GLACC         KLIST
     C                   KFLD                    K#CNUM
     C                   KFLD                    K#CCY
     C                   KFLD                    K#ACOD
     C                   KFLD                    K#ACSQ
     C                   KFLD                    K#BRCA
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR                                                  *** InzEnd ***
 
      *****************************************************************
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
