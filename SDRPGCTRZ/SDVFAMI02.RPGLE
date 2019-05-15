     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Validate Family Name')
      *****************************************************************
      *                                                               *
      *  Midas - Midas Standing Data Module                           *
      *                                                               *
      *  SDVFAMI02 - Validate Family Name                             *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD033686           Date 27Jul15               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 254721             Date 30May08               *
      *                 BUG16741           Date 18Mar08               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 232543             Date 14Mar05               *
      * Midas Release 4.04 -------------------------------------------*
      *                 CGL031  *CREATE    Date 05Jul04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD033686 - With CRE047, Family Name is mandatory.            *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  254721 - Added checking on SDSVALPD re: details on Family    *
      *           Name.  MidasR4 allows Number on Family Name.        *
      *  BUG16741 - Family name and street 2 not defaulting values    *
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
 
     D DSFDY         E DS                  Extname(DSFDY)                                   MD033686
     D SCSARD        E DS                  Extname(SCSARDPD)                                MD033686
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
 
     D @RUN            S              1
     D**DDCNA1********  S             70                                                    BUG16741
     D DDCNA1          S             35                                                     BUG16741
     D DDIDE1          S             70
     D DDOKIDE1        S              1
     D FamilyName      S             70
     D FirstChar       S              1
     D PTaxStat        S              1A                                                      232543
     D POptn           S              7A                                                    MD033686
     D CER047          S              1A                                                    MD033686
     D PSARD           S              6A                                                    MD033686
                                                                                              254721
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
 
     C                   EVAL      RetCodeIn = *BLANK
     C                   EVAL      FldNamXAr = *BLANK
     C                   EVAL      MsgIDXAr  = *BLANK
     C                   EVAL      MsgDtaXAr = *BLANK
     C                   EVAL      Idx = 0
 
      ** Validation
 
     C                   EXSR      SRVCNA1
 
      ** If an error was found, set the return code appropriately
 
     C                   IF        DDOKIDE1 = 'N'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
 
      ** Return
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRVCNA1 - Validate Family Name                                *
      *                                                               *
      *****************************************************************
 
     C     SRVCNA1       BEGSR
 
      ** Family Name is Mandatory
      ***if*Status*is*'D'isclosed**************************************              232543 BUG16741
 
     C                   IF        CER047 = 'N'                                             MD033686
     C                   IF        DDIDE1 = *Blanks
     C**********                   And PTaxStat = 'D'                                232543 BUG16741
     C                   EVAL      DDIDE1 = DDCNA1
     C                   ENDIF
     C                   ENDIF                                                              MD033686
 
      ** Family Name should start with a character
 
     C                   EVAL      FamilyName = %TRIML(DDIDE1)
     C                   EVAL      FirstChar = %SUBST(FamilyName:1:1)
 
     C                   IF        NmbrOnFname = 'N'                                          254721
     C                   IF        FirstChar = '0' OR FirstChar  = '1' OR
     C                             FirstChar = '2' OR FirstChar  = '3' OR
     C                             FirstChar = '4' OR FirstChar  = '5' OR
     C                             FirstChar = '6' OR FirstChar  = '7' OR
     C                             FirstChar = '8' OR FirstChar  = '9'
     C                   EVAL      DDOKIDE1 = 'N'
     C                   ADD       1             Idx
     C                   MOVEL     'DDIDE1'      FldNamXAr(Idx)
     C**********         MOVEL     'USR9169'     MsgIDXAr(Idx)                                232543
     C                   MOVEL     'USR1660'     MsgIDXAr(Idx)                                232543
     C                   GOTO      ENDVAL
     C                   ENDIF
     C                   Endif                                                                254721
 
     C                   EVAL      DDOKIDE1 = 'Y'
 
      ** If Family Name is still blank, this will be a mandatory entry                      BUG16741
      ** if Status is 'D'isclosed                                                           BUG16741
                                                                                            BUG16741
     C                   IF        DDIDE1 = *Blanks                                         BUG16741
     C                             And PTaxStat = 'D'                                       BUG16741
     C                             Or DDIDE1 = *Blanks and CER047 = 'Y'                     MD033686
     C                   EVAL      DDOKIDE1 = 'N'                                           BUG16741
     C                   ADD       1             Idx                                        BUG16741
     C                   MOVEL     'DDIDE1'      FldNamXAr(Idx)                             BUG16741
     C                   MOVEL     'USR4769'     MsgIDXAr(Idx)                              BUG16741
     C                   GOTO      ENDVAL                                                   BUG16741
     C                   ENDIF                                                              BUG16741
                                                                                            BUG16741
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
 
     C                   PARM                    DDCNA1
 
      ** Family Name
 
     C                   PARM                    DDIDE1
 
      ** Tax Status                                                                           232543
     C                   PARM                    PTaxStat                                     232543
                                                                                              232543
      ** OUTPUTS
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Tax Identification Number - OK
 
     C                   PARM                    DDOKIDE1
 
      *
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
      ** Call AOSARDR0 to check for CER047                                                  MD033686
      *                                                                                     MD033686
     C                   CALL      'AOSARDR0'                                               MD033686
     C                   PARM      *BLANKS       PRtcd                                      MD033686
     C                   PARM      '*VERIFY'     POptn                                      MD033686
     C                   PARM      'CER047'      PSard                                      MD033686
     C     SCSARD        PARM      SCSARD        DSFDY                                      MD033686
      *                                                                                     MD033686
     C                   IF        PRtcd = *BLANKS                                          MD033686
      *                                                                                     MD033686
     C                   EVAL      CER047 = 'Y'                                             MD033686
      *                                                                                     MD033686
     C                   ELSE                                                               MD033686
      *                                                                                     MD033686
     C                   EVAL      CER047 = 'N'                                             MD033686
      *                                                                                     MD033686
     C                   ENDIF                                                              MD033686
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
 
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
 
     C                   CALLB     'DBERRCTL'
 
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2004
