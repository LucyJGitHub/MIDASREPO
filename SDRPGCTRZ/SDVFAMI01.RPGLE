     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Validate Family Name')                        *
      *****************************************************************
      *                                                               *
      *  Midas - Midas Standing Data Module                           *
      *                                                               *
      *  SDVFAMI01 - Validate Family Name                             *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. MD050145           Date 30Jan19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 MD021510           Date 09Aug13               *
      *                 CER059             Date 19Jul10               *
      *                 BUG22667           Date 11Feb09               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256481B            Date 24Nov08               *
      *                 256564             Date 17Sep08               *
      *                 254721             Date 30May08               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG10069           Date 25Jan06               *
      *                 232543             Date 14Mar05               *
      * Midas Release 4.04 -------------------------------------------*
      *                 CGL031  *CREATE    Date 05Jul04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD050145 - Wrong defaulting of Account Owner/Family,         *
      *             Company Name/First Street of Residence 1,2 fields *
      *             in Additional Customer Details 1 on Amend         *
      *             Applied for MD052499.                             *
      *  MD046248 - Finastra Rebranding                               *
      *  MD021510 -  Account Owner/Family and Company Name/First Name *
      *              are being populated from Repair Queue even no    *
      *              value is passed Edit                             *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG22667 - Session time out occurs when entering data in     *
      *             ACUD                                              *
      *  256481B - Do not default value for Additional Customer Name  *
      *            and Address if system value is not required        *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  254721 - Added checking on SDSVALPD re: details on Family    *
      *           Name.  MidasR4 allows Number on Family Name.        *
      *  BUG10069 - If no customer details exist, check the shadow    *
      *             file.                                             *
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
 
      ** Midas SD Customer Details Retrieval Shadow File                                    BUG10069
     FSDCDSHL1  IF   E           K DISK    INFSR(*PSSR)                                     BUG10069
     F                                     RENAME(@BBREBF:SDCDSHD1)                         BUG10069
 
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
     D SVAL02          C                   CONST('AdditionalNameAddres')                     256481B
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** External DS for Country Details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
 
      ** Long DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      **  Data Structure for AOSVALR0 string                                                 256481B
     DPCurSet02        DS           200                                                      256481B
     DSVAL11                   1      1                                                      256481B
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
 
     D @RUN            S              1A
     D***DDCUST          S              1A                                                    232543
     D DDCUST          S              6A                                                      232543
     D DDCNA1          S             70A
     D DDOKCNA1        S              1A
     D FamilyName      S             70A
     D FirstChar       S              1A
     D PTaxStat        S              1A                                                      232543
     D PJACType        S              1A                                                      232543
     D DDACTN          S              1A                                                    MD021510
 
      ** Parameter for Access Object
     D PRTCD           S              7A
     D POPTN           S              7A
     D PKEY1           S             10A
     D PKYST           S              7A
                                                                                              254721
     D PSysVal01       S             20A   INZ(*Blanks)                                       254721
     D PCurSet01       S            200A                                                      254721
     D PSysVal02       S             20A                                                      254721
     D*PCurSet02       S            200A                                              254721 256481B
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
 
      ** Initial Processing
 
     C                   EXSR      SRInit
 
      ** Validation
 
     C                   EXSR      SRVCNA1
 
      ** If an error was found, set the return code appropriately
 
     C                   IF        DDOKCNA1 = 'N'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRVCNA1 - Validate Family Name                                *
      *                                                               *
      *****************************************************************
 
     C     SRVCNA1       BEGSR
      **********                                                                   BUG22667 MD050145
      ***Set*up*Family*Name,*default*to*BBCNA1*when*blank**************            BUG22667 MD050145
      **********                                                                   BUG22667 MD050145
     C**********         IF        DDCNA1 = *Blanks                                BUG22667 MD021510
     C**********         IF        DDCNA1 = *BLANKS AND                            MD021510 MD050145
     C**********                   DDACTN = 'I'                                    MD021510 MD050145
     C**********         EVAL      DDCNA1 = BBCNA1                                 BUG22667 MD050145
     C**********         ENDIF                                                     BUG22667 MD050145
 
      ** Family Name should start with a character
 
     C**********         IF        DDCNA1 <> *Blanks                                          254721
     C                   IF        DDCNA1 <> *Blanks                                          254721
     C                             And NmbrOnFname = 'N'                                      254721
     C                   EVAL      FamilyName = %TRIML(DDCNA1)
     C                   EVAL      FirstChar = %SUBST(FamilyName:1:1)
 
     C                   IF        FirstChar = '0' OR FirstChar  = '1' or
     C                             FirstChar = '2' OR FirstChar  = '3' or
     C                             FirstChar = '4' OR FirstChar  = '5' or
     C                             FirstChar = '6' OR FirstChar  = '7' or
     C                             FirstChar = '8' OR FirstChar  = '9'
     C                   EVAL      DDOKCNA1 = 'N'
     C                   ADD       1             Idx
     C                   MOVEL     'DDCNA1'      FldNamXAr(Idx)
als  C                   MOVEL     'USR1660'     MsgIDXAr(Idx)
     C                   GOTO      ENDVAL
     C                   ENDIF
     C                   ENDIF
 
      ***Set*up*Family Name, default to BBCNA1 when blank                                   BUG22667
      **********                                                                            BUG22667
     C**********         IF        DDCNA1 = *Blanks                                         BUG22667
     C                   IF        SVAL11='Y'                                                256481B
     C**********         EVAL      DDCNA1 = BBCNA1                                          BUG22667
     C                   ENDIF                                                               256481B
     C**********         ENDIF                                                              BUG22667
 
      ** If Family Name is still blank, this will be a mandatory entry
      ** if Status is 'D'isclosed                                                             232543
      ** and Joint A/c Type is 'I' or 'Y' (not 'N')                                           232543
 
     C                   IF        DDCNA1 = *Blanks
     C                             And PTaxStat = 'D'                                         232543
     C                             And PJACType <> 'N'                                        232543
     C                   EVAL      DDOKCNA1 = 'N'
     C                   ADD       1             Idx
     C                   MOVEL     'DDCNA1'      FldNamXAr(Idx)
als  C                   MOVEL     'USR4769'     MsgIDXAr(Idx)
     C                   GOTO      ENDVAL
     C                   ENDIF
 
     C     ENDVAL        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRInit - Initial Processing                                   *
      *                                                               *
      *****************************************************************
 
     C     SRInit        BEGSR
 
      ** Check customer details
 
     C                   MOVEL     DDCUST        PKEY1
 
     C                   CALLB     'AOCUSTR0'
     C                   PARM      *Blanks       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM                    PKEY1
     C                   PARM                    PKYST
     C     SDCUST        PARM      SDCUST        DSSDY
 
     C                   IF        PRTCD = '*NRF   '
     C     DDCUST        CHAIN     SDCDSHL1                                                 BUG10069
     C                   IF        NOT %FOUND                                               BUG10069
     C                   EVAL      BBCNA1 = *Blanks
     C                   ENDIF                                                              BUG10069
     C                   ENDIF
                                                                                              254721
      ** Check if settings allow Numbers on Family Name                                       254721
     C                   CALLB     'AOSVALR0'                                                 254721
     C                   PARM      *BLANKS       PRtCd             7                          254721
     C                   PARM      NumericOnFNamePSysVal01                                    254721
     C                   PARM                    PCurSet01                                    254721
     C                   PARM      SVAL02        PSysVal02                            254721 256481B
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
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *Entry        PLIST
 
      ** INPUTS
      ** Return Code
     C                   PARM                    RetCodeIn
 
      ** Customer Number
     C                   PARM                    DDCUST
 
      ** Family Name
     C                   PARM                    DDCNA1
 
      ** Tax Status                                                                           232543
     C                   PARM                    PTaxStat                                     232543
                                                                                              232543
      ** Joint A/c Tupe                                                                       232543
     C                   PARM                    PJACType                                     232543
                                                                                            MD021510
      ** Action Code                                                                        MD021510
     C                   PARM                    DDACTN                                     MD021510
                                                                                              232543
      ** OUTPUTS
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Tax Identification Number - OK
     C                   PARM                    DDOKCNA1
 
 
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
      * Called by: (**calling routines**)                                 *
      *                                                                   *
      * Calls: None                                                       *
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
(c) Finastra International Limited 2004
