     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2007')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AP Controller call controller FT')               *
      *****************************************************************
      *                                                               *
      *  Midas - Application Programming Interfaces module            *
      *                                                               *
      *  APCALCTLFT - Controller call controller                      *
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
      *                 MD046248           Date 27Oct17               *
      *                 CDL094             Date 11Jun14               *
      *                 CFT039             Date 28Sep12               *
      *                 CLE148             Date 23Jul12               *
      *                 CSF011A            Date 28Nov11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 258287             Date 24Dec08               *
      *                 248920 *C *CREATE  Date 17Jan07               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *  CSD102 - Password Length Extension                           *
      *  MD046248 - Finastra Rebranding                               *
      *  CDL094 - Enhance Receive Settlement Instructions (recompile) *
      *  CFT039 - SWIFT Mapping of Field Ordering Bank                *
      *           Align parameters with FTOPAYCTL                     *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  258287 - Apply 257300 here as well.                          *
      *  248920 - FT OPAY API buffer is divided into file format      *
      *           lengths with a maximum of 500 wh. is too short for  *
      *           parms 1 and 7 (FTOPY1PD + FTOPY6PD): OPAY is to     *
      *           use parm list T1 -8K                                *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Functions to be called
     F**********APFUNCL0  IF   E             DISK    INFSR(*pssr)                             258287
     FAPFUNCL0  IF   E           K DISK    INFSR(*pssr)                                       258287
 
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
     D ArraySize       C                   200
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
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
 
     D PayStmtV      E DS                  EXTNAME(SDESSPPD) PREFIX(V)
      ** Pay Settlement Instructions  (Value date)
 
     D RecStmtV      E DS                  EXTNAME(SDESSRPD) PREFIX(V)
      ** Receive Settlement Instructions  (Value date)
 
     D PayStmtM      E DS                  EXTNAME(SDESSPPD) PREFIX(M)
      ** Pay Settlement Instructions  (Maturity date)
 
     D RecStmtM      E DS                  EXTNAME(SDESSRPD) PREFIX(M)
      ** Receive Settlement Instructions  (Maturity date)
 
      ** IN Message Formats for 'old' LE API's
     D InMsgFmt1     E DS                  EXTNAME(LEF1MFPD)
     D InMsgFmt1RONS E                     EXTFLD(QQRONS)
     D InMsgFmt1PONS E                     EXTFLD(QQPONS)
     D InMsgFmt2     E DS                  EXTNAME(LEN1MFPD)
     D InMsgFmt3     E DS                  EXTNAME(LEA1MFPD)
     D InMsgFmt3RONS E                     EXTFLD(QQRONS)
     D InMsgFmt3PONS E                     EXTFLD(QQPONS)
     D InMsgFmt4     E DS                  EXTNAME(LEO1MFPD)
     D InMsgFmt5     E DS                  EXTNAME(LEM1MFPD)
     D InMsgFmt5RONS E                     EXTFLD(QQRONS)
     D InMsgFmt5PONS E                     EXTFLD(QQPONS)
     D InMsgFmt6     E DS                  EXTNAME(LEF3MFPD)
     D InMsgFmt6RONS E                     EXTFLD(QQRONS)
     D InMsgFmt6PONS E                     EXTFLD(QQPONS)
 
      ** OUT Message Formats for 'old' LE API's
     D OutMsgFmt1    E DS                  EXTNAME(LEF2MFPD)
     D OutMsgFmt2      S            172
     D OutMsgFmt3      S            192
     D OutMsgFmt4      S            172
     D OutMsgFmt5      S            183
     D OutMsgFmt6      S            192
 
     D Command         DS
      ** OVRDBF command for QCMDEXC to run
     D                         1     25    INZ('OVRDBF ZAFLDNPD MBR(')
     D  Member                26     35
     D                        36     36    INZ(')')
 
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Incoming transaction blocks
     D Trans1          S            500A
     D*Trans2***       S                   LIKE(Trans1)                                       CSD102
     D*Trans3***       S                   LIKE(Trans1)                                       CSD102
     D Trans2          S           1000A                                                      CSD102
     D Trans3          S           1000A                                                      CSD102
     D Trans4          S                   LIKE(Trans1)
     D Trans5          S                   LIKE(Trans1)
     D Trans6          S                   LIKE(Trans1)
     D Trans7          S                   LIKE(Trans1)
     D Trans8          S                   LIKE(Trans1)
     D Trans9          S                   LIKE(Trans1)
     D Trans9A         S           1000A                                                      CFT039
     D Trans9B         S           1000A                                                      CFT039
     D Trans10         S            500A                                                      CFT039
     D Trans11         S            500A                                                      CFT039
 
      ** Non-screen Interface Data for Class 1 enhancement
     D InfData         S                   LIKE(Trans1)
 
      ** Extra data for non-class 1 enhancements
     D ExtData         S                   LIKE(Trans1)
      *
      ** Extra data for regional enhancements
      *
     D RegData         S                   LIKE(Trans1)
 
      ** Other Depot Details for Securities Customer.
      ** This totals to 150 additional other depot details from the incoming message.
     D OthDData        S           4755A
 
      ** Transaction type, from caller
     D TransactTp      S              8A
 
      ** Command length for QCMDEXC
     D CommandLen      S             15P 5 INZ(36)
 
      ** The array index (initialised in *inzsr, as it is first used there)
     D In              S              5P 0
     D WCNT            S              5P 0                                                    CFT039
 
      ** Error message to send if an invalid parameter list code is
      ** received
     D InvParmMsg      S            132A   inz('An invalid parameter code +
     D                                          was received in APCCALLCTL')
 
      ** Dummy message ID and file for ZAMSGTOOPR
     D DummyMsgID      S              7A
     D DummyMsgF       S             10A
 
     D LoanType        S              4A
 
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
      *                                                                                       CFT039
      ** Accommodate multiple APFUNCPD records                                                CFT039
     C                   DOW       ParmLstArr(In) <> 'T1-13K'                                 CFT039
     C                             AND WCNT <> In                                             CFT039
     C                   EVAL      In = In + 1                                                CFT039
     C                   ENDDO                                                                CFT039
 
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
 
     C**********         WHEN      ParmLstArr(In) = 'T1-8K'                                   CFT039
     C**********         CALL      PgmArr(In)    T1_8K                                        CFT039
     C                   WHEN      ParmLstArr(In) = 'T1-13K'                                  CFT039
     C                   CALL      PgmArr(In)    T1_13K                                       CFT039
 
      * Handle unknown parameter list codes
     C                   other
 
     C                   clear                   ReturnCode
     C                   callb     'ZAMSGTOOPR'
     C                   parm                    ReturnCode
     C                   parm                    InvParmMsg
     C                   parm                    DummyMsgID
     C                   parm                    DummyMsgF
 
     C                   eval      APRETCODE = 'APCALCTLFT'
 
     C                   dump
 
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
     C                   PARM                    Trans1FT       1000
     C                   PARM                    TRANS1A        1000
     C                   PARM                    Trans2
     C                   PARM                    Trans3
     C                   PARM                    Trans4
     C                   PARM                    Trans5
     C                   PARM                    Trans6FT       1000
     C                   PARM                    Trans7
     C                   PARM                    Trans8
     C                   PARM                    Trans9
     C                   PARM                    Trans9A                                      CFT039
     C                   PARM                    Trans9B                                      CFT039
     C                   PARM                    Trans10                                      CFT039
     C                   PARM                    Trans11                                      CFT039
      ** Pay, receive and FRA settlement instructions
     C                   PARM                    PaySttmt
     C                   PARM                    RecSttmt
     C                   PARM                    FRASttmt
      ** Extra Settlements
     C                   PARM                    PayStmtV
     C                   PARM                    RecStmtV
     C                   PARM                    PayStmtM
     C                   PARM                    RecStmtM
      ** Non-screen Interface Data for Class 1 enhancement
     C                   PARM                    InfData
     C                   PARM                    RegData
      ** Extra data
     C                   PARM                    ExtData
      ** Other Depot Details for Securities Customer
     C                   PARM                    OthDData
      ** Program, module and procedure names of callers
     C                   PARM                    #ProcPgm
     C                   PARM                    #ProcMod
     C                   PARM                    #ProcName
 
 
      ** Load the function code, program calling and member overrdiing
      ** information into three arrays
      ** -------------------------------------------------------------------
 
      ** Initialise the array index
     C                   EVAL      In = 1
     C     *LOVAL        SETLL     APFUNCD0                                                   258287
 
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
 
     C                   EVAL      WCNT = In                                                  CFT039
      ** Reinitialise the array index, to ensure that it has the correct
      ** reset value in the main body of the module.
     C                   EVAL      In = 1
 
 
      ** Parameter lists
      ** ---------------
 
 
      ** Trans1-Trans8
 
     C*****T1_8K         PLIST                                                                CFT039
     C     T1_13K        PLIST                                                                CFT039
     C                   PARM                    APHead
     C                   PARM                    Trans1FT       1000
     C                   PARM                    Trans1A        1000
     C                   PARM                    Trans2
     C                   PARM                    Trans3
     C                   PARM                    Trans4
     C                   PARM                    Trans5
     C                   PARM                    Trans6FT       1000
     C                   PARM                    Trans7
     C                   PARM                    Trans9A                                      CFT039
     C                   PARM                    Trans9B                                      CFT039
     C                   PARM                    Trans9                                       CFT039
     C                   PARM                    Trans10                                      CFT039
     C                   PARM                    Trans11                                      CFT039
     C                   PARM                    RegData                                      CFT039
     C                   PARM                    ExtData
     C                   PARM                    #ProcPgm
     C                   PARM                    #ProcMod
     C                   PARM                    #ProcName
 
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
