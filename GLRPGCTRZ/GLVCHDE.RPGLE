     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*OVRF*: OVRDBF FILE(REIACXX) TOFILE(REIAC) SHARE(*NO)              : *
/*OVRF*: OVRDBF FILE(ACCNTLXX) TOFILE(ACCBR) SHARE(*NO)             : *
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Validate Charges Details')                    *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GLVCHDE    - Validate Charges Details                        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. MD046635           Date 10Aug17               *
      *  Prev Amend No. AR676213           Date 19Nov10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 222462             Date 06Jun06               *
      *                 238915             Date 27Mar06               *
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG11017           Date 03Apr06               *
      *                 CGL029             Date 01Sep03               *
      *                 217559             Date 14May03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP035  *CREATE    Date 19Mar99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046635 - User permissions are not verified on account      *
      *             input via AMAD API. Change the validation so that *
      *             the user inserting an account is always validated *
      *             to have authority to the branch of the account.   *
      *  AR676213 - Incorrect definition of CLGLAI field (Recompile)  *
      *           (Child: AR676229)                                   *
      *  222462 - There is no check that the alternate account is     *
      *           live.                                               *
      *  238915 - Correct definition of ACCKYK to prevent incorrect   *
      *           validation of alternative account.                  *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG11017 - Use correct Message Id when Alternate Account for *
      *             charges is already used by another account.       *
      *  CGL029 - Increase account code to 10 digits                  *
      *  217559 - CRE008 Fix - if Top Account, Alternative A/c        *
      *           should be mandatory and must be a Sub-A/c in the    *
      *           same hierarchy                                      *
      *  CAP035 - Midas/ToF Interface                                 *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *****************************************************************
 
      ** RE Account Numbers File
     FACNUM     IF   E           K DISK    INFSR(*PSSR)
 
      ** RE Interest and Charges File
     FREIACXX   IF   E           K DISK    INFSR(*PSSR)
 
      ** GL Account by Branch
     FACCNTLXX  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(ACCNTABF:ACCNTLXF)
 
      ** RE Charges Details
     FRECRG     IF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(RECRGAF)
     F                                     IGNORE(RECRGZF)
     FREGAHLJ0  IF   E           K DISK    INFSR(*PSSR)                                       217559
     F                                     RENAME(REGAHLD0:REGAHLXX)                          217559
     F                                     PREFIX(S_)                                         217559
     FREGAHLJ1  IF   E           K DISK    INFSR(*PSSR)                                       217559
 
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
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
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
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** The maximum size of the appended error arrays
     D XArrayMax       C                   CONST(20)
 
     D @NDIGT          C                   CONST('0123456789')
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Array of Fields in error.
     D FldNamXAr       S             10A   DIM(XArrayMax)
 
      ** Array of error message IDs
     D MsgIDXAr        S                   DIM(XArrayMax) LIKE(#MsgId)
 
      ** Array of error message data.
     D MsgDtaXAr       S                   DIM(XArrayMax) LIKE(#MsgData)
 
     D                 DS
     D***ACKEY1*                1     15                                                      CGL029
     D  ACKEY1                 1     21                                                       CGL029
     D  WWCNUM                 1      6
     D  WWCCY                  7      9
     D***WWACOD*               10     13                                                      CGL029
     D***WWACSQ*               14     15                                                      CGL029
     D  WWACOD                10     19                                                       CGL029
     D  WWACSQ                20     21                                                       CGL029
 
     D                 DS
     D***ACKEYK*                1     18                                                      CGL029
     D  ACKEYK                 1     24                                                       CGL029
     D**WWCUSK**               1      6  0                                                    CSD027
     D  WWCUSK                 1      6                                                       CSD027
     D  WWCCYK                 7      9
     D***WWACOK*               10     13  0                                                   CGL029
     D***WWACSK*               14     15  0                                                   CGL029
     D***WWBRCK*               16     18                                                      CGL029
     D  WWACOK                10     19  0                                                    CGL029
     D  WWACSK                20     21  0                                                    CGL029
     D  WWBRCK                22     24                                                       CGL029
     D  RETKK                  1     10  0
     D  ACCKYK                11     21                                                       238915
     D***ACCKYK*               11     15                                                      CGL029
     D**ACCKYK**              11     24                                                CGL029 238915
 
     D                 DS
     D  KEY                    1     12
     D  BLANC                  1      1    INZ(' ')
     D  ICTYPE                 2      3
     D  ICSTYP                 4      8
     D  ICCCY                  9     11
     D  D                     12     12    INZ('D')
 
      ** Switchable Features Details File                                       217559
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                    217559
      *                                                                         217559
      ** External data structure for branch codes file
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
 
      ** First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
     DA6NBDP           S              1S 0
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
                                                                                              CGL029
     D DDCHCP          S             21                                                       CGL029
     D DDACOD          S             10                                                       CGL029
     D WGAACOD         S             10  0                                                    CGL029
      *                                                                                       CGL029
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CGL029
      *                                                                                       CGL029
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Initialization
 
     C                   MoveL     *Blanks       RetCodeIn
     C                   MoveL     *Blanks       FldNamXAr
     C                   MoveL     *Blanks       MsgIDXAr
     C                   MoveL     *Blanks       MsgDtaXAr
     C                   Z-Add     0             Idx
     C                   MOVE      ' '           WTop              1                          217559
     C     CRE008        IFEQ      'Y'                                                        217559
     C**********         MOVE      DDCUSN        WGACNUM           6 0                 217559 CSD027
     C                   MOVE      DDCUSN        WGACNUM           6                          CSD027
     C**********         MOVE      DDACOD        WGAACOD           4 0                 217559 CGL029
     C                   MOVE      DDACOD        WGAACOD                                      CGL029
     C                   MOVE      DDACSQ        WGAACSQ           2 0                        217559
     C     CMKEY1        CHAIN     REGAHLJ1                           81                      217559
     C     *IN81         IFEQ      *Off                                                       217559
     C                   MOVE      'Y'           WTop                                         217559
     C                   Endif                                                                217559
     C                   Endif                                                                217559
      *
      ** CHARGE TYPE & SUB-TYPE
     C     DDCHGT        IFNE      *BLANKS
     C     DDCHST        ORNE      *BLANKS
     C                   MOVE      DDCHGT        ICTYPE
     C                   MOVE      DDCHST        ICSTYP
     C                   MOVE      DDCCY         ICCCY
     C     KEY           CHAIN     RECRGDF                            50
     C                   If        *IN50
     C                   Move      'N'           DDCHGTOk
     C                   Move      'N'           DDCHSTOk
     C                   Add       1             Idx
     C                   MoveL     'DDCHGT'      FldNamXAr(Idx)
     C                   MoveL     'RE71326'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   ENDIF
      *
      ** Validate Charge Branch
      *
      *  If alternate entry Charge condition must exist
     C     DDCHCP        IFEQ      *BLANK
     C                   MOVE      *BLANKS       DDCHBR
      *                                                                                       217559
      ** Alternate entry is mandatory if Top Account                                          217559
     C     WTop          Ifeq      'Y'                                                        217559
     C     DDCHGT        ANDNE     *blanks                                                    217559
     C     DDCHGTOk      ANDNE     'N'                                                        217559
     C                   Move      'N'           DDCHCPOk                                     217559
     C                   Move      'N'           DDCHBROk                                     217559
     C                   Add       1             Idx                                          217559
     C                   MoveL     'DDCHCP'      FldNamXAr(Idx)                               217559
     C                   MoveL     'RE76017'     MsgIDXAr(Idx)                                217559
     C                   Endif                                                                217559
     C                                                                                        217559
     C                   ELSE
      *
     C     DDCHBR        IFEQ      *BLANKS
     C                   MOVE      DBRN          DDCHBR
     C                   ENDIF
      *
     C     DDCHGT        IFEQ      *BLANKS
     C     DDCHST        ANDEQ     *BLANKS
     C                   Move      'N'           DDCHCPOk
     C                   Move      'N'           DDCHBROk
     C                   Add       1             Idx
     C                   MoveL     'DDCHCP'      FldNamXAr(Idx)
     C                   MoveL     'RE71327'     MsgIDXAr(Idx)
     C                   ELSE
      *
     C                   MOVE      DDCUSN        WWCNUM
     C                   MOVE      DDCCY         WWCCY
     C                   MOVE      DDACOD        WWACOD
     C                   MOVE      DDACSQ        WWACSQ
      *
      ** If alternate entry Can not be the account itself
     C     DDCHCP        IFEQ      ACKEY1
     C     DDCHBR        ANDEQ     DDBRCA
     C     DDCHCP        OREQ      DDACNO
     C                   Move      'N'           DDCHCPOk
     C                   Move      'N'           DDCHBROk
     C                   Add       1             Idx
     C                   MoveL     'DDCHCP'      FldNamXAr(Idx)
     C                   MoveL     'RE71328'     MsgIDXAr(Idx)
      *
      ** If alternate entry and amend mode the account can not be the
      ** alternate of another account.
     C                   ELSE
      *
     C     DDACTN        IFEQ      'A'
     C     WIN44         ANDEQ     '1'
     C                   Move      'N'           DDCHCPOk
     C                   Move      'N'           DDCHBROk
     C                   Add       1             Idx
     C                   MoveL     'DDCHCP'      FldNamXAr(Idx)
     C**********         MoveL     'RE71326'     MsgIDXAr(Idx)                              BUG11017
     C                   MoveL     'RE71351'     MsgIDXAr(Idx)                              BUG11017
      *
     C                   ELSE
      *
      ** Format of entry must be Retail A/c Number or Full Account
     C     @NDIGT        CHECK     DDCHCP        @POSN1            3 0
     C     @NDIGT        CHECK     DDCHCP:10     @POSN2            3 0
     C     ' '           CHECK     DDCHCP:11     @POSN3            3 0
      *
     C                   SELECT
     C*****@POSN1        WHENEQ    11                                                         CSD027
     C     @POSN1        WHENLE    11                                                         CSD027
     C     @POSN3        ANDEQ     *ZERO
      *
     C*****@POSN1        WHENEQ    7                                                          CSD027
     C     @POSN1        WHENLE    7                                                          CSD027
     C     @POSN2        ANDEQ     *ZERO
      *
     C                   OTHER
     C                   Move      'N'           DDCHCPOk
     C                   Move      'N'           DDCHBROk
     C                   Add       1             Idx
     C                   MoveL     'DDCHCP'      FldNamXAr(Idx)
     C                   MoveL     'RE71328'     MsgIDXAr(Idx)
     C                   ENDSL
      *
      *  If alternate entry account must exist and be live.
      *  alternate of another account.
     C                   MOVEL     *BLANKS       ACKEYK
     C                   MOVEL     DDCHCP        ACKEYK
     C                   MOVE      DDCHBR        WWBRCK
     C     ACCKYK        IFEQ      *BLANK
     C                   MOVE      *BLANK        DDCHBR
     C                   MOVE      *BLANK        WWBRCK
     C                   Z-ADD     RETKK         WURKEY           10 0
      *
     C     WURKEY        CHAIN     ACNUM                              80
      *
     C     *IN80         IFEQ      '1'
      *
      **  Alternative account doesn't exist in FILE : ACCNTLXX OR ACNUM
      *
     C                   Move      'N'           DDCHCPOk
     C                   Move      'N'           DDCHBROk
     C                   Add       1             Idx
     C                   MoveL     'DDCHCP'      FldNamXAr(Idx)
     C                   MoveL     'RE71328'     MsgIDXAr(Idx)
     C                   ELSE
      *
      **  Alternative account exist in FILE : ACNUM  Setup key
      *
     C                   MOVE      CNUM          WWCUSK
     C                   MOVE      CCY           WWCCYK
     C                   MOVE      ACOD          WWACOK
     C                   MOVE      ACSQ          WWACSK
     C                   MOVE      BRCA          WWBRCK
     C                   MOVE      BRCA          DDCHBR                                     MD046635
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C     Idx           IFEq      0
     C*****WWACK3****    SETLL     ACCNTLXX                               80                  222462
      *
      **  ALTERNATIVE ACCOUNT DOESN'T EXIST IN FILE : ACCNTLXX OR ACNUM
     C******IN80         IFEQ      '0'                                                        222462
     C     WWACK3        CHAIN     ACCNTLXX                           80                      222462
     C     *IN80         IFEQ      '1'                                                        222462
     C     *IN80         OREQ      '0'                                                        222462
     C     ACST          ANDNE     ' '                                                        222462
     C                   Move      'N'           DDCHCPOk
     C                   Move      'N'           DDCHBROk
     C                   Add       1             Idx
     C                   MoveL     'DDCHCP'      FldNamXAr(Idx)
     C                   MoveL     'RE71328'     MsgIDXAr(Idx)
      *
     C                   ELSE
      *
     C**********         CALL      'AOBRCHR0'                                                 CGL029
     C                   CALL      'AOBRCHR1'                                                 CGL029
     C                   PARM      '*MSG   '     @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      WWBRCK        @BRCA             3
     C*****SDBRCH        PARM      SDBRCH        DSFDY                                        CGL029
     C     SDBRCH        PARM      SDBRCH        DSSDY                                        CGL029
      *
     C     @RTCD         IFNE      *BLANKS
     C                   Move      'N'           DDCHCPOk
     C                   Move      'N'           DDCHBROk
     C                   Add       1             Idx
     C                   MoveL     'DDCHCP'      FldNamXAr(Idx)
     C                   MoveL     'RE71856'     MsgIDXAr(Idx)
     C                   ENDIF
      *
      **  Alternative account can not have any alternate.
      *
      ** Only if retail
     C     WWACK2        CHAIN     REIACDF                            80
     C     *IN80         IFEQ      '0'
     C     DACP          IFNE      *BLANKS
     C     CACP          ORNE      *BLANKS
     C     CHAC          ORNE      *BLANKS
     C                   Move      'N'           DDCHCPOk
     C                   Move      'N'           DDCHBROk
     C                   Add       1             Idx
     C                   MoveL     'DDCHCP'      FldNamXAr(Idx)
     C                   MoveL     'RE71324'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *                                                                                       217559
      * Further Testing for Alternate Account                                                 217559
     C     WTop          IFEQ      'Y'                                                        217559
     C     DDCHCP        ANDNE     *blanks                                                    217559
     C     DDCHCPOk      ANDNE     'N'                                                        217559
     C     DDCHBROk      ANDNE     'N'                                                        217559
     C*                                                                                       217559
      *  If Top Account,  Alternate account must be sub account of Top Account                217559
     C     WWACK2        CHAIN     REGAHLJ0                           81                      217559
     C     *IN81         IFEQ      *ON                                                        217559
     C     *IN81         OREQ      *Off                                                       217559
     C     S_CLHIER      ANDNE     CLHIER                                                     217559
     C                   Move      'N'           DDCHCPOk                                     217559
     C                   Move      'N'           DDCHBROk                                     217559
     C                   Add       1             Idx                                          217559
     C                   MoveL     'DDCHCP'      FldNamXAr(Idx)                               217559
     C                   MoveL     'RE76018'     MsgIDXAr(Idx)                                217559
     C                   Endif                                                                217559
     C                   Endif                                                                217559
      *
      **   TRANSACTION CHARGE OVERIDE
      *
      ** If Transaction Charges is on table file TABTBRE
     C     TCAL          IFEQ      'Y'
      *
     C     DDCHGT        IFEQ      *BLANKS
     C     DDCHST        ANDEQ     *BLANKS
     C     DDTCHO        ANDNE     *BLANKS
     C                   Move      'N'           DDTCHOOk
     C                   Add       1             Idx
     C                   MoveL     'DDTCHO'      FldNamXAr(Idx)
     C                   MoveL     'RE71329'     MsgIDXAr(Idx)
     C                   ENDIF
      *
     C     DDTCHO        IFNE      *BLANKS
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      DDTCHO        ZFIELD
     C                   Z-ADD     A6NBDP        ZADEC
     C     7             SUB       A6NBDP        ZADIG
      *
      ** CHECK VALID FORMAT
     C                   CallB     'ZALIGN'
     C                   Parm                    ZAlignOk          1
     C                   Parm      DDTCHO        ZField           16
     C                   Parm                    ZADec             1 0
     C                   Parm                    ZADig             2 0
      *
     C     ZAlignOk      IfNe      'Y'
     C                   Move      'N'           DDTCHOOk
     C                   Add       1             Idx
     C                   MoveL     'DDTCHO'      FldNamXAr(Idx)
     C                   MoveL     'RE71330'     MsgIDXAr(Idx)
     C                   ELSE
     C                   MOVE      ZFIELD        WNTCHO
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      ** If an error was found, set the return code appropriately
      *
     C     DDCHGTOk      IfEq      'N'
     C     DDCHSTOk      OrEq      'N'
     C     DDCHBROk      OrEq      'N'
     C     DDCHCPOk      OrEq      'N'
     C     DDTCHOOk      OrEq      'N'
     C                   Eval      RetCodeIn = 'Error'
     C                   EndIf
      *
      ** RETURN
      *
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *Entry        Plist
      *
      ** INPUTS
      *
      ** Return Code
     C                   Parm                    RetCodeIn
      *
      ** Account Screen fields
     C                   Parm                    DDCHGT            2
     C                   Parm                    DDCHST            5
     C                   Parm                    DDCHBR            3
     C**********         Parm                    DDCHCP           15                          CGL029
     C                   Parm                    DDCHCP                                       CGL029
     C                   Parm                    DDTCHO            7
     C                   Parm                    DDACNO           10
     C                   Parm                    DDACTN            1
     C                   Parm                    DDBRCA            3
     C                   Parm                    DDCUSN            6
     C                   Parm                    DDCCY             3
     C**********         Parm                    DDACOD            4                          CGL029
     C                   Parm                    DDACOD                                       CGL029
     C                   Parm                    DDACSQ            2
      *
     C                   Parm                    WIN44             1
      *
      ** ICD
     C                   Parm                    DBRN              3
     C                   Parm                    A6NBDP
     C                   Parm                    TCAL              1
      *
      ** OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
      *
     C                   Parm                    WNTCHO            7 0
      *
      ** Charges Calculation Type - Ok
      ** Charges Calculation Subtype - Ok
      ** Alternate A/C Charges Branch - Ok
      ** Alternate A/C Charges Account - Ok
      ** Transaction Charges Override - Ok
     C                   Parm                    DDCHGTOk          1
     C                   Parm                    DDCHSTOk          1
     C                   Parm                    DDCHBROk          1
     C                   Parm                    DDCHCPOk          1
     C                   Parm                    DDTCHOOk          1
      *                                                                                       217559
     C                   CALL      'AOSARDR0'                                                 217559
     C                   PARM      *Blanks       @Rtcd             7                          217559
     C                   PARM      '*KEY   '     @Optn             7                          217559
     C                   PARM      'CRE008'      WSard             6                          217559
     C     SCSARD        PARM      SCSARD        DSFDY                                        217559
      *                                                                                       217559
     C                   IF        @Rtcd = *Blank                                             217559
     C                   MOVEL     'Y'           CRE008            1                          217559
     C                   ELSE                                                                 217559
     C                   EVAL      CRE008 = 'N'                                               217559
     C                   ENDIF                                                                217559
      *                                                                                       217559
      *
      ** KEY LIST TO ACCESS ALTERNATIVE ACCOUNTS ON REAIC
     C     WWACK2        KLIST
     C                   KFLD                    WWCUSK
     C                   KFLD                    WWCCYK
     C                   KFLD                    WWACOK
     C                   KFLD                    WWACSK
     C                   KFLD                    WWBRCK
      *
      ** KEY LIST TO ACCESS ALTERNATIVE ACCOUNTS ON ACCBR
     C     WWACK3        KLIST
     C                   KFLD                    WWBRCK
     C                   KFLD                    WWCUSK
     C                   KFLD                    WWCCYK
     C                   KFLD                    WWACOK
     C                   KFLD                    WWACSK
      *                                                                                       217559
      ** KEY LIST TO ACCESS REGAHLJ1                                                          217559
     C     CMKEY1        KLIST                                                                217559
     C                   KFLD                    WGACNUM                                      217559
     C                   KFLD                    DDCCY                                        217559
     C                   KFLD                    WGAACOD                                      217559
     C                   KFLD                    WGAACSQ                                      217559
     C                   KFLD                    DDBRCA                                       217559
      *
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
(c) Misys International Banking Systems Ltd. 2001
