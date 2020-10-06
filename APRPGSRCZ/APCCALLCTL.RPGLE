     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AP Controller call controller')                  *
      *****************************************************************
      *                                                               *
      *  Midas - Application Programming Interfaces module            *
      *                                                               *
      *  APCCALLCTL - Controller call controller                      *
      *                                                               *
      *  Function:  This module determines which controller program   *
      *             is to be called based on transaction type;        *
      *             applies the necessary override; and calls the     *
      *             controller.                                       *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. CSD102             Date 08Jan19               *
      *                 MD040876           Date 26Aug16               *
      *                 MD046248           Date 27Oct17               *
      *                 CDL094             Date 11Jun14               *
      *                 CGL132             Date 01May13               *
      *                 CFT120             Date 28Sep12               *
      *                 CLE148             Date 23Jul12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CER059             Date 19Jul10               *
      *                 262664             Date 11Nov09               *
      *                 BUG25877           Date 03Sep09               *
      *                 CER034A            Date 19May08               *
      *                 CER030             Date 20Nov08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 CSW209             Date 01Apr09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 257681             Date 13Nov08               *
      *                 257300             Date 21Oct08               *
      *                 256407             Date 04Sep08               *
      *                 247158             Date 18Apr07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 241470             Date 07Sep06               *
      *                 BUG11857           Date 09Aug06               *
      *                 BUG9887            Date 12Jan06               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 CER001             Date 25Apr05               *
      *                 CLE031             Date 26Apr05               *
      *                 BUG7380            Date 01Jun05               *
      *                 BG5888             Date 03Mar05               *
      *                 CDL018             Date 03Feb04               *
      *                 221948             Date 01Sep03               *
      *                 CGL029             Date 01Sep03               *
      *                 CSE045             Date 24Mar03               *
      *                 CAS006             Date 21Jan03               *
      *                 214265             Date 07Feb03               *
      *                 CAP043             Date 02May02               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 209905             Date 25Sep02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAP056             Date 13Mar02               *
      *                 CSC011             Date 18Sep01               *
      *                 CSW024             Date 31Aug01               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CSE022             Date 29Mar01               *
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSD006             Date 28Feb01               *
      *                 CIR003             Date 13Sep00               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CFT014             Date 25May00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CAP039             Date 14Jul00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP035             Date 08Jul99               *
      *                 CAP034             Date 08Jul99               *
      *                 CAP031             Date 08Jul99               *
      *                 CAP051             Date 08Nov99               *
      *                 CDL007             Date 05Oct99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP006  *CREATE    Date 04Dec98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *           (Recompile)                                         *
      *  CSD102 - Password Length Extension (Recompile)               *
      *  MD040876 - CRS MQ                                            *
      *  MD046248 - Finastra Rebranding                               *
      *  CDL094 - Enhance Receive Settlement Instructions (recompile) *
      *  CGL132 - FATCA Phase 1 - Customers' Identification and       *
      *           Classification - Master                             *
      *  CFT120 - FT IN/OP - Charges to DR of Account Currency        *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  262664 - GF Phase 1 - Incorrect parameter - FTIPAYCTL /      *
      *           FTOPAYCTL.                                          *
      *         - Corrected the parameters.                           *
      *  BUG25877 - Data is always truncated and ends in ACUD repair  *
      *  CER034A - German Features - New Fields and Enquiries         *
      *  CER030 - Multi Cash german Features                          *
      *  CSW209 - SWIFT 2009 Changes                                  *
      *  257681 - FEES not taking settlement details correctly        *
      *  257300 - FTIPAY is looping after FTOPAY                      *
      *  256407 - Changes to allow Lending APIs to pass message back  *
      *  247158 - Review parameter list for SETRAD and CSE045.        *
      *  241470 - Applied fix BUG9887.                                *
      *  BUG9887 - No information passed to IRCIRSCTL at all...       *
      *  BUG11857 - Include InfData to T2_LOANRLX, T2_PTPURLX, T2_PTSO*
      *             RLX, T1PRFRLX and T1_5RLX.                        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CER001 - LUX Update to MidasPlus                             *
      *  CLE031 - Lending Enhancements - Settlement Currency Recompile*
      *  BUG7380- Changes missing for CAS006                          *
      *  BG5888 - Changes missing for CAP074 Lending inputs           *
      *  CDL018 - Multiple Settlement Accounts on Loans/Deposits      *
      *           (Recompile)                                         *
      *  221948 - Parameter mismatch                                  *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CSE045 - API for Extended Settlement for Trade Input and     *
      *           Depot Movement                                      *
      *  CAS006 - Hedge Accounting Phase B                            *
      *  214265 - Missing parameter from T1_6 PLIST                   *
      *  CAP043 - Additional APIs for IRS Schedules                   *
      *  209905 - Fiduciary API Enhancement                           *
      *  CAP056 - Automatic Authorisation of Interface Deals          *
      *  CSC011 - 24x7 Midas Availability                             *
      *  CSW024 - S.W.I.F.T. MT3xx Field 82/83/87.                    *
      *  CSE022 - Depository Definition Enhancement                   *
      *  CSD006 - Market Data Feeds (recomp)                          *
      *  CIR003 - FRA/IRS Pay/Receive Messages for Swaps              *
      *  CFT014 - Straight-through Processing Phase 2 MT103           *
      *           Messages Generation for FT.                         *
      *  CAP039 - Midas / ToF interface, SD Security Customer details *
      *  CAP035 - Midas / ToF interface, GL Accounts Maintenance.     *
      *  CAP034 - Midas / ToF interface, SD Customers details.        *
      *  CAP031 - Midas / ToF interface, FT Outgoing Payments.        *
      *  CAP051 - Automatic Authorisation                             *
      *  CDL007 - Deposit Breakdown Penalty                           *
      *  CAP006 - Splitting up of API functions into service programs *
      *                                                               *
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      ** Functions to be called
     F***APFUNCL0  IF   E             DISK    INFSR(*pssr)                                    257300
     FAPFUNCL0  IF   E           K DISK    INFSR(*pssr)                                       257300

      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
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
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structure.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes definitions for thefields
      ** #ProcPgm, #ProcMod and #ProcName.  They are based on the
      ** corresponding fields in the PSDS /COPY member.
     D/COPY ZACPYSRC,PROCPARMS
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
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** The size of the arrays used below
     D*ArraySize****   C                   100                                                209905
     D ArraySize       C                   200                                                209905

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
     D/COPY WNCPYSRC,APH00036

      ** +--- Named indicators -------------------------------------------+
      ** ¦                                                                ¦
      ** ¦ Map variable names to indicators to allow use of names instead ¦
      ** ¦ of numbers; base the following data structure on a pointer to  ¦
      ** ¦ the indicator array.                                           ¦
     D Indicators      DS                  BASED(pIndicator)
      ** ¦                                                                ¦
      ** ¦                                                                ¦
     D  LookupSucc            98     98
      ** ¦                                                                ¦
     D  EndOfFile             99     99
      ** ¦                                                                ¦
      ** ¦                                                                ¦
      ** ¦ Set the indicator array pointer                                ¦
     D pIndicator      S               *   INZ(%Addr(*In))
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+

     D FuncCdeArr      S              8A   DIM(ArraySize)
      ** Array of function codes, loaded from APFUNCPD in *inzsr

     D PgmArr          S             10A   DIM(ArraySize)
      ** Array of programs to call, loaded from APFUNCPD in *inzsr

     D ParmLstArr      S             10A   DIM(ArraySize)
      ** Array of parameter list codes, loaded from APFUNCPD in *inzsr

     D OvrMbrArr       S             10A   DIM(ArraySize)
      ** Array of members to override to, loaded from APFUNCPD in *inzsr


     D APHead        E DS                  EXTNAME(APHEADPD)
      ** Incoming message header format

     D PaySttmt      E DS                  EXTNAME(SDESSPPD)
      ** Pay Settlement Instructions

     D RecSttmt      E DS                  EXTNAME(SDESSRPD)
      ** Receive Settlement Instructions

     D FRASttmt      E DS                  EXTNAME(SDESSFPD)
      ** FRA/IRS Settlement Instructions

     D PayStmtV      E DS                  EXTNAME(SDESSPPD) PREFIX(V)                        CIR003
      ** Pay Settlement Instructions  (Value date)                                            CIR003
                                                                                              CIR003
     D RecStmtV      E DS                  EXTNAME(SDESSRPD) PREFIX(V)                        CIR003
      ** Receive Settlement Instructions  (Value date)                                        CIR003
                                                                                              CIR003
     D PayStmtM      E DS                  EXTNAME(SDESSPPD) PREFIX(M)                        CIR003
      ** Pay Settlement Instructions  (Maturity date)                                         CIR003
                                                                                              CIR003
     D RecStmtM      E DS                  EXTNAME(SDESSRPD) PREFIX(M)                        CIR003
      ** Receive Settlement Instructions  (Maturity date)                                     CIR003
                                                                                              CIR003
      ** IN Message Formats for 'old' LE API's                                                CSC011
     D InMsgFmt1     E DS                  EXTNAME(LEF1MFPD)                                  CSC011
     D InMsgFmt1RONS E                     EXTFLD(QQRONS)                                     CGL029
     D InMsgFmt1PONS E                     EXTFLD(QQPONS)                                     CGL029
     D InMsgFmt2     E DS                  EXTNAME(LEN1MFPD)                                  CSC011
     D InMsgFmt3     E DS                  EXTNAME(LEA1MFPD)                                  CSC011
     D InMsgFmt3RONS E                     EXTFLD(QQRONS)                                     CGL029
     D InMsgFmt3PONS E                     EXTFLD(QQPONS)                                     CGL029
     D InMsgFmt4     E DS                  EXTNAME(LEO1MFPD)                                  CSC011
     D InMsgFmt5     E DS                  EXTNAME(LEM1MFPD)                                  CSC011
     D InMsgFmt5RONS E                     EXTFLD(QQRONS)                                     CGL029
     D InMsgFmt5PONS E                     EXTFLD(QQPONS)                                     CGL029
     D InMsgFmt6     E DS                  EXTNAME(LEF3MFPD)                                  CSC011
     D InMsgFmt6RONS E                     EXTFLD(QQRONS)                                     CGL029
     D InMsgFmt6PONS E                     EXTFLD(QQPONS)                                     CGL029
                                                                                              CSC011
      ** OUT Message Formats for 'old' LE API's                                               CSC011
     D OutMsgFmt1    E DS                  EXTNAME(LEF2MFPD)                                  CSC011
     D OutMsgFmt2      S            172                                                       CSC011
     D OutMsgFmt3      S            192                                                       CSC011
     D OutMsgFmt4      S            172                                                       CSC011
     D OutMsgFmt5      S            183                                                       CSC011
     D OutMsgFmt6      S            192                                                       CSC011
                                                                                              CSC011
     D Command         DS
      ** OVRDBF command for QCMDEXC to run
     D                         1     25    INZ('OVRDBF ZAFLDNPD MBR(')
     D  Member                26     35
     D                        36     36    INZ(')')
     D/COPY WNCPYSRC,APH00071


      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** Incoming transaction blocks
     D Trans1          S            500A
     D Trans2          S                   LIKE(Trans1)
     D Trans3          S                   LIKE(Trans1)
     D Trans4          S                   LIKE(Trans1)
     D Trans5          S                   LIKE(Trans1)
     D Trans6          S                   LIKE(Trans1)
     D Trans7          S                   LIKE(Trans1)
     D Trans8          S                   LIKE(Trans1)
     D Trans9          S                   LIKE(Trans1)                                       209905
     D Trans9A         S           1000A                                                      CSW209
     D Trans9B         S           1000A                                                      CSW209
     D Trans10         S                   LIKE(Trans1)                                       262664
     D Trans3A         S                   LIKE(Trans9A)                                      CFT120
     D Trans5A         S                   LIKE(Trans9A)                                      CFT120
     D Trans9C         S           3000A                                                      CGL132
     D Trans9999_1     S           9999A                                                    MD040876
     D Trans9999_2     S           9999A                                                    MD040876
     D Trans9999_3     S           9999A                                                    MD040876
                                                                                CDL007
      ** Non-screen Interface Data for Class 1 enhancement                      CDL007
     D InfData         S                   LIKE(Trans1)                         CDL007

      ** Extra data for non-class 1 enhancements
     D ExtData         S                   LIKE(Trans1)
      *                                                                                       CER001
      ** Extra data for regional enhancements                                                 CER001
      *                                                                                       CER001
     D RegData         S                   LIKE(Trans1)                                       CER001

      ** Other Depot Details for Securities Customer.                                         CSE022
      ** This totals to 150 additional other depot details from the incoming message.         CSE022
     D OthDData        S           4755A                                                      CSE022
                                                                                              CSE022
      ** Transaction type, from caller
     D TransactTp      S              8A

      ** Command length for QCMDEXC
     D CommandLen      S             15P 5 INZ(36)

      ** The array index (initialised in *inzsr, as it is first used there)
     D In              S              5P 0

      ** Error message to send if an invalid parameter list code is             CAP031
      ** received                                                               CAP031
     D InvParmMsg      S            132A   inz('An invalid parameter code +     CAP031
     D                                          was received in APCCALLCTL')    CAP031
                                                                                CAP031
      ** Dummy message ID and file for ZAMSGTOOPR                               CAP031
     D DummyMsgID      S              7A                                        CAP031
     D DummyMsgF       S             10A                                        CAP031
                                                                                              BG5888
     D LoanType        S              4A                                                      BG5888

      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************

     C     Start         TAG
      ** Note: the above tag is only there to force the first comments in
      ** the C-specs to appear after the D- or I-specs in compiled listings.

      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *inzsr is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+

      ** Reset the array index (initialised in *inzsr)
     C                   RESET                   In

      ** Use the received transaction type to access the functions-to-call
      ** details
     C     TransactTp    LOOKUP    FuncCdeArr(In)                         98

     C                   IF        LookupSucc = False

      ** Transaction type is not found; signal an error to the caller.
      ** *pssr will do this by setting the current module name up in the
      ** APDUMP field; it will also roll the transaction back; this is
      ** as required, because the caller assumes that this has happened
      ** if an error is signalled, and re-reads the transaction from
      ** MQSeries before logging it to the exception errors file.
      ** *pssr also returns, so no further processing is required here.
     C                   EXSR      *pssr

     C                   ENDIF

      ** Apply the override to the ZAFLDNPD member required by the
      ** controller.
     C                   EXSR      ApplyOvr

      ** Call the controller program retrieved from file, using the
      ** parameter list defined on the file.

      ** The parameter list code is ten bytes indicating which of the
      ** Trans* parameters and which settlement parameters are expected
      ** by the called program.  The general form of these, with square
      ** brackets denoting optional characters, is:

      **             Tn££-]m]£P]£R]£F]

      ** where:
      **             T refers to the Trans* parameters
      **             n is the first of these to pass (normally 1)
      **             m is the last of them to pass
      **             P means pass the pay settlement instructions
      **             R means pass the receive settlement instructions
      **             F means pass the FRA/IRS settlement instructions

      ** So for example, if Trans1 to Trans5 inclusive, and all three
      ** sets of settlement instructions are to be passed, the parameter
      ** list code will be T1-5PRF.  If only Trans1 is to be passed the
      ** code will be T1.  This format can be extended: if, for example,
      ** only Trans1 and Trans8 were to be passed, a code of T18 could be
      ** used.
      ** There is an additional set of parameters which is always passed.

      ** The select group below includes tests for all the parameter list
      ** codes that are in use at the time of development.  It will
      ** have to be extended when new codes are used.  The CALLs use
      ** parameter lists defined in *inzsr.  The parameter lists have
      ** the same names as the parameter list codes, except that the '-'
      ** is replaced by a '_'.

     C                   SELECT

     C                   WHEN      ParmLstArr(In) = 'T1'
     C                   CALL      PgmArr(In)    T1
      *                                                                                      CER034A
     C                   WHEN      ParmLstArr(In) = 'T6'                                     CER034A
     C                   CALL      PgmArr(In)    T1_6                                        CER034A
      *                                                                                      CER034A
                                                                                              CER001
     C                   WHEN      ParmLstArr(In) = 'T1RLX'                                   CER001
     C                   CALL      PgmArr(In)    T1RLX                                        CER001

     C                   WHEN      ParmLstArr(In) = 'T12'
     C                   CALL      PgmArr(In)    T12
                                                                                              CER001
     C                   WHEN      ParmLstArr(In) = 'T12RLX'                                  CER001
     C                   CALL      PgmArr(In)    T12RLX                                       CER001

     C                   WHEN      ParmLstArr(In) = 'T1-3'
     C                   CALL      PgmArr(In)    T1_3
                                                                                            BUG25877
     C                   WHEN      ParmLstArr(In) = 'T1-3GF'                                BUG25877
     C                   CALL      PgmArr(In)    T1_3GF                                     BUG25877
                                                                                              CER001
     C                   WHEN      ParmLstArr(In) = 'T1-3RLX'                                 CER001
     C                   CALL      PgmArr(In)    T1_3RLX                                      CER001

     C                   WHEN      ParmLstArr(In) = 'T1-8'
     C                   CALL      PgmArr(In)    T1_8

     C                   WHEN      ParmLstArr(In) = 'T1PRF'
     C                   CALL      PgmArr(In)    T1PRF

     C                   WHEN      ParmLstArr(In) = 'T1-5PRF'
     C                   CALL      PgmArr(In)    T1_5PRF
                                                                                CDL007
     C                   WHEN      ParmLstArr(In) = 'T12PRF'                    CDL007
     C                   CALL      PgmArr(In)    T12PRF                         CDL007
                                                                                              209905
     C                   WHEN      ParmLstArr(In) = 'T9PRF'                                   209905
     C                   CALL      PgmArr(In)    T9PRF                                        209905
                                                                                              CER001
     C                   WHEN      ParmLstArr(In) = 'T9PRFRLX'                                CER001
     C                   CALL      PgmArr(In)    T9PRFRLX                                     CER001

     C                   WHEN      ParmLstArr(In) = 'T1-4'                      CAP031
     C                   CALL      PgmArr(In)    T1_4                           CAP031
                                                                                CAP031
     C                   WHEN      ParmLstArr(In) = 'T1-4RLX'                                 CER001
     C                   CALL      PgmArr(In)    T1_4RLX                                      CER001
                                                                                              CER001
     C                   WHEN      ParmLstArr(In) = 'T1-5'                      CAP035
     C                   CALL      PgmArr(In)    T1_5                           CAP035
                                                                                CAP035
     C                   WHEN      ParmLstArr(In) = 'T1-5RLX'                                 CER001
     C                   CALL      PgmArr(In)    T1_5RLX                                      CER001
                                                                                              CER001
     C                   WHEN      ParmLstArr(In) = 'T1PRFRLX'                                CER001
     C                   CALL      PgmArr(In)    T1PRFRLX                                     CER001
                                                                                              CER001
     C                   WHEN      ParmLstArr(In) = 'T1-6'                      CAP034
     C                   CALL      PgmArr(In)    T1_6                           CAP034
                                                                                            BUG11857
     C                   WHEN      ParmLstArr(In) = 'T1-6RLX'                               BUG11857
     C                   CALL      PgmArr(In)    T1_6RLX                                    BUG11857
                                                                                              CSW024
     C                   WHEN      ParmLstArr(In) = 'T1-7'                                    CSW024
     C                   CALL      PgmArr(In)    T1_7                                         CSW024
                                                                                              CER001
     C                   WHEN      ParmLstArr(In) = 'T1-7RLX'                                 CER001
     C                   CALL      PgmArr(In)    T1_7RLX                                      CER001
                                                                                              CIR003
     C                   WHEN      ParmLstArr(In) = 'T1-7PRF'                                 CIR003
     C                   CALL      PgmArr(In)    T1_7PRF                                      CIR003
                                                                                CFT014
     C                   WHEN      ParmLstArr(In) = 'T1-8A'                     CFT014
     C                   CALL      PgmArr(In)    T1_8A                          CFT014
      * Start of Change CER030                                                                CER030
     C                   WHEN      ParmLstArr(In) = 'T1-9'                                    CER030
     C                   CALL      PgmArr(In)    T1_9                                         CER030
      * End   of Change CER030                                                                CER030
                                                                                              262664
     C                   WHEN      ParmLstArr(In) = 'T1-9A'                                   262664
     C                   CALL      PgmArr(In)    T1_9A                                        262664
                                                                                              CER001
     C                   WHEN      ParmLstArr(In) = 'T1-8ARLX'                                CER001
     C                   CALL      PgmArr(In)    T1_8ARLX                                     CER001
                                                                                              CGL132
     C                   WHEN      ParmLstArr(In) = 'T1-9C'                                   CGL132
     C                   CALL      PgmArr(In)    T1_9C                                        CGL132
                                                                                              CGL132
     C                   WHEN      ParmLstArr(In) = 'T1-9D'                                   CGL132
     C                   CALL      PgmArr(In)    T1_9D                                        CGL132
                                                                                              CSW209
     C                   WHEN      ParmLstArr(In) = 'T1-9B'                                   CSW209
     C                   CALL      PgmArr(In)    T1_9B                                        CSW209
      *                                                                                       CSW209
     C                   WHEN      ParmLstArr(In) = 'T1-10A'                                  CSW209
     C                   CALL      PgmArr(In)    T1_10A                                       CSW209
                                                                                              CSE022
     C                   WHEN      ParmLstArr(In) = 'T1SECOD'                                 CSE022
     C                   CALL      PgmArr(In)    T1SECOD                                      CSE022
                                                                                              CER001
     C                   WHEN      ParmLstArr(In) = 'T1SECODRLX'                              CER001
     C                   CALL      PgmArr(In)    T1SECODRLX                                   CER001
                                                                                              CAP043
     C                   WHEN      ParmLstArr(In) = 'T1-8PRF1'                                CAP043
     C                   CALL      PgmArr(In)    T1_8PRF1                                     CAP043
                                                                                              CAP043
     C                   WHEN      ParmLstArr(In) = 'T1-8PRF2'                                CAP043
     C                   CALL      PgmArr(In)    T1_8PRF2                                     CAP043
                                                                                            MD040876
     C                   WHEN      ParmLstArr(In) = 'T1-8ARLX2'                             MD040876
     C                   CALL      PgmArr(In)    T1_8ARLX2                                  MD040876
                                                                                              CSC011
      ** Setup the parameters for the calls to the lendfing Api's.  For each                  CSC011
      ** call, check the return code in the reply message to check if a DBASE                 CSC011
      ** error has occurred.  If so, set the APRETCODE = 'E' to remove the                    CSC011
      ** the MQ message from the queue and output to APEXCPERPD.                              CSC011
                                                                                              CSC011
     C                   WHEN      ParmLstArr(In) = 'LECS1'                                   CSC011
     C                   Eval      InMsgFmt1 = TRANS1 + TRANS2 + TRANS3                       CSC011
     C                   CALL      PgmArr(In)    LECS1                                        CSC011
     C     1             SUBST     OutMsgFmt1:81 Error             1                          CSC011
     C     Error         IFEQ      'D'                                                        CSC011
     C                   EVAL      APRETCODE = 'E'                                            CSC011
     C                   EVAL      Error = *BLANKS                                            CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   WHEN      ParmLstArr(In) = 'LECS2'                                   CSC011
     C     4             SUBST     TransactTp:3  TRANSTYPE         4                          CSC011
     C                   Eval      InMsgFmt2 = TRANS1 + TRANS2 + TRANS3                       CSC011
     C                   CALL      PgmArr(In)    LECS2                                        CSC011
     C     1             SUBST     OutMsgFmt2:81 Error                                        CSC011
     C     Error         IFEQ      'D'                                                        CSC011
     C                   EVAL      APRETCODE = 'E'                                            CSC011
     C                   EVAL      Error = *BLANKS                                            CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   WHEN      ParmLstArr(In) = 'LECS3'                                   CSC011
     C                   Eval      InMsgFmt3 = TRANS1 + TRANS2                                CSC011
     C                   CALL      PgmArr(In)    LECS3                                        CSC011
     C     1             SUBST     OutMsgFmt3:81 Error                                        CSC011
     C     Error         IFEQ      'D'                                                        CSC011
     C                   EVAL      APRETCODE = 'E'                                            CSC011
     C                   EVAL      Error = *BLANKS                                            CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   WHEN      ParmLstArr(In) = 'LECS4'                                   CSC011
     C     4             SUBST     TransactTp:3  TRANSTYPE         4                          CSC011
     C                   Eval      InMsgFmt4 = TRANS1 + TRANS2                                CSC011
     C                   CALL      PgmArr(In)    LECS4                                        CSC011
     C     1             SUBST     OutMsgFmt4:81 Error                                        CSC011
     C     Error         IFEQ      'D'                                                        CSC011
     C                   EVAL      APRETCODE = 'E'                                            CSC011
     C                   EVAL      Error = *BLANKS                                            CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   WHEN      ParmLstArr(In) = 'LECS5'                                   CSC011
     C                   Eval      InMsgFmt5 = TRANS1 + TRANS2                                CSC011
     C                   CALL      PgmArr(In)    LECS5                                        CSC011
     C     1             SUBST     OutMsgFmt5:81 Error                                        CSC011
     C     Error         IFEQ      'D'                                                        CSC011
     C                   EVAL      APRETCODE = 'E'                                            CSC011
     C                   EVAL      Error = *BLANKS                                            CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   WHEN      ParmLstArr(In) = 'LECS6'                                   CSC011
     C**********         Eval      InMsgFmt6 = TRANS1 + TRANS2                         CSC011 257681
     C                   Eval      InMsgFmt6 = TRANS1 + TRANS2 + TRANS3                       257681
     C                   CALL      PgmArr(In)    LECS6                                        CSC011
     C     1             SUBST     OutMsgFmt6:81 Error                                        CSC011
     C     Error         IFEQ      'D'                                                        CSC011
     C                   EVAL      APRETCODE = 'E'                                            CSC011
     C                   EVAL      Error = *BLANKS                                            CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
                                                                                              CAP056
     C                   WHEN      ParmLstArr(In) = 'T1-9PRF'                                 CAP056
     C                   CALL      PgmArr(In)    T1_9PRF                                      CAP056
                                                                                              CSE045
     C                   WHEN      ParmLstArr(In) = 'T1-7S'                                   CSE045
     C                   CALL      PgmArr(In)    T1_7S                                        CSE045
                                                                                              CER001
     C                   WHEN      ParmLstArr(In) = 'T1-8SRLX'                                CER001
     C                   CALL      PgmArr(In)    T1_8SRLX                                     CER001
                                                                                              BG5888
     C                   WHEN      ParmLstArr(In) = 'T2_LOAN'                                 BG5888
     C                   Eval      LoanType = 'LOAN'                                          BG5888
     C                   CALL      PgmArr(In)    T1_4PRFT                                     BG5888
                                                                                              CER001
     C                   WHEN      ParmLstArr(In) = 'T2_LOANRLX'                              CER001
     C                   Eval      LoanType = 'LOAN'                                          CER001
     C                   CALL      PgmArr(In)    T1_4PRFTRX                                   CER001
                                                                                              BG5888
     C                   WHEN      ParmLstArr(In) = 'T2_PTPU'                                 BG5888
     C                   Eval      LoanType = 'PTPU'                                          BG5888
     C                   CALL      PgmArr(In)    T1_4PRFT                                     BG5888
                                                                                              CER001
     C                   WHEN      ParmLstArr(In) = 'T2_PTPURLX'                              CER001
     C                   Eval      LoanType = 'PTPU'                                          CER001
     C                   CALL      PgmArr(In)    T1_4PRFTRX                                   CER001
                                                                                              BG5888
     C                   WHEN      ParmLstArr(In) = 'T2_PTSO'                                 BG5888
     C                   Eval      LoanType = 'PTSO'                                          BG5888
     C                   CALL      PgmArr(In)    T1_4PRFT                                     BG5888
     C/COPY WNCPYSRC,APH00072
                                                                                              CER001
     C                   WHEN      ParmLstArr(In) = 'T2_PTSORLX'                              CER001
     C                   Eval      LoanType = 'PTSO'                                          CER001
     C                   CALL      PgmArr(In)    T1_4PRFTRX                                   CER001
                                                                                CAP034
     C/COPY WNCPYSRC,APH00037
      * Handle unknown parameter list codes                                     CAP034
     C                   other                                                  CAP031
                                                                                CAP031
     C                   clear                   ReturnCode                     CAP031
     C                   callb     'ZAMSGTOOPR'                                 CAP031
     C                   parm                    ReturnCode                     CAP031
     C                   parm                    InvParmMsg                     CAP031
     C                   parm                    DummyMsgID                     CAP031
     C                   parm                    DummyMsgF                      CAP031
                                                                                CAP031
     C                   eval      APRETCODE = 'APCCALLCTL'                     CAP031
                                                                                CAP031
     C                   dump                                                   CAP031

     C                   ENDSL


     C                   RETURN


      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ApplyOvr - Apply member using QCMDEXC                         *
      *                                                               *
      *****************************************************************

     C     ApplyOvr      BEGSR

      ** Put the retrieved member name into the data structure
      ** subfield
     C                   EVAL      Member = OvrMbrArr(In)

     C                   CALL      'QCMDEXC'
     C                   PARM                    Command
     C                   PARM                    CommandLen

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *inzsr - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     *inzsr        BEGSR

     C     *entry        PLIST
      ** Inputs to this procedure
      ** ------------------------
      ** Transaction type (8A)
     C                   PARM                    TransactTp
      ** Transaction header
     C                   PARM                    APHead
      ** Eight blocks of transaction data
     C                   PARM                    Trans1                         CAP003
     C                   PARM                    TRANS1A        1000                         BUG9887
     C                   PARM                    TRANS1B        1500                        BUG25877
     C                   PARM                    Trans2                         CAP003
     C                   PARM                    Trans3                         CAP003
     C                   PARM                    Trans3A                                      CFT120
     C                   PARM                    Trans4                         CAP003
     C                   PARM                    Trans5                         CAP003
     C                   PARM                    Trans5A                                      CFT120
     C                   PARM                    Trans6                         CAP003
     C                   PARM                    Trans7                         CAP003
     C                   PARM                    Trans8                         CAP003
     C                   PARM                    Trans9                                       209905
     C                   PARM                    Trans9A                                      CSW209
     C                   PARM                    Trans9B                                      CSW209
     C                   PARM                    Trans10                                      262664
     C                   PARM                    Trans9C                                      CGL132
      ** Pay, receive and FRA settlement instructions
     C                   PARM                    PaySttmt
     C                   PARM                    RecSttmt
     C                   PARM                    FRASttmt
      ** Extra Settlements                                                                    CIR003
     C                   PARM                    PayStmtV                                     CIR003
     C                   PARM                    RecStmtV                                     CIR003
     C                   PARM                    PayStmtM                                     CIR003
     C                   PARM                    RecStmtM                                     CIR003
      ** Non-screen Interface Data for Class 1 enhancement                      CDL007
     C                   PARM                    InfData                        CDL007
     C                   PARM                    RegData                                      CER001
      ** Extra data
     C                   PARM                    ExtData                        CAP004
      ** Other Depot Details for Securities Customer                                          CSE022
     C                   PARM                    OthDData                                     CSE022
     C                   PARM                    Trans9999_1                                MD040876
     C                   PARM                    Trans9999_2                                MD040876
     C                   PARM                    Trans9999_3                                MD040876
      ** Program, module and procedure names of callers
     C                   PARM                    #ProcPgm
     C                   PARM                    #ProcMod
     C                   PARM                    #ProcName

     C/COPY WNCPYSRC,APH00038

      ** Load the function code, program calling and member overrdiing
      ** information into three arrays
      ** -------------------------------------------------------------------

      ** Initialise the array index
     C                   EVAL      In = 1
     C     *LOVAL        SETLL     APFUNCD0                                                   257300

      ** Read each record from the function codes file:
     C                   DOU       EndOfFile = True

     C                   READ      APFUNCL0                               99
     C                   IF        EndOfFile = True
     C                   LEAVE
     C                   ENDIF

     C                   EVAL      FuncCdeArr(In) = AAFNCODE
     C                   EVAL      PgmArr(In)     = AACTLPGM
     C                   EVAL      ParmLstArr(In) = AAPARMSET
     C                   EVAL      OvrMbrArr(In)  = AAOVRMBR

     C                   EVAL      In = In + 1

     C                   ENDDO

      ** Reinitialise the array index, to ensure that it has the correct
      ** reset value in the main body of the module.
     C                   EVAL      In = 1
     C/COPY WNCPYSRC,APH00073


      ** Parameter lists
      ** ---------------

      ** Trans1-Trans5, Pay, Receive and FRA/IRS settlement instructions
     C     T1_5PRF       PLIST
     C                   PARM                    APHead
     C                   PARM                    Trans1
     C                   PARM                    Trans2                         CAP004
     C                   PARM                    Trans3                         CAP004
     C                   PARM                    Trans4                         CAP004
     C                   PARM                    Trans5                         CAP004
     C                   PARM                    PaySttmt
     C                   PARM                    RecSttmt
     C                   PARM                    FRASttmt
     C                   PARM                    InfData                                      CAP056
     C                   PARM                    ExtData                        CAP004
     C                   PARM                    #ProcPgm
     C                   PARM                    #ProcMod
     C                   PARM                    #ProcName

      ** Trans1-Trans8, Pay, Receive and FRA/IRS settlement instructions                      CAP043
                                                                                              CAP043
     C     T1_8PRF1      PLIST                                                                CAP043
     C                   PARM                    APHead                                       CAP043
     C                   PARM                    Trans1                                       CAP043
     C                   PARM                    Trans2                                       CAP043
     C                   PARM                    Trans3                                       CAP043
     C                   PARM                    Trans4                                       CAP043
     C                   PARM                    Trans5                                       CAP043
     C                   PARM                    Trans6                                       CAP043
     C                   PARM                    Trans7                                       CAP043
     C                   PARM                    Trans8                                       CAP043
     C                   PARM                    PaySttmt                                     CAP043
     C                   PARM                    RecSttmt                                     CAP043
     C                   PARM                    FRASttmt                                     CAP043
     C                   PARM                    InfData                                      221948
     C                   PARM                    ExtData                                      CAP043
     C                   PARM                    #ProcPgm                                     CAP043
     C                   PARM                    #ProcMod                                     CAP043
     C                   PARM                    #ProcName                                    CAP043
                                                                                              CAP043
      ** Trans1-Trans8, Pay, Receive and FRA/IRS settlement instruction, Extra                CAP043
      ** Settlements                                                                          CAP043
                                                                                              CAP043
     C     T1_8PRF2      PLIST                                                                CAP043
     C                   PARM                    APHead                                       CAP043
     C******             PARM                    Trans1                               CAP043 BUG9887
     C                   PARM                    Trans1A                                     BUG9887
     C                   PARM                    Trans2                                       CAP043
     C                   PARM                    Trans3                                       CAP043
     C                   PARM                    Trans4                                       CAP043
     C                   PARM                    Trans5                                       CAP043
     C                   PARM                    Trans6                                       CAP043
     C                   PARM                    Trans7                                       CAP043
     C                   PARM                    Trans8                                       CAP043
     C                   PARM                    PaySttmt                                     CAP043
     C                   PARM                    RecSttmt                                     CAP043
     C                   PARM                    FRASttmt                                     CAP043
     C                   PARM                    PayStmtV                                     CAP043
     C                   PARM                    RecStmtV                                     CAP043
     C                   PARM                    PayStmtM                                     CAP043
     C                   PARM                    RecStmtM                                     CAP043
     C                   PARM                    InfData                                      221948
     C                   PARM                    ExtData                                      CAP043
     C                   PARM                    #ProcPgm                                     CAP043
     C                   PARM                    #ProcMod                                     CAP043
     C                   PARM                    #ProcName                                    CAP043

      ** Trans1-Trans8
     C     T1_8          PLIST
     C                   PARM                    APHead
     C                   PARM                    Trans1
     C                   PARM                    Trans2                         CAP004
     C                   PARM                    Trans3                         CAP004
     C                   PARM                    Trans4                         CAP004
     C                   PARM                    Trans5                         CAP004
     C                   PARM                    Trans6                         CAP004
     C                   PARM                    Trans7                         CAP004
     C                   PARM                    Trans8                                       CAS006
     C****************** PARM                    Trans8                  CAP004 CAP051
     C                   PARM                    InfData                        CAP051
     C                   PARM                    ExtData                        CAP004
     C                   PARM                    #ProcPgm
     C                   PARM                    #ProcMod
     C                   PARM                    #ProcName

      ** Trans1-Trans3
     C     T1_3          PLIST
     C                   PARM                    APHead
     C                   PARM                    Trans1
     C                   PARM                    Trans2                         CAP004
     C                   PARM                    Trans3                         CAP004
     C                   PARM                    ExtData                        CAP004
     C                   PARM                    #ProcPgm
     C                   PARM                    #ProcMod
     C                   PARM                    #ProcName
                                                                                            BUG25877
      ** Trans1-Trans3 (German Feature ACUD)                                                BUG25877
     C     T1_3GF        PLIST                                                              BUG25877
     C                   PARM                    APHead                                     BUG25877
     C                   PARM                    TRANS1B                                    BUG25877
     C                   PARM                    Trans2                                     BUG25877
     C                   PARM                    Trans3                                     BUG25877
     C                   PARM                    ExtData                                    BUG25877
     C                   PARM                    #ProcPgm                                   BUG25877
     C                   PARM                    #ProcMod                                   BUG25877
     C                   PARM                    #ProcName                                  BUG25877
                                                                                              CER001
      *                                                                                       CER001
      ** Trans1-Trans3 + Regional data                                                        CER001
      *                                                                                       CER001
     C     T1_3RLX       PLIST                                                                CER001
     C                   PARM                    APHead                                       CER001
     C                   PARM                    Trans1                                       CER001
     C                   PARM                    Trans2                                       CER001
     C                   PARM                    Trans3                                       CER001
     C                   PARM                    RegData                                      CER001
     C                   PARM                    ExtData                                      CER001
     C                   PARM                    #ProcPgm                                     CER001
     C                   PARM                    #ProcMod                                     CER001
     C                   PARM                    #ProcName                                    CER001

      ** Trans1
     C     T1            PLIST
     C                   PARM                    APHead
     C                   PARM                    Trans1
     C                   PARM                    ExtData                        CAP004
     C                   PARM                    #ProcPgm
     C                   PARM                    #ProcMod
     C                   PARM                    #ProcName
                                                                                              CER001
      *                                                                                       CER001
      ** Trans1 + Regional Data                                                               CER001
      *                                                                                       CER001
     C     T1RLX         PLIST                                                                CER001
     C                   PARM                    APHead                                       CER001
     C                   PARM                    Trans1                                       CER001
     C                   PARM                    RegData                                      CER001
     C                   PARM                    ExtData                                      CER001
     C                   PARM                    #ProcPgm                                     CER001
     C                   PARM                    #ProcMod                                     CER001
     C                   PARM                    #ProcName                                    CER001

      ** Trans1, Pay, Receive and FRA/IRS settlement instructions
     C     T1PRF         PLIST
     C                   PARM                    APHead
     C                   PARM                    Trans1
     C                   PARM                    PaySttmt
     C                   PARM                    RecSttmt
     C                   PARM                    FRASttmt
     C                   PARM                    ExtData                        CAP004
     C                   PARM                    #ProcPgm
     C                   PARM                    #ProcMod
     C                   PARM                    #ProcName

      *                                                                                       CER001
      ** Trans1, Pay, Receive and FRA/IRS settlement instructions +                           CER001
      ** Regional Data                                                                        CER001
      *                                                                                       CER001
     C     T1PRFRLX      PLIST                                                                CER001
     C                   PARM                    APHead                                       CER001
     C                   PARM                    Trans1                                       CER001
     C                   PARM                    PaySttmt                                     CER001
     C                   PARM                    RecSttmt                                     CER001
     C                   PARM                    FRASttmt                                     CER001
     C                   PARM                    InfData                                    BUG11857
     C                   PARM                    RegData                                      CER001
     C                   PARM                    ExtData                                      CER001
     C                   PARM                    #ProcPgm                                     CER001
     C                   PARM                    #ProcMod                                     CER001
     C                   PARM                    #ProcName                                    CER001
                                                                                              CER001
      ** Trans1 & Trans2
     C     T12           PLIST
     C                   PARM                    APHead
     C                   PARM                    Trans1
     C                   PARM                    Trans2                         CAP004
     C                   PARM                    ExtData                        CAP004
     C                   PARM                    #ProcPgm
     C                   PARM                    #ProcMod
     C                   PARM                    #ProcName
                                                                                              CER001
      *                                                                                       CER001
      ** Trans1 & Trans2 + Regional Data                                                      CER001
      *                                                                                       CER001
     C     T12RLX        PLIST                                                                CER001
     C                   PARM                    APHead                                       CER001
     C                   PARM                    Trans1                                       CER001
     C                   PARM                    Trans2                                       CER001
     C                   PARM                    RegData                                      CER001
     C                   PARM                    ExtData                                      CER001
     C                   PARM                    #ProcPgm                                     CER001
     C                   PARM                    #ProcMod                                     CER001
     C                   PARM                    #ProcName                                    CER001
                                                                                CDL007
      ** Trans1, Pay, Receive and FRA/IRS settlement instructions               CDL007
     C     T12PRF        PLIST                                                  CDL007
     C                   PARM                    APHead                         CDL007
     C                   PARM                    Trans1                         CDL007
     C                   PARM                    InfData                        CDL007
     C                   PARM                    PaySttmt                       CDL007
     C                   PARM                    RecSttmt                       CDL007
     C                   PARM                    FRASttmt                       CDL007
     C                   PARM                    ExtData                        CDL007
     C                   PARM                    #ProcPgm                       CDL007
     C                   PARM                    #ProcMod                       CDL007
     C                   PARM                    #ProcName                      CDL007
                                                                                              209905
      ** Trans1 to Trans9, Pay, Receive and FRA/IRS settlement instructions                   209905
                                                                                              209905
     C     T9PRF         PLIST                                                                209905
     C                   PARM                    APHead                                       209905
     C                   PARM                    Trans1                                       209905
     C                   PARM                    Trans2                                       209905
     C                   PARM                    Trans3                                       209905
     C                   PARM                    Trans4                                       209905
     C                   PARM                    Trans5                                       209905
     C                   PARM                    Trans6                                       209905
     C                   PARM                    Trans7                                       209905
     C                   PARM                    Trans8                                       209905
     C                   PARM                    Trans9                                       209905
     C                   PARM                    InfData                                      209905
     C                   PARM                    PaySttmt                                     209905
     C                   PARM                    RecSttmt                                     209905
     C                   PARM                    FRASttmt                                     209905
     C                   PARM                    ExtData                                      209905
     C                   PARM                    #ProcPgm                                     209905
     C                   PARM                    #ProcMod                                     209905
     C                   PARM                    #ProcName                                    209905
                                                                                              CER001
      *                                                                                       CER001
      ** Trans1 to Trans9, Pay, Receive and FRA/IRS settlement                                CER001
      ** instructions + Regional Data                                                         CER001
      *                                                                                       CER001
     C     T9PRFRLX      PLIST                                                                CER001
     C                   PARM                    APHead                                       CER001
     C                   PARM                    Trans1                                       CER001
     C                   PARM                    Trans2                                       CER001
     C                   PARM                    Trans3                                       CER001
     C                   PARM                    Trans4                                       CER001
     C                   PARM                    Trans5                                       CER001
     C                   PARM                    Trans6                                       CER001
     C                   PARM                    Trans7                                       CER001
     C                   PARM                    Trans8                                       CER001
     C                   PARM                    Trans9                                       CER001
     C                   PARM                    InfData                                      CER001
     C                   PARM                    PaySttmt                                     CER001
     C                   PARM                    RecSttmt                                     CER001
     C                   PARM                    FRASttmt                                     CER001
     C                   PARM                    RegData                                      CER001
     C                   PARM                    ExtData                                      CER001
     C                   PARM                    #ProcPgm                                     CER001
     C                   PARM                    #ProcMod                                     CER001
     C                   PARM                    #ProcName                                    CER001
                                                                                CAP031
      ** Trans1-Trans4                                                          CAP031
     C     T1_4          PLIST                                                  CAP031
     C                   PARM                    APHead                         CAP031
     C                   PARM                    Trans1                         CAP031
     C                   PARM                    Trans2                         CAP031
     C                   PARM                    Trans3                         CAP031
     C                   PARM                    Trans4                         CAP031
     C                   PARM                    ExtData                        CAP031
     C                   PARM                    #ProcPgm                       CAP031
     C                   PARM                    #ProcMod                       CAP031
     C                   PARM                    #ProcName                      CAP031
                                                                                              CER001
      ** Trans1-Trans4 + Regional Data                                                        CER001
     C     T1_4RLX       PLIST                                                                CER001
     C                   PARM                    APHead                                       CER001
     C                   PARM                    Trans1                                       CER001
     C                   PARM                    Trans2                                       CER001
     C                   PARM                    Trans3                                       CER001
     C                   PARM                    Trans4                                       CER001
     C                   PARM                    RegData                                      CER001
     C                   PARM                    ExtData                                      CER001
     C                   PARM                    #ProcPgm                                     CER001
     C                   PARM                    #ProcMod                                     CER001
     C                   PARM                    #ProcName                                    CER001
                                                                                CAP031
      ** Trans1-Trans5                                                          CAP031
     C     T1_5          PLIST                                                  CAP035
     C                   PARM                    APHead                         CAP035
     C                   PARM                    Trans1                         CAP035
     C                   PARM                    Trans2                         CAP035
     C                   PARM                    Trans3                         CAP035
     C                   PARM                    Trans4                         CAP035
     C                   PARM                    Trans5                         CAP035
     C                   PARM                    ExtData                        CAP035
     C                   PARM                    #ProcPgm                       CAP035
     C                   PARM                    #ProcMod                       CAP035
     C                   PARM                    #ProcName                      CAP035
                                                                                              CER001
      ** Trans1-Trans5 + Regional Data                                                        CER001
     C     T1_5RLX       PLIST                                                                CER001
     C                   PARM                    APHead                                       CER001
     C                   PARM                    Trans1                                       CER001
     C                   PARM                    Trans2                                       CER001
     C                   PARM                    Trans3                                       CER001
     C                   PARM                    Trans4                                       CER001
     C                   PARM                    Trans5                                       CER001
     C                   PARM                    RegData                                      CER001
     C                   PARM                    InfData                                    BUG11857
     C                   PARM                    ExtData                                      CER001
     C                   PARM                    #ProcPgm                                     CER001
     C                   PARM                    #ProcMod                                     CER001
     C                   PARM                    #ProcName                                    CER001

      ** Trans1-Trans6                                                          CAP034
     C     T1_6          PLIST                                                  CAP034
     C                   PARM                    APHead                         CAP034
     C                   PARM                    Trans1                         CAP034
     C                   PARM                    Trans2                         CAP034
     C                   PARM                    Trans3                         CAP034
     C                   PARM                    Trans4                         CAP034
     C                   PARM                    Trans5                         CAP034
     C                   PARM                    Trans6                         CAP034
     C                   PARM                    Trans7                                       214265
     C                   PARM                    ExtData                        CAP034
     C                   PARM                    #ProcPgm                       CAP034
     C                   PARM                    #ProcMod                       CAP034
     C                   PARM                    #ProcName                      CAP034
                                                                                            BUG11857
      ** Trans1-Trans6 plus regional data                                                   BUG11857
     C     T1_6RLX       PLIST                                                              BUG11857
     C                   PARM                    APHead                                     BUG11857
     C                   PARM                    Trans1                                     BUG11857
     C                   PARM                    Trans2                                     BUG11857
     C                   PARM                    Trans3                                     BUG11857
     C                   PARM                    Trans4                                     BUG11857
     C                   PARM                    Trans5                                     BUG11857
     C                   PARM                    Trans6                                     BUG11857
     C                   PARM                    RegData                                    BUG11857
     C                   PARM                    ExtData                                    BUG11857
     C                   PARM                    #ProcPgm                                   BUG11857
     C                   PARM                    #ProcMod                                   BUG11857
     C                   PARM                    #ProcName                                  BUG11857
                                                                                              CSW024
      ** Trans1-Trans7                                                                        CSW024
     C     T1_7          PLIST                                                                CSW024
     C                   PARM                    APHead                                       CSW024
     C                   PARM                    Trans1                                       CSW024
     C                   PARM                    Trans2                                       CSW024
     C                   PARM                    Trans3                                       CSW024
     C                   PARM                    Trans4                                       CSW024
     C                   PARM                    Trans5                                       CSW024
     C                   PARM                    Trans6                                       CSW024
     C                   PARM                    Trans7                                       CSW024
     C                   PARM                    ExtData                                      CSW024
     C                   PARM                    #ProcPgm                                     CSW024
     C                   PARM                    #ProcMod                                     CSW024
     C                   PARM                    #ProcName                                    CSW024
                                                                                              CER001
      ** Trans1-Trans7 + Regional Data                                                        CER001
     C     T1_7RLX       PLIST                                                                CER001
     C                   PARM                    APHead                                       CER001
     C                   PARM                    Trans1                                       CER001
     C                   PARM                    Trans2                                       CER001
     C                   PARM                    Trans3                                       CER001
     C                   PARM                    Trans4                                       CER001
     C                   PARM                    Trans5                                       CER001
     C                   PARM                    Trans6                                       CER001
     C                   PARM                    Trans7                                       CER001
     C                   PARM                    RegData                                      CER001
     C                   PARM                    ExtData                                      CER001
     C                   PARM                    #ProcPgm                                     CER001
     C                   PARM                    #ProcMod                                     CER001
     C                   PARM                    #ProcName                                    CER001
                                                                                              CSW024
      ** Trans1-Trans5, Pay, Receive and FRA/IRS settlement instruction, Extra                CIR003
      ** Settlements                                                                          CIR003
     C     T1_7PRF       PLIST                                                                CIR003
     C                   PARM                    APHead                                       CIR003
     C                   PARM                    Trans1                                       CIR003
     C                   PARM                    Trans2                                       CIR003
     C                   PARM                    Trans3                                       CIR003
     C                   PARM                    Trans4                                       CIR003
     C                   PARM                    Trans5                                       CIR003
     C                   PARM                    PaySttmt                                     CIR003
     C                   PARM                    RecSttmt                                     CIR003
     C                   PARM                    FRASttmt                                     CIR003
     C                   PARM                    PayStmtV                                     CIR003
     C                   PARM                    RecStmtV                                     CIR003
     C                   PARM                    PayStmtM                                     CIR003
     C                   PARM                    RecStmtM                                     CIR003
     C                   PARM                    InfData                                      CAP056
     C                   PARM                    ExtData                                      CIR003
     C                   PARM                    #ProcPgm                                     CIR003
     C                   PARM                    #ProcMod                                     CIR003
     C                   PARM                    #ProcName                                    CIR003
                                                                                              CIR003
                                                                                CFT014
      ** Trans1-Trans8                                                          CFT014
                                                                                CFT014
     C     T1_8A         PLIST                                                  CFT014
     C                   PARM                    APHead                         CFT014
     C                   PARM                    Trans1                         CFT014
     C                   PARM                    Trans2                         CFT014
     C                   PARM                    Trans3                         CFT014
     C                   PARM                    Trans4                         CFT014
     C                   PARM                    Trans5                         CFT014
     C                   PARM                    Trans6                         CFT014
     C                   PARM                    Trans7                         CFT014
     C                   PARM                    Trans8                         CFT014
     C                   PARM                    ExtData                        CFT014
     C                   PARM                    #ProcPgm                       CFT014
     C                   PARM                    #ProcMod                       CFT014
     C                   PARM                    #ProcName                      CFT014
      *                                                                                       CER030
      * *Start of Change CER030                                                               CER030
      *                                                                                       CER030
     C     T1_9          PLIST                                                                CER030
     C                   PARM                    APHead                                       CER030
     C**********         PARM                    Trans1                                CER030 CFT120
     C                   PARM                    Trans1A                                      CFT120
     C                   PARM                    Trans2                                       CER030
     C**********         PARM                    Trans3                                CER030 CFT120
     C                   PARM                    Trans3A                                      CFT120
     C                   PARM                    Trans4                                       CER030
     C**********         PARM                    Trans5                                CER030 CFT120
     C                   PARM                    Trans5A                                      CFT120
     C                   PARM                    Trans6                                       CER030
     C                   PARM                    Trans7                                       CER030
     C                   PARM                    Trans8                                       CER030
     C                   PARM                    Trans9A                                      CER059
     C                   PARM                    Trans9B                                      CER059
     C                   PARM                    Trans9                                       CER030
     C                   PARM                    RegData                                      262664
     C                   PARM                    ExtData                                      CER030
     C                   PARM                    #ProcPgm                                     CER030
     C                   PARM                    #ProcMod                                     CER030
     C                   PARM                    #ProcName                                    CER030
      *                                                                                       CER030
      * End   of Change CER030                                                                CER030
                                                                                              CER001
      *                                                                                       CER001
      ** Trans1-Trans8 + Regional Data                                                        CER001
      *                                                                                       CER001
     C     T1_8ARLX      PLIST                                                                CER001
     C                   PARM                    APHead                                       CER001
     C                   PARM                    Trans1                                       CER001
     C                   PARM                    Trans2                                       CER001
     C                   PARM                    Trans3                                       CER001
     C                   PARM                    Trans4                                       CER001
     C                   PARM                    Trans5                                       CER001
     C                   PARM                    Trans6                                       CER001
     C                   PARM                    Trans7                                       CER001
     C                   PARM                    Trans8                                       CER001
     C                   PARM                    RegData                                      CER001
     C                   PARM                    ExtData                                      CER001
     C                   PARM                    #ProcPgm                                     CER001
     C                   PARM                    #ProcMod                                     CER001
     C                   PARM                    #ProcName                                    CER001
      *                                                                                       CGL132
      ** Trans1-Trans9 + Regional Data                                                        CGL132
      *                                                                                       CGL132
     C     T1_9C         PLIST                                                                CGL132
     C                   PARM                    APHead                                       CGL132
     C                   PARM                    Trans1                                       CGL132
     C                   PARM                    Trans2                                       CGL132
     C                   PARM                    Trans3                                       CGL132
     C                   PARM                    Trans4                                       CGL132
     C                   PARM                    Trans5                                       CGL132
     C                   PARM                    Trans6                                       CGL132
     C                   PARM                    Trans7                                       CGL132
     C                   PARM                    Trans8                                       CGL132
     C                   PARM                    Trans9C                                      CGL132
     C                   PARM                    RegData                                      CGL132
     C                   PARM                    ExtData                                      CGL132
     C                   PARM                    #ProcPgm                                     CGL132
     C                   PARM                    #ProcMod                                     CGL132
     C                   PARM                    #ProcName                                    CGL132
                                                                                              CGL132
      ** Trans1                                                                               CGL132
     C     T1_9D         PLIST                                                                CGL132
     C                   PARM                    APHead                                       CGL132
     C                   PARM                    Trans9A                                      CGL132
     C                   PARM                    Trans9C                                      CGL132
     C                   PARM                    ExtData                                      CGL132
     C                   PARM                    #ProcPgm                                     CGL132
     C                   PARM                    #ProcMod                                     CGL132
     C                   PARM                    #ProcName                                    CGL132
                                                                                              CGL132
                                                                                              CSW209
      ** Trans1-Trans9B                                                                       CSW209
                                                                                              CSW209
     C/COPY WNCPYSRC,APH00028
     C     T1_9B         PLIST                                                                CSW209
     C                   PARM                    APHead                                       CSW209
     C                   PARM                    Trans1                                       CSW209
     C                   PARM                    Trans2                                       CSW209
     C                   PARM                    Trans3                                       CSW209
     C                   PARM                    Trans4                                       CSW209
     C                   PARM                    Trans5                                       CSW209
     C                   PARM                    Trans6                                       CSW209
     C                   PARM                    Trans7                                       CSW209
     C                   PARM                    Trans8                                       CSW209
     C                   PARM                    Trans9A                                      CSW209
     C                   PARM                    Trans9B                                      CSW209
     C/COPY WNCPYSRC,APH00030
     C                   PARM                    ExtData                                      CSW209
     C                   PARM                    #ProcPgm                                     CSW209
     C                   PARM                    #ProcMod                                     CSW209
     C                   PARM                    #ProcName                                    CSW209
     C/COPY WNCPYSRC,APH00029
      *                                                                                       CSW209
      ** Trans1-Trans10                                                                       CSW209
      *                                                                                       CSW209
     C     T1_10A        PLIST                                                                CSW209
     C                   PARM                    APHead                                       CSW209
     C                   PARM                    Trans1                                       CSW209
     C                   PARM                    Trans2                                       CSW209
     C                   PARM                    Trans3                                       CSW209
     C                   PARM                    Trans4                                       CSW209
     C                   PARM                    Trans5                                       CSW209
     C                   PARM                    Trans6                                       CSW209
     C                   PARM                    Trans7                                       CSW209
     C                   PARM                    Trans8                                       CSW209
     C                   PARM                    Trans9A                                      CSW209
     C                   PARM                    Trans9B                                      CSW209
     C/COPY WNCPYSRC,APH00031
     C                   PARM                    ExtData                                      CSW209
     C                   PARM                    #ProcPgm                                     CSW209
     C                   PARM                    #ProcMod                                     CSW209
     C                   PARM                    #ProcName                                    CSW209
      *                                                                                       262664
     C     T1_9A         PLIST                                                                262664
     C                   PARM                    APHead                                       262664
     C                   PARM                    Trans1                                       262664
     C                   PARM                    Trans2                                       262664
     C                   PARM                    Trans3                                       262664
     C                   PARM                    Trans4                                       262664
     C                   PARM                    Trans5                                       262664
     C                   PARM                    Trans6                                       262664
     C                   PARM                    Trans7                                       262664
     C                   PARM                    Trans8                                       262664
     C                   PARM                    Trans9A                                      262664
     C                   PARM                    Trans9B                                      262664
     C                   PARM                    Trans9                                       262664
     C                   PARM                    Trans10                                      262664
     C                   PARM                    RegData                                      262664
     C                   PARM                    ExtData                                      262664
     C                   PARM                    #ProcPgm                                     262664
     C                   PARM                    #ProcMod                                     262664
     C                   PARM                    #ProcName                                    262664
                                                                                              CSE022
      ** Trans1-Other Depot Details for Securities Customer                                   CSE022
     C     T1SECOD       PLIST                                                                CSE022
     C                   PARM                    APHead                                       CSE022
     C                   PARM                    Trans1                                       CSE022
     C                   PARM                    ExtData                                      CSE022
     C                   PARM                    OthDData                                     CSE022
     C                   PARM                    #ProcPgm                                     CSE022
     C                   PARM                    #ProcMod                                     CSE022
     C                   PARM                    #ProcName                                    CSE022
                                                                                              CER001
      *                                                                                       CER001
      ** Trans1-Other Depot Details for Securities Customer +                                 CER001
      ** Regional Data                                                                        CER001
      *                                                                                       CER001
     C     T1SECODRLX    PLIST                                                                CER001
     C                   PARM                    APHead                                       CER001
     C                   PARM                    Trans1                                       CER001
     C                   PARM                    RegData                                      CER001
     C                   PARM                    ExtData                                      CER001
     C                   PARM                    OthDData                                     CER001
     C                   PARM                    #ProcPgm                                     CER001
     C                   PARM                    #ProcMod                                     CER001
     C                   PARM                    #ProcName                                    CER001
                                                                                CSC011
      ** Lending API's - LE2020, LE2030, LE2040, LE270, LE2110, LE2210          CSC011
     C     LECS1         PLIST                                                  CSC011
     C                   PARM      'B'           PMODE             1            CSC011
     C                   PARM                    InMsgFmt1                      CSC011
     C                   PARM                    OutMsgFmt1                     CSC011
     C                   PARM                    APHead                                       256407
                                                                                CSC011
     C     LECS2         PLIST                                                  CSC011
     C                   PARM      'B'           PMODE                          CSC011
     C                   PARM                    TRANSTYPE                      CSC011
     C                   PARM                    InMsgFmt2                      CSC011
     C                   PARM                    OutMsgFmt2                     CSC011
     C                   PARM                    APHead                                       256407
                                                                                CSC011
     C     LECS3         PLIST                                                  CSC011
     C                   PARM      'B'           PMODE                          CSC011
     C                   PARM                    InMsgFmt3                      CSC011
     C                   PARM                    OutMsgFmt3                     CSC011
     C                   PARM                    APHead                                       256407
                                                                                CSC011
     C     LECS4         PLIST                                                  CSC011
     C                   PARM      'B'           PMODE                          CSC011
     C                   PARM                    TRANSTYPE                      CSC011
     C                   PARM                    InMsgFmt4                      CSC011
     C                   PARM                    OutMsgFmt4                     CSC011
     C                   PARM                    APHead                                       256407
                                                                                CSC011
     C     LECS5         PLIST                                                  CSC011
     C                   PARM      'B'           PMODE                          CSC011
     C                   PARM                    InMsgFmt5                      CSC011
     C                   PARM                    OutMsgFmt5                     CSC011
     C                   PARM                    APHead                                       256407
                                                                                CSC011
     C     LECS6         PLIST                                                  CSC011
     C                   PARM      'B'           PMODE                          CSC011
     C                   PARM                    InMsgFmt6                      CSC011
     C                   PARM                    OutMsgFmt6                     CSC011
     C                   PARM                    APHead                                       256407
                                                                                              CAP056
      ** Trans1, Pay, Receive, FRA/IRS settlement instruction,                                CAP056
      ** Interface Non-Screen Data                                                            CAP056
                                                                                              CAP056
     C     T1_9PRF       PLIST                                                                CAP056
     C                   PARM                    APHead                                       CAP056
     C                   PARM                    Trans1                                       CAP056
     C                   PARM                    Trans2                                       CAP043
     C                   PARM                    Trans3                                       CAP043
     C                   PARM                    Trans4                                       CAP043
     C                   PARM                    PaySttmt                                     CAP056
     C                   PARM                    RecSttmt                                     CAP056
     C                   PARM                    FRASttmt                                     CAP056
     C                   PARM                    InfData                                      CAP056
     C                   PARM                    ExtData                                      CAP056
     C                   PARM                    #ProcPgm                                     CAP056
     C                   PARM                    #ProcMod                                     CAP056
     C                   PARM                    #ProcName                                    CAP056
                                                                                              CSE045
      ** Trans1-Trans7 Securities Trading                                                     CSE045
                                                                                              CSE045
     C     T1_7S         PLIST                                                                CSE045
     C                   PARM                    APHead                                       CSE045
     C                   PARM                    Trans1                                       CSE045
     C                   PARM                    Trans2                                       CSE045
     C                   PARM                    Trans3                                       CSE045
     C                   PARM                    Trans4                                       CSE045
     C                   PARM                    Trans5                                       CSE045
     C                   PARM                    Trans6                                       CSE045
     C                   PARM                    Trans7                                       CSE045
     C                   PARM                    Trans8                                      BUG7380
     C                   PARM                    InfData                                      CSE045
     C                   PARM                    RegData                                      247158
     C                   PARM                    ExtData                                      CSE045
     C                   PARM                    OthDData                                     CSE045
     C                   PARM                    #ProcPgm                                     CSE045
     C                   PARM                    #ProcMod                                     CSE045
     C                   PARM                    #ProcName                                    CSE045
                                                                                              CER001
      *                                                                                       CER001
      ** Trans1-Trans8 Securities Trading + Regional Data                                     CER001
      *                                                                                       CER001
     C     T1_8SRLX      PLIST                                                                CER001
     C                   PARM                    APHead                                       CER001
     C                   PARM                    Trans1                                       CER001
     C                   PARM                    Trans2                                       CER001
     C                   PARM                    Trans3                                       CER001
     C                   PARM                    Trans4                                       CER001
     C                   PARM                    Trans5                                       CER001
     C                   PARM                    Trans6                                       CER001
     C                   PARM                    Trans7                                       CER001
     C                   PARM                    Trans8                                       CER001
     C                   PARM                    InfData                                      CER001
     C                   PARM                    RegData                                      CER001
     C                   PARM                    ExtData                                      CER001
     C                   PARM                    OthDData                                     CER001
     C                   PARM                    #ProcPgm                                     CER001
     C                   PARM                    #ProcMod                                     CER001
     C                   PARM                    #ProcName                                    CER001
                                                                                              BG5888
      ** Trans1-Trans4 for Loans input                                                        BG5888
     C     T1_4PRFT      PLIST                                                                BG5888
     C                   PARM                    APHead                                       BG5888
     C                   PARM                    Trans1                                       BG5888
     C                   PARM                    Trans2                                       BG5888
     C                   PARM                    Trans3                                       BG5888
     C                   PARM                    Trans4                                       BG5888
     C                   PARM                    ExtData                                      BG5888
     C                   PARM                    PaySttmt                                     BG5888
     C                   PARM                    RecSttmt                                     BG5888
     C                   PARM                    FRASttmt                                     BG5888
     C                   PARM                    #ProcPgm                                     BG5888
     C                   PARM                    #ProcMod                                     BG5888
     C                   PARM                    #ProcName                                    BG5888
     C                   PARM                    LoanType                                     BG5888
     C/COPY WNCPYSRC,APH00074
                                                                                              CER001
      *                                                                                       CER001
      ** Trans1-Trans4 for Loans input + Regional Data                                        CER001
      *                                                                                       CER001
     C     T1_4PRFTRX    PLIST                                                                CER001
     C                   PARM                    APHead                                       CER001
     C                   PARM                    Trans1                                       CER001
     C                   PARM                    Trans2                                       CER001
     C                   PARM                    Trans3                                       CER001
     C                   PARM                    Trans4                                       CER001
     C                   PARM                    InfData                                    BUG11857
     C                   PARM                    PaySttmt                                     CER001
     C                   PARM                    RecSttmt                                     CER001
     C                   PARM                    FRASttmt                                     CER001
     C                   PARM                    RegData                                      CER001
     C                   PARM                    ExtData                                      CER001
     C                   PARM                    #ProcPgm                                     CER001
     C                   PARM                    #ProcMod                                     CER001
     C                   PARM                    #ProcName                                    CER001
     C                   PARM                    LoanType                                     CER001
     C                                                                                      MD040876
     C     T1_8ARLX2     PLIST                                                              MD040876
     C                   PARM                    APHead                                     MD040876
     C                   PARM                    Trans9999_1                                MD040876
     C                   PARM                    Trans9999_2                                MD040876
     C                   PARM                    Trans9999_3                                MD040876
     C                   PARM                    #ProcPgm                                   MD040876
     C                   PARM                    #ProcMod                                   MD040876
     C                   PARM                    #ProcName                                  MD040876

     C/COPY WNCPYSRC,APH00039
      **--------------------------------------------------------------------------------------------
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
     C/COPY ZACPYSRC,DBFIELDS
      **--------------------------------------------------------------------------------------------

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      **--------------------------------------------------------------------------------------------
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      **--------------------------------------------------------------------------------------------
      ********************************************************************
      /EJECT
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
