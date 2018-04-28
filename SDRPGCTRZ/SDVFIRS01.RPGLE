     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Validate First Name')                         *
      *****************************************************************
      *                                                               *
      *  Midas - Midas Standing Data Module                           *
      *                                                               *
      *  SDVFIRS01 - Validate First Name                              *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2004            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. MD022651           Date 10Oct13               *
      *  Prev Amend No. MD021510           Date 09Aug13               *
      *                 AR978528           Date 21May12               *
      *                 CER059             Date 19Jul10               *
      *                 BUG22667           Date 11Oct07               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 254721             Date 30May08               *
      *                 BUG17464           Date 28Mar08               *
      *                 BUG16243           Date 26Feb08               *
      *                 250804A            Date 11Oct07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 232543             Date 14Mar05               *
      * Midas Release 4.04 -------------------------------------------*
      *                 CGL031  *CREATE    Date 05Jul04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD022651 - Impossible to amend additional customer details   *
      *  MD021510 -  Account Owner/Family and Company Name/First Name *
      *              are being populated from Repair Queue even no    *
      *              value is passed Edit                             *
      *  AR978528 - No defaulting from Cust. should be done for NAHL  *
      *             (Child:AR978529)                                  *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG22667 - Session time out occurs when entering data in     *
      *             ACUD                                              *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  254721 - Added checking on SDSVALPD re: details on Family    *
      *           Name.  MidasR4 allows Number on Family Name.        *
      *  BUG17464 - Do no default value for first name                *
      *  BUG16243 - Moved defaulting of First Name (fix 250804A)      *
      *             inside subroutine SRVCNA2                         *
      *  250804A - Correct defaulting of additional customer details  *
      *           from main customer details.                         *
      *  232543 - Fix to CGL031                                       *
      *  CGL031 - Taxation of Savings Income                          *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    XX         Function of indicator                           *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *PSSR - Error processing                                      *
      * *INZSR - Initialise                                           *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
      *
      ** Program Status Data Structure
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
     D/COPY ZACPYSRC,ERR_XARRYS
      **--------------------------------------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *                                                                                       254721
      ** Constant to hold input parameter for AOSVALR0                                        254721
     D NumericOnFname  C                   Const('NumericOnName_Fname')                       254721
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      ** External DS for Country Details                                                     250804A
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                                 250804A
      *                                                                                      250804A
      ** Long DS for access programs                                                         250804A
     D DSLDY         E DS                  EXTNAME(DSLDY)                                    250804A
      *                                                                                      250804A
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
 
     D @RUN            S              1
     D DDCUST          S              6A                                                     250804A
     D DDCNA2          S             70
     D DDOKCNA2        S              1
     D FirstName       S             70
     D FirstChar       S              1
     D PTaxStat        S              1                                                       232543
     D PJACType        S              1                                                       232543
     D DDACTN          S              1                                                     MD021510
 
      ** Parameter for Access Object                                                         250804A
     D PRTCD           S              7A                                                     250804A
     D POPTN           S              7A                                                     250804A
     D PKEY1           S             10A                                                     250804A
     D PKYST           S              7A                                                     250804A
      *                                                                                      250804A
                                                                                              254721
     D PSysVal01       S             20A   INZ(*Blanks)                                       254721
     D PCurSet01       S            200A                                                      254721
     D PSysVal02       S             20A                                                      254721
     D PCurSet02       S            200A                                                      254721
     D PSysVal03       S             20A                                                      254721
     D PCurSet03       S            200A                                                      254721
     D PSysVal04       S             20A                                                      254721
     D PCurSet04       S            200A                                                      254721
     D PSysVal05       S             20A                                                      254721
     D PCurSet05       S            200A                                                      254721
     D PSysVal06       S             20A                                                      254721
     D PCurSet06       S            200A                                                      254721
     D PSysVal07       S             20A                                                      254721
     D PCurSet07       S            200A                                                      254721
     D PSysVal08       S             20A                                                      254721
     D PCurSet08       S            200A                                                      254721
     D PSysVal09       S             20A                                                      254721
     D PCurSet09       S            200A                                                      254721
     D PSysVal10       S             20A                                                      254721
     D PCurSet10       S            200A                                                      254721
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
 
      ** Check customer details                                                              250804A
      *                                                                                      250804A
     C                   IF        DDCUST <> *Blanks                                        AR978528
     C                   MOVEL     DDCUST        PKEY1                                       250804A
      *                                                                                      250804A
     C                   CALLB     'AOCUSTR1'                                                250804A
     C                   PARM      *Blanks       PRTCD                                       250804A
     C                   PARM      '*KEY   '     POPTN                                       250804A
     C                   PARM                    PKEY1                                       250804A
     C                   PARM                    PKYST                                       250804A
     C     SDCUST        PARM      SDCUST        DSLDY                                       250804A
      *                                                                                      250804A
     C                   IF        PRTCD = '*NRF   '                                         250804A
     C                   EVAL      BBCNA2 = *Blanks                                          250804A
     C                   ENDIF                                                               250804A
      *                                                                                      250804A
     C                   ENDIF                                                              AR978528
      ** Check if settings allow Numbers on Family Name                                       254721
     C                   CALLB     'AOSVALR0'                                                 254721
     C                   PARM      *BLANKS       PRtCd             7                          254721
     C                   PARM      NumericOnFNamePSysVal01                                    254721
     C                   PARM                    PCurSet01                                    254721
     C                   PARM                    PSysVal02                                    254721
     C                   PARM                    PCurSet02                                    254721
     C                   PARM                    PSysVal03                                    254721
     C                   PARM                    PCurSet03                                    254721
     C                   PARM                    PSysVal04                                    254721
     C                   PARM                    PCurSet04                                    254721
     C                   PARM                    PSysVal05                                    254721
     C                   PARM                    PCurSet05                                    254721
     C                   PARM                    PSysVal06                                    254721
     C                   PARM                    PCurSet06                                    254721
     C                   PARM                    PSysVal07                                    254721
     C                   PARM                    PCurSet07                                    254721
     C                   PARM                    PSysVal08                                    254721
     C                   PARM                    PCurSet08                                    254721
     C                   PARM                    PSysVal09                                    254721
     C                   PARM                    PCurSet09                                    254721
     C                   PARM                    PSysVal10                                    254721
     C                   PARM                    PCurSet10                                    254721
                                                                                              254721
     C                   If        PRtCd <> *Blanks                                           254721
     C     *LOCK         In        LDA                                                        254721
     C                   Eval      DBFile = 'SDSVALPD'                                        254721
     C                   Eval      DBase = 1                                                  254721
     C                   Eval      DBKey = PSysVal01                                          254721
     C                   Out       LDA                                                        254721
     C                   ExSR      *PSSR                                                      254721
     C                   EndIf                                                                254721
                                                                                              254721
      ** Isolate the first character of the current system value setting                      254721
     C                   MOVEL     PCurSet01     WRK01             1                          254721
     C                   If        WRK01 = 'N'                                                254721
     C                   Move      'N'           NmbrOnFname       1                          254721
     C                   Else                                                                 254721
     C                   Move      'Y'           NmbrOnFname                                  254721
     C                   EndIf                                                                254721
      ** Initialization
 
     C                   EVAL      RetCodeIn = *Blanks
     C                   EVAL      FldNamXAr = *Blanks
     C                   EVAL      MsgIDXAr  = *Blanks
     C                   EVAL      MsgDtaXAr = *Blanks
     C                   EVAL      Idx = 0
 
      ** Validation
 
     C                   EXSR      SRVCNA2
 
      ** If an error was found, set the return code appropriately
 
     C                   IF        DDOKCNA2 = 'N'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
 
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRVCNA2 - Validate First Name                                 *
      *                                                               *
      *****************************************************************
 
     C     SRVCNA2       BEGSR
 
      ***Set*up*First*Name,*default*to*BBCNA2*when*blank***************            BUG16243 BUG17464
      *                                                                            BUG16243 BUG17464
     C**********         IF        DDCNA2 = *Blanks                                BUG16243 BUG17464
     C**********         EVAL      DDCNA2 = BBCNA2                                 BUG16243 BUG17464
     C**********         ENDIF                                                     BUG16243 BUG17464
      *                                                                            BUG16243 BUG17464
      ***First*Name*is Mandatory                                                              232543
      ** First Name is Mandatory if Status is 'D'isclosed                                     232543
      ** and Joint A/c Type is 'I' or 'Y' (not 'N')                                           232543
 
     C                   IF        DDCNA2 = *Blanks
     C                             And PTaxStat = 'D'                                         232543
     C                             And PJACType <>' N'                                        232543
     C                   EVAL      DDOKCNA2 = 'N'
     C                   ADD       1             Idx
     C                   MOVEL     'DDCNA2'      FldNamXAr(Idx)
als  C                   MOVEL     'USR4770'     MsgIDXAr(Idx)
     C                   GOTO      ENDVAL
     C                   ENDIF
                                                                                            BUG22667
      ** Set up First Name, default to BBCNA2 when blank                                    BUG22667
      ** And for customer only (not for non account holder)                                 AR978528
                                                                                            BUG22667
     C                   IF        DDCNA2 = *Blanks                                         BUG22667
     C**********                   AND DDCUST <> *BLANKS                           AR978528 MD021510
     C                             AND DDCUST <> *BLANKS AND                                MD021510
     C                             DDACTN = 'I'                                             MD021510
     C                   EVAL      DDCNA2 = BBCNA2                                          BUG22667
     C                   ENDIF                                                              BUG22667
 
      ** First Name should start with a character
 
     C                   EVAL      FirstName = %TRIML(DDCNA2)
     C                   EVAL      FirstChar = %SUBST(FirstName:1:1)
 
     C                   IF        NmbrOnFname = 'N'                                          254721
     C                   IF        FirstChar = '0' OR FirstChar  = '1' or
     C                             FirstChar = '2' OR FirstChar  = '3' or
     C                             FirstChar = '4' OR FirstChar  = '5' or
     C                             FirstChar = '6' OR FirstChar  = '7' or
     C                             FirstChar = '8' OR FirstChar  = '9'
     C                   EVAL      DDOKCNA2 = 'N'
     C                   ADD       1             Idx
     C                   MOVEL     'DDCNA2'      FldNamXAr(Idx)
als  C                   MOVEL     'USR1660'     MsgIDXAr(Idx)
     C                   GOTO      ENDVAL
     C                   ENDIF
     C                   Endif                                                                254721
 
      ** Set up First Name, default to BBCNA2 when blank                                     250804A
      *                                                                                      250804A
     C**********         IF        DDCNA2 = *Blanks                                 250804A BUG16243
     C**********         EVAL      DDCNA2 = BBCNA2                                  250804A BUG16243
     C**********         ENDIF                                                      250804A BUG16243
      *                                                                                      250804A
     C     ENDVAL        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *Entry        PLIST
 
      ** INPUTS
      ** Return Code
     C                   PARM                    RetCodeIn
 
      ** Other parms
      ** Customer Number                                                                     250804A
     C                   PARM                    DDCUST                                      250804A
      *                                                                                      250804A
      ** Family Name
     C                   PARM                    DDCNA2
 
      ** Tax Status                                                                           232543
     C                   PARM                    PTaxStat                                     232543
                                                                                              232543
      ** Joint A/c Type                                                                       232543
     C                   PARM                    PJACType                                     232543
                                                                                              232543
                                                                                            MD022651
      ** Action Code                                                                        MD022651
                                                                                            MD022651
     C                   PARM                    DDACTN                                     MD022651
      ** OUTPUTS
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Tax Identification Number - OK
     C                   PARM                    DDOKCNA2
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *********************************************************************
      /EJECT
      *********************************************************************
      *                                                                   *
      * *PSSR  - Program exception error routine                          *
      *          Called automatically if a program error occurs,          *
      *          or directly by the program code using EXSR.              *
      *          This subroutine DUMPs the program just once.             *
      *                                                                   *
      *********************************************************************
 
     C     *PSSR         BEGSR
 
     C                   DUMP
 
     C                   IF        @RUN = *Blanks
     C                   EVAL      @RUN = 'Y'
 
     C                   CALLB     'DBERRCTL'
 
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
      ********************************************************************
** CTDATA CPY@
(c) Misys International Banking Systems Ltd. 2004
