     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ZA Validate interest calculation method')        *
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  ZAVINTCALC - Validate Interest Calculation Method            *
      *                                                               *
      *  Function:  This module receives a parameter containing the   *
      *             Interest Calculation Method and confirms whether  *
      *             it has a valid value.                             *
      *             If it is valid the 10A return code will be blank, *
      *             if it is not it will contain  'Error'             *
      *                                                               *
      *             This was originally a section of code which was   *
      *             repeated in each of the MM deals input programs   *
      *             (and possibly elsewhere). Code has been added     *
      *             around it to turn it into a compilable module     *
      *                                                               *
      *  Component of: ZA_ALL - All ZA modules service program        *
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
      *  Prev Amend No. MD027384           Date 10Jun14               *
      *                 CDL093             Date 07Apr14               *
      *                 CER059             Date 19Jul10               *
      *                 BUG26602           Date 19Nov09               *
      *                 BUG23841           Date 29Apr09               *
      *                 CER016             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG9373            Date 13Feb06               *
      *                 224743             Date 02Feb04               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 194650             Date 24May02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP002  *CREATE    Date 17Sep97               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD027384 - remove forced initialisation of CDL093 feature    *
      *  CDL093 - MM Interest method 9 (Actual/ACtual - AFB)          *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG26602 - Make message for Calculation method generic       *
      *  BUG23841 - A Serious Midas Error occur when creating a NASP  *
      *           transaction with Deal Type 'BD'                     *
      *  CER016 - German Interest Calculation: Upgarde of FGE059      *
      *           to Midas Plus                                       *
      *  BUG9373 - Applied 224743 Reopen - SDYRATRTV should use new   *
      *           ZAVCALCB instead of ZAVINTCALC to validate int      *
      *           calculation method. Reverse previous amendments     *
      *  224743 - Interest Calculation Method should allow '7' if     *
      *           CIR004 is installed                                 *
      *  194650 - Interest Calculation Method defaults to the previous*
      *           deal input.  Default the Interest Calculation method*
      *           to its Deal Currency.                               *
      *  CAP002 - Conversion of Midas inputs to modular API structure *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
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
      *                                                                                       CER016
      ** External DS for SAR Details                                                          CER016
      *                                                                                       CER016
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CER016
      *                                                                                       CER016
      ** First DS for Access Programs, Short Data Structure                                   CER016
      *                                                                                       CER016
     D DSFDY         E DS                  EXTNAME(DSFDY)                                     CER016
 
      ***DS*for*Access*Programs:*Short*Data*Structure******************               224743 BUG9373
     D*DSFDY****     E DS                  EXTNAME(DSFDY)                             224743 BUG9373
      **********                                                                      224743 BUG9373
      ***DS*for*SC*Switchable*Features*********************************               224743 BUG9373
     D*SCSARD***     E DS                  EXTNAME(SCSARDPD)                          224743 BUG9373
      **********                                                                      224743 BUG9373
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Error message field received as a parameter
     D Msgid1          S                   LIKE(#Msgid)
 
      ** Midas Interest Calculation method - received as a parameter
     D DDICMT          S              1A
 
      ** Midas Default Int. Calculation method - received as a parameter
      ** from SDCURRPD
     D A6DICB          S              1A
      *                                                                                       CDL093
      ** MM Method 9                                                                          CDL093
      *                                                                                       CDL093
     D CDL093          S              1A                                                      CDL093
      *                                                                                       CER016
      ** Fields defined for Enhancement CER016                                                CER016
      *                                                                                       CER016
     D CER016          S              1A                                                      CER016
     D PRtCd           S              7A                                                      CER016
     D POptn           S              7A                                                      CER016
     D PSard           S              6A                                                      CER016
 
      ***Parameters*for*access*object*AOSARDR0*************************               224743 BUG9373
      **********                                                                      224743 BUG9373
     D*PRTCD****       S              7A                                              224743 BUG9373
     D*POPTN****       S              7A                                              224743 BUG9373
     D*PSARD****       S              6A                                              224743 BUG9373
     D*CIR004***       S              1A                                              224743 BUG9373
      **********                                                                      224743 BUG9373
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
 
      ** Reset error flags & msgs to prevent problems on subsequent calls
     C                   RESET                   ErrorFound
     C                   RESET                   Msgid1
 
      *  *-----------------------------*
      *  * Validate Calculation Method *
      *  *-----------------------------*
      *
      **  If the interest calculation method is blank, default it
     C*****DDICMT        IFEQ      *BLANK                                                     194650
     C**********         MOVE      A6DICB        DDICMT                                       194650
     C**********         END                                                                  194650
      *
      **  If the method is not 1,2,3,4,5 or 6 this is an error.
     C     DDICMT        IFNE      '1'
     C     DDICMT        ANDNE     '2'
     C     DDICMT        ANDNE     '3'
     C     DDICMT        ANDNE     '4'
     C     DDICMT        ANDNE     '5'
     C     DDICMT        ANDNE     '6'
     C     DDICMT        ANDNE     '9'                                                        CDL093
     C     DDICMT        OREQ      '9'                                                        CDL093
     C     CDL093        ANDNE     'Y'                                                        CDL093
     C*****DDICMT        ANDEQ     '0'                                               CER016 BUG23841
     C*****CER016        ANDNE     'Y'                                               CER016 BUG23841
     C*****DDICMT        ORGT      '6'                                               CER016 BUG23841
     C*****DDICMT        ANDNE     *BLANKS                                                    194650
      **********                                                                      224743 BUG9373
      ***Allow*if*method*is*7*and*CIR004*is*installed******************               224743 BUG9373
      **********                                                                      224743 BUG9373
     C*****DDICMT        ANDNE     '7'                                                224743 BUG9373
     C*****DDICMT        OREQ      '7'                                                224743 BUG9373
     C*****CIR004        ANDNE     'Y'                                                224743 BUG9373
      **********                                                                      224743 BUG9373
     C**********         MOVE      'Y'           ErrorFound                                 BUG23841
      **********                                                                      224743 BUG9373
      ***Use*message*"...not*a*digit*from*1*to*7"*if*CIR004*is*installed,             224743 BUG9373
      ***else*use*message*"...not*a*digit*from*1*to*6"                                224743 BUG9373
      **********                                                                      224743 BUG9373
     C**********         IF        CIR004 = 'Y'                                       224743 BUG9373
     C**********         MOVEL     'MMM0429'     MSGID1                               224743 BUG9373
     C**********         ELSE                                                         224743 BUG9373
     C**********         MOVEL     'MMM0428'     MSGID1                                     BUG23841
     C*****CER016        IFEQ      'Y'                                               CER016 BUG23841
     C**********         MOVEL     'USR8008'     MSGID1                              CER016 BUG23841
     C**********         ENDIF                                                       CER016 BUG23841
     C**********         ENDIF                                                        224743 BUG9373
      **********                                                                      224743 BUG9373
      *                                                                                     BUG23841
      ** If CER016 is ON, calc method should be a digit from 0 to 6,                        BUG23841
      ** Else, from 1 to 6.                                                                 BUG23841
     C                   IF        DDICMT = '0'                                             BUG23841
      *                                                                                     BUG23841
     C                   IF        CER016 = 'N'                                             BUG23841
     C                   EVAL      ErrorFound = 'Y'                                         BUG23841
     C                   EVAL      MSGID1 = 'MMM0428'                                       BUG23841
     C                   ENDIF                                                              BUG23841
      *                                                                                     BUG23841
     C                   ELSE                                                               BUG23841
      *                                                                                     BUG23841
     C                   IF        CER016 = 'Y'                                             BUG23841
     C                             OR CDL093 = 'Y'                                            CDL093
     C                   EVAL      ErrorFound = 'Y'                                         BUG23841
     C**********         EVAL      MSGID1 = 'USR8008'                              BUG23841 BUG26602
     C                   EVAL      MSGID1 = 'MMA3007'                                       BUG26602
     C                   ELSE                                                               BUG23841
     C                   EVAL      ErrorFound = 'Y'                                         BUG23841
     C                   EVAL      MSGID1 = 'MMM0428'                                       BUG23841
     C                   ENDIF                                                              BUG23841
      *                                                                                     BUG23841
     C                   ENDIF                                                              BUG23841
      *                                                                                     BUG23841
     C                   END
      *
      ** If an error was found, set the return code appropriately
     C                   IF        ErrorFound = 'Y'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
 
     C                   RETURN
 
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
     C                   PARM                    RetCodeIn
     C                   PARM                    Msgid1
     C                   PARM                    DDICMT
     C                   PARM                    A6DICB
      *                                                                                       CER016
      ** Check if switchable feature CER016 is installed                                      CER016
      *                                                                                       CER016
     C                   CALLB     'AOSARDR0'                                                 CER016
     C                   PARM      *BLANKS       PRtCd                                        CER016
     C                   PARM      '*VERIFY'     POptn                                        CER016
     C                   PARM      'CER016'      PSard                                        CER016
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER016
      *                                                                                       CER016
     C                   IF        PRtCd <> *BLANKS AND                                       CER016
     C                             PRtCd <> '*NRF'                                            CER016
     C     *LOCK         IN        LDA                                                        CER016
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER016
     C                   EVAL      DBASE = 1                                                  CER016
     C                   EVAL      DBKEY = 'CER016'                                           CER016
     C                   OUT       LDA                                                        CER016
     C                   EXSR      *PSSR                                                      CER016
     C                   ENDIF                                                                CER016
      *                                                                                       CER016
     C                   IF        PRtCd = *BLANKS                                            CER016
     C                   EVAL      CER016 = 'Y'                                               CER016
     C                   ENDIF                                                                CER016
      *                                                                                       CDL093
      ** Check if switchable feature CDL093 is installed                                      CDL093
      ** MM interest method 9 (Actual/Actual AFB)                                             CDL093
      *                                                                                       CDL093
     C                   EVAL      CDL093 = 'N'                                               CDL093
     C                   CALLB     'AOSARDR0'                                                 CDL093
     C                   PARM      *BLANKS       PRtCd                                        CDL093
     C                   PARM      '*VERIFY'     POptn                                        CDL093
     C                   PARM      'CDL093'      PSard                                        CDL093
     C     SCSARD        PARM      SCSARD        DSFDY                                        CDL093
      *                                                                                       CDL093
     C                   IF        PRtCd = *BLANKS                                            CDL093
     C                   EVAL      CDL093 = 'Y'                                               CDL093
     C                   ENDIF                                                                CDL093
     C**********         EVAL      CDL093 = 'Y'                                      EFIXAC MD027384
 
      ***Check*is*CIR004*is*installed**********************************               224743 BUG9373
      **********                                                                      224743 BUG9373
     C**********         EVAL      CIR004 = 'N'                                       224743 BUG9373
     C**********         CALL      'AOSARDR0'                                         224743 BUG9373
     C**********         PARM      *BLANKS       PRTCD                                224743 BUG9373
     C**********         PARM      '*VERIFY'     POPTN                                224743 BUG9373
     C**********         PARM      'CIR004'      PSARD                                224743 BUG9373
     C*****SCSARD        PARM      SCSARD        DSFDY                                224743 BUG9373
      **********                                                                      224743 BUG9373
      ***Database*error.***********************************************               224743 BUG9373
      **********                                                                      224743 BUG9373
     C**********         IF        PRTCD <> *BLANKS  AND                              224743 BUG9373
     C**********                   PRTCD <> '*NRF   '                                 224743 BUG9373
     C**********         EVAL      DBKEY = PSARD                                      224743 BUG9373
     C**********         EVAL      DBFILE = 'SCSARDPD'                                224743 BUG9373
     C**********         EVAL      DBASE  =  001                                      224743 BUG9373
     C**********         EXSR      *PSSR                                              224743 BUG9373
     C**********         ENDIF                                                        224743 BUG9373
      **********                                                                      224743 BUG9373
     C**********         IF        PRTCD = *BLANKS                                    224743 BUG9373
     C**********         EVAL      CIR004 = 'Y'                                       224743 BUG9373
     C**********         ENDIF                                                        224743 BUG9373
      **********                                                                      224743 BUG9373
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
